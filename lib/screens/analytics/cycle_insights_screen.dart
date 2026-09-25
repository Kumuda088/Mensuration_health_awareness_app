import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/responsive_body.dart';

class CycleInsightsScreen extends StatelessWidget {
  const CycleInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personalized Insights')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: const [
            AppEmptyState(
              icon: Icons.auto_awesome_outlined,
              title: 'Insights need more data',
              message:
                  'Gentle, personal notes will appear after your own cycle logs are available. This is not a medical diagnosis.',
            ),
          ],
        ),
      ),
    );
  }
}
