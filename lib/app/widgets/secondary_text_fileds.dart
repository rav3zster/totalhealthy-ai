// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReusableTextField extends StatelessWidget {
  final Widget? suffixIcon;
  final String? labelText;
  final String? initialValue; // Nullable value
  final String? hintText; // New hintText property
  final bool isNullable;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? fillColor;
  final bool? filled;
  final Widget? prefixIcon;
  final BorderSide borderSide;
  final String? Function(String?)? validator;

  final Function(String)? onChanged;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final BoxConstraints? prefixIconConstraints;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final bool? readOnly;
  final bool? obscureText;

  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? suffixText;

  final bool? enabled;

  const ReusableTextField({
    this.filled,
    this.fillColor,
    this.suffixIcon,
    this.labelText,
    this.initialValue,
    this.hintText, // Add the hintText property
    this.isNullable = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    this.borderRadius = 8.0,
    this.borderSide = const BorderSide(color: Colors.grey),
    this.validator,
    this.onChanged,
    this.width,
    this.height,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.controller,
    this.keyboardType,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.inputFormatters,
    this.onTap,
    this.readOnly,
    this.obscureText,
    this.hintStyle,
    this.enabled,
    this.suffixText,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // TextEditingController controller = TextEditingController();
    // controller.text = initialValue ?? '';
    final double dropdownWidth = width ?? double.infinity;

    return SizedBox(
      width: dropdownWidth,
      height: minLines == 1 ? height : null,
      child: TextFormField(
        obscureText: obscureText ?? false,
        readOnly: readOnly ?? false,
        onTap: onTap,
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        style: style ??
            TextStyle(
              height: 1.1,
              color: Color.fromARGB(255, 70, 65, 65),
            ),

        // textCapitalization: TextCapitalization.characters,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          suffixText: suffixText,
          contentPadding: padding,
          hintStyle: hintStyle,
          filled: true,
          fillColor: Color(0XFF242522),
          labelStyle: const TextStyle(color: Color(0XFF7E7E7E)),
          prefixIconConstraints: prefixIconConstraints,
          floatingLabelBehavior: floatingLabelBehavior,

          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,

          alignLabelWithHint: true,
          // suffix: Text("data"),

          labelText: labelText,
          hintText: hintText, // Set the hintText
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            borderSide:
                BorderSide(color: Colors.transparent), // Transparent border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            borderSide:
                BorderSide(color: Colors.transparent), // Transparent border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            borderSide:
                BorderSide(color: Colors.transparent), // Transparent border
          ),
        ),
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
