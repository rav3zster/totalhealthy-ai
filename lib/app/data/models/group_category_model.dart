class GroupCategoryModel {
  final String? id;
  final String name;
  final String? description;
  final String icon; // Emoji or icon identifier
  final int order;
  final bool isDefault;
  final DateTime createdAt;
  final String createdBy;

  // Default group categories
  static const List<Map<String, dynamic>> defaultGroupCategories = [
    {'name': 'General', 'description': 'General meal planning', 'icon': '🍽️'},
    {
      'name': 'Fitness',
      'description': 'Workout and fitness meals',
      'icon': '💪',
    },
    {'name': 'Yoga', 'description': 'Yoga and wellness meals', 'icon': '🧘'},
    {
      'name': 'Medication',
      'description': 'Medical and supplement tracking',
      'icon': '💊',
    },
  ];

  GroupCategoryModel({
    this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.order,
    required this.isDefault,
    required this.createdAt,
    required this.createdBy,
  });

  factory GroupCategoryModel.fromJson(
    Map<String, dynamic> json, {
    String? docId,
  }) {
    return GroupCategoryModel(
      id: docId ?? json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'] ?? '🍽️',
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
      'name': name,
      'description': description,
      'icon': icon,
      'order': order,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  GroupCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    int? order,
    bool? isDefault,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return GroupCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
