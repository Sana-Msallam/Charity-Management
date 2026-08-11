class CancelSponsorshipModel {
  final int id;
  final int donorId;
  final int? orphanId;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? cancellationSource;
  final bool orphanReleased;

  CancelSponsorshipModel({
    required this.id,
    required this.donorId,
    this.orphanId,
    required this.status,
    this.startDate,
    this.endDate,
    this.cancellationSource,
    required this.orphanReleased,
  });

  factory CancelSponsorshipModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CancelSponsorshipModel(
      id: json['id'],
      donorId: json['donorId'],
      orphanId: json['orphanId'],
      status: json['status'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      cancellationSource: json['cancellationSource'],
      orphanReleased: json['orphanReleased'] ?? false,
    );
  }
}

class CancelSponsorshipResponse {
  final bool success;
  final String message;
  final CancelSponsorshipModel data;

  CancelSponsorshipResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CancelSponsorshipResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CancelSponsorshipResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CancelSponsorshipModel.fromJson(
        json['data'],
      ),
    );
  }
}