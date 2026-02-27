import 'package:flutter/material.dart';

/// Model for storing reminder settings
class ReminderModel {
  final String type; // 'water', 'meal', 'exercise', 'update'
  final bool enabled;
  final List<String> times; // Time strings in HH:mm format
  final Map<String, dynamic>? extraData; // For additional settings

  ReminderModel({
    required this.type,
    required this.enabled,
    required this.times,
    this.extraData,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'type': type,
    'enabled': enabled,
    'times': times,
    'extraData': extraData,
  };

  // Create from JSON
  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    type: json['type'] as String,
    enabled: json['enabled'] as bool,
    times: List<String>.from(json['times'] as List),
    extraData: json['extraData'] as Map<String, dynamic>?,
  );

  // Create copy with modifications
  ReminderModel copyWith({
    String? type,
    bool? enabled,
    List<String>? times,
    Map<String, dynamic>? extraData,
  }) => ReminderModel(
    type: type ?? this.type,
    enabled: enabled ?? this.enabled,
    times: times ?? this.times,
    extraData: extraData ?? this.extraData,
  );
}

/// Water reminder specific settings
class WaterReminderSettings {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int intervalMinutes; // 30, 60, or 120

  WaterReminderSettings({
    required this.startTime,
    required this.endTime,
    required this.intervalMinutes,
  });

  Map<String, dynamic> toJson() => {
    'startTime': '${startTime.hour}:${startTime.minute}',
    'endTime': '${endTime.hour}:${endTime.minute}',
    'intervalMinutes': intervalMinutes,
  };

  factory WaterReminderSettings.fromJson(Map<String, dynamic> json) {
    final startParts = (json['startTime'] as String).split(':');
    final endParts = (json['endTime'] as String).split(':');
    return WaterReminderSettings(
      startTime: TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      ),
      intervalMinutes: json['intervalMinutes'] as int,
    );
  }
}

/// Meal reminder specific settings
class MealReminderSettings {
  final String mealCategory; // 'Breakfast', 'Lunch', 'Dinner', etc.
  final TimeOfDay time;
  final bool repeatDaily;

  MealReminderSettings({
    required this.mealCategory,
    required this.time,
    this.repeatDaily = true,
  });

  Map<String, dynamic> toJson() => {
    'mealCategory': mealCategory,
    'time': '${time.hour}:${time.minute}',
    'repeatDaily': repeatDaily,
  };

  factory MealReminderSettings.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['time'] as String).split(':');
    return MealReminderSettings(
      mealCategory: json['mealCategory'] as String,
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      repeatDaily: json['repeatDaily'] as bool? ?? true,
    );
  }
}

/// Exercise reminder specific settings
class ExerciseReminderSettings {
  final List<int> weekdays; // 1=Monday, 7=Sunday
  final TimeOfDay time;

  ExerciseReminderSettings({required this.weekdays, required this.time});

  Map<String, dynamic> toJson() => {
    'weekdays': weekdays,
    'time': '${time.hour}:${time.minute}',
  };

  factory ExerciseReminderSettings.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['time'] as String).split(':');
    return ExerciseReminderSettings(
      weekdays: List<int>.from(json['weekdays'] as List),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
    );
  }
}
