class RequestDetailsModel {
  const RequestDetailsModel({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.firstName,
    required this.lastName,
    required this.beneficiaryFatherName,
    required this.socialStatus,
    required this.addressAr,
    required this.addressEn,
    required this.age,
    required this.isUnemployed,
    required this.gender,
    required this.number,
    required this.title,
    required this.detailsAr,
    required this.detailsEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.cost,
    required this.currentPayment,
    required this.status,
    required this.rejectionReason,
    required this.isUrgent,
    required this.category,
    required this.subCategory,
    required this.aidDetailsAr,
    required this.aidDetailsEn,
  });

  final int id;

  final int categoryId;

  final int? subCategoryId;

  final String firstName;

  final String lastName;

  final String beneficiaryFatherName;

  final String socialStatus;

  // ==========================================
  // ADDRESS
  // ==========================================

  final String addressAr;

  final String addressEn;

  // للتوافق مع الكود القديم.
  String get address => addressAr;

  final int age;

  final bool isUnemployed;

  final String gender;

  final String number;

  final String? title;

  // ==========================================
  // DETAILS
  // ==========================================

  final String? detailsAr;

  final String? detailsEn;

  // للتوافق مع الكود القديم.
  String? get details => detailsAr;

  // ==========================================
  // DESCRIPTION
  // ==========================================

  final String? descriptionAr;

  final String? descriptionEn;

  // للتوافق مع الكود القديم.
  String? get description => descriptionAr;

  final double cost;

  final double currentPayment;

  final String status;

  final String? rejectionReason;

  final bool isUrgent;

  final RequestDetailsCategory category;

  final RequestDetailsSubCategory? subCategory;

  // ==========================================
  // AID DETAILS
  // ==========================================

  /// تفاصيل الطلب باللغة العربية.
  final Map<String, dynamic> aidDetailsAr;

  /// تفاصيل الطلب باللغة الإنجليزية.
  final Map<String, dynamic> aidDetailsEn;

  /// للتوافق مع الكود القديم.
  /// افتراضياً نعيد العربية.
  Map<String, dynamic> get aidDetails =>
      aidDetailsAr;

  // ==========================================
  // FACTORY
  // ==========================================

  factory RequestDetailsModel.fromLocalizedJson({
    required Map<String, dynamic> arabicJson,
    required Map<String, dynamic> englishJson,
  }) {
    final dynamic categoryData =
        arabicJson['category'];

    final dynamic subCategoryData =
        arabicJson['subCategory'];

    final dynamic arabicAidDetailsData =
        arabicJson['aidDetails'];

    final dynamic englishAidDetailsData =
        englishJson['aidDetails'];

    return RequestDetailsModel(
      id: _parseInt(
        arabicJson['id'],
      ),

      categoryId: _parseInt(
        arabicJson['categoryId'],
      ),

      subCategoryId: _parseNullableInt(
        arabicJson['subCategoryId'],
      ),

      firstName:
          arabicJson['firstName']?.toString() ??
              '',

      lastName:
          arabicJson['lastName']?.toString() ??
              '',

      beneficiaryFatherName:
          arabicJson['beneficiaryFatherName']
                  ?.toString() ??
              '',

      socialStatus:
          arabicJson['socialStatus']?.toString() ??
              '',

      addressAr:
          _parsePlainString(
        arabicJson['address'],
      ),

      addressEn:
          _parsePlainString(
        englishJson['address'],
      ),

      age: _parseInt(
        arabicJson['age'],
      ),

      isUnemployed:
          arabicJson['isUnemployed'] == true,

      gender:
          arabicJson['gender']?.toString() ??
              '',

      number:
          arabicJson['number']?.toString() ??
              '',

      title: _parseNullableString(
        arabicJson['title'],
      ),

      detailsAr:
          _parseNullableString(
        arabicJson['details'],
      ),

      detailsEn:
          _parseNullableString(
        englishJson['details'],
      ),

      descriptionAr:
          _parseNullableString(
        arabicJson['description'],
      ),

      descriptionEn:
          _parseNullableString(
        englishJson['description'],
      ),

      cost: _parseDouble(
        arabicJson['cost'],
      ),

      currentPayment: _parseDouble(
        arabicJson['currentPayment'],
      ),

      status:
          arabicJson['status']?.toString() ??
              '',

      rejectionReason:
          _parseNullableString(
        arabicJson['rejectionReason'],
      ),

      isUrgent:
          arabicJson['isUrgent'] == true,

      category:
          categoryData is Map
              ? RequestDetailsCategory.fromJson(
                  Map<String, dynamic>.from(
                    categoryData,
                  ),
                )
              : const RequestDetailsCategory(
                  id: 0,
                  name: '',
                ),

      subCategory:
          subCategoryData is Map
              ? RequestDetailsSubCategory.fromJson(
                  Map<String, dynamic>.from(
                    subCategoryData,
                  ),
                )
              : null,

      aidDetailsAr:
          arabicAidDetailsData is Map
              ? Map<String, dynamic>.from(
                  arabicAidDetailsData,
                )
              : <String, dynamic>{},

      aidDetailsEn:
          englishAidDetailsData is Map
              ? Map<String, dynamic>.from(
                  englishAidDetailsData,
                )
              : <String, dynamic>{},
    );
  }

  // ==========================================
  // REQUEST TYPE HELPERS
  // ==========================================

  bool get isHealth {
    return categoryId == 1;
  }

  bool get isFood {
    return categoryId == 2;
  }

  bool get isHousing {
    return categoryId == 3;
  }

  bool get isEducation {
    return categoryId == 4;
  }

  bool get isSmallProject {
    return categoryId == 5;
  }

  // ==========================================
  // AID DETAILS - ARABIC
  // ==========================================

  String? getAidDetailString(
    String key,
  ) {
    return getAidDetailStringAr(
      key,
    );
  }

  String? getAidDetailStringAr(
    String key,
  ) {
    return _parseNullableString(
      aidDetailsAr[key],
    );
  }

  // ==========================================
  // AID DETAILS - ENGLISH
  // ==========================================

  String? getAidDetailStringEn(
    String key,
  ) {
    return _parseNullableString(
      aidDetailsEn[key],
    );
  }

  // ==========================================
  // NUMBERS
  // ==========================================

  int? getAidDetailInt(
    String key,
  ) {
    return _parseNullableInt(
      aidDetailsAr[key],
    );
  }

  double? getAidDetailDouble(
    String key,
  ) {
    final dynamic value =
        aidDetailsAr[key];

    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }

  // ==========================================
  // LISTS
  // ==========================================

  List<String> getAidDetailStringList(
    String key,
  ) {
    final dynamic value =
        aidDetailsAr[key];

    if (value is! List) {
      return const [];
    }

    return value
        .map(
          (item) => item.toString(),
        )
        .toList();
  }

  // ==========================================
  // PARSERS
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

  static String _parsePlainString(
    dynamic value,
  ) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
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
// CATEGORY
// ============================================

class RequestDetailsCategory {
  const RequestDetailsCategory({
    required this.id,
    required this.name,
  });

  final int id;

  final String name;

  factory RequestDetailsCategory.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestDetailsCategory(
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
// SUB CATEGORY
// ============================================

class RequestDetailsSubCategory {
  const RequestDetailsSubCategory({
    required this.id,
    required this.name,
  });

  final int id;

  final String name;

  factory RequestDetailsSubCategory.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestDetailsSubCategory(
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