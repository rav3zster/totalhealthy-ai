import 'package:flutter/material.dart';

class AppColors {
  static const Color pageBackground = Color(0xFFFFFFFF);
  static const Color violet = Color(0xFF8A2BE2);
  static const Color heading = Color(0xFF9A74D9);
  static const Color drawerBackground = Color(0xFFFEE6F2);
  // 9A74D9
  static const Color white = Colors.white;
  static const Color buttonColor = Color(0xffa989de);
  static const Color backgroundColor = Color(0xffbda4e8);
  static const Color black = Colors.black;
  static const Color primaryColor = Color(0xFF001e00);
  static const Color red = Colors.red;
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color(0xFFEFEFEF); // Add the new color
  static const Color customOrange = Color(0xFFFF9A2F); // Add the new color
  static const Color customGreen = Color(0xFF046A38);
  static const Color customGreen2 = Color(0xf00a8901);
  static const Color pinklight = Color(0xfffc0a3f3);
  static const Color pinkText = Color(0xfffa889dc);

  static const Color pinkdark = Color(0xfffa989dc);

  static const Color backgroundGreen = Color(0xEBEAFFE9);
  static const Color primarygreen = Color(0xEBCCFAC8); // Add the new color

  static const Color customNavyBlue = Color(0xFF000089);

  static const Color navyBlue = Color(0xFF000089);
}

class AppColorSchemes {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2F6B26),
    onPrimary: Color(0xFF00391B),
    primaryContainer: Color(0xFFB1F49D),
    onPrimaryContainer: Color(0xFF002200),
    secondary: Color(0xFF00391B),
    onSecondary: Color(0xFF00391B),
    secondaryContainer: Color(0xFF9AF6B4),
    onSecondaryContainer: Color(0xFF00210D),
    tertiary: Color(0xFF056E00),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF8AFC72),
    onTertiaryContainer: Color(0xFF012200),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF6FFF1),
    onSurface: AppColors.backgroundGreen,
    surfaceContainerHighest: Color.fromARGB(255, 255, 255, 255),
    onSurfaceVariant: Color(0xFF43483F),
    outline: Color(0xFF73796E),
    onInverseSurface: Color(0xFFC6FFC6),
    inverseSurface: Color(0xFF003912),
    inversePrimary: Color(0xFF96D784),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF2F6B26),
    outlineVariant: Color(0xFFC3C8BC),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF96D784),
    onPrimary: Color(0xFFe3e3dc),
    primaryContainer: Color(0xFF15520F),
    onPrimaryContainer: Color(0xFFB1F49D),
    secondary: Color(0xFF7EDA99),
    onSecondary: Color(0xFF3e4a36),
    secondaryContainer: Color(0xFF00522A),
    onSecondaryContainer: Color(0xFF9AF6B4),
    tertiary: Color(0xFF6EDF59),
    onTertiary: Color(0xFF023A00),
    tertiaryContainer: Color(0xFF035300),
    onTertiaryContainer: Color(0xFF8AFC72),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF272e23),
    onSurface: Color(0xFF272e23),
    surfaceContainerHighest: Color(0xFF43483F),
    onSurfaceVariant: Color(0xFFC3C8BC),
    outline: Color(0xFF8D9387),
    onInverseSurface: Color(0xFF002107),
    inverseSurface: Color(0xFFA4F5A9),
    inversePrimary: Color(0xFF2F6B26),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF96D784),
    outlineVariant: Color(0xFF43483F),
    scrim: Color(0xFF000000),
  );
}

extension CustomColorScheme on BuildContext {
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;
  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;
  Color get onPrimaryContainer => Theme.of(this).colorScheme.onPrimaryContainer;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;
  Color get secondaryContainer => Theme.of(this).colorScheme.secondaryContainer;
  Color get onSecondaryContainer =>
      Theme.of(this).colorScheme.onSecondaryContainer;
  Color get tertiary => Theme.of(this).colorScheme.tertiary;
  Color get onTertiary => Theme.of(this).colorScheme.onTertiary;
  Color get tertiaryContainer => Theme.of(this).colorScheme.tertiaryContainer;
  Color get onTertiaryContainer =>
      Theme.of(this).colorScheme.onTertiaryContainer;
  Color get error => Theme.of(this).colorScheme.error;
  Color get errorContainer => Theme.of(this).colorScheme.errorContainer;
  Color get onError => Theme.of(this).colorScheme.onError;
  Color get onErrorContainer => Theme.of(this).colorScheme.onErrorContainer;
  Color get background => Theme.of(this).colorScheme.surface;
  Color get onBackground => Theme.of(this).colorScheme.onSurface;
  Color get surfaceVariant => Theme.of(this).colorScheme.surfaceContainerHighest;
  Color get onSurfaceVariant => Theme.of(this).colorScheme.onSurfaceVariant;
  Color get outline => Theme.of(this).colorScheme.outline;
  Color get onInverseSurface => Theme.of(this).colorScheme.onInverseSurface;
  Color get inverseSurface => Theme.of(this).colorScheme.inverseSurface;
  Color get inversePrimary => Theme.of(this).colorScheme.inversePrimary;
  Color get shadow => Theme.of(this).colorScheme.shadow;
  Color get surfaceTint => Theme.of(this).colorScheme.surfaceTint;
  Color get outlineVariant => Theme.of(this).colorScheme.outlineVariant;
  Color get scrim => Theme.of(this).colorScheme.scrim;
}
