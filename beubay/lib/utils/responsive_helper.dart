import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints for different screen sizes
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Check if mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < mobileBreakpoint;
  }

  // Check if tablet
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  // Check if desktop/web
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= tabletBreakpoint;
  }

  // Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return EdgeInsets.symmetric(
        horizontal: screenWidth(context) * 0.1,
        vertical: 24,
      );
    }
  }

  // Get responsive font size
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile * 1.2;
    } else {
      return desktop ?? mobile * 1.5;
    }
  }

  // Get responsive width (percentage based)
  static double responsiveWidth(BuildContext context, double percentage) {
    return screenWidth(context) * (percentage / 100);
  }

  // Get responsive height (percentage based)
  static double responsiveHeight(BuildContext context, double percentage) {
    return screenHeight(context) * (percentage / 100);
  }

  // Get card width for horizontal lists
  static double cardWidth(BuildContext context) {
    if (isMobile(context)) {
      return 160;
    } else if (isTablet(context)) {
      return 200;
    } else {
      return 240;
    }
  }

  // Get max content width for centered layouts
  static double maxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 768;
    } else {
      return 1200;
    }
  }

  // Get grid cross axis count
  static int gridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  // Get responsive spacing
  static double responsiveSpacing(BuildContext context, double base) {
    if (isMobile(context)) {
      return base;
    } else if (isTablet(context)) {
      return base * 1.2;
    } else {
      return base * 1.5;
    }
  }
}
