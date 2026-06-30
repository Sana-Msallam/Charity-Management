import 'package:flutter/material.dart';

// 1. نموذج البيانات المخصص لكل حالة تبرع
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

// 2. الواجهة المرنة القابلة لإعادة الاستخدام
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
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF765A00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryTitle, // 👈 العنوان متغير هنا
          style: const TextStyle(
            color: Color(0xFF765A00),
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
              
              // بنر الحالات النشطة المتأثر بلون القسم الممرر
              buildActiveCasesBanner(),
              const SizedBox(height: 20),

              // 👈 إنشاء قائمة الحالات ديناميكياً بناءً على البيانات المستلمة
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cases.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final currentCase = cases[index];
                  return buildCaseCard(currentCase);
                },
              ),
              const SizedBox(height: 32),
            ],
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
        color: bannerColor, // 👈 اللون يتغير تلقائياً حسب القسم
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Cases',
                style: TextStyle(color: Color(0xFF3D523A), fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D523A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cases.length} Available', // عدد الحالات المتاحة ديناميكي
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Supporting urgent requirements and development campaigns for $categoryTitle.',
            style: const TextStyle(color: Color(0xFF5D754C), fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget buildCaseCard(DonationCase item) {
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
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'URGENT',
                      style: TextStyle(color: Color(0xFFA8201A), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(color: Color(0xFF2B2D42), fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(item.description, style: const TextStyle(color: Color(0xFF7F8C8D), fontSize: 13, height: 1.4)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RAISED', style: TextStyle(color: Color(0xFF8A817C), fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(item.raised, style: const TextStyle(color: Color(0xFF3D523A), fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('GOAL', style: TextStyle(color: Color(0xFF8A817C), fontSize: 11)),
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
                    Text(item.daysLeft, style: const TextStyle(color: Color(0xFF8A817C), fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5D166),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Donate Now', style: TextStyle(color: Color(0xFF765A00), fontSize: 14, fontWeight: FontWeight.bold)),
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