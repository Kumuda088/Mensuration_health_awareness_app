import 'package:flutter/material.dart';

import '../../models/period_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../../utils/date_utils.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/period_card.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/section_header.dart';

class PeriodTrackingScreen extends StatefulWidget {
  const PeriodTrackingScreen({super.key});

  @override
  State<PeriodTrackingScreen> createState() => _PeriodTrackingScreenState();
}

class _PeriodTrackingScreenState extends State<PeriodTrackingScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _error;
  bool _isSaving = false;
  bool _isLoading = true;
  List<PeriodModel> _periods = [];

  @override
  void initState() {
    super.initState();
    _loadPeriods();
  }

  bool get _isLoggedIn => _authService.currentUser != null;

  Future<void> _loadPeriods() async {
    if (!_isLoggedIn) {
      setState(() {
        _isLoading = false;
        _periods = [];
        _error = 'Please log in to save and view your period history.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final periods = await _firestoreService.getPeriods();
      if (!mounted) {
        return;
      }
      setState(() {
        _periods = periods;
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

  /// Picks a calendar day and closes as soon as a valid date is tapped.
  /// showDatePicker on Web/Edge often only highlights a day until OK is pressed,
  /// and time on DateTime.now() can make the only valid day look untappable.
  Future<DateTime?> _pickCalendarDate({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    final first = DateUtils.dateOnly(firstDate);
    var last = DateUtils.dateOnly(lastDate);
    if (last.isBefore(first)) {
      last = first;
    }

    var initial = DateUtils.dateOnly(initialDate);
    if (initial.isBefore(first)) {
      initial = first;
    } else if (initial.isAfter(last)) {
      initial = last;
    }

    return showDialog<DateTime>(
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
              currentDate: DateUtils.dateOnly(DateTime.now()),
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
  }

  Future<void> _pickStart() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selected = await _pickCalendarDate(
      initialDate: _startDate ?? today,
      firstDate: DateTime(2020),
      lastDate: today,
    );
    if (selected == null) {
      return;
    }

    final start = DateUtils.dateOnly(selected);
    setState(() {
      _startDate = start;
      if (_endDate != null && DateUtils.dateOnly(_endDate!).isBefore(start)) {
        _endDate = null;
      }
      _error = null;
    });
  }

  Future<void> _pickEnd() async {
    if (_startDate == null) {
      setState(() {
        _error = 'Please choose a period start date first.';
      });
      return;
    }

    final today = DateUtils.dateOnly(DateTime.now());
    final start = DateUtils.dateOnly(_startDate!);
    final selected = await _pickCalendarDate(
      initialDate: _endDate ?? start,
      firstDate: start,
      lastDate: today.isBefore(start) ? start : today,
    );
    if (selected == null) {
      return;
    }

    setState(() {
      _endDate = DateUtils.dateOnly(selected);
      _error = null;
    });
  }

  int? get _duration {
    if (_startDate == null || _endDate == null) {
      return null;
    }
    final start = DateUtils.dateOnly(_startDate!);
    final end = DateUtils.dateOnly(_endDate!);
    return AppDateUtils.daysBetween(start, end) + 1;
  }

  Future<void> _save() async {
    if (!_isLoggedIn) {
      setState(() {
        _error = 'Please log in to save period data.';
      });
      return;
    }
    if (_startDate == null) {
      setState(() => _error = 'Please choose a period start date.');
      return;
    }
    if (_endDate != null &&
        DateUtils.dateOnly(_endDate!).isBefore(DateUtils.dateOnly(_startDate!))) {
      setState(() => _error = 'End date cannot be before the start date.');
      return;
    }

    setState(() {
      _error = null;
      _isSaving = true;
    });

    try {
      await _firestoreService.savePeriod(
        startDate: _startDate!,
        endDate: _endDate,
        duration: _duration,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _startDate = null;
        _endDate = null;
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Period saved to your account.')),
      );
      await _loadPeriods();
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

  Future<void> _deletePeriod(PeriodModel period) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete this period?'),
          content: const Text('This removes the record from your account.'),
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
      await _firestoreService.deletePeriod(period.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Period deleted.')),
      );
      await _loadPeriods();
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
      appBar: AppBar(title: const Text('Period Tracking')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            const SectionHeader(
              title: 'Log your period',
              subtitle: 'Dates are saved privately under your account.',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.play_arrow_rounded),
                      title: const Text('Period start date'),
                      subtitle: Text(
                        _startDate == null
                            ? 'Tap to choose a date'
                            : AppDateUtils.formatDate(_startDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: _isSaving ? null : _pickStart,
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.stop_rounded),
                      title: const Text('Period end date'),
                      subtitle: Text(
                        _endDate == null
                            ? 'Optional if your period is still ongoing'
                            : AppDateUtils.formatDate(_endDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: _isSaving ? null : _pickEnd,
                    ),
                    if (_duration != null) ...[
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.timelapse),
                        title: const Text('Duration'),
                        subtitle: Text('$_duration days'),
                      ),
                    ],
                  ],
                ),
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
                  : const Text('Save'),
            ),
            const SizedBox(height: 28),
            const SectionHeader(
              title: 'Period history',
              subtitle: 'Only your saved cycles are shown here.',
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_periods.isEmpty)
              const AppEmptyState(
                icon: Icons.history,
                title: 'No period history yet',
                message: 'Saved periods will appear here after you tap Save.',
              )
            else
              ..._periods.map(
                (period) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PeriodCard(
                    period: period,
                    onDelete: () => _deletePeriod(period),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
