import 'package:charity_management/Sponsership/Screen/sponsership_request.dart';
import 'package:flutter/material.dart';
// تأكدي من تعديل مسارات الاستيراد (imports) أدناه لتتوافق مع أسماء الملفات وبنية المجلدات في مشروعكِ
import 'package:charity_management/Sponsership/Screen/sponsorships_screen.dart'; 
// import 'package:charity_management/Donor/sponsorship_request_screen.dart'; 

class SponsorshipMainScreen extends StatelessWidget {
  const SponsorshipMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFBF7),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF765A00)),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'الكفالات',
            style: TextStyle(
              color: Color(0xFF765A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF765A00)),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. كرت رصيد المحفظة الحالي
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D523A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, color: Color(0xFFF5D166), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'رصيد المحفظة الحالي',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '\$450.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5D166),
                            foregroundColor: const Color(0xFF765A00),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, size: 18),
                              SizedBox(width: 6),
                              Text('شحن المحفظة', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'IBM Plex Sans Arabic')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. زر كفالاتي الرئيسي (تم تفعيل حدث الضغط والانتقال إلى صفحة الكفالات هنا 👇)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SponsorshipsScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF765A00),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.favorite, color: Colors.white, size: 32),
                        SizedBox(height: 8),
                        Text(
                          'كفالاتي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                        ),
                        Text(
                          'إدارة الأيتام المكفولين حالياً',
                          style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'IBM Plex Sans Arabic'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. زر إضافة كفالة جديدة (ينتقل إلى صفحة طلب الكفالة والشروط)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SponsorshipRequestScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F2EA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEFEAE4)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add_alt_1_outlined, color: Color(0xFF3D523A)),
                        SizedBox(width: 8),
                        Text(
                          'إضافة كفالة جديدة',
                          style: TextStyle(
                            color: Color(0xFF3D523A),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}