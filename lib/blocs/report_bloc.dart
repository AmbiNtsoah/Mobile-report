import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_internship/report_repository.dart';
import 'report_event.dart';
import 'report_state.dart';
import '../models/report_model.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc(this.repository) : super(ReportInitial()) {
    on<LoadReports>((event, emit) async {
      emit(ReportLoading());
      try {
        await emit.forEach<List<Report>>(
          repository.fetchReports(),
          onData: (reports) => ReportLoaded(reports),
        );
      } catch (e) {
        emit(ReportError("Erreur de chargement des rapports"));
      }
    });

    on<AddReport>((event, emit) async {
      await repository.addReport(event.report);
    });

    on<UpdateReport>((event, emit) async {
      await repository.updateReport(event.id, event.report);
    });

    on<DeleteReport>((event, emit) async {
      await repository.deleteReport(event.id);
    });
  }
}
