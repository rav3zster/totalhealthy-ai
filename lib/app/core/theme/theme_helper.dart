import 'package:flutter/material.dart';

/// Production-grade theme helper for TotalHealthy app
/// Provides 1-line access to all theme-aware colors and styles
extension ThemeHelper on BuildContext {
  /// ========= THEME MODE =========
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  bool get isLight => Theme.of(this).brightness == Brightness.light;

  // Legacy support (deprecated, use isDark/isLight)
  bool get isLightTheme => isLight;

  /// ========= BACKGROUNDS =========
  Color get backgroundColor =>
      isDark ? const Color(0xFF000000) : const Color(0xFFFAFBFC);

  Color get cardColor =>
      isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF);

  Color get cardSecondary =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F6F7);

  // Legacy support
  Color get cardSecondaryColor => cardSecondary;

  Color get inputBackground =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F3F5);

  // Legacy support
  Color get searchBarColor => inputBackground;

  /// ========= TEXT COLORS =========
  Color get textPrimary => isDark ? Colors.white : const Color(0xFF1A1D1F);

  Color get textSecondary =>
      isDark ? const Color(0xFFB0B0B0) : const Color(0xFF6C757D);

  Color get textTertiary =>
      isDark ? const Color(0xFF8B8B8B) : const Color(0xFFADB5BD);

  /// ========= BRAND COLORS =========
  Color get accent =>
      isDark ? const Color(0xFFC2D86A) : const Color(0xFFC2FF00);

  // Legacy support
  Color get accentColor => accent;

  Color get accentSoft =>
      isDark ? const Color(0xFF2F3A1A) : const Color(0xFFF4FFE0);

  Color get success => const Color(0xFF10B981);

  Color get error => const Color(0xFFEF4444);

  /// ========= BORDER / DIVIDER =========
  Color get border =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE9ECEF);

  // Legacy support
  Color get borderColor => border;

  Color get divider =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFDEE2E6);

  // Legacy support
  Color get dividerColor => divider;

  /// ========= SHADOW =========
  List<BoxShadow> get cardShadow => isDark
      ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
      : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];

  // Single shadow for convenience
  BoxShadow get cardShadowSingle => cardShadow.first;

  /// ========= GRADIENTS =========
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: isDark
        ? [
            const Color(0xFF000000),
            const Color(0xFF1A1A1A),
            const Color(0xFF000000),
          ]
        : [
            const Color(0xFFFAFBFC),
            const Color(0xFFF8F9FA),
            const Color(0xFFFAFBFC),
          ],
    stops: const [0.0, 0.5, 1.0],
  );

  LinearGradient get cardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark
        ? [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)]
        : [const Color(0xFFFFFFFF), const Color(0xFFFAFBFC)],
  );

  LinearGradient get headerGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark
        ? [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)]
        : [const Color(0xFFFFFFFF), const Color(0xFFF8F9FA)],
  );

  LinearGradient get accentGradient => LinearGradient(
    colors: isDark
        ? [const Color(0xFFC2D86A), const Color(0xFFB8CC5A)]
        : [const Color(0xFFC2FF00), const Color(0xFFB8FF00)],
  );

  /// ========= SPECIAL UI COLORS =========
  Color get proteinColor =>
      isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);

  Color get proteinBackground =>
      isDark ? const Color(0xFF1A3A2A) : const Color(0xFFE8F5E9);

  Color get carbsColor =>
      isDark ? const Color(0xFFE53935) : const Color(0xFFC62828);

  Color get carbsBackground =>
      isDark ? const Color(0xFF3A1A1A) : const Color(0xFFFFEBEE);

  Color get fatColor =>
      isDark ? const Color(0xFF2196F3) : const Color(0xFF1565C0);

  Color get fatBackground =>
      isDark ? const Color(0xFF1A2A3A) : const Color(0xFFE3F2FD);

  Color get caloriesColor =>
      isDark ? const Color(0xFFFFB800) : const Color(0xFFFF8C00);

  Color get caloriesBackground =>
      isDark ? const Color(0xFF3A2F1A) : const Color(0xFFFFF4E6);
}

/// Helper widget for theme-aware containers
class ThemedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool useGradient;
  final bool useSecondaryColor;

  const ThemedContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.useGradient = false,
    this.useSecondaryColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: useGradient ? context.cardGradient : null,
        color: useGradient
            ? null
            : (useSecondaryColor ? context.cardSecondary : context.cardColor),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: context.border, width: 1),
        boxShadow: context.cardShadow,
      ),
      child: child,
    );
  }
}

/// Helper widget for theme-aware text
class ThemedText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final bool isSecondary;
  final bool isTertiary;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ThemedText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.isSecondary = false,
    this.isTertiary = false,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if (color != null) {
      textColor = color!;
    } else if (isTertiary) {
      textColor = context.textTertiary;
    } else if (isSecondary) {
      textColor = context.textSecondary;
    } else {
      textColor = context.textPrimary;
    }

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
