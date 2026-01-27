import '../models/user_model.dart';
import '../models/health_data_model.dart';

class DummyDataService {
  // Mock credentials for login
  static const String mockEmail = "demo@totalhealthy.com";
  static const String mockPassword = "Demo123!";
  static const String mockPhone = "+1234567890";

  static bool validateLogin(String email, String password) {
    return (email.toLowerCase() == mockEmail.toLowerCase() && password == mockPassword) ||
           (email == mockPhone && password == mockPassword);
  }

  static UserModel getDummyUser() {
    return UserModel(
      id: "user_123",
      email: "ayush@gmail.com",
      username: "Ayush Shukla",
      phone: "+1234567890",
      firstName: "Ayush",
      lastName: "Shukla",
      profileImage: "https://via.placeholder.com/150",
      age: 28,
      weight: 70.5,
      height: 175,
      activityLevel: "Moderate",
      goals: ["Weight Loss", "Muscle Gain"],
      joinDate: "2024-01-15",
      planName: "Keto Plan",
      planDuration: "Oct 1 - Nov 1",
      progressPercentage: 85,
    );
  }

  static List<HealthDataModel> getDummyHealthData() {
    final baseDate = DateTime(2024, 10, 15); // Static base date: October 15, 2024
    return List.generate(30, (index) {
      final date = baseDate.subtract(Duration(days: index));
      return HealthDataModel(
        id: "health_${index + 1}",
        userId: "user_123",
        date: date,
        steps: 8000 + (index * 200) + (index % 3 * 1000),
        caloriesBurned: 300.0 + (index * 25) + (index % 4 * 50),
        waterIntake: 2.0 + (index * 0.1) + (index % 5 * 0.3),
        sleepHours: 7 + (index % 3),
        weight: 70.5 - (index * 0.05),
        mood: ["Happy", "Energetic", "Calm", "Motivated", "Relaxed", "Focused", "Peaceful"][index % 7],
      );
    });
  }

  static List<WorkoutModel> getDummyWorkouts() {
    return [
      WorkoutModel(
        id: "workout_1",
        name: "Morning Cardio",
        description: "High-intensity cardio workout to start your day",
        duration: 30,
        difficulty: "Intermediate",
        exercises: ["Jumping Jacks", "Burpees", "Mountain Climbers", "High Knees"],
        category: "Cardio",
        imageUrl: "https://via.placeholder.com/300x200",
      ),
      WorkoutModel(
        id: "workout_2",
        name: "Strength Training",
        description: "Full body strength workout for muscle building",
        duration: 45,
        difficulty: "Advanced",
        exercises: ["Push-ups", "Squats", "Deadlifts", "Pull-ups"],
        category: "Strength",
        imageUrl: "https://via.placeholder.com/300x200",
      ),
      WorkoutModel(
        id: "workout_3",
        name: "Yoga Flow",
        description: "Relaxing yoga session for flexibility and mindfulness",
        duration: 25,
        difficulty: "Beginner",
        exercises: ["Sun Salutation", "Warrior Pose", "Tree Pose", "Child's Pose"],
        category: "Yoga",
        imageUrl: "https://via.placeholder.com/300x200",
      ),
      WorkoutModel(
        id: "workout_4",
        name: "HIIT Training",
        description: "High-intensity interval training for maximum results",
        duration: 20,
        difficulty: "Advanced",
        exercises: ["Sprint Intervals", "Jump Squats", "Plank Jacks", "Battle Ropes"],
        category: "HIIT",
        imageUrl: "https://via.placeholder.com/300x200",
      ),
      WorkoutModel(
        id: "workout_5",
        name: "Core Blast",
        description: "Targeted core strengthening workout",
        duration: 15,
        difficulty: "Intermediate",
        exercises: ["Planks", "Russian Twists", "Bicycle Crunches", "Dead Bug"],
        category: "Core",
        imageUrl: "https://via.placeholder.com/300x200",
      ),
      WorkoutModel(
        id: "workout_6",
        name: "Upper Body Power",
        description: "Focus on building upper body strength",
        duration: 40,
        difficulty: "Advanced",
        exercises: ["Bench Press", "Rows", "Shoulder Press", "Tricep Dips"],
        category: "Strength",
        imageUrl: "https://via.placeholder.com/300x200",
      ),
    ];
  }

