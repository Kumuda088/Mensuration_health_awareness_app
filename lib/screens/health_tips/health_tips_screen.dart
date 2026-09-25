import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/section_header.dart';

class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});

  static const _tips = [
    (
      icon: Icons.water_drop_outlined,
      title: 'Sip water through the day',
      body: 'Staying hydrated can help you feel more comfortable. This is a general wellness habit, not a treatment.',
    ),
    (
      icon: Icons.hotel_outlined,
      title: 'Give yourself rest',
      body: 'Extra rest on period days is okay. Listen to your body and pause when you need to.',
    ),
    (
      icon: Icons.directions_walk_outlined,
      title: 'Try gentle movement',
      body: 'A short walk or light stretch may feel soothing for some people. Stop if anything hurts.',
    ),
    (
      icon: Icons.spa_outlined,
      title: 'Use warmth if it helps',
      body: 'A warm compress on the lower abdomen is a common comfort choice. Avoid extreme heat.',
    ),
    (
      icon: Icons.edit_note_outlined,
      title: 'Notice patterns, don’t diagnose',
      body: 'Writing down dates and feelings can help you learn your own rhythm. It does not diagnose a condition.',
    ),
    (
      icon: Icons.favorite_outline,
      title: 'Ask for support',
      body: 'Talk with someone you trust if pain, mood, or questions feel heavy. A healthcare professional can give personal advice.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Tips')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            const SectionHeader(
              title: 'Gentle daily ideas',
              subtitle: 'These tips support wellbeing. They are not medical advice.',
            ),
            ..._tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.peach.withValues(alpha: 0.35),
                      foregroundColor: AppColors.blush,
                      child: Icon(tip.icon),
                    ),
                    title: Text(tip.title),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(tip.body),
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
