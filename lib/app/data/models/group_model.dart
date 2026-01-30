class GroupModel {
  final String? id;
  final String name;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final int memberCount;
  final List<String> categories;
  final bool isPrivate;

  GroupModel({
    this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    this.memberCount = 1,
    this.categories = const [],
    this.isPrivate = false,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return GroupModel(
      id: docId ?? json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      memberCount: json['member_count'] ?? 0,
      categories: List<String>.from(json['categories'] ?? []),
      isPrivate: json['is_private'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'member_count': memberCount,
      'categories': categories,
      'is_private': isPrivate,
    };
  }
}
