import 'package:charity_management/Payment/checkout.dart';
import 'package:flutter/material.dart';

class DonationCase {
  final String title;
  final String description;
  final String raised;
  final String goal;
  final double progress;
  final String percentage;
  final String daysLeft;
  final String imagePath;
  final bool isUrgent;

  DonationCase({
    required this.title,
    required this.description,
    required this.raised,
    required this.goal,
    required this.progress,
    required this.percentage,
    required this.daysLeft,
    required this.imagePath,
    required this.isUrgent,
  });
}

class SupportCategoryScreen extends StatelessWidget {
  final String categoryTitle;
  final Color bannerColor;
  final List<DonationCase> cases;

  const SupportCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.bannerColor,
    required this.cases,
  });

  @override
  Widget build(BuildContext context) {
    // تغليف واجهة القسم بـ Directionality لتصبح RTL بالكامل من اليمين
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFBF7),
          elevation: 0,
          leading: IconButton(
            // قلب السهم البرمجي تلقائياً للخلف بناءً على الاتجاه
            icon: const Icon(Icons.arrow_back, color: Color(0xFF765A00)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            categoryTitle,
            style: const TextStyle(
              color: Color(0xFF765A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.search, color: Color(0xFF765A00)), onPressed: () {}),
            IconButton(icon: const Icon(Icons.tune, color: Color(0xFF765A00)), onPressed: () {}),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                
                buildActiveCasesBanner(),
                const SizedBox(height: 20),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cases.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final currentCase = cases[index];
                    return buildCaseCard(context, currentCase); 
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActiveCasesBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // يبدأ من اليمين
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الحالات النشطة',
                style: TextStyle(color: Color(0xFF3D523A), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D523A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cases.length} متاحة',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'دعم المتطلبات العاجلة والحملات التنموية لـ $categoryTitle.',
            style: const TextStyle(color: Color(0xFF5D754C), fontSize: 12, height: 1.4, fontFamily: 'IBM Plex Sans Arabic'),
          ),
        ],
      ),
    );
  }

  Widget buildCaseCard(BuildContext context, DonationCase item) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEAE4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (item.isUrgent)
                Positioned(
                  top: 12,
                  left: 12, // تغييرها لتصبح في الجهة اليسرى العلوية للبطاقة
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'عاجل',
                      style: TextStyle(color: Color(0xFFA8201A), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // نصوص البطاقة تبدأ من اليمين تلقائياً
              children: [
                Text(item.title, style: const TextStyle(color: Color(0xFF2B2D42), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic')),
                const SizedBox(height: 6),
                Text(item.description, style: const TextStyle(color: Color(0xFF7F8C8D), fontSize: 13, height: 1.4, fontFamily: 'IBM Plex Sans Arabic')),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('المجمّع', style: TextStyle(color: Color(0xFF8A817C), fontSize: 11, fontFamily: 'IBM Plex Sans Arabic')),
                        const SizedBox(height: 2),
                        Text(item.raised, style: const TextStyle(color: Color(0xFF3D523A), fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('الهدف', style: TextStyle(color: Color(0xFF8A817C), fontSize: 11, fontFamily: 'IBM Plex Sans Arabic')),
                        const SizedBox(height: 2),
                        Text(item.goal, style: const TextStyle(color: Color(0xFF2B2D42), fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF2ECE4),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3D523A)),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.percentage, style: const TextStyle(color: Color(0xFF8A817C), fontSize: 11, fontWeight: FontWeight.w600)),
                    Text(item.daysLeft, style: const TextStyle(color: Color(0xFF8A817C), fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'IBM Plex Sans Arabic')),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5D166), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            currentCaseName: item.title, 
                          ),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تبرع الآن', 
                          style: TextStyle(color: Color(0xFF765A00), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.favorite_border, color: Color(0xFF765A00), size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}