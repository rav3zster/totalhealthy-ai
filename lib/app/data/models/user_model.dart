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
  final int height;
  final String activityLevel;
  final List<String> goals;
  final String joinDate;
  final String planName;
  final String planDuration;
  final int progressPercentage;

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
    this.planName = "Keto Plan",
    this.planDuration = "Oct 1 - Nov 1",
    this.progressPercentage = 85,
  });

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
      height: json['height'] ?? 0,
      activityLevel: json['activityLevel'] ?? '',
      goals: List<String>.from(json['goals'] ?? []),
      joinDate: json['joinDate'] ?? '',
      planName: json['planName'] ?? 'Keto Plan',
      planDuration: json['planDuration'] ?? 'Oct 1 - Nov 1',
      progressPercentage: json['progressPercentage'] ?? 85,
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
      'height': height,
      'activityLevel': activityLevel,
      'goals': goals,
      'joinDate': joinDate,
      'planName': planName,
      'planDuration': planDuration,
      'progressPercentage': progressPercentage,
    };
  }
}