import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/section_header.dart';
import '../education/health_education_screen.dart';
import '../health_tips/health_tips_screen.dart';
import '../period/period_tracking_screen.dart';
import '../symptoms/symptom_tracking_screen.dart';
import '../analytics/cycle_analytics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.greetingName});

  final String? greetingName;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final userName = greetingName ??
        AuthService().currentUser?.displayName?.trim();
    final name = userName != null && userName.isNotEmpty
        ? userName.split(' ').first
        : 'there';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            Text(
              '${_greeting()}, $name',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.appTagline,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            const AppEmptyState(
              icon: Icons.calendar_month_outlined,
              title: 'Your cycle summary will appear here',
              message:
                  'Log your first period to see a calm overview of where you are in your cycle. No estimates are shown until you add real dates.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _open(context, const PeriodTrackingScreen()),
              icon: const Icon(Icons.add),
              label: const Text('Log Period'),
            ),
            const SizedBox(height: 28),
            const SectionHeader(
              title: 'Quick actions',
              subtitle: 'Open a tool when you need it',
            ),
            GridView.count(
              crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 3 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
              children: [
                DashboardCard(
                  title: 'Period Tracking',
                  subtitle: 'Log start and end dates',
                  icon: Icons.water_drop_outlined,
                  onTap: () => _open(context, const PeriodTrackingScreen()),
                ),
                DashboardCard(
                  title: 'Symptoms',
                  subtitle: 'Note how you feel',
                  icon: Icons.favorite_outline,
                  onTap: () => _open(context, const SymptomTrackingScreen()),
                ),
                DashboardCard(
                  title: 'Cycle Analytics',
                  subtitle: 'View patterns later',
                  icon: Icons.insights_outlined,
                  onTap: () => _open(context, const CycleAnalyticsScreen()),
                ),
                DashboardCard(
                  title: 'Health Education',
                  subtitle: 'Learn with care',
                  icon: Icons.menu_book_outlined,
                  onTap: () => _open(context, const HealthEducationScreen()),
                ),
                DashboardCard(
                  title: 'Health Tips',
                  subtitle: 'Gentle daily ideas',
                  icon: Icons.spa_outlined,
                  onTap: () => _open(context, const HealthTipsScreen()),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Upcoming reminder'),
            const AppEmptyState(
              icon: Icons.notifications_outlined,
              title: 'No reminders yet',
              message:
                  'Period reminders will appear here after notifications are connected. Nothing is scheduled right now.',
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Recent activity'),
            const AppEmptyState(
              icon: Icons.history,
              title: 'No activity yet',
              message:
                  'Your recent period and symptom logs will show here once they are saved to your account.',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
