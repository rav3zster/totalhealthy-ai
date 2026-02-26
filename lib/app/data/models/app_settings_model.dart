class AppSettingsModel {
  final String language;
  final String region;
  final String theme;

  AppSettingsModel({
    required this.language,
    required this.region,
    required this.theme,
  });

  Map<String, dynamic> toJson() => {
    'language': language,
    'region': region,
    'theme': theme,
  };

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      language: json['language'] ?? 'English',
      region: json['region'] ?? 'India',
      theme: json['theme'] ?? 'Dark',
    );
  }

  AppSettingsModel copyWith({String? language, String? region, String? theme}) {
    return AppSettingsModel(
      language: language ?? this.language,
      region: region ?? this.region,
      theme: theme ?? this.theme,
    );
  }
}
