class HealthDataModel {
  final String id;
  final String userId;
  final DateTime date;
  final int steps;
  final double caloriesBurned;
  final double waterIntake;
  final int sleepHours;
  final double weight;
  final String mood;

  HealthDataModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.steps,
    required this.caloriesBurned,
    required this.waterIntake,
    required this.sleepHours,
    required this.weight,
    required this.mood,
  });

  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    return HealthDataModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime(2024, 10, 15).toIso8601String()),
      steps: json['steps'] ?? 0,
      caloriesBurned: (json['caloriesBurned'] ?? 0.0).toDouble(),
      waterIntake: (json['waterIntake'] ?? 0.0).toDouble(),
      sleepHours: json['sleepHours'] ?? 0,
      weight: (json['weight'] ?? 0.0).toDouble(),
      mood: json['mood'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'waterIntake': waterIntake,
      'sleepHours': sleepHours,
      'weight': weight,
      'mood': mood,
    };
  }
}

class WorkoutModel {
  final String id;
  final String name;
  final String description;
  final int duration;
  final String difficulty;
  final List<String> exercises;
  final String category;
  final String imageUrl;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.exercises,
    required this.category,
    required this.imageUrl,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      difficulty: json['difficulty'] ?? '',
      exercises: List<String>.from(json['exercises'] ?? []),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'exercises': exercises,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}

class NutritionModel {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String category;
  final String imageUrl;

  NutritionModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.category,
    required this.imageUrl,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      calories: json['calories'] ?? 0,
      protein: (json['protein'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}