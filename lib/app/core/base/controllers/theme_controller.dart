import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/appcolor.dart';

class ThemeController extends GetxController {
  final Rx<ThemeData> _themeData = lightTheme.obs;

  ThemeData get themeData => _themeData.value;

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    datePickerTheme: const DatePickerThemeData(
      todayForegroundColor: WidgetStatePropertyAll(Colors.black),
      weekdayStyle: TextStyle(color: Colors.black),
      yearForegroundColor:
          WidgetStatePropertyAll(Color.fromARGB(255, 168, 144, 144)),
      dayForegroundColor: WidgetStatePropertyAll(Colors.black),
      headerForegroundColor: Colors.black,
    ),
    listTileTheme: const ListTileThemeData(
        titleTextStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    // cardTheme: CardTheme(color: AppColors.primarygreen),
    scaffoldBackgroundColor: AppColors.white,
    iconTheme: const IconThemeData(
      color: AppColors.customGreen,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black), // Equivalent to headline2
      displaySmall: TextStyle(color: Colors.black), // Equivalent to headline3
      headlineLarge: TextStyle(color: Colors.black), // Equivalent to headline4
      headlineMedium: TextStyle(color: Colors.black), // Equivalent to headline5
      headlineSmall: TextStyle(color: Colors.black), // Equivalent to headline6
      bodyLarge: TextStyle(color: Colors.black), // Equivalent to bodyText1
      bodyMedium: TextStyle(color: Colors.black), // Equivalent to bodyText2
      titleLarge: TextStyle(color: Colors.black), // Equivalent to subtitle1
      titleMedium: TextStyle(color: Colors.black), // Equivalent to subtitle2
      labelLarge: TextStyle(color: Colors.black), // Equivalent to button
      bodySmall: TextStyle(color: Colors.black), // Equivalent to caption
      labelSmall: TextStyle(color: Colors.black), // Equivalent to overline
    ),

    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              AppColors.customGreen2,
            ),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            textStyle: WidgetStatePropertyAll(
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.heading),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.heading),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    colorScheme: AppColorSchemes.lightColorScheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      color: AppColors.lightGrey,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // Define dark theme
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    cardColor: const Color.fromARGB(255, 15, 12, 12),
    datePickerTheme: const DatePickerThemeData(
      todayForegroundColor: WidgetStatePropertyAll(Colors.white),
      weekdayStyle: TextStyle(color: Colors.white),
      yearForegroundColor: WidgetStatePropertyAll(Colors.white),
      dayForegroundColor: WidgetStatePropertyAll(Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey.withOpacity(.4)),
        borderRadius: BorderRadius.circular(4.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey.withOpacity(.4)),
        borderRadius: BorderRadius.circular(4.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    colorScheme: AppColorSchemes.darkColorScheme,
    appBarTheme: const AppBarTheme(
      color: AppColors.lightGrey,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // Change the theme
  void changeTheme(ThemeData newTheme) {
    _themeData.value = newTheme;
    Get.changeTheme(newTheme);
  }

  // Toggle between light and dark themes
  void toggleTheme() {
    changeTheme(_themeData.value == lightTheme ? darkTheme : lightTheme);
  }

  // Check if the current theme is dark
  bool isDarkTheme() {
    return _themeData.value == darkTheme;
  }
}
