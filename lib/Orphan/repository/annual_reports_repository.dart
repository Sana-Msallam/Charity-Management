import 'package:charity_management/Orphan/model/annual_report_model.dart';
import 'package:charity_management/Orphan/service/annual_reports_service.dart';

class AnnualReportsRepository {
  AnnualReportsRepository({AnnualReportsService? service})
    : _service = service ?? AnnualReportsService();

  final AnnualReportsService _service;

  Future<List<AnnualReportModel>> getAnnualReports({
    required int sponsorshipId,
  }) {
    return _service.getAnnualReports(sponsorshipId: sponsorshipId);
  }
}
