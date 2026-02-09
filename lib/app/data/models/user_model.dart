class UserModel {
  final String id;
  final String email;
  final String username;
  final String phone;
  final String firstName;
  final String lastName;
  final String profileImage;
  final int age;
  final double weight;
  final double targetWeight;
  final int height;
  final String activityLevel;
  final List<String> goals;
  final DateTime joinDate;
  final String planName;
  final String planDuration;
  final int progressPercentage;
  final double initialWeight;
  final double fatLost;
  final double muscleGained;
  final int goalDuration; // in days
  final String?
  role; // "advisor", "member" - null if not selected yet, IMMUTABLE after first set
  final DateTime?
  roleSetAt; // Timestamp when role was first set (immutability marker)
  final String? assignedTrainerId; // ID of trainer this client is assigned to
  final bool profileCompleted; // Track if user has completed their profile
  final DateTime createdAt; // Account creation timestamp

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.goals,
    required this.joinDate,
    this.targetWeight = 0.0,
    this.planName = "Keto Plan",
    this.planDuration = "Oct 1 - Nov 1",
    this.progressPercentage = 85,
    this.initialWeight = 0.0,
    this.fatLost = 0.0,
    this.muscleGained = 0.0,
    this.goalDuration = 55,
    this.role, // No default - null means role not selected
    this.roleSetAt, // Timestamp when role was set
    this.assignedTrainerId,
    this.profileCompleted = false, // Default to false for new users
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profileImage: json['profileImage'] ?? '',
      age: json['age'] ?? 0,
      weight: (json['weight'] ?? 0.0).toDouble(),
      targetWeight: (json['targetWeight'] ?? 0.0).toDouble(),
      height: json['height'] ?? 0,
      activityLevel: json['activityLevel'] ?? '',
      goals: List<String>.from(json['goals'] ?? []),
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
      planName: json['planName'] ?? 'Keto Plan',
      planDuration: json['planDuration'] ?? 'Oct 1 - Nov 1',
      progressPercentage: json['progressPercentage'] ?? 85,
      initialWeight: (json['initialWeight'] ?? 0.0).toDouble(),
      fatLost: (json['fatLost'] ?? 0.0).toDouble(),
      muscleGained: (json['muscleGained'] ?? 0.0).toDouble(),
      goalDuration: json['goalDuration'] ?? 55,
      role: json['role'], // Can be null if not selected
      roleSetAt: json['roleSetAt'] != null
          ? DateTime.parse(json['roleSetAt'])
          : null,
      assignedTrainerId: json['assignedTrainerId'],
      profileCompleted: json['profileCompleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': profileImage,
      'age': age,
      'weight': weight,
      'targetWeight': targetWeight,
      'height': height,
      'activityLevel': activityLevel,
      'goals': goals,
      'joinDate': joinDate.toIso8601String(),
      'planName': planName,
      'planDuration': planDuration,
      'progressPercentage': progressPercentage,
      'initialWeight': initialWeight,
      'fatLost': fatLost,
      'muscleGained': muscleGained,
      'goalDuration': goalDuration,
      'role': role,
      'roleSetAt': roleSetAt?.toIso8601String(),
      'assignedTrainerId': assignedTrainerId,
      'profileCompleted': profileCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper methods for dynamic calculations
  int get currentDay {
    final now = DateTime.now();
    final difference = now.difference(joinDate).inDays + 1;
    return difference > 0 ? difference : 1;
  }

  double get goalAchievedPercentage {
    switch (primaryGoal.toLowerCase()) {
      case 'weight loss':
      case 'fat loss':
        return weightLossProgress;
      case 'muscle gain':
      case 'build muscle':
        return muscleGainProgress;
      case 'maintenance':
      case 'maintain weight':
        return maintenanceProgress;
      default:
        // Default to weight loss calculation for unknown goals
        return weightLossProgress;
    }
  }

  String get primaryGoal {
    if (goals.isEmpty) return 'General Fitness';
    return goals.first;
  }

  String get fullName {
    if (firstName.isEmpty && lastName.isEmpty) return username;
    return '$firstName $lastName'.trim();
  }

  // Additional calculated properties for dynamic UI
  String get dayCountDisplay => 'Day $currentDay/$goalDuration';

  String get planDateRange {
    final endDate = joinDate.add(Duration(days: goalDuration));
    final startMonth = _getMonthAbbreviation(joinDate.month);
    final endMonth = _getMonthAbbreviation(endDate.month);
    return '$startMonth ${joinDate.day} - $endMonth ${endDate.day}';
  }

  // Goal-specific progress calculations
  double get weightLossProgress {
    if (initialWeight == 0 || targetWeight == 0) return 0.0;
    final totalWeightToLose = (initialWeight - targetWeight).abs();
    final currentWeightLost = (initialWeight - weight).abs();
    if (totalWeightToLose == 0) return 100.0;
    final percentage = (currentWeightLost / totalWeightToLose) * 100;
    return percentage > 100 ? 100.0 : percentage;
  }

  double get muscleGainProgress {
    // For muscle gain goals, calculate based on weight increase and muscle gained
    if (primaryGoal.toLowerCase().contains('muscle')) {
      final weightGained = weight - initialWeight;
      final targetGain = targetWeight - initialWeight;
      if (targetGain <= 0) return muscleGained > 0 ? 50.0 : 0.0;
      final percentage = (weightGained / targetGain) * 100;
      return percentage > 100 ? 100.0 : percentage.clamp(0.0, 100.0);
    }
    return 0.0;
  }

  double get maintenanceProgress {
    // For maintenance goals, calculate based on weight stability
    if (initialWeight == 0) return 0.0;
    final weightDifference = (weight - initialWeight).abs();
    final allowedVariation = initialWeight * 0.05; // 5% variation allowed
    if (weightDifference <= allowedVariation) return 100.0;
    final percentage =
        ((allowedVariation - weightDifference) / allowedVariation) * 100;
    return percentage.clamp(0.0, 100.0);
  }

  // Helper methods for live stats
  String get fatLostDisplay {
    if (primaryGoal.toLowerCase().contains('weight loss') ||
        primaryGoal.toLowerCase().contains('fat')) {
      return '${fatLost.toStringAsFixed(1)}kg';
    }
    return '${fatLost.toStringAsFixed(1)}kg';
  }

  String get muscleGainedDisplay {
    if (primaryGoal.toLowerCase().contains('muscle')) {
      return '${muscleGained.toStringAsFixed(1)}kg';
    }
    return '${(muscleGained * 1000).toStringAsFixed(0)}g';
  }

  String get goalProgressDisplay {
    final progress = goalAchievedPercentage;
    return '${progress.toInt()}%';
  }

  // Data validation methods - safe for new users
  static bool isValidWeight(double weight) => weight >= 0 && weight < 1000;
  static bool isValidHeight(int height) => height >= 0 && height < 300;
  static bool isValidAge(int age) => age >= 0 && age < 150;

  String? validateUserData() {
    // Basic structural validation only - don't validate incomplete profiles
    if (email.isEmpty || !email.contains('@')) return 'Invalid email address';

    // Only validate profile data if profile is marked as completed
    if (profileCompleted) {
      if (firstName.isEmpty && lastName.isEmpty && username.isEmpty) {
        return 'Name is required';
      }
      if (weight > 0 && !isValidWeight(weight)) {
        return 'Invalid weight value';
      }
      if (height > 0 && !isValidHeight(height)) {
        return 'Invalid height value';
      }
      if (age > 0 && !isValidAge(age)) {
        return 'Invalid age value';
      }
    }

    return null;
  }

  // Check if profile needs completion
  bool get needsProfileCompletion {
    return !profileCompleted || (weight == 0 && height == 0 && age == 0);
  }

  // Role helper methods for RBAC
  bool get isAdvisor {
    return role != null &&
        (role == 'advisor' || role == 'admin' || role == 'trainer');
  }

  bool get isMember {
    return role != null && (role == 'member' || role == 'user');
  }

  bool get hasRole {
    return role != null && role!.isNotEmpty;
  }

  bool get isRoleLocked {
    return roleSetAt != null; // Role is locked once roleSetAt is set
  }

  String get normalizedRole {
    if (role == null || role!.isEmpty) return '';
    switch (role!.toLowerCase()) {
      case 'admin':
      case 'trainer':
      case 'advisor':
        return 'advisor';
      case 'user':
      case 'member':
        return 'member';
      default:
        return role!.toLowerCase();
    }
  }

  // Helper method for month abbreviations
  String _getMonthAbbreviation(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
