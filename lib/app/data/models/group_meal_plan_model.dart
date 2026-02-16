class GroupMealPlanModel {
  final String? id;
  final String groupId;
  final DateTime date;

  // Dynamic meal slots - stores category name as key and mealId as value
  // Example: {'Breakfast': 'meal123', 'Morning Snack': 'meal456', 'Lunch': 'meal789'}
  final Map<String, String?> mealSlots;

  final String createdBy;
  final String createdByName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  GroupMealPlanModel({
    this.id,
    required this.groupId,
    required this.date,
    required this.mealSlots,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    this.updatedAt,
  });

  // Backward compatibility getters
  String? get breakfastMealId => mealSlots['Breakfast'];
  String? get lunchMealId => mealSlots['Lunch'];
  String? get dinnerMealId => mealSlots['Dinner'];

  // Helper to check if any meal is assigned
  bool get hasAnyMeal => mealSlots.values.any((id) => id != null);

  // Helper to get meal count
  int get mealCount => mealSlots.values.where((id) => id != null).length;

  // Get meal ID for a specific category
  String? getMealIdForCategory(String category) {
    return mealSlots[category];
  }

  // Helper to normalize category names (handle lowercase from old data)
  static String _normalizeCategory(String category) {
    // Map lowercase to proper case
    final normalized = {
      'breakfast': 'Breakfast',
      'lunch': 'Lunch',
      'dinner': 'Dinner',
      'morning snacks': 'Morning Snacks',
      'preworkout': 'Preworkout',
      'post workout': 'Post Workout',
    };
    return normalized[category.toLowerCase()] ?? category;
  }

  factory GroupMealPlanModel.fromJson(
    Map<String, dynamic> json, {
    String? docId,
  }) {
    // Parse mealSlots from JSON
    Map<String, String?> slots = {};

    // Check if new format exists
    if (json['mealSlots'] != null) {
      final slotsData = json['mealSlots'] as Map<String, dynamic>;
      // Normalize keys to handle lowercase from old data
      for (var entry in slotsData.entries) {
        final normalizedKey = _normalizeCategory(entry.key);
        slots[normalizedKey] = entry.value as String?;
      }
    }

    // ALWAYS check old format for backward compatibility
    // This ensures old data is migrated to new format
    if (json['breakfastMealId'] != null || json['breakfast_meal_id'] != null) {
      slots['Breakfast'] = json['breakfastMealId'] ?? json['breakfast_meal_id'];
    }
    if (json['lunchMealId'] != null || json['lunch_meal_id'] != null) {
      slots['Lunch'] = json['lunchMealId'] ?? json['lunch_meal_id'];
    }
    if (json['dinnerMealId'] != null || json['dinner_meal_id'] != null) {
      slots['Dinner'] = json['dinnerMealId'] ?? json['dinner_meal_id'];
    }

    return GroupMealPlanModel(
      id: docId ?? json['id'],
      groupId: json['groupId'] ?? json['group_id'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      mealSlots: slots,
      createdBy: json['createdBy'] ?? json['created_by'] ?? '',
      createdByName: json['createdByName'] ?? json['created_by_name'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'date': _formatDateOnly(date),
      'mealSlots': mealSlots,
      // Backward compatibility
      'breakfastMealId': mealSlots['Breakfast'],
      'lunchMealId': mealSlots['Lunch'],
      'dinnerMealId': mealSlots['Dinner'],
      'createdBy': createdBy,
      'createdByName': createdByName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String _formatDateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  GroupMealPlanModel copyWith({
    String? id,
    String? groupId,
    DateTime? date,
    Map<String, String?>? mealSlots,
    String? createdBy,
    String? createdByName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GroupMealPlanModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      date: date ?? this.date,
      mealSlots: mealSlots ?? Map.from(this.mealSlots),
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
