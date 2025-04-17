import 'package:report_internship/models/report_model.dart';


abstract class ReportEvent {}

class LoadReports extends ReportEvent {}

class AddReport extends ReportEvent {
  final Report report;
  AddReport(this.report, String text);
}

class UpdateReport extends ReportEvent {
  final String id;
  final Report report;
  UpdateReport(this.id, this.report);
}

class DeleteReport extends ReportEvent {
  final String id;
  DeleteReport(this.id);
}
