import 'package:flutter/material.dart';

enum ButtonSize { small, medium, large }

enum ButtonType { elevated, text, outlined, icon }

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonType type;
  final IconData? icon;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.size,
    required this.type,
    this.icon,
    this.isFullWidth = false, // Default to sizing according to the content
  });

  // Define button sizes
  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 30.0;
      case ButtonSize.medium:
        return 45.0;
      case ButtonSize.large:
        return 60.0;
    }
  }

  double _getButtonPadding() {
    switch (size) {
      case ButtonSize.small:
        return 8.0;
      case ButtonSize.medium:
        return 12.0;
      case ButtonSize.large:
        return 16.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_getButtonPadding()),
      child: SizedBox(
        height: _getButtonHeight(),
        width: isFullWidth
            ? double.infinity
            : null, // Full width or adaptive width
        child: _buildButton(),
      ),
    );
  }

  // Choose button type
  Widget _buildButton() {
    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(onPressed: onPressed, child: child);
      case ButtonType.text:
        return TextButton(onPressed: onPressed, child: child);
      case ButtonType.outlined:
        return OutlinedButton(onPressed: onPressed, child: child);
      case ButtonType.icon:
        return IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          tooltip: 'Icon Button',
        );
      default:
        return ElevatedButton(onPressed: onPressed, child: child);
    }
  }
}
