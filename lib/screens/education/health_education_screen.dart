import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/section_header.dart';

class HealthEducationScreen extends StatelessWidget {
  const HealthEducationScreen({super.key});

  static const _topics = [
    EducationTopic(
      title: 'Menstrual Cycle',
      icon: Icons.sync,
      summary: 'The usual phases of a menstrual cycle.',
      body:
          'A menstrual cycle is the time from the first day of one period to the first day of the next. Many cycles last about 21 to 35 days, but this can vary from person to person.\n\n'
          'Common phases include menstruation, the follicular phase, ovulation, and the luteal phase. This app shares general awareness only. It cannot tell you where you are in your cycle until you log real dates, and it is not a medical diagnosis.',
    ),
    EducationTopic(
      title: 'Menstrual Hygiene',
      icon: Icons.clean_hands_outlined,
      summary: 'Everyday hygiene habits during a period.',
      body:
          'Wash your hands before and after changing pads, tampons, cups, or other products. Change products as often as the package recommends, or sooner if needed.\n\n'
          'Use clean underwear and bathe regularly if you can. Everyone’s access to products is different. Choose what is comfortable, available, and safe for you.',
    ),
    EducationTopic(
      title: 'Period Symptoms',
      icon: Icons.favorite_outline,
      summary: 'Symptoms some people notice around a period.',
      body:
          'Some people notice cramps, tiredness, bloating, headaches, mood changes, back pain, or skin changes around a period. These experiences are common, but they are not the same for everyone.\n\n'
          'Tracking how you feel can help you notice patterns. Strong pain, very heavy bleeding, or symptoms that interrupt daily life deserve a conversation with a healthcare professional.',
    ),
    EducationTopic(
      title: 'Nutrition',
      icon: Icons.restaurant_outlined,
      summary: 'Simple food ideas that support wellbeing.',
      body:
          'A balanced plate with fruits, vegetables, grains, proteins, and plenty of water can support energy during your cycle. Iron-rich foods such as beans, greens, or fortified cereals may be helpful if your diet allows them.\n\n'
          'This is general wellness information, not a diet plan or treatment. Speak with a clinician or dietitian for personal nutrition advice.',
    ),
    EducationTopic(
      title: 'Self Care',
      icon: Icons.spa_outlined,
      summary: 'Gentle ways to rest and feel supported.',
      body:
          'Rest, hydration, a warm compress, light stretching, and comfortable clothes can make period days easier for some people. It is okay to slow down.\n\n'
          'Self-care does not replace medical care. If pain or mood changes feel unmanageable, ask a trusted adult or healthcare professional for help.',
    ),
    EducationTopic(
      title: 'When to Seek Medical Help',
      icon: Icons.health_and_safety_outlined,
      summary: 'Signs that deserve professional advice.',
      body:
          'Consider speaking with a healthcare professional if you have very heavy bleeding, periods that last much longer than usual, severe pain, bleeding between periods, or if you miss several periods and that is unusual for you.\n\n'
          'This app cannot diagnose conditions or tell you whether something is urgent. If you feel unsafe or very unwell, seek local emergency care.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Education')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            const SectionHeader(
              title: 'Learn at your pace',
              subtitle: 'Clear, general information. Not a diagnosis.',
            ),
            ..._topics.map(
              (topic) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.lavender.withValues(alpha: 0.3),
                      foregroundColor: AppColors.blush,
                      child: Icon(topic.icon),
                    ),
                    title: Text(topic.title),
                    subtitle: Text(topic.summary),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EducationTopicScreen(topic: topic),
                        ),
                      );
                    },
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

class EducationTopic {
  final String title;
  final IconData icon;
  final String summary;
  final String body;

  const EducationTopic({
    required this.title,
    required this.icon,
    required this.summary,
    required this.body,
  });
}

class EducationTopicScreen extends StatelessWidget {
  const EducationTopicScreen({super.key, required this.topic});

  final EducationTopic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  topic.body,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
