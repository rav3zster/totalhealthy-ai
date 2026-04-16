import '../models/user_model.dart';
import 'package:flutter/foundation.dart';
import '../models/health_data_model.dart';
import '../models/meal_model.dart';
import './meals_firestore_service.dart';
class DummyDataService {
  // Mock credentials for login
  static const String mockEmail = "demo@totalhealthy.com";
  static const String mockPassword = "Demo123!";
  static const String mockPhone = "+1234567890";

  static bool validateLogin(String email, String password) {
    return (email.toLowerCase() == mockEmail.toLowerCase() &&
            password == mockPassword) ||
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
      joinDate: DateTime.parse("2024-01-15"),
      planName: "Keto Plan",
      planDuration: "Oct 1 - Nov 1",
      progressPercentage: 85,
    );
  }

  static List<HealthDataModel> getDummyHealthData() {
    final baseDate = DateTime(
      2024,
      10,
      15,
    ); // Static base date: October 15, 2024
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
        mood: [
          "Happy",
          "Energetic",
          "Calm",
          "Motivated",
          "Relaxed",
          "Focused",
          "Peaceful",
        ][index % 7],
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
        exercises: [
          "Jumping Jacks",
          "Burpees",
          "Mountain Climbers",
          "High Knees",
        ],
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
        exercises: [
          "Sun Salutation",
          "Warrior Pose",
          "Tree Pose",
          "Child's Pose",
        ],
        category: "Yoga",
        imageUrl: "https://via.placeholder.com/300x200",
      ),
      WorkoutModel(
        id: "workout_4",
        name: "HIIT Training",
        description: "High-intensity interval training for maximum results",
        duration: 20,
        difficulty: "Advanced",
        exercises: [
          "Sprint Intervals",
          "Jump Squats",
          "Plank Jacks",
          "Battle Ropes",
        ],
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
      "monthlyProgress": List.generate(
        30,
        (index) => {
          "date": DateTime(
            2024,
            10,
            15,
          ).subtract(Duration(days: 29 - index)).toIso8601String(),
          "steps": 7000 + (index * 100) + (index % 7 * 500),
          "calories": 300 + (index * 10) + (index % 5 * 50),
          "weight": 70.5 - (index * 0.02),
        },
      ),
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
      // {
      //   "id": "group_1",
      //   "name": "Weekly Meal Planning Group",
      //   "description":
      //       "A support group for planning and tracking weekly meal prep, ideal for maintaining a balanced diet.",
      //   "memberCount": 12,
      //   "createdBy": "Alex Johnson",
      //   "createdDate": "August 1, 2024",
      //   "isAdmin": true,
      //   "category": "Meal Planning",
      //   "isPrivate": false,
      // },
      // {
      //   "id": "group_2",
      //   "name": "Weight Loss Journey Group",
      //   "description":
      //       "A motivational group for clients focused on achieving weight loss goals through balanced nutrition and regular tracking.",
      //   "memberCount": 10,
      //   "createdBy": "Sarah Wilson",
      //   "createdDate": "July 15, 2024",
      //   "isAdmin": false,
      //   "category": "Weight Loss",
      //   "isPrivate": false,
      // },
      // {
      //   "id": "group_3",
      //   "name": "Muscle Gain Program Group",
      //   "description":
      //       "A group for individuals focused on building muscle through high-protein diets and regular nutrition updates.",
      //   "memberCount": 18,
      //   "createdBy": "Mike Johnson",
      //   "createdDate": "June 20, 2024",
      //   "isAdmin": false,
      //   "category": "Muscle Gain",
      //   "isPrivate": false,
      // },
      // {
      //   "id": "group_4",
      //   "name": "Family Meal Planning Group",
      //   "description":
      //       "A community for creating family-friendly meal plans that support a balanced diet for all age groups.",
      //   "memberCount": 22,
      //   "createdBy": "Emma Davis",
      //   "createdDate": "May 10, 2024",
      //   "isAdmin": false,
      //   "category": "Family Nutrition",
      //   "isPrivate": false,
      // },
      // {
      //   "id": "group_5",
      //   "name": "Vegan Lifestyle Support Group",
      //   "description":
      //       "A support group for those following or interested in a plant-based, vegan lifestyle.",
      //   "memberCount": 15,
      //   "createdBy": "David Brown",
      //   "createdDate": "April 5, 2024",
      //   "isAdmin": false,
      //   "category": "Vegan",
      //   "isPrivate": false,
      // },
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
        "userId": "all",
        "groupId": "group_1",
        "name": "Oatmeal with Berries",
        "description": "Healthy breakfast with oats, mixed berries, and honey",
        "kcal": "320",
        "protein": "12",
        "carbs": "58",
        "fat": "6",
        "categorys": ["Breakfast"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Oats", "amount": "50"},
          {"name": "Blueberries", "amount": "30"},
          {"name": "Strawberries", "amount": "25"},
          {"name": "Honey", "amount": "15"},
          {"name": "Milk", "amount": "200"},
        ],
        "instructions": "Cook oats with milk, add berries and honey on top",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "10 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_2",
        "userId": "all",
        "groupId": "group_1",
        "name": "Greek Yogurt Parfait",
        "description": "Layered yogurt with granola and fresh fruits",
        "kcal": "280",
        "protein": "20",
        "carbs": "35",
        "fat": "8",
        "categorys": ["Breakfast"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Greek yogurt", "amount": "150"},
          {"name": "Granola", "amount": "30"},
          {"name": "Berries", "amount": "50"},
          {"name": "Honey", "amount": "10"},
        ],
        "instructions": "Layer yogurt, granola, and berries in a glass",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "5 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_3",
        "userId": "all",
        "groupId": "group_1",
        "name": "Grilled Chicken Salad",
        "description": "Fresh salad with grilled chicken breast and vegetables",
        "kcal": "285",
        "protein": "35",
        "carbs": "12",
        "fat": "8",
        "categorys": ["Lunch"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Chicken breast", "amount": "120"},
          {"name": "Mixed greens", "amount": "80"},
          {"name": "Tomatoes", "amount": "50"},
          {"name": "Cucumber", "amount": "40"},
          {"name": "Olive oil", "amount": "10"},
        ],
        "instructions": "Grill chicken, mix with fresh vegetables and dressing",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "20 minutes",
        "difficulty": "Medium",
      },
      {
        "_id": "meal_4",
        "userId": "all",
        "groupId": "group_1",
        "name": "Quinoa Buddha Bowl",
        "description":
            "Nutritious bowl with quinoa, vegetables, and tahini dressing",
        "kcal": "380",
        "protein": "15",
        "carbs": "45",
        "fat": "12",
        "categorys": ["Lunch"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Quinoa", "amount": "75"},
          {"name": "Chickpeas", "amount": "60"},
          {"name": "Avocado", "amount": "80"},
          {"name": "Sweet potato", "amount": "100"},
          {"name": "Tahini", "amount": "20"},
        ],
        "instructions":
            "Cook quinoa, roast vegetables, assemble bowl with dressing",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "30 minutes",
        "difficulty": "Medium",
      },
      {
        "_id": "meal_5",
        "userId": "all",
        "groupId": "group_1",
        "name": "Salmon with Quinoa",
        "description": "Baked salmon with quinoa and steamed vegetables",
        "kcal": "420",
        "protein": "28",
        "carbs": "35",
        "fat": "18",
        "categorys": ["Dinner"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Salmon fillet", "amount": "150"},
          {"name": "Quinoa", "amount": "75"},
          {"name": "Broccoli", "amount": "100"},
          {"name": "Carrots", "amount": "80"},
          {"name": "Lemon", "amount": "30"},
        ],
        "instructions": "Bake salmon, cook quinoa, steam vegetables",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "25 minutes",
        "difficulty": "Medium",
      },
      {
        "_id": "meal_6",
        "userId": "all",
        "groupId": "group_1",
        "name": "Vegetable Stir Fry",
        "description": "Colorful vegetable stir fry with brown rice",
        "kcal": "310",
        "protein": "12",
        "carbs": "48",
        "fat": "10",
        "categorys": ["Dinner"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Mixed vegetables", "amount": "200"},
          {"name": "Brown rice", "amount": "75"},
          {"name": "Soy sauce", "amount": "15"},
          {"name": "Ginger", "amount": "10"},
          {"name": "Garlic", "amount": "5"},
        ],
        "instructions": "Stir fry vegetables, serve over brown rice",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "15 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_7",
        "userId": "all",
        "groupId": "group_1",
        "name": "Apple with Almond Butter",
        "description": "Simple and nutritious snack",
        "kcal": "190",
        "protein": "4",
        "carbs": "25",
        "fat": "8",
        "categorys": ["Mid-Morning Snack"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Apple", "amount": "150"},
          {"name": "Almond butter", "amount": "20"},
        ],
        "instructions": "Slice apple and serve with almond butter",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "2 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_8",
        "userId": "all",
        "groupId": "group_1",
        "name": "Trail Mix",
        "description": "Homemade trail mix with nuts and dried fruits",
        "kcal": "220",
        "protein": "6",
        "carbs": "18",
        "fat": "14",
        "categorys": ["Evening Snack"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Almonds", "amount": "30"},
          {"name": "Walnuts", "amount": "25"},
          {"name": "Dried cranberries", "amount": "20"},
          {"name": "Dark chocolate chips", "amount": "15"},
        ],
        "instructions": "Mix all ingredients together",
        "created_at": staticDate.toIso8601String(),
        "prep_time": "1 minute",
        "difficulty": "Easy",
      },
      // Add more meals for different dates to ensure there's always data
      {
        "_id": "meal_9",
        "userId": "all",
        "groupId": "group_1",
        "name": "Avocado Toast",
        "description": "Whole grain toast with mashed avocado",
        "kcal": "250",
        "protein": "8",
        "carbs": "30",
        "fat": "12",
        "categorys": ["Breakfast"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Whole grain bread", "amount": "2 slices"},
          {"name": "Avocado", "amount": "100"},
          {"name": "Lemon", "amount": "10"},
          {"name": "Salt", "amount": "2"},
          {"name": "Pepper", "amount": "1"},
        ],
        "instructions":
            "Toast bread, mash avocado with seasonings, spread on toast",
        "created_at": staticDate.subtract(Duration(days: 1)).toIso8601String(),
        "prep_time": "5 minutes",
        "difficulty": "Easy",
      },
      {
        "_id": "meal_10",
        "userId": "all",
        "groupId": "group_1",
        "name": "Chicken Wrap",
        "description": "Grilled chicken wrap with vegetables",
        "kcal": "350",
        "protein": "25",
        "carbs": "40",
        "fat": "10",
        "categorys": ["Lunch"],
        "imageUrl": "https://via.placeholder.com/200x150",
        "ingredients": [
          {"name": "Tortilla", "amount": "1 large"},
          {"name": "Grilled chicken", "amount": "100"},
          {"name": "Lettuce", "amount": "30"},
          {"name": "Tomato", "amount": "50"},
          {"name": "Cucumber", "amount": "40"},
        ],
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
        "message":
            "Check out this healthy breakfast recipe perfect for your goals.",
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
        "lastActive": baseDate
            .subtract(Duration(minutes: 30))
            .toIso8601String(),
        "progress": 85,
      },
    ];
  }

  // Simulate network delay
  static Future<T> simulateNetworkDelay<T>(
    T data, {
    int milliseconds = 1000,
  }) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    return data;
  }

  // Mock API response structure
  static Map<String, dynamic> mockApiResponse(
    dynamic data, {
    bool success = true,
  }) {
    return {
      "success": success,
      "data": data,
      "message": success ? "Operation successful" : "Operation failed",
      "statusCode": success ? 200 : 400,
    };
  }

  /// Upload dummy meals to Firestore if needed
  static Future<void> uploadDummyMealsToFirestore() async {
    try {
      final mealsService = MealsFirestoreService();
      final existingMeals = await mealsService.getMeals();

      if (existingMeals.isEmpty) {
        final mealsData = getDummyMeals();
        final meals = mealsData.map((m) => MealModel.fromJson(m)).toList();
        await mealsService.uploadBulkMeals(meals);
        debugPrint("Successfully seeded dummy meals to Firestore.");
      } else {
        debugPrint("Meals already exist in Firestore, skipping seeding.");
      }
    } catch (e) {
      debugPrint("Error seeding dummy meals: $e");
    }
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
