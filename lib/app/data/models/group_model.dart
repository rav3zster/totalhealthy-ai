class GroupModel {
  final String? id;
  final String name;
  final String description;
  final String? groupCategoryId; // Reference to group category
  final String createdBy; // Keep existing field name for Firebase compatibility
  final List<String> membersList; // Use existing Firebase field name
  final DateTime createdAt;
  final int memberCount;
  final List<String> categories;
  final bool isPrivate;

  GroupModel({
    this.id,
    required this.name,
    required this.description,
    this.groupCategoryId,
    required this.createdBy,
    this.membersList = const [],
    required this.createdAt,
    this.memberCount = 1,
    this.categories = const [],
    this.isPrivate = false,
  });

  // Computed properties for member management
  int get actualMemberCount => membersList.length;
  bool isAdmin(String userId) => createdBy == userId;
  bool isMember(String userId) => membersList.contains(userId);

  factory GroupModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return GroupModel(
      id: docId ?? json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      groupCategoryId: json['group_category_id'],
      createdBy: json['created_by'] ?? '',
      membersList: List<String>.from(json['members_list'] ?? []),
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
      'id': id, // Include the id field
      'name': name,
      'description': description,
      'group_category_id': groupCategoryId,
      'created_by': createdBy,
      'members_list': membersList,
      'created_at': createdAt.toIso8601String(),
      'member_count': membersList.length, // Use actual member count
      'categories': categories,
      'is_private': isPrivate,
    };
  }

  // Helper methods for member management
  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? groupCategoryId,
    String? createdBy,
    List<String>? membersList,
    DateTime? createdAt,
    int? memberCount,
    List<String>? categories,
    bool? isPrivate,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      groupCategoryId: groupCategoryId ?? this.groupCategoryId,
      createdBy: createdBy ?? this.createdBy,
      membersList: membersList ?? this.membersList,
      createdAt: createdAt ?? this.createdAt,
      memberCount: memberCount ?? this.memberCount,
      categories: categories ?? this.categories,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  // Add member to the group
  GroupModel addMember(String userId) {
    if (isMember(userId)) return this;

    final newMembersList = List<String>.from(membersList)..add(userId);

    return copyWith(
      membersList: newMembersList,
      memberCount: newMembersList.length,
    );
  }

  // Remove member from the group
  GroupModel removeMember(String userId) {
    if (!isMember(userId)) return this;

    final newMembersList = List<String>.from(membersList)..remove(userId);

    return copyWith(
      membersList: newMembersList,
      memberCount: newMembersList.length,
    );
  }
}
