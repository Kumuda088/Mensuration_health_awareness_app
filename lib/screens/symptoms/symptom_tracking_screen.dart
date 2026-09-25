import 'package:flutter/material.dart';

import '../../models/symptom_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../../utils/date_utils.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/section_header.dart';
import '../../widgets/symptom_card.dart';

class SymptomTrackingScreen extends StatefulWidget {
  const SymptomTrackingScreen({super.key});

  @override
  State<SymptomTrackingScreen> createState() => _SymptomTrackingScreenState();
}

class _SymptomTrackingScreenState extends State<SymptomTrackingScreen> {
  static const _symptomOptions = [
    'Cramps',
    'Headache',
    'Back Pain',
    'Fatigue',
    'Bloating',
    'Mood Swings',
    'Nausea',
    'Breast Tenderness',
  ];

  static const _severityOptions = ['Mild', 'Moderate', 'Severe'];

  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  final _selected = <String>{};
  final _notesController = TextEditingController();

  DateTime _date = DateUtils.dateOnly(DateTime.now());
  String _severity = 'Mild';
  String? _error;
  bool _isSaving = false;
  bool _isLoading = true;
  List<SymptomModel> _history = [];

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _isLoggedIn => _authService.currentUser != null;

  Future<void> _loadSymptoms() async {
    if (!_isLoggedIn) {
      setState(() {
        _isLoading = false;
        _history = [];
        _error = 'Please log in to save and view your symptom history.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final history = await _firestoreService.getSymptoms();
      if (!mounted) {
        return;
      }
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _error = FirestoreService.errorMessage(error);
      });
    }
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final first = DateTime(2020);
    var last = today;
    var initial = DateUtils.dateOnly(_date);
    if (initial.isBefore(first)) {
      initial = first;
    } else if (initial.isAfter(last)) {
      initial = last;
    }

    final selected = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
          content: SizedBox(
            width: 320,
            height: 360,
            child: CalendarDatePicker(
              initialDate: initial,
              firstDate: first,
              lastDate: last,
              currentDate: today,
              onDateChanged: (value) {
                Navigator.of(dialogContext).pop(DateUtils.dateOnly(value));
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selected == null) {
      return;
    }
    setState(() {
      _date = DateUtils.dateOnly(selected);
      _error = null;
    });
  }

  Future<void> _save() async {
    if (!_isLoggedIn) {
      setState(() {
        _error = 'Please log in to save symptom data.';
      });
      return;
    }
    if (_selected.isEmpty) {
      setState(() => _error = 'Please choose at least one symptom.');
      return;
    }

    setState(() {
      _error = null;
      _isSaving = true;
    });

    try {
      await _firestoreService.saveSymptom(
        date: DateUtils.dateOnly(_date),
        symptoms: _selected.toList(),
        severity: _severity,
        notes: _notesController.text,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _selected.clear();
        _severity = 'Mild';
        _notesController.clear();
        _date = DateUtils.dateOnly(DateTime.now());
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Symptoms saved to your account.')),
      );
      await _loadSymptoms();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
        _error = FirestoreService.errorMessage(error);
      });
    }
  }

  Future<void> _deleteSymptom(SymptomModel symptom) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete this log?'),
          content: const Text('This removes the symptom record from your account.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _firestoreService.deleteSymptom(symptom.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Symptom log deleted.')),
      );
      await _loadSymptoms();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(FirestoreService.errorMessage(error))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptoms')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            const SectionHeader(
              title: 'How do you feel?',
              subtitle: 'Select a date and anything that applies.',
            ),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Date'),
                subtitle: Text(AppDateUtils.formatDate(_date)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _isSaving ? null : _pickDate,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _symptomOptions.map((symptom) {
                    final selected = _selected.contains(symptom);
                    return FilterChip(
                      label: Text(symptom),
                      selected: selected,
                      onSelected: _isSaving
                          ? null
                          : (value) {
                              setState(() {
                                if (value) {
                                  _selected.add(symptom);
                                } else {
                                  _selected.remove(symptom);
                                }
                                _error = null;
                              });
                            },
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Severity',
              subtitle: 'Choose how strong the symptoms feel',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  children: _severityOptions.map((level) {
                    return ChoiceChip(
                      label: Text(level),
                      selected: _severity == level,
                      onSelected: _isSaving
                          ? null
                          : (selected) {
                              if (selected) {
                                setState(() => _severity = level);
                              }
                            },
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Notes'),
            TextField(
              controller: _notesController,
              maxLines: 4,
              enabled: !_isSaving,
              decoration: const InputDecoration(
                hintText: 'Optional notes, such as rest or hydration',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save symptoms'),
            ),
            const SizedBox(height: 28),
            const SectionHeader(
              title: 'Symptom history',
              subtitle: 'Only your saved logs are shown here.',
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_history.isEmpty)
              const AppEmptyState(
                icon: Icons.favorite_outline,
                title: 'No symptom logs yet',
                message: 'Saved symptoms will appear here after you tap Save.',
              )
            else
              ..._history.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SymptomCard(
                    symptom: item,
                    onDelete: () => _deleteSymptom(item),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
