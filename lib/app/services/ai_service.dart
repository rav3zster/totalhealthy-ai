import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

/// Base URL of your deployed Firebase Cloud Functions (Python)
/// Replace with your actual project region + function URLs after deployment
const String _baseUrl =
    'https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net';

class AiService {
  AiService._();
  static final AiService instance = AiService._();

  // ── PHASE 1: Meal Recommendations ────────────────────────────────────────
  Future<List<MealRecommendation>> getRecommendations() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final response = await http
        .post(
          Uri.parse('$_baseUrl/recommend_meals'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'userId': userId}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Recommendation API error: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['recommendations'] as List<dynamic>? ?? [];
    return list.map((e) => MealRecommendation.fromJson(e)).toList();
  }

  // ── PHASE 2: Nutrition Prediction ────────────────────────────────────────
  Future<NutritionResult> predictNutrition(String description) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/predict_meal_nutrition'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'description': description}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Nutrition API error: ${response.body}');
    }

    return NutritionResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ── PHASE 3: Diet Classifier ──────────────────────────────────────────────
  Future<DietClassification> classifyDiet({
    required int age,
    required double weight,
    required double height,
    required int activityLevel,
    required String goal,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/classify_user_diet'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'age': age,
            'weight': weight,
            'height': height,
            'activityLevel': activityLevel,
            'goal': goal,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Classifier API error: ${response.body}');
    }

    return DietClassification.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ── GENERATE MEAL WITH AI (Gemini) ────────────────────────────────────────
  Future<List<AiGeneratedMeal>> generateMealWithAI(
    Map<String, dynamic> userInputs,
  ) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/generate_meal_with_ai'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userInputs),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Generate meal API error: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = data['meals'] as List<dynamic>? ?? [];
    return meals.map((e) => AiGeneratedMeal.fromJson(e)).toList();
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
    ingredients: List<String>.from(j['ingredients'] as List? ?? []),
    calories: (j['calories'] as num?)?.toDouble() ?? 0,
    protein: (j['protein'] as num?)?.toDouble() ?? 0,
    carbs: (j['carbs'] as num?)?.toDouble() ?? 0,
    fat: (j['fat'] as num?)?.toDouble() ?? 0,
    bestTime: j['bestTime'] as String? ?? '',
    description: j['description'] as String? ?? '',
  );

  /// Convert to MealModel for Firestore save
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
