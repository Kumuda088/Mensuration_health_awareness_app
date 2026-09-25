import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/responsive_body.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: const [
            AppEmptyState(
              icon: Icons.notifications_outlined,
              title: 'Reminders are not connected yet',
              message:
                  'Period reminders will use Firebase Cloud Messaging in a later step. No alerts are sent from this screen.',
            ),
            SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: false,
                    onChanged: null,
                    title: Text('Period reminders'),
                    subtitle: Text('Coming soon'),
                  ),
                  SwitchListTile(
                    value: false,
                    onChanged: null,
                    title: Text('Health tips'),
                    subtitle: Text('Coming soon'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
