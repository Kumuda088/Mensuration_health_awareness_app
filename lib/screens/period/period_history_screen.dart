import 'package:flutter/material.dart';

import '../../models/period_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/period_card.dart';
import '../../widgets/responsive_body.dart';
import 'period_tracking_screen.dart';

class PeriodHistoryScreen extends StatefulWidget {
  const PeriodHistoryScreen({super.key});

  @override
  State<PeriodHistoryScreen> createState() => _PeriodHistoryScreenState();
}

class _PeriodHistoryScreenState extends State<PeriodHistoryScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  bool _isLoading = true;
  String? _error;
  List<PeriodModel> _periods = [];

  @override
  void initState() {
    super.initState();
    _loadPeriods();
  }

  Future<void> _loadPeriods() async {
    if (_authService.currentUser == null) {
      setState(() {
        _isLoading = false;
        _error = 'Please log in to view your period history.';
        _periods = [];
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

  Future<void> _deletePeriod(PeriodModel period) async {
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
      appBar: AppBar(title: const Text('Period History')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              AppEmptyState(
                icon: Icons.lock_outline,
                title: 'Could not load history',
                message: _error!,
              )
            else if (_periods.isEmpty)
              AppEmptyState(
                icon: Icons.history,
                title: 'No period history yet',
                message: 'Log a period to see it saved under your account.',
                action: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PeriodTrackingScreen(),
                      ),
                    );
                  },
                  child: const Text('Log Period'),
                ),
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
