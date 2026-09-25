import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/section_header.dart';

class CycleAnalyticsScreen extends StatelessWidget {
  const CycleAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: const [
            SectionHeader(
              title: 'Cycle analytics',
              subtitle: 'Charts stay hidden until you have real cycle data.',
            ),
            AppEmptyState(
              icon: Icons.straighten,
              title: 'Cycle length',
              message:
                  'Average cycle length will be calculated from your saved periods. No estimate is shown yet.',
            ),
            SizedBox(height: 16),
            AppEmptyState(
              icon: Icons.timelapse,
              title: 'Period duration',
              message:
                  'Average period length will appear after at least one complete period is saved.',
            ),
            SizedBox(height: 16),
            AppEmptyState(
              icon: Icons.history,
              title: 'Cycle history',
              message:
                  'A history of logged cycles will show here. There is nothing to chart right now.',
            ),
            SizedBox(height: 16),
            AppEmptyState(
              icon: Icons.auto_awesome_outlined,
              title: 'Pattern insights',
              message:
                  'Personalized patterns need several logged cycles. Check back after tracking is connected to Firebase.',
            ),
          ],
        ),
      ),
    );
  }
}
