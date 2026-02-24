class MealCategoryModel {
  final String? id;
  final String groupCategoryId; // Reference to parent group category
  final String name;
  final String? time; // e.g., "07:00"
  final int order;
  final bool isDefault;
  final DateTime createdAt;
  final String createdBy;

  // Default meal categories with timings
  static const List<Map<String, dynamic>> defaultMealCategories = [
    {'name': 'Breakfast', 'time': '07:00'},
    {'name': 'Lunch', 'time': '12:00'},
    {'name': 'Dinner', 'time': '19:00'},
  ];

  MealCategoryModel({
    this.id,
    required this.groupCategoryId,
    required this.name,
    this.time,
    required this.order,
    required this.isDefault,
    required this.createdAt,
    required this.createdBy,
  });

  factory MealCategoryModel.fromJson(
    Map<String, dynamic> json, {
    String? docId,
  }) {
    return MealCategoryModel(
      id: docId ?? json['id'],
      groupCategoryId: json['groupCategoryId'] ?? '',
      name: json['name'] ?? '',
      time: json['time'],
      order: json['order'] ?? 0,
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      createdBy: json['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupCategoryId': groupCategoryId,
      'name': name,
      'time': time,
      'order': order,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  // Get formatted time
  String get formattedTime {
    return time ?? '';
  }

  MealCategoryModel copyWith({
    String? id,
    String? groupCategoryId,
    String? name,
    String? time,
    int? order,
    bool? isDefault,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return MealCategoryModel(
      id: id ?? this.id,
      groupCategoryId: groupCategoryId ?? this.groupCategoryId,
      name: name ?? this.name,
      time: time ?? this.time,
      order: order ?? this.order,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
