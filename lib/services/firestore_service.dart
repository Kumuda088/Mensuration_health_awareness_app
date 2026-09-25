import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/period_model.dart';
import '../models/symptom_model.dart';

/// Cloud Firestore helpers. Period data is always scoped to the signed-in user.
class FirestoreService {
  FirestoreService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String _currentUid() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw StateError('Please log in to save and view your records.');
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> _periodsCollection() {
    final uid = _currentUid();
    return _firestore.collection('users').doc(uid).collection('periods');
  }

  CollectionReference<Map<String, dynamic>> _symptomsCollection() {
    final uid = _currentUid();
    return _firestore.collection('users').doc(uid).collection('symptoms');
  }

  Future<void> createUserDocument({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserName({
    required String uid,
    required String name,
  }) async {
    await _firestore.collection('users').doc(uid).set(
      {'name': name},
      SetOptions(merge: true),
    );
  }

  Future<void> savePeriod({
    required DateTime startDate,
    DateTime? endDate,
    int? duration,
  }) async {
    await _periodsCollection().add({
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate),
      'duration': duration,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<PeriodModel>> getPeriods() async {
    final uid = _currentUid();
    final snapshot = await _periodsCollection()
        .orderBy('startDate', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return PeriodModel(
        id: doc.id,
        userId: uid,
        startDate: _toDate(data['startDate']) ?? DateTime.now(),
        endDate: _toDate(data['endDate']),
        duration: data['duration'] as int?,
        createdAt: _toDate(data['createdAt']),
      );
    }).toList();
  }

  Future<void> deletePeriod(String periodId) async {
    await _periodsCollection().doc(periodId).delete();
  }

  Future<void> saveSymptom({
    required DateTime date,
    required List<String> symptoms,
    required String severity,
    String notes = '',
  }) async {
    await _symptomsCollection().add({
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'symptoms': symptoms,
      'severity': severity,
      'notes': notes.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<SymptomModel>> getSymptoms() async {
    final uid = _currentUid();
    final snapshot = await _symptomsCollection()
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final rawSymptoms = data['symptoms'];
      final symptoms = rawSymptoms is List
          ? rawSymptoms.map((item) => item.toString()).toList()
          : <String>[];

      return SymptomModel(
        id: doc.id,
        userId: uid,
        date: _toDate(data['date']) ?? DateTime.now(),
        symptoms: symptoms,
        severity: (data['severity'] as String?) ?? 'Mild',
        notes: (data['notes'] as String?) ?? '',
        createdAt: _toDate(data['createdAt']),
      );
    }).toList();
  }

  Future<void> deleteSymptom(String symptomId) async {
    await _symptomsCollection().doc(symptomId).delete();
  }

  DateTime? _toDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  static String errorMessage(Object error) {
    if (error is StateError) {
      return error.message;
    }
    if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return 'You do not have permission to access this data.';
      }
      if (error.code == 'unavailable') {
        return 'Could not reach Firestore. Check your internet connection.';
      }
      return 'Could not update your data. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
