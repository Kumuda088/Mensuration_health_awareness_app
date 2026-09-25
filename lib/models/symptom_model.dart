/// One symptom log stored in Firestore.
class SymptomModel {
  final String id;
  final String userId;
  final DateTime date;
  final List<String> symptoms;
  final String severity;
  final String notes;
  final DateTime? createdAt;

  const SymptomModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.symptoms,
    required this.severity,
    this.notes = '',
    this.createdAt,
  });

  String get summary => symptoms.join(', ');
}
