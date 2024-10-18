
import 'package:flutter/material.dart';

import 'appcolor.dart';

class Style {
  static TextStyle cardHeading() {
    return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
  }

  static TextStyle cardvalue() {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.buttonColor,
    );
  }
}
