
class CompletedAidRequestModel {
  final int id;
  final String image;
  final String title;
  final String totalCost;
  final String paidAmount;
  final String remainingAmount;
  final int completionPercentage;
  final bool isUrgent;

  CompletedAidRequestModel({
    required this.id,
    required this.image,
    required this.title,
    required this.totalCost,
    required this.paidAmount,
    required this.remainingAmount,
    required this.completionPercentage,
    required this.isUrgent,
  });

  factory CompletedAidRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CompletedAidRequestModel(
      id: json['id'],
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      totalCost: json['totalCost']?.toString() ?? '0',
      paidAmount: json['paidAmount']?.toString() ?? '0',
      remainingAmount:
          json['remainingAmount']?.toString() ?? '0',
      completionPercentage:
          json['completionPercentage'] ?? 0,
      isUrgent: json['isUrgent'] ?? false,
    );
  }
}