  static List<NutritionModel> getDummyNutrition() {
    return [
      NutritionModel(
        id: "food_1",
        name: "Grilled Chicken Breast",
        calories: 165,
        protein: 31,
        carbs: 0,
        fat: 3.6,
        category: "Protein",
        imageUrl: "https://via.placeholder.com/200x150",
      ),
      NutritionModel(
        id: "food_2",
        name: "Brown Rice",
        calories: 216,
        protein: 5,
        carbs: 45,
        fat: 1.8,
        category: "Carbs",
        imageUrl: "https://via.placeholder.com/200x150",
      ),
      NutritionModel(
        id: "food_3",
        name: "Avocado",
        calories: 234,
        protein: 2.9,
        carbs: 12,
        fat: 21,
        category: "Healthy Fats",
        imageUrl: "https://via.placeholder.com/200x150",
      ),
      NutritionModel(
        id: "food_4",
        name: "Greek Yogurt",
        calories: 100,
        protein: 17,
        carbs: 6,
        fat: 0.4,
        category: "Protein",
        imageUrl: "https://via.placeholder.com/200x150",
      ),
      NutritionModel(
        id: "food_5",
        name: "Quinoa",
        calories: 222,
        protein: 8,
        carbs: 39,
        fat: 3.6,
        category: "Carbs",
        imageUrl: "https://via.placeholder.com/200x150",
      ),
      NutritionModel(
        id: "food_6",
        name: "Salmon",
        calories: 208,
        protein: 22,
        carbs: 0,
        fat: 12,
        category: "Protein",
        imageUrl: "https://via.placeholder.com/200x150",
      ),
      NutritionModel(
        id: "food_7",
        name: "Sweet Potato",
        calories: 112,
        protein: 2,
        carbs: 26,
        fat: 0.1,
        category: "Carbs",
        imageUrl: "https://via.placeholder.com/200x150",
      ),
      NutritionModel(
        id: "food_8",
        name: "Almonds",
        calories: 161,
        protein: 6,
        carbs: 6,
        fat: 14,
        category: "Healthy Fats",
        imageUrl: "https://via.placeholder.com/200x150",
      ),
    ];
  }

  static Map<String, dynamic> getDummyDashboardStats() {
    return {
      "todaySteps": 8547,
      "stepGoal": 10000,
      "caloriesBurned": 420,
      "calorieGoal": 500,
      "waterIntake": 2.3,
      "waterGoal": 3.0,
      "sleepHours": 7.5,
      "sleepGoal": 8.0,
      "weeklyWorkouts": 4,
      "workoutGoal": 5,
      "currentWeight": 70.2,
      "targetWeight": 68.0,
      "weeklyProgress": [
        {"day": "Mon", "steps": 9200, "calories": 380},
        {"day": "Tue", "steps": 8500, "calories": 420},
        {"day": "Wed", "steps": 10200, "calories": 450},
        {"day": "Thu", "steps": 7800, "calories": 350},
        {"day": "Fri", "steps": 9500, "calories": 480},
        {"day": "Sat", "steps": 11000, "calories": 520},
        {"day": "Sun", "steps": 8547, "calories": 420},
      ],
      "monthlyProgress": List.generate(30, (index) => {
        "date": DateTime(2024, 10, 15).subtract(Duration(days: 29 - index)).toIso8601String(),
        "steps": 7000 + (index * 100) + (index % 7 * 500),
        "calories": 300 + (index * 10) + (index % 5 * 50),
        "weight": 70.5 - (index * 0.02),
      }),
    };
  }

