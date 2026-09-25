/// One logged period cycle stored in Firestore.
class PeriodModel {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int? duration;
  final DateTime? createdAt;

  const PeriodModel({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.duration,
    this.createdAt,
  });

  int? get durationInDays {
    if (duration != null) {
      return duration;
    }
    if (endDate == null) {
      return null;
    }
    return endDate!.difference(startDate).inDays + 1;
  }
}
