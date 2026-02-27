import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors (based on reference image)
  static const Color lightBackground = Color(
    0xFFF5F5F5,
  ); // Light gray background
  static const Color lightCardBackground = Colors.white;
  static const Color lightCardSecondary = Color(0xFFE8F5E9); // Light mint green
  static const Color lightAccent = Color(0xFFC2D86A); // Lime green accent
  static const Color lightTextPrimary = Color(0xFF1A1A1A); // Dark text
  static const Color lightTextSecondary = Color(0xFF666666); // Gray text
  static const Color lightBorder = Color(0xFFE0E0E0); // Light border
  static const Color lightSuccess = Color(0xFF4CAF50); // Green
  static const Color lightError = Color(0xFFFF6B6B); // Red

  // Dark Theme Colors (existing)
  static const Color darkBackground = Colors.black;
  static const Color darkCardBackground = Color(0xFF1C1C1E);
  static const Color darkCardSecondary = Color(0xFF2A2A2A);
  static const Color darkAccent = Color(0xFFC2D86A); // Same lime green
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkBorder = Color(0xFF3A3A3A);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: lightAccent,
    cardColor: lightCardBackground,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: lightCardBackground,
      foregroundColor: lightTextPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: lightTextPrimary),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: lightTextPrimary),
      bodyMedium: TextStyle(color: lightTextSecondary),
      bodySmall: TextStyle(color: lightTextSecondary),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: lightTextPrimary),

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: lightAccent,
      secondary: lightAccent,
      surface: lightCardBackground,
      error: lightError,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: lightTextPrimary,
      onError: Colors.white,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: darkAccent,
    cardColor: darkCardBackground,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: darkCardSecondary,
      foregroundColor: darkTextPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: darkTextPrimary),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: darkTextPrimary),
      bodyMedium: TextStyle(color: darkTextSecondary),
      bodySmall: TextStyle(color: darkTextSecondary),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: darkTextPrimary),

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: darkAccent,
      secondary: darkAccent,
      surface: darkCardBackground,
      error: Color(0xFFFF6B6B),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: darkTextPrimary,
      onError: Colors.white,
    ),
  );

  // Helper methods to get theme-aware colors
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBackground
        : darkBackground;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightCardBackground
        : darkCardBackground;
  }

  static Color getCardSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightCardSecondary
        : darkCardSecondary;
  }

  static Color getTextPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextPrimary
        : darkTextPrimary;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextSecondary
        : darkTextSecondary;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBorder
        : darkBorder;
  }

  static Color getAccentColor(BuildContext context) {
    return lightAccent; // Same for both themes
  }

  // Gradient helpers
  static LinearGradient getBackgroundGradient(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
        stops: [0.0, 0.3, 1.0],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
        stops: [0.0, 0.3, 1.0],
      );
    }
  }

  static LinearGradient getCardGradient(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, const Color(0xFFF5F5F5).withValues(alpha: 0.5)],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
      );
    }
  }

  static LinearGradient getHeaderGradient(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Color(0xFFF5F5F5)],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
      );
    }
  }

  static BoxShadow getCardShadow(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 10,
        offset: const Offset(0, 2),
      );
    } else {
      return BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
      );
    }
  }
}
