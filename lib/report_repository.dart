import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:report_internship/models/report_model.dart';

class ReportRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('daily_report');

  Stream<List<Report>> fetchReports() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Report.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addReport(Report report) {
    return _collection.add(report.toMap());
  }

  Future<void> updateReport(String id, Report report) {
    return _collection.doc(id).update(report.toMap());
  }

  Future<void> deleteReport(String id) {
    return _collection.doc(id).delete();
  }
}
