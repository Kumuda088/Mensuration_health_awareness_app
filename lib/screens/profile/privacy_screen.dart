import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widgets/insight_card.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/section_header.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: const [
            SectionHeader(
              title: 'Your data stays yours',
              subtitle: 'This app is built for private, respectful health tracking.',
            ),
            InsightCard(
              icon: Icons.lock_outline,
              title: 'Account security',
              message:
                  'Login uses Firebase Authentication with email and password. We do not show or store passwords in the app.',
            ),
            SizedBox(height: 12),
            InsightCard(
              icon: Icons.cloud_outlined,
              title: 'What will be stored',
              message:
                  'Your name and email are saved in your user profile. Period and symptom logs will be stored under your account when those features are connected.',
            ),
            SizedBox(height: 12),
            InsightCard(
              icon: Icons.visibility_off_outlined,
              title: 'What we do not do',
              message:
                  'This app does not sell your health data. Educational content is general and is not a medical diagnosis.',
            ),
          ],
        ),
      ),
    );
  }
}
