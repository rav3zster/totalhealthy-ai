enum MemberStatus { admin, member, invited, rejected, removed }

class MembershipModel {
  final String userId;
  final String groupId;
  final MemberStatus status;
  final DateTime joinedAt;
  final DateTime? invitedAt;
  final String? invitedBy;

  MembershipModel({
    required this.userId,
    required this.groupId,
    required this.status,
    required this.joinedAt,
    this.invitedAt,
    this.invitedBy,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      userId: json['user_id'] ?? '',
      groupId: json['group_id'] ?? '',
      status: MemberStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => MemberStatus.member,
      ),
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'])
          : DateTime.now(),
      invitedAt: json['invited_at'] != null
          ? DateTime.parse(json['invited_at'])
          : null,
      invitedBy: json['invited_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'group_id': groupId,
      'status': status.toString().split('.').last,
      'joined_at': joinedAt.toIso8601String(),
      'invited_at': invitedAt?.toIso8601String(),
      'invited_by': invitedBy,
    };
  }

  // Status validation methods
  bool canTransitionTo(MemberStatus newStatus) {
    switch (status) {
      case MemberStatus.invited:
        return newStatus == MemberStatus.member ||
            newStatus == MemberStatus.rejected;
      case MemberStatus.member:
        return newStatus == MemberStatus.removed;
      case MemberStatus.admin:
        return false; // Admin status cannot be changed
      case MemberStatus.rejected:
        return newStatus == MemberStatus.invited;
      case MemberStatus.removed:
        return newStatus == MemberStatus.invited;
    }
  }

  // Create a new membership with status transition
  MembershipModel transitionTo(MemberStatus newStatus) {
    if (!canTransitionTo(newStatus)) {
      throw ArgumentError(
        'Invalid status transition from $status to $newStatus',
      );
    }

    return MembershipModel(
      userId: userId,
      groupId: groupId,
      status: newStatus,
      joinedAt: newStatus == MemberStatus.member ? DateTime.now() : joinedAt,
      invitedAt: invitedAt,
      invitedBy: invitedBy,
    );
  }

  // Helper methods
  bool get isActive =>
      status == MemberStatus.member || status == MemberStatus.admin;
  bool get isPending => status == MemberStatus.invited;
  bool get isAdmin => status == MemberStatus.admin;
  bool get isMember => status == MemberStatus.member;

  MembershipModel copyWith({
    String? userId,
    String? groupId,
    MemberStatus? status,
    DateTime? joinedAt,
    DateTime? invitedAt,
    String? invitedBy,
  }) {
    return MembershipModel(
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      invitedAt: invitedAt ?? this.invitedAt,
      invitedBy: invitedBy ?? this.invitedBy,
    );
  }
}
