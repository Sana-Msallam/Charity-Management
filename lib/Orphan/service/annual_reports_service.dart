import 'package:charity_management/Orphan/model/annual_report_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';

class AnnualReportsService {
  AnnualReportsService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  final Dio _dio;

  Future<List<AnnualReportModel>> getAnnualReports({
    required int sponsorshipId,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.annualReports(sponsorshipId),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid annual reports response');
    }

    final reportsData = data['data'];
    if (reportsData is! List) {
      throw const FormatException('Invalid annual reports data');
    }

    return reportsData
        .whereType<Map>()
        .map(
          (item) => AnnualReportModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
