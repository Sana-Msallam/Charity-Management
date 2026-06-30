import 'package:charity_management/Donor/Support_Area/support_category_screen.dart';
import 'package:flutter/material.dart';

class DonorHomeScreen extends StatelessWidget {
  const DonorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون Background المعتمد في التصميم
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. شريط الترحيب العلوي (Header)
                buildHeader(),
                const SizedBox(height: 20),

                // 2. كرت الإعلان الرئيسي (Sponsor an Orphan Today)
                buildMainCampaignCard(),
                const SizedBox(height: 28),

                // 3. قسم مجالات الدعم (Support Areas)
                buildSupportAreasSection(context),
                const SizedBox(height: 28),

                // 4. كرت المبادرات المجتمعية (Community Initiatives)
                buildCommunityCard(),
                const SizedBox(height: 24),

                // 5. إحصائيات التأثير السفلي (Impact Stats)
                buildImpactStatsRow(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      // 6. شريط التنقل السفلي المخصص (Bottom Navigation Bar)
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  // 1. شريط الترحيب العلوي
  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/user_avatar.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Row(
              children: [
                Text(
                  'Welcome Back, Sarah',
                  style: TextStyle(
                    color: Color(0xFF765A00),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                SizedBox(width: 4),
                Text('👋', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF765A00), size: 26),
          onPressed: () {},
        ),
      ],
    );
  }

  // 2. كرت الحملة الإعلانية الرئيسي
  Widget buildMainCampaignCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE2F0B9), Color(0xFFD2E794)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: Size.infinite.width * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Special Appeal',
                      style: TextStyle(color: Color(0xFF4A6438), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sponsor an\nOrphan Today',
                    style: TextStyle(
                      color: Color(0xFF384D2B),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Transform a life in State A with monthly support, education, and healthcare.',
                    style: TextStyle(color: Color(0xFF5D754C), fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A5A40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 0,
            top: 20,
            child: Image.asset(
              'assets/orphan_profile.jpg',
              fit: BoxFit.contain,
              width: 120,
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لتسهيل الانتقال وتمرير البيانات ديناميكياً للـ Category Screen
  void _navigateToCategory(BuildContext context, {required String title, required Color color}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupportCategoryScreen(
          categoryTitle: title,
          bannerColor: color,
          cases: _getDummyCasesFor(title),
        ),
      ),
    );
  }

  // 3. قسم مجالات الدعم (تم تعديل الكروت بالكامل لتصبح قابلة للضغط والتوجيه)
  Widget buildSupportAreasSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Support Areas',
              style: TextStyle(color: Color(0xFF2B2D42), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(color: Color(0xFF765A00), fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // الصف الأول: Small Projects & Education
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'Small Projects', color: const Color(0xFFF5EBE6)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('Small Projects', Icons.rocket_launch_outlined, const Color(0xFFF5EBE6)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'Education', color: const Color(0xFFFEF3D6)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('Education', Icons.school_outlined, const Color(0xFFFEF3D6)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // الصف الثاني: Health, Food & Residential
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'Health', color: const Color(0xFFEBF5EE)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('Health', Icons.local_hospital_outlined, const Color(0xFFEBF5EE)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'Food', color: const Color(0xFFF7F5DD)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('Food', Icons.restaurant_outlined, const Color(0xFFF7F5DD)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'Residential', color: const Color(0xFFEFEAE4)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('Residential', Icons.holiday_village_outlined, const Color(0xFFEFEAE4)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ويدجت بناء كرت المجال الفردي
  Widget buildSupportCard(String title, IconData icon, Color bgColor) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF3D523A), size: 24),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2B2D42),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // دالة توليد الحالات التجريبية لكل قسم يتم الضغط عليه
  List<DonationCase> _getDummyCasesFor(String category) {
    return [
      DonationCase(
        title: 'Support $category Campaign',
        description: 'Help us deliver essential support and complete urgent requirements for $category projects.',
        raised: '\$12,450',
        goal: '\$20,000',
        progress: 0.62,
        percentage: '62%',
        daysLeft: '12 Days left',
        imagePath: 'assets/images/sample.png', // غيري المسار حسب الصور المتوفرة لديكِ
        isUrgent: true,
      ),
      DonationCase(
        title: 'General Development for $category',
        description: 'Long-term sustainable funding targeting community needs in the $category sector.',
        raised: '\$4,200',
        goal: '\$15,000',
        progress: 0.28,
        percentage: '28%',
        daysLeft: '30 Days left',
        imagePath: 'assets/images/sample.png',
        isUrgent: false,
      ),
    ];
  }

  // 4. كرت المبادرات المجتمعية
  Widget buildCommunityCard() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/community_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          // cross Dynamic: CrossAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Community Initiatives',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Join hands with local leaders to build sustainable futures through collaborative giving.',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore Gateway',
                    style: TextStyle(color: Color(0xFFFFD56B), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, color: Color(0xFFFFD56B), size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 5. إحصائيات التأثير السفلي
  Widget buildImpactStatsRow() {
    return Row(
      children: [
        Expanded(child: buildStatBox('Total Impact', '\$1,240.00', const Color(0xFF3D523A))),
        const SizedBox(width: 16),
        Expanded(child: buildStatBox('Lives Touched', '12 Children', const Color(0xFF765A00))),
      ],
    );
  }

  Widget buildStatBox(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2EA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF8A817C), fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 6. شريط التنقل السفلي
  Widget buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFDFBF7),
        border: Border(top: BorderSide(color: Color(0xFFEFEAE4), width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF765A00),
        unselectedItemColor: const Color(0xFF8A817C),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5D166),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.home, color: Color(0xFF765A00)),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Sponsorship',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Impact',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}