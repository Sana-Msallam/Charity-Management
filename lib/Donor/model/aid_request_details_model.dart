class AidRequestDetailsModel {
  final String image;
  final String title;
  final String description;
  final String totalCost;
  final String paidAmount;
  final String remainingAmount;
  final double completionPercentage;
  final bool isUrgent;

  AidRequestDetailsModel({
    required this.image,
    required this.title,
    required this.description,
    required this.totalCost,
    required this.paidAmount,
    required this.remainingAmount,
    required this.completionPercentage,
    required this.isUrgent,
  });

  factory AidRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    return AidRequestDetailsModel(
      image: _asString(json['image']),

      title: _asString(json['title']),

      description: _asString(json['description']),

      totalCost: _asString(json['totalCost'], fallback: '0'),

      paidAmount: _asString(json['paidAmount'], fallback: '0'),

      remainingAmount: _asString(json['remainingAmount'], fallback: '0'),

      completionPercentage: _asDouble(json['completionPercentage']),

      isUrgent: json['isUrgent'] ?? false,
    );
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    if (value == null) {
      return fallback;
    }

    return value.toString();
  }

  static double _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }
}
