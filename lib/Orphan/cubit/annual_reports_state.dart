import 'package:charity_management/Orphan/model/annual_report_model.dart';

sealed class AnnualReportsState {
  const AnnualReportsState();
}

final class AnnualReportsInitial extends AnnualReportsState {
  const AnnualReportsInitial();
}

final class AnnualReportsLoading extends AnnualReportsState {
  const AnnualReportsLoading();
}

final class AnnualReportsSuccess extends AnnualReportsState {
  const AnnualReportsSuccess(this.reports);

  final List<AnnualReportModel> reports;
}

final class AnnualReportsEmpty extends AnnualReportsState {
  const AnnualReportsEmpty();
}

final class AnnualReportsFailure extends AnnualReportsState {
  const AnnualReportsFailure(this.message);

  final String message;
}
