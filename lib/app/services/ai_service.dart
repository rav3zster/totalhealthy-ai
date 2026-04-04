import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Backend URLs ──────────────────────────────────────────────────────────────

/// Render Flask backend — live, handles Gemini meal generation
const String _renderUrl = 'https://totalhealthy-ai.onrender.com';

/// GCP Cloud Functions — set this once your functions are deployed.
/// While empty, the recommendation / nutrition / classifier features
/// will return empty/null results instead of crashing.
const String _gcpUrl = '';

// ── Helpers ───────────────────────────────────────────────────────────────────

bool get _gcpReady => _gcpUrl.isNotEmpty && !_gcpUrl.contains('YOUR_');

Map<String, String> get _jsonHeaders => {'Content-Type': 'application/json'};

/// Decode response body safely — returns null on any error.
Map<String, dynamic>? _decode(http.Response res) {
  try {
    return jsonDecode(res.body) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

// ── Service ───────────────────────────────────────────────────────────────────

class AiService {
  AiService._();
  static final AiService instance = AiService._();

  // ── PHASE 1: Meal Recommendations ────────────────────────────────────────
  /// Returns empty list when GCP is not yet configured.
  Future<List<MealRecommendation>> getRecommendations() async {
    if (!_gcpReady) return [];

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    try {
      final res = await http
          .post(
            Uri.parse('$_gcpUrl/recommend_meals'),
            headers: _jsonHeaders,
            body: jsonEncode({'userId': userId}),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) return [];

      final data = _decode(res);
      final list = data?['recommendations'] as List<dynamic>? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(MealRecommendation.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── PHASE 2: Nutrition Prediction ────────────────────────────────────────
  /// Returns null when GCP is not yet configured or call fails.
  Future<NutritionResult?> predictNutrition(String description) async {
    if (!_gcpReady) return null;

    try {
      final res = await http
          .post(
            Uri.parse('$_gcpUrl/predict_meal_nutrition'),
            headers: _jsonHeaders,
            body: jsonEncode({'description': description}),
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) return null;

      final data = _decode(res);
      if (data == null) return null;
      return NutritionResult.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  // ── PHASE 3: Diet Classifier ──────────────────────────────────────────────
  /// Calls the Render backend /classify_diet endpoint.
  Future<DietClassification?> classifyDiet({
    required int age,
    required double weight,
    required double height,
    required int activityLevel,
    required String goal,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_renderUrl/classify_diet'),
            headers: _jsonHeaders,
            body: jsonEncode({
              'age': age,
              'weight': weight,
              'height': height,
              'activityLevel': activityLevel,
              'goal': goal,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode != 200) return null;
      final data = _decode(res);
      if (data == null || data['status'] != 'ok') return null;
      return DietClassification.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  // ── GENERATE MEAL — Render Flask backend ──────────────────────────────────
  /// POST /generate_meal → {"status":"ok","meals":[...]}
  ///
  /// Render free tier cold-starts in ~30 s, so we allow 90 s total
  /// (60 s first attempt + 30 s retry) before giving up.
  Future<List<AiGeneratedMeal>> generateMealWithAI(
    Map<String, dynamic> userInputs, {
    int attempt = 0,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_renderUrl/generate_meal'),
            headers: _jsonHeaders,
            body: jsonEncode(userInputs),
          )
          .timeout(const Duration(seconds: 90));

      if (res.statusCode != 200) {
        final data = _decode(res);
        final errMsg = data?['error'] as String? ?? res.body;
        throw Exception('Backend error: $errMsg');
      }

      final data = _decode(res);
      if (data == null) throw const FormatException('Invalid JSON response');

      final status = data['status'] as String? ?? '';
      if (status != 'ok') {
        throw Exception('Backend returned status: $status');
      }

      final meals = data['meals'] as List<dynamic>? ?? [];
      if (meals.isEmpty) throw Exception('No meals returned from backend');

      return meals
          .whereType<Map<String, dynamic>>()
          .map(AiGeneratedMeal.fromJson)
          .toList();
    } on SocketException {
      if (attempt == 0) return generateMealWithAI(userInputs, attempt: 1);
      throw Exception('No internet connection');
    } on http.ClientException {
      if (attempt == 0) return generateMealWithAI(userInputs, attempt: 1);
      rethrow;
    } catch (e) {
      // Retry once for cold-start timeouts
      if (attempt == 0) return generateMealWithAI(userInputs, attempt: 1);
      rethrow;
    }
  }

  // ── Health check ──────────────────────────────────────────────────────────
  /// Returns true if the Render backend is reachable.
  Future<bool> pingBackend() async {
    try {
      final res = await http
          .get(Uri.parse('$_renderUrl/'))
          .timeout(const Duration(seconds: 10));
      final data = _decode(res);
      return res.statusCode == 200 && data?['status'] == 'ok';
    } catch (_) {
      return false;
    }
  }

  // ── Regenerate single meal ────────────────────────────────────────────────
  /// Regenerates one meal by excluding the current meal name.
  Future<AiGeneratedMeal?> regenerateSingleMeal({
    required String excludeMealName,
    required String category,
    required Map<String, dynamic> userInputs,
  }) async {
    try {
      final payload = {
        ...userInputs,
        'mealTypes': [category],
        'mealsPerDay': 1,
        'previousMeals': [
          excludeMealName,
          ...((userInputs['previousMeals'] as List?)?.cast<String>() ?? []),
        ],
      };
      final meals = await generateMealWithAI(payload);
      return meals.isNotEmpty ? meals.first : null;
    } catch (_) {
      return null;
    }
  }

  // ── Explain meal ──────────────────────────────────────────────────────────
  /// Returns an AI explanation of why a meal fits the user's goal.
  Future<String?> explainMeal({
    required String mealName,
    required String goal,
    required String dietType,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_renderUrl/explain_meal'),
            headers: _jsonHeaders,
            body: jsonEncode({
              'mealName': mealName,
              'goal': goal,
              'dietType': dietType,
            }),
          )
          .timeout(const Duration(seconds: 60));
      final data = _decode(res);
      if (res.statusCode == 200 && data?['status'] == 'ok') {
        return data?['explanation'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Save / load AI preferences ────────────────────────────────────────────
  static const String _prefsKey = 'ai_preferences';

  Future<void> savePreferences({
    required String goal,
    required String dietType,
    required String cuisine,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode({'goal': goal, 'dietType': dietType, 'cuisine': cuisine}),
    );
  }

  Future<Map<String, String>> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null) return {};
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  // ── Food image scan ───────────────────────────────────────────────────────
  /// Sends a base64 image to the backend and returns nutritional data.
  Future<Map<String, dynamic>?> scanFood({
    required String base64Image,
    String mimeType = 'image/jpeg',
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_renderUrl/scan_food'),
            headers: _jsonHeaders,
            body: jsonEncode({'image': base64Image, 'mimeType': mimeType}),
          )
          .timeout(const Duration(seconds: 60));
      final data = _decode(res);
      if (res.statusCode == 200 && data?['status'] == 'ok') return data;
      return null;
    } catch (_) {
      return null;
    }
  }
}

// ── Data models ───────────────────────────────────────────────────────────────

class MealRecommendation {
  final String mealType;
  final String description;
  final double score;

  const MealRecommendation({
    required this.mealType,
    required this.description,
    required this.score,
  });

  factory MealRecommendation.fromJson(Map<String, dynamic> j) =>
      MealRecommendation(
        mealType: j['mealType'] as String? ?? '',
        description: j['description'] as String? ?? '',
        score: (j['score'] as num?)?.toDouble() ?? 0.0,
      );
}

class NutritionResult {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const NutritionResult({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory NutritionResult.fromJson(Map<String, dynamic> j) => NutritionResult(
    calories: (j['calories'] as num?)?.toDouble() ?? 0,
    protein: (j['protein'] as num?)?.toDouble() ?? 0,
    carbs: (j['carbs'] as num?)?.toDouble() ?? 0,
    fat: (j['fat'] as num?)?.toDouble() ?? 0,
  );
}

class DietClassification {
  final String dietType;
  final double bmi;
  final double tdee;
  final int recommendedCalories;

  const DietClassification({
    required this.dietType,
    required this.bmi,
    required this.tdee,
    required this.recommendedCalories,
  });

  factory DietClassification.fromJson(Map<String, dynamic> j) =>
      DietClassification(
        dietType: j['dietType'] as String? ?? 'maintenance',
        bmi: (j['bmi'] as num?)?.toDouble() ?? 0,
        tdee: (j['tdee'] as num?)?.toDouble() ?? 0,
        recommendedCalories:
            (j['recommendedCalories'] as num?)?.toInt() ?? 2000,
      );
}

class AiGeneratedMeal {
  final String name;
  final String category;
  final List<String> ingredients;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String bestTime;
  final String description;

  const AiGeneratedMeal({
    required this.name,
    required this.category,
    required this.ingredients,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.bestTime,
    required this.description,
  });

  factory AiGeneratedMeal.fromJson(Map<String, dynamic> j) => AiGeneratedMeal(
    name: j['name'] as String? ?? '',
    category: j['category'] as String? ?? '',
    ingredients: (j['ingredients'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    calories: (j['calories'] as num?)?.toDouble() ?? 0,
    protein: (j['protein'] as num?)?.toDouble() ?? 0,
    carbs: (j['carbs'] as num?)?.toDouble() ?? 0,
    fat: (j['fat'] as num?)?.toDouble() ?? 0,
    bestTime: j['bestTime'] as String? ?? '',
    description: j['description'] as String? ?? '',
  );

  Map<String, dynamic> toFirestoreMap({
    required String userId,
    required String groupId,
  }) => {
    'userId': userId,
    'groupId': groupId,
    'name': name,
    'description': description,
    'kcal': calories.toStringAsFixed(0),
    'protein': protein.toStringAsFixed(1),
    'carbs': carbs.toStringAsFixed(1),
    'fat': fat.toStringAsFixed(1),
    'categorys': [category],
    'imageUrl': '',
    'ingredients': ingredients
        .map((i) => {'name': i, 'amount': '', 'unit': ''})
        .toList(),
    'instructions': '',
    'created_at': DateTime.now().toIso8601String(),
    'prep_time': '',
    'difficulty': '',
    'generatedByAI': true,
    'bestTime': bestTime,
  };
}
