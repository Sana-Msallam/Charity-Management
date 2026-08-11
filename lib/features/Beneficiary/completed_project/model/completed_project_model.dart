class CompletedProjectCategory {
  const CompletedProjectCategory({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory CompletedProjectCategory.fromJson(
    Map<String, dynamic> json,
  ) {
    return CompletedProjectCategory(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(
                json['id']?.toString() ?? '',
              ) ??
              0,
      name: json['name']?.toString() ?? '',
    );
  }
}

class CompletedProjectModel {
  const CompletedProjectModel({
    required this.id,
    required this.category,
    required this.image,
    required this.title,
    required this.totalCost,
    required this.paidAmount,
    required this.remainingAmount,
    required this.completionPercentage,
    required this.isUrgent,
  });

  final int id;

  final CompletedProjectCategory category;

  final String? image;
  final String? title;

  final double totalCost;
  final double paidAmount;
  final double remainingAmount;

  final double completionPercentage;

  final bool isUrgent;

  factory CompletedProjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dynamic categoryData = json['category'];

    return CompletedProjectModel(
      id: _parseInt(
        json['id'],
      ),
      category: categoryData is Map
          ? CompletedProjectCategory.fromJson(
              Map<String, dynamic>.from(
                categoryData,
              ),
            )
          : const CompletedProjectCategory(
              id: 0,
              name: '',
            ),
      image: _parseNullableString(
        json['image'],
      ),
      title: _parseNullableString(
        json['title'],
      ),
      totalCost: _parseDouble(
        json['totalCost'],
      ),
      paidAmount: _parseDouble(
        json['paidAmount'],
      ),
      remainingAmount: _parseDouble(
        json['remainingAmount'],
      ),
      completionPercentage: _parseDouble(
        json['completionPercentage'],
      ),
      isUrgent: json['isUrgent'] == true,
    );
  }

String get displayTitle {
  final String? currentTitle = title?.trim();

  // إذا الباك رجّع title حقيقي
  // منعرضه مباشرة
  if (currentTitle != null && currentTitle.isNotEmpty) {
    return currentTitle;
  }

  // إذا الباك رجّع title = null أو فاضي
  // منستخدم عنوان افتراضي حسب نوع الطلب
  switch (category.id) {
    case 1:
      return 'دعم الرعاية الصحية';

    case 2:
      return 'توفير الاحتياجات الغذائية';

    case 3:
      return 'دعم وتأمين السكن';

    case 4:
      return 'دعم المسيرة التعليمية';

    case 5:
      return 'دعم مشروع صغير';

    default:
      return 'مساهمة صنعت أثراً';
  }
}

  String get defaultImagePath {
    switch (category.id) {
      case 1:
        return 'assets/img/health_default.jpg';

      case 2:
        return 'assets/img/food_default.jpg';

      case 3:
        return 'assets/img/housing_default.jpg';

      case 4:
        return 'assets/img/education_default.jpg';

      case 5:
        return 'assets/img/project_default.jpg';

      default:
        return 'assets/img/default_aid.jpg';
    }
  }

  bool get hasImage {
    return image != null &&
        image!.trim().isNotEmpty;
  }

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