  static List<Map<String, dynamic>> getDummyAchievements() {
    return [
      {
        "id": "achievement_1",
        "title": "First Week Complete",
        "description": "Completed your first week of workouts",
        "icon": "🏆",
        "unlocked": true,
        "date": "2024-01-22",
        "points": 100,
      },
      {
        "id": "achievement_2",
        "title": "10K Steps Master",
        "description": "Reached 10,000 steps in a single day",
        "icon": "👟",
        "unlocked": true,
        "date": "2024-01-20",
        "points": 50,
      },
      {
        "id": "achievement_3",
        "title": "Hydration Hero",
        "description": "Drank 3L of water for 5 consecutive days",
        "icon": "💧",
        "unlocked": false,
        "date": null,
        "points": 75,
      },
      {
        "id": "achievement_4",
        "title": "Early Bird",
        "description": "Completed morning workouts for a week",
        "icon": "🌅",
        "unlocked": true,
        "date": "2024-01-18",
        "points": 80,
      },
      {
        "id": "achievement_5",
        "title": "Consistency King",
        "description": "Logged meals for 30 consecutive days",
        "icon": "👑",
        "unlocked": true,
        "date": "2024-01-15",
        "points": 200,
      },
      {
        "id": "achievement_6",
        "title": "Protein Power",
        "description": "Met protein goals for 14 days straight",
        "icon": "💪",
        "unlocked": false,
        "date": null,
        "points": 120,
      },
    ];
  }

  static List<Map<String, dynamic>> getDummyGroups() {
    return [
      {
        "id": "group_1",
        "name": "Fitness Enthusiasts",
        "description": "A group for people passionate about fitness and healthy living",
        "memberCount": 24,
        "createdBy": "Alex Johnson",
        "createdDate": "2024-01-10",
        "isAdmin": true,
        "category": "Fitness",
        "isPrivate": false,
      },
      {
        "id": "group_2",
        "name": "Weight Loss Journey",
        "description": "Supporting each other in achieving weight loss goals",
        "memberCount": 18,
        "createdBy": "Sarah Wilson",
        "createdDate": "2024-01-05",
        "isAdmin": false,
        "category": "Weight Loss",
        "isPrivate": false,
      },
      {
        "id": "group_3",
        "name": "Yoga Masters",
        "description": "Daily yoga practice and mindfulness community",
        "memberCount": 32,
        "createdBy": "Mike Johnson",
        "createdDate": "2024-01-12",
        "isAdmin": false,
        "category": "Yoga",
        "isPrivate": false,
      },
      {
        "id": "group_4",
        "name": "Nutrition Experts",
        "description": "Share recipes, meal plans, and nutrition tips",
        "memberCount": 15,
        "createdBy": "Emma Davis",
        "createdDate": "2024-01-08",
        "isAdmin": false,
        "category": "Nutrition",
        "isPrivate": true,
      },
      {
        "id": "group_5",
        "name": "Marathon Runners",
        "description": "Training together for marathon and long-distance running",
        "memberCount": 12,
        "createdBy": "David Brown",
        "createdDate": "2024-01-14",
        "isAdmin": false,
        "category": "Running",
        "isPrivate": false,
      },
    ];
  }

  static List<Map<String, dynamic>> getDummyMealCategories() {
    return [
      {
        "id": "category_1",
        "label_name": "Breakfast",
        "time_range": "07:00",
        "created_at": "2024-01-15T07:00:00Z",
        "icon": "🍳",
        "color": "#FF6B6B",
      },
      {
        "id": "category_2",
        "label_name": "Mid-Morning Snack",
        "time_range": "10:00",
        "created_at": "2024-01-15T10:00:00Z",
        "icon": "🍎",
        "color": "#4ECDC4",
      },
      {
        "id": "category_3",
        "label_name": "Lunch",
        "time_range": "13:00",
        "created_at": "2024-01-15T13:00:00Z",
        "icon": "🥗",
        "color": "#45B7D1",
      },
      {
        "id": "category_4",
        "label_name": "Evening Snack",
        "time_range": "16:00",
        "created_at": "2024-01-15T16:00:00Z",
        "icon": "🥜",
        "color": "#F7DC6F",
      },
      {
        "id": "category_5",
        "label_name": "Dinner",
        "time_range": "19:00",
        "created_at": "2024-01-15T19:00:00Z",
        "icon": "🍽️",
        "color": "#BB8FCE",
      },
    ];
  }

