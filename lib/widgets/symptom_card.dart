import 'package:flutter/material.dart';

import '../models/symptom_model.dart';
import '../utils/date_utils.dart';

class SymptomCard extends StatelessWidget {
  final SymptomModel symptom;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SymptomCard({
    super.key,
    required this.symptom,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final notes = symptom.notes.trim();

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.favorite_outline),
        title: Text(
          symptom.summary.isEmpty ? 'Symptoms' : symptom.summary,
        ),
        subtitle: Text(
          '${AppDateUtils.formatDate(symptom.date)} • ${symptom.severity}'
          '${notes.isEmpty ? '' : '\n$notes'}',
        ),
        isThreeLine: notes.isNotEmpty,
        trailing: onDelete == null
            ? null
            : IconButton(
                tooltip: 'Delete symptom log',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
      ),
    );
  }
}
