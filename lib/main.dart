import 'package:flutter/material.dart';

import 'screens/analytics/cycle_analytics_screen.dart';
import 'screens/analytics/cycle_insights_screen.dart';
import 'screens/auth/auth_gate.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/education/health_education_screen.dart';
import 'screens/health_tips/health_tips_screen.dart';
import 'screens/home/main_shell.dart';
import 'screens/period/period_history_screen.dart';
import 'screens/period/period_tracking_screen.dart';
import 'screens/profile/privacy_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/symptoms/symptom_tracking_screen.dart';
import 'services/firebase_service.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const MenstrualHealthApp());
}

class MenstrualHealthApp extends StatelessWidget {
  const MenstrualHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AuthGate(),
      routes: {
        AppRoutes.home: (_) => const MainShell(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.privacy: (_) => const PrivacyScreen(),
        AppRoutes.periodTracking: (_) => const PeriodTrackingScreen(),
        AppRoutes.periodHistory: (_) => const PeriodHistoryScreen(),
        AppRoutes.symptoms: (_) => const SymptomTrackingScreen(),
        AppRoutes.analytics: (_) => const CycleAnalyticsScreen(),
        AppRoutes.insights: (_) => const CycleInsightsScreen(),
        AppRoutes.education: (_) => const HealthEducationScreen(),
        AppRoutes.healthTips: (_) => const HealthTipsScreen(),
      },
    );
  }
}
