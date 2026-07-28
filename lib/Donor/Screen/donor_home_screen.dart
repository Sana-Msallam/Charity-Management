import 'package:charity_management/Donor/Drawer/app_drawer.dart';
import 'package:charity_management/Donor/Screen/Support_Area/support_category_screen.dart';
import 'package:charity_management/Donor/cubit/aid_request_cubit.dart';
import 'package:charity_management/Sponsership/Screen/sponsership_main_screen.dart';
import 'package:charity_management/Sponsership/Screen/sponsorships_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonorHomeScreen extends StatelessWidget {
  DonorHomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // تغليف الواجهة بـ Directionality لجعل الاتجاه من اليمين إلى اليسار (RTL)
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
         key: scaffoldKey,
        // لون Background المعتمد في التصميم
        backgroundColor: const Color(0xFFFDFBF7),
        drawer: const AppDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // ستبدأ تلقائياً من اليمين
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
        bottomNavigationBar: buildBottomNavigationBar(context),
      ),
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
                  'مرحباً بعودتك، سارة',
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
          begin: Alignment.topRight, // تم التعديل ليناسب الـ RTL
          end: Alignment.bottomLeft,
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
                      'نداء خاص',
                      style: TextStyle(color: Color(0xFF4A6438), fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'IBM Plex Sans Arabic'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'اكفل يتيماً\nاليوم',
                    style: TextStyle(
                      color: Color(0xFF384D2B),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'غيّر حياة طفل في الولاية (أ) بدعم شهري، وتعليم، ورعاية صحية.',
                    style: TextStyle(color: Color(0xFF5D754C), fontSize: 12, height: 1.4, fontFamily: 'IBM Plex Sans Arabic'),
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
                      'لمعرفة المزيد',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16, // تم تغييرها من right إلى left لتصبح الصورة في اليسار والنصوص في اليمين
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

void _navigateToCategory(
 BuildContext context,
 {required String title, required Color color}
) {

final id = _getCategoryId(title);

Navigator.push(
 context,
 MaterialPageRoute(
  builder: (_) => BlocProvider(
    create: (_) => AidRequestCubit()
      ..fetchAidRequests(categoryId: id),

    child: SupportCategoryScreen(
      categoryTitle: title,
      bannerColor: color,
      categoryId: id,
    ),
  ),
 ),
);

}
  // 3. قسم مجالات الدعم
  Widget buildSupportAreasSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'مجالات الدعم',
              style: TextStyle(color: Color(0xFF2B2D42), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(color: Color(0xFF765A00), fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'IBM Plex Sans Arabic'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'المشاريع الصغيرة', color: const Color(0xFFF5EBE6)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('المشاريع الصغيرة', Icons.rocket_launch_outlined, const Color(0xFFF5EBE6)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'التعليم', color: const Color(0xFFFEF3D6)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('التعليم', Icons.school_outlined, const Color(0xFFFEF3D6)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'الصحة', color: const Color(0xFFEBF5EE)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('الصحة', Icons.local_hospital_outlined, const Color(0xFFEBF5EE)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'الغذاء', color: const Color(0xFFF7F5DD)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('الغذاء', Icons.restaurant_outlined, const Color(0xFFF7F5DD)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToCategory(context, title: 'السكن', color: const Color(0xFFEFEAE4)),
                borderRadius: BorderRadius.circular(16),
                child: buildSupportCard('السكن', Icons.holiday_village_outlined, const Color(0xFFEFEAE4)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSupportCard(String title, IconData icon, Color bgColor) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
   decoration: BoxDecoration(
  color: bgColor,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ],
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
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ],
      ),
    );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'المبادرات المجتمعية',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
            ),
            const SizedBox(height: 4),
            Text(
              'تكاتف مع القادة المحليين لبناء مستقبل مستدام من خلال العطاء التعاوني.',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, height: 1.4, fontFamily: 'IBM Plex Sans Arabic'),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'استكشف البوابة',
                    style: TextStyle(color: Color(0xFFFFD56B), fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
                  ),
                  const SizedBox(width: 6),
                  // قلب السهم ليناسب اتجاه الـ RTL العربي
                  Transform.flip(
                    flipX: true,
                    child: const Icon(Icons.arrow_forward, color: Color(0xFFFFD56B), size: 16),
                  ),
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
        Expanded(child: buildStatBox('إجمالي التأثير', '\$1,240.00', const Color(0xFF3D523A))),
        const SizedBox(width: 16),
        Expanded(child: buildStatBox('الأرواح المؤثرة', '12 طفل', const Color(0xFF765A00))),
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
            style: const TextStyle(color: Color(0xFF8A817C), fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'IBM Plex Sans Arabic'),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic'),
          ),
        ],
      ),
    );
  }

  // 6. شريط التنقل السفلي المخصص
  Widget buildBottomNavigationBar(BuildContext context) { 
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
        currentIndex: 2,
  onTap: (index) {
  if (index == 0) {
    scaffoldKey.currentState?.openDrawer();
  }

  if (index == 4) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SponsorshipMainScreen(),
      ),
    );
  }
},

       items: [
  const BottomNavigationBarItem(
    icon: Icon(Icons.menu),
    label: 'القائمة',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.analytics_outlined),
    label: 'التأثير',
  ),
  BottomNavigationBarItem(
    icon: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5D166),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.home,
        color: Color(0xFF765A00),
      ),
    ),
    label: 'الرئيسية',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.account_balance_wallet_outlined),
    label: 'المحفظة',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.favorite_border),
    label: 'الكفالات',
  ),
],
      ),
    );
  }
}int _getCategoryId(String title){

  switch(title){

    case 'المشاريع الصغيرة':
      return 1;

    case 'التعليم':
      return 2;

    case 'الصحة':
      return 3;

    case 'الغذاء':
      return 4;

    case 'السكن':
      return 5;

    default:
      return 1;
  }

}