class SponsorshipListModel {
  final int id;
  final int donorId;
  final String monthlyAmount;
  final String status;
  final String? rejectionReason;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? cancellationSource;
  final DateTime createdAt;
  final SponsoredOrphanModel? orphan;

  SponsorshipListModel({
    required this.id,
    required this.donorId,
    required this.monthlyAmount,
    required this.status,
    this.rejectionReason,
    this.startDate,
    this.endDate,
    this.cancellationSource,
    required this.createdAt,
    this.orphan,
  });

  factory SponsorshipListModel.fromJson(Map<String, dynamic> json) {
    return SponsorshipListModel(
      id: json['id'],
      donorId: json['donorId'],
      monthlyAmount: json['monthlyAmount']?.toString() ?? '0.00',
      status: json['status'] ?? '',
      rejectionReason: json['rejectionReason'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      cancellationSource: json['cancellationSource'],
      createdAt: DateTime.parse(json['createdAt']),
      orphan: json['orphan'] != null
          ? SponsoredOrphanModel.fromJson(json['orphan'])
          : null,
    );
  }
}

class SponsoredOrphanModel {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime birthOfDate;
  final String gender;
  final String className;
  final String? talent;

  SponsoredOrphanModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthOfDate,
    required this.gender,
    required this.className,
    this.talent,
  });

  factory SponsoredOrphanModel.fromJson(Map<String, dynamic> json) {
    return SponsoredOrphanModel(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      birthOfDate: DateTime.parse(json['birthOfDate']),
      gender: json['gender'] ?? '',
      className: json['class'] ?? '',
      talent: json['talent'],
    );
  }

  String get fullName => '$firstName $lastName';
}
