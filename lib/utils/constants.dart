import 'package:flutter/material.dart';

/// App-wide values used by screens and widgets.
class AppColors {
  static const Color blush = Color(0xFFC45C78);
  static const Color lavender = Color(0xFFB7A4D8);
  static const Color peach = Color(0xFFE8B89A);
  static const Color cream = Color(0xFFFFF7F4);
  static const Color card = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF3D2C33);
  static const Color muted = Color(0xFF6E5A62);
}

class AppConstants {
  static const String appName = 'Menstrual Health Awareness';
  static const String appTagline = 'Track, learn, and stay informed';

  static const Color seedColor = AppColors.blush;

  static const double defaultPadding = 20.0;
  static const double cardRadius = 20.0;
  static const double maxContentWidth = 720.0;
  static const double compactBreakpoint = 800.0;

  static const int defaultCycleLength = 28;
  static const int defaultPeriodLength = 5;
}

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String privacy = '/privacy';
  static const String periodTracking = '/period-tracking';
  static const String periodHistory = '/period-history';
  static const String symptoms = '/symptoms';
  static const String analytics = '/analytics';
  static const String insights = '/insights';
  static const String education = '/education';
  static const String healthTips = '/health-tips';
}
