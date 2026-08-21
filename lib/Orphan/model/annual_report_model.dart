class AnnualReportModel {
  const AnnualReportModel({
    required this.id,
    required this.reportNumber,
    required this.reportYear,
    required this.imageUrl,
    required this.createdAt,
  });

  final int id;
  final int reportNumber;
  final int reportYear;
  final String imageUrl;
  final DateTime createdAt;

  factory AnnualReportModel.fromJson(Map<String, dynamic> json) {
    return AnnualReportModel(
      id: _readInt(json['id']),
      reportNumber: _readInt(json['reportNumber']),
      reportYear: _readInt(json['reportYear']),
      imageUrl: json['imageUrl']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt']?.toString() ?? ''),
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.parse(value.toString());
  }
}
