class DonorHistoryModel {
  final List<DonorHistoryYear> years;

  const DonorHistoryModel({
    required this.years,
  });

  factory DonorHistoryModel.fromJson(Map<String, dynamic> json) {
    return DonorHistoryModel(
      years: (json['years'] as List<dynamic>? ?? [])
          .map(
            (year) => DonorHistoryYear.fromJson(
              year as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  List<DonorOperation> get allOperations {
    return years
        .expand((year) => year.operations)
        .toList();
  }
}

class DonorHistoryYear {
  final int year;
  final List<DonorOperation> operations;

  const DonorHistoryYear({
    required this.year,
    required this.operations,
  });

  factory DonorHistoryYear.fromJson(Map<String, dynamic> json) {
    return DonorHistoryYear(
      year: json['year'] as int,
      operations: (json['operations'] as List<dynamic>? ?? [])
          .map(
            (operation) => DonorOperation.fromJson(
              operation as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class DonorOperation {
  final double amount;
  final DonorOperationType type;
  final DateTime createdAt;
  final DonorOrphan? orphan;
  final DonorAidRequest? aidRequest;

  const DonorOperation({
    required this.amount,
    required this.type,
    required this.createdAt,
    this.orphan,
    this.aidRequest,
  });

  factory DonorOperation.fromJson(Map<String, dynamic> json) {
    return DonorOperation(
      amount: double.tryParse(
            json['amount']?.toString() ?? '0',
          ) ??
          0,
      type: DonorOperationType.fromString(
        json['type']?.toString(),
      ),
      createdAt: DateTime.parse(
        json['createdAt'].toString(),
      ),
      orphan: json['orphan'] != null
          ? DonorOrphan.fromJson(
              json['orphan'] as Map<String, dynamic>,
            )
          : null,
      aidRequest: json['aidRequest'] != null
          ? DonorAidRequest.fromJson(
              json['aidRequest'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class DonorOrphan {
  final int id;
  final String firstName;
  final String lastName;

  const DonorOrphan({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory DonorOrphan.fromJson(Map<String, dynamic> json) {
    return DonorOrphan(
      id: json['id'] as int,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
    );
  }

  String get fullName {
    return '$firstName $lastName';
  }
}

class DonorAidRequest {
  final int id;
  final String title;

  const DonorAidRequest({
    required this.id,
    required this.title,
  });

  factory DonorAidRequest.fromJson(Map<String, dynamic> json) {
    return DonorAidRequest(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
    );
  }
}

enum DonorOperationType {
  sponsorshipDonation,
  aidRequestDonation,
  walletTopUp,
  unknown;

  static DonorOperationType fromString(String? value) {
    switch (value) {
      case 'SPONSORSHIP_DONATION':
        return DonorOperationType.sponsorshipDonation;

      case 'AID_REQUEST_DONATION':
        return DonorOperationType.aidRequestDonation;

      case 'WALLET_TOP_UP':
        return DonorOperationType.walletTopUp;

      default:
        return DonorOperationType.unknown;
    }
  }
}