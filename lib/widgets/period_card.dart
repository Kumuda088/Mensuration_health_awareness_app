import 'package:flutter/material.dart';

import '../models/period_model.dart';
import '../utils/date_utils.dart';

/// Card used on period history lists.
class PeriodCard extends StatelessWidget {
  final PeriodModel period;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PeriodCard({
    super.key,
    required this.period,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final duration = period.durationInDays;
    final endText = period.endDate == null
        ? 'Ongoing'
        : AppDateUtils.formatDate(period.endDate!);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.calendar_month_outlined),
        title: Text('Started ${AppDateUtils.formatDate(period.startDate)}'),
        subtitle: Text(
          'Ended: $endText'
          '${duration == null ? '' : '\n$duration days'}',
        ),
        isThreeLine: duration != null,
        trailing: onDelete == null
            ? null
            : IconButton(
                tooltip: 'Delete period',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
      ),
    );
  }
}
