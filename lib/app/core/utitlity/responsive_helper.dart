import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isLargePhone(BuildContext context) {
    return MediaQuery.of(context).size.width >= 400 &&
        MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return baseSize * 0.85; // Small phones
    } else if (width < 600) {
      return baseSize; // Regular phones
    } else if (width < 1200) {
      return baseSize * 1.15; // Tablets
    } else {
      return baseSize * 1.3; // Desktop
    }
  }

  static double getResponsivePadding(BuildContext context, double basePadding) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return basePadding * 0.75; // Small phones
    } else if (width < 600) {
      return basePadding; // Regular phones
    } else if (width < 1200) {
      return basePadding * 1.5; // Tablets
    } else {
      return basePadding * 2; // Desktop
    }
  }

  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return baseSpacing * 0.75; // Small phones
    } else if (width < 600) {
      return baseSpacing; // Regular phones
    } else if (width < 1200) {
      return baseSpacing * 1.25; // Tablets
    } else {
      return baseSpacing * 1.5; // Desktop
    }
  }

  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 1; // Phone
    } else if (width < 900) {
      return 2; // Small tablet
    } else if (width < 1200) {
      return 3; // Large tablet
    } else {
      return 4; // Desktop
    }
  }

  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return width; // Full width on phones
    } else if (width < 1200) {
      return 800; // Max width on tablets
    } else {
      return 1200; // Max width on desktop
    }
  }
}
