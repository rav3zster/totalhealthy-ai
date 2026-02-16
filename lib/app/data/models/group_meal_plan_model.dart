class GroupMealPlanModel {
  final String? id;
  final String groupId;
  final DateTime date; // The specific date for this plan
  final String? breakfastMealId;
  final String? lunchMealId;
  final String? dinnerMealId;
  final String createdBy;
  final String createdByName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  GroupMealPlanModel({
    this.id,
    required this.groupId,
    required this.date,
    this.breakfastMealId,
    this.lunchMealId,
    this.dinnerMealId,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    this.updatedAt,
  });

  // Helper to check if any meal is assigned
  bool get hasAnyMeal =>
      breakfastMealId != null || lunchMealId != null || dinnerMealId != null;

  // Helper to get meal count
  int get mealCount {
    int count = 0;
    if (breakfastMealId != null) count++;
    if (lunchMealId != null) count++;
    if (dinnerMealId != null) count++;
    return count;
  }

  factory GroupMealPlanModel.fromJson(
    Map<String, dynamic> json, {
    String? docId,
  }) {
    return GroupMealPlanModel(
      id: docId ?? json['id'],
      groupId: json['groupId'] ?? json['group_id'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      breakfastMealId: json['breakfastMealId'] ?? json['breakfast_meal_id'],
      lunchMealId: json['lunchMealId'] ?? json['lunch_meal_id'],
      dinnerMealId: json['dinnerMealId'] ?? json['dinner_meal_id'],
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
      'breakfastMealId': breakfastMealId,
      'lunchMealId': lunchMealId,
      'dinnerMealId': dinnerMealId,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Format date as YYYY-MM-DD for consistent storage
  String _formatDateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  GroupMealPlanModel copyWith({
    String? id,
    String? groupId,
    DateTime? date,
    String? breakfastMealId,
    String? lunchMealId,
    String? dinnerMealId,
    String? createdBy,
    String? createdByName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GroupMealPlanModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      date: date ?? this.date,
      breakfastMealId: breakfastMealId ?? this.breakfastMealId,
      lunchMealId: lunchMealId ?? this.lunchMealId,
      dinnerMealId: dinnerMealId ?? this.dinnerMealId,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
