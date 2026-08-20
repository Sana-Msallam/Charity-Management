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


  factory AidRequestDetailsModel.fromJson(Map<String,dynamic> json){

    return AidRequestDetailsModel(

      image: json['image'] ?? '',

      title: json['title'] ?? '',

      description: json['description'] ?? '',

      totalCost: json['totalCost'] ?? '0',

      paidAmount: json['paidAmount'] ?? '0',

      remainingAmount: json['remainingAmount'] ?? '0',

      completionPercentage:
          (json['completionPercentage'] ?? 0).toDouble(),

      isUrgent: json['isUrgent'] ?? false,

    );

  }

}