import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Extension to easily access theme-aware colors
extension ThemeHelper on BuildContext {
  // Check if current theme is light
  bool get isLightTheme => Theme.of(this).brightness == Brightness.light;

  // Background colors
  Color get backgroundColor => AppTheme.getBackgroundColor(this);
  Color get cardColor => AppTheme.getCardColor(this);
  Color get cardSecondaryColor => AppTheme.getCardSecondaryColor(this);

  // Text colors
  Color get textPrimary => AppTheme.getTextPrimaryColor(this);
  Color get textSecondary => AppTheme.getTextSecondaryColor(this);

  // Other colors
  Color get borderColor => AppTheme.getBorderColor(this);
  Color get accentColor => AppTheme.getAccentColor(this);

  // Gradients
  LinearGradient get backgroundGradient => AppTheme.getBackgroundGradient(this);
  LinearGradient get cardGradient => AppTheme.getCardGradient(this);
  LinearGradient get headerGradient => AppTheme.getHeaderGradient(this);

  // Shadow
  BoxShadow get cardShadow => AppTheme.getCardShadow(this);
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
            : (useSecondaryColor
                  ? context.cardSecondaryColor
                  : context.cardColor),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: context.isLightTheme
              ? context.borderColor
              : const Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [context.cardShadow],
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
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color:
            color ??
            (isSecondary ? context.textSecondary : context.textPrimary),
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
