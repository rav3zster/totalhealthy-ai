import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors (based on reference image analysis)
  static const Color lightBackground = Color(
    0xFFFAFBFC,
  ); // Very light gray background
  static const Color lightCardBackground = Color(
    0xFFFFFFFF,
  ); // Pure white cards
  static const Color lightCardSecondary = Color(
    0xFFF5F6F7,
  ); // Light gray for secondary cards
  static const Color lightAccent = Color(
    0xFFC2FF00,
  ); // Bright lime green accent
  static const Color lightTextPrimary = Color(
    0xFF1A1D1F,
  ); // Very dark gray/black for headings
  static const Color lightTextSecondary = Color(
    0xFF6C757D,
  ); // Medium gray for labels
  static const Color lightTextTertiary = Color(
    0xFFADB5BD,
  ); // Light gray for hints
  static const Color lightBorder = Color(0xFFE9ECEF); // Very subtle border
  static const Color lightSearchBar = Color(
    0xFFF1F3F5,
  ); // Search bar background
  static const Color lightSuccess = Color(0xFF10B981); // Success green
  static const Color lightError = Color(0xFFEF4444); // Error red
  static const Color lightDivider = Color(0xFFDEE2E6); // Divider color

  // Dark Theme Colors (existing)
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkCardBackground = Color(0xFF1C1C1E);
  static const Color darkCardSecondary = Color(0xFF2A2A2A);
  static const Color darkAccent = Color(
    0xFFC2D86A,
  ); // Muted lime green for dark theme
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF8B8B8B);
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

  static Color getTextTertiaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextTertiary
        : darkTextTertiary;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBorder
        : darkBorder;
  }

  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightDivider
        : darkBorder;
  }

  static Color getSearchBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSearchBar
        : darkCardSecondary;
  }

  static Color getAccentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightAccent // Bright lime green (#C2FF00) for light theme
        : darkAccent; // Muted lime green (#C2D86A) for dark theme
  }

  // Gradient helpers
  static LinearGradient getBackgroundGradient(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFAFBFC), Color(0xFFF8F9FA), Color(0xFFFAFBFC)],
        stops: [0.0, 0.5, 1.0],
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
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFFAFBFC)],
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
        colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
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
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
        spreadRadius: 0,
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
