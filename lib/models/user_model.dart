/// Local user data model.
/// Firebase Auth and Firestore mapping will be added in a later step.
class UserModel {
  final String id;
  final String name;
  final String email;
  final int? age;
  final int cycleLength;
  final int periodLength;
  final DateTime? lastPeriodStart;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.lastPeriodStart,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    int? cycleLength,
    int? periodLength,
    DateTime? lastPeriodStart,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      cycleLength: cycleLength ?? this.cycleLength,
      periodLength: periodLength ?? this.periodLength,
      lastPeriodStart: lastPeriodStart ?? this.lastPeriodStart,
    );
  }
}
