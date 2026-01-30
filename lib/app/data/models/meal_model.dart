class MealModel {
  final String? id;
  final String name;
  final String description;
  final String kcal;
  final String protein;
  final String carbs;
  final String fat;
  final List<String> categories;
  final String imageUrl;
  final List<IngredientModel> ingredients;
  final String instructions;
  final DateTime createdAt;
  final String prepTime;
  final String difficulty;

  final String userId;
  final String groupId;

  MealModel({
    this.id,
    required this.userId,
    required this.groupId,
    required this.name,
    required this.description,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.categories,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.createdAt,
    required this.prepTime,
    required this.difficulty,
  });

  factory MealModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return MealModel(
      id: docId ?? json['_id'] ?? json['id'],
      userId: json['userId'] ?? json['user_id'] ?? '',
      groupId: json['groupId'] ?? json['group_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      kcal: json['kcal']?.toString() ?? '0',
      protein: json['protein']?.toString() ?? '0',
      carbs: json['carbs']?.toString() ?? '0',
      fat: json['fat']?.toString() ?? '0',
      categories: List<String>.from(
        json['categorys'] ?? json['categories'] ?? [],
      ),
      imageUrl: json['imageUrl'] ?? '',
      ingredients: (json['ingredients'] as List? ?? [])
          .map((i) => IngredientModel.fromJson(i))
          .toList(),
      instructions: json['instructions'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      prepTime: json['prep_time'] ?? '',
      difficulty: json['difficulty'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'groupId': groupId,
      'name': name,
      'description': description,
      'kcal': kcal,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'categorys': categories,
      'imageUrl': imageUrl,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions,
      'created_at': createdAt.toIso8601String(),
      'prep_time': prepTime,
      'difficulty': difficulty,
    };
  }
}

class IngredientModel {
  final String name;
  final String amount;
  final String unit;

  IngredientModel({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] ?? '',
      amount: json['amount']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'amount': amount, 'unit': unit};
  }
}
