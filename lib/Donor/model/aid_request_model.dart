class AidRequestModel {
  final int id;
  final String image;
  final String title;
  final String totalCost;
  final String paidAmount;
  final String remainingAmount;
  final num completionPercentage;
  final bool isUrgent;

  AidRequestModel({
    required this.id,
    required this.image,
    required this.title,
    required this.totalCost,
    required this.paidAmount,
    required this.remainingAmount,
    required this.completionPercentage,
    required this.isUrgent,
  });

  // هذه الدالة لتحويل JSON إلى Object
  factory AidRequestModel.fromJson(Map<String, dynamic> json) {
    return AidRequestModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      totalCost: json['totalCost'] ?? '0',
      paidAmount: json['paidAmount'] ?? '0',
      remainingAmount: json['remainingAmount'] ?? '0',
      completionPercentage: json['completionPercentage'] ?? 0,
      isUrgent: json['isUrgent'] ?? false,
    );
  }
}