  static List<Map<String, dynamic>> getDummyMeals() {
    final staticDate = DateTime(2024, 10, 15); // Static date: October 15, 2024
    return [
      {
        "_id": "meal_1",
        "name": "Oatmeal with Berries",
        "description": "Healthy breakfast with oats, mixed berries, and honey",
        "kcal": "320",
        "protein": "12",
        "carbs": "58",
        "fat": "6",
        "categorys": ["Breakfast"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Oats", "Blueberries", "Strawberries", "Honey", "Milk"],
        "instructions": "Cook oats with milk, add berries and honey on top",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "10 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_2",
        "name": "Greek Yogurt Parfait",
        "description": "Layered yogurt with granola and fresh fruits",
        "kcal": "280",
        "protein": "20",
        "carbs": "35",
        "fat": "8",
        "categorys": ["Breakfast"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Greek yogurt", "Granola", "Berries", "Honey"],
        "instructions": "Layer yogurt, granola, and berries in a glass",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "5 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_3",
        "name": "Grilled Chicken Salad",
        "description": "Fresh salad with grilled chicken breast and vegetables",
        "kcal": "285",
        "protein": "35",
        "carbs": "12",
        "fat": "8",
        "categorys": ["Lunch"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Chicken breast", "Mixed greens", "Tomatoes", "Cucumber", "Olive oil"],
        "instructions": "Grill chicken, mix with fresh vegetables and dressing",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "20 minutes",
        "difficulty": "Medium",
      },
      {
        "_id": "meal_4",
        "name": "Quinoa Buddha Bowl",
        "description": "Nutritious bowl with quinoa, vegetables, and tahini dressing",
        "kcal": "380",
        "protein": "15",
        "carbs": "45",
        "fat": "12",
        "categorys": ["Lunch"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Quinoa", "Chickpeas", "Avocado", "Sweet potato", "Tahini"],
        "instructions": "Cook quinoa, roast vegetables, assemble bowl with dressing",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "30 minutes",
        "difficulty": "Medium",
      },
      {
        "_id": "meal_5",
        "name": "Salmon with Quinoa",
        "description": "Baked salmon with quinoa and steamed vegetables",
        "kcal": "420",
        "protein": "28",
        "carbs": "35",
        "fat": "18",
        "categorys": ["Dinner"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Salmon fillet", "Quinoa", "Broccoli", "Carrots", "Lemon"],
        "instructions": "Bake salmon, cook quinoa, steam vegetables",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "25 minutes",
        "difficulty": "Medium",
      },
      {
        "_id": "meal_6",
        "name": "Vegetable Stir Fry",
        "description": "Colorful vegetable stir fry with brown rice",
        "kcal": "310",
        "protein": "12",
        "carbs": "48",
        "fat": "10",
        "categorys": ["Dinner"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Mixed vegetables", "Brown rice", "Soy sauce", "Ginger", "Garlic"],
        "instructions": "Stir fry vegetables, serve over brown rice",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "15 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_7",
        "name": "Apple with Almond Butter",
        "description": "Simple and nutritious snack",
        "kcal": "190",
        "protein": "4",
        "carbs": "25",
        "fat": "8",
        "categorys": ["Mid-Morning Snack"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Apple", "Almond butter"],
        "instructions": "Slice apple and serve with almond butter",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "2 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_8",
        "name": "Trail Mix",
        "description": "Homemade trail mix with nuts and dried fruits",
        "kcal": "220",
        "protein": "6",
        "carbs": "18",
        "fat": "14",
        "categorys": ["Evening Snack"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Almonds", "Walnuts", "Dried cranberries", "Dark chocolate chips"],
        "instructions": "Mix all ingredients together",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "1 minute",
        "difficulty": "Easy",
      },
      // Add more meals for different dates to ensure there's always data
      {
        "_id": "meal_9",
        "name": "Avocado Toast",
        "description": "Whole grain toast with mashed avocado",
        "kcal": "250",
        "protein": "8",
        "carbs": "30",
        "fat": "12",
        "categorys": ["Breakfast"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Whole grain bread", "Avocado", "Lemon", "Salt", "Pepper"],
        "instructions": "Toast bread, mash avocado with seasonings, spread on toast",
        "created_at": staticDate.subtract(Duration(days: 1)).toIso8601String(),
        "prep_time": "5 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_10",
        "name": "Chicken Wrap",
        "description": "Grilled chicken wrap with vegetables",
        "kcal": "350",
        "protein": "25",
        "carbs": "40",
        "fat": "10",
        "categorys": ["Lunch"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": ["Tortilla", "Grilled chicken", "Lettuce", "Tomato", "Cucumber"],
        "instructions": "Wrap chicken and vegetables in tortilla",
        "created_at": staticDate.subtract(Duration(days: 1)).toIso8601String(),
        "prep_time": "10 minutes",
        "difficulty": "Easy",
      },
    ];
  }

  static List<Map<String, dynamic>> getDummyNotifications() {
    final baseDate = DateTime(2024, 10, 15); // Static base date
    return [
      {
        "id": "notif_1",
        "title": "Meal Reminder",
        "message": "Time for your lunch! Don't forget to log your meal.",
        "type": "meal_reminder",
        "timestamp": baseDate.subtract(Duration(hours: 2)).toIso8601String(),
        "isRead": false,
        "priority": "high",
      },
      {
        "id": "notif_2",
        "title": "Workout Complete",
        "message": "Great job completing your morning cardio workout!",
        "type": "achievement",
        "timestamp": baseDate.subtract(Duration(hours: 5)).toIso8601String(),
        "isRead": true,
        "priority": "medium",
      },
      {
        "id": "notif_3",
        "title": "Hydration Reminder",
        "message": "Remember to drink water! You're 200ml behind your goal.",
        "type": "hydration",
        "timestamp": baseDate.subtract(Duration(minutes: 30)).toIso8601String(),
        "isRead": false,
        "priority": "medium",
      },
      {
        "id": "notif_4",
        "title": "Weekly Goal Achieved",
        "message": "Congratulations! You've reached your weekly step goal.",
        "type": "achievement",
        "timestamp": baseDate.subtract(Duration(days: 1)).toIso8601String(),
        "isRead": true,
        "priority": "high",
      },
      {
        "id": "notif_5",
        "title": "New Recipe Available",
        "message": "Check out this healthy breakfast recipe perfect for your goals.",
        "type": "recipe",
        "timestamp": baseDate.subtract(Duration(days: 2)).toIso8601String(),
        "isRead": false,
        "priority": "low",
      },
    ];
  }

  static List<Map<String, dynamic>> getDummyClients() {
    final baseDate = DateTime(2024, 10, 15); // Static base date
    return [
      {
        "id": "client_1",
        "name": "Sarah Wilson",
        "email": "sarah.wilson@email.com",
        "phone": "+1234567891",
        "age": 32,
        "weight": 65.0,
        "height": 168,
        "goals": ["Weight Loss", "Muscle Tone"],
        "joinDate": "2024-01-10",
        "lastActive": baseDate.subtract(Duration(hours: 2)).toIso8601String(),
        "progress": 75,
      },
      {
        "id": "client_2",
        "name": "Mike Johnson",
        "email": "mike.johnson@email.com",
        "phone": "+1234567892",
        "age": 28,
        "weight": 80.5,
        "height": 182,
        "goals": ["Muscle Gain", "Strength"],
        "joinDate": "2024-01-08",
        "lastActive": baseDate.subtract(Duration(hours: 1)).toIso8601String(),
        "progress": 60,
      },
      {
        "id": "client_3",
        "name": "Emma Davis",
        "email": "emma.davis@email.com",
        "phone": "+1234567893",
        "age": 25,
        "weight": 58.0,
        "height": 165,
        "goals": ["Fitness", "Endurance"],
        "joinDate": "2024-01-12",
        "lastActive": baseDate.subtract(Duration(minutes: 30)).toIso8601String(),
        "progress": 85,
      },
    ];
  }

  // Simulate network delay
  static Future<T> simulateNetworkDelay<T>(T data, {int milliseconds = 1000}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    return data;
  }

  // Mock API response structure
  static Map<String, dynamic> mockApiResponse(dynamic data, {bool success = true}) {
    return {
      "success": success,
      "data": data,
      "message": success ? "Operation successful" : "Operation failed",
      "statusCode": success ? 200 : 400,
    };
  }
}

// Additional model classes for the dummy data
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