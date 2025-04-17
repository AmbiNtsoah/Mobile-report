import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String day;
  final String activity;
  final DateTime date;
  final String lieu;
  final String skills;

  Report({
    required this.id,
    required this.day,
    required this.activity,
    required this.date,
    required this.lieu,
    required this.skills,
  });

  factory Report.fromDocument(Map<String, dynamic> doc, String id) {
    return Report(
      id: id,
      day: doc['day'] ?? '',
      activity: doc['activity'] ?? '',
      date: (doc['date'] as Timestamp).toDate(),
      lieu: doc['lieu'] ?? '',
      skills: doc['skills'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'activity': activity,
      'date': date,
      'lieu': lieu,
      'skills': skills,
    };
  }
}
