class RequestTrackingModel {
  const RequestTrackingModel({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.title,
    required this.status,
    required this.rejectionReason,
    required this.cost,
    required this.currentPayment,
    required this.isUrgent,
    required this.createdAt,
    required this.category,
    required this.subCategory,
    required this.typeAid,
  });

  final int id;
  final int categoryId;
  final int? subCategoryId;
  final String? title;
  final String status;
  final String? rejectionReason;
  final double cost;
  final double currentPayment;
  final bool? isUrgent;
  final DateTime? createdAt;
  final RequestCategoryModel category;
  final RequestSubCategoryModel? subCategory;
  final dynamic typeAid;

  factory RequestTrackingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestTrackingModel(
      id: _parseInt(json['id']),
      categoryId: _parseInt(json['categoryId']),
      subCategoryId: _parseNullableInt(
        json['subCategoryId'],
      ),
      title: _parseNullableString(
        json['title'],
      ),
      status: json['status']?.toString() ?? '',
      rejectionReason: _parseNullableString(
        json['rejectionReason'],
      ),
      cost: _parseDouble(json['cost']),
      currentPayment: _parseDouble(
        json['currentPayment'],
      ),
      isUrgent: json['isUrgent'] is bool
          ? json['isUrgent'] as bool
          : null,
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
      category: json['category'] is Map
          ? RequestCategoryModel.fromJson(
              Map<String, dynamic>.from(
                json['category'],
              ),
            )
          : const RequestCategoryModel(
              id: 0,
              name: '',
            ),
      subCategory: json['subCategory'] is Map
          ? RequestSubCategoryModel.fromJson(
              Map<String, dynamic>.from(
                json['subCategory'],
              ),
            )
          : null,
      typeAid: json['typeAid'],
    );
  }

  // ==========================================
  // Payment helpers
  // ==========================================

  double get paymentProgress {
    if (cost <= 0) {
      return 0;
    }

    final double progress =
        currentPayment / cost;

    return progress.clamp(
      0.0,
      1.0,
    );
  }

  double get paymentPercentage {
    return paymentProgress * 100;
  }

  double get remainingAmount {
    final double remaining =
        cost - currentPayment;

    if (remaining < 0) {
      return 0;
    }

    return remaining;
  }

  // ==========================================
  // Status helpers
  // ==========================================

  bool get isPending {
    return status.toUpperCase() ==
        'PENDING';
  }

  bool get isAccepted {
    return status.toUpperCase() ==
        'ACCEPTED';
  }

  bool get isRejected {
    return status.toUpperCase() ==
        'REJECTED';
  }

  bool get isCancelled {
    return status.toUpperCase() ==
        'CANCELLED';
  }

  // ==========================================
  // Display helpers
  // ==========================================

  String get normalizedStatus {
    return status.toUpperCase();
  }

  String? get validTitle {
    final String? currentTitle =
        title?.trim();

    if (currentTitle != null &&
        currentTitle.isNotEmpty) {
      return currentTitle;
    }

    return null;
  }

  bool get hasCategoryName {
    return category.name.trim().isNotEmpty;
  }

  // ==========================================
  // Parsers
  // ==========================================

  static int _parseInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static int? _parseNullableInt(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  static double _parseDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static String? _parseNullableString(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    final String text =
        value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }
}

// ============================================
// Category
// ============================================

class RequestCategoryModel {
  const RequestCategoryModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory RequestCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestCategoryModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(
                json['id']?.toString() ?? '',
              ) ??
              0,
      name:
          json['name']?.toString() ?? '',
    );
  }
}

// ============================================
// Sub Category
// ============================================

class RequestSubCategoryModel {
  const RequestSubCategoryModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory RequestSubCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestSubCategoryModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(
                json['id']?.toString() ?? '',
              ) ??
              0,
      name:
          json['name']?.toString() ?? '',
    );
  }
}