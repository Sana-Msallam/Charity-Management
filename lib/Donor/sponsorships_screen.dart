import 'package:flutter/material.dart';

// هيكل بيانات تجريبي للأطفال المكفولين لسهولة العرض والتحكم
class SponsoredChild {
  final String name;
  final String grade;
  final String status;
  final String imagePath;

  SponsoredChild({
    required this.name,
    required this.grade,
    required this.status,
    required this.imagePath,
  });
}

class SponsorshipsScreen extends StatelessWidget {
  const SponsorshipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // قائمة البيانات بناءً على الصورة المرفقة image_626a17.png
    final List<SponsoredChild> children = [
      SponsoredChild(
        name: 'أحمد محمد',
        grade: 'الصف الرابع الابتدائي',
        status: 'نشط',
        imagePath: 'assets/images/orphan_profile.jpg', // تأكدي من تطابق مسارات الصور لديكِ
      ),
      SponsoredChild(
        name: 'سارة علي',
        grade: 'الصف الثاني الابتدائي',
        status: 'نشط',
        imagePath: 'assets/images/orphan_profile.jpg', 
      ),
      SponsoredChild(
        name: 'ياسين خالد',
        grade: 'الصف السادس الابتدائي',
        status: 'نشط',
        imagePath: 'assets/images/orphan_profile.jpg',
      ),
    ];

    // الألوان الرئيسية المعتمدة في التصميم
    const Color primaryYellow = Color(0xFFD4AF37); // اللون الأصفر الثري للهوية
    const Color lightCardBg = Color(0xFFFDF8EB);   // خلفية كرت النظرة العامة
    const Color textDark = Color(0xFF1A2E40);      // لون النصوص الداكنة

    return Directionality(
      textDirection: TextDirection.rtl, // لضبط الواجهة باللغة العربية بالكامل
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // خلفية الصفحة المائلة للبياض النقي
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/orphan_profile.jpg'), // صورة بروفايل المستخدم
            ),
          ),
          title: const Text(
            'Noor Giving',
            style: TextStyle(
              color: primaryYellow,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: textDark),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. كرت النظرة العامة (كفالاتي الحالية)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: lightCardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نظرة عامة',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'كفالاتي الحالية',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'عدد الأطفال المكفولين حالياً',
                          style: TextStyle(color: textDark, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryYellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${children.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. عنوان قائمة المكفولين مع أيقونة التصفية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'قائمة المكفولين',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey), // أيقونة الفلترة والتصفية الجانبية
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 3. قائمة كروت الأطفال المكفولين
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: children.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final child = children[index];
                  return InkWell(
                    onTap: () {
                      // الانتقال إلى صفحة تفاصيل اليتيم عند الضغط على الكرت
                      /* 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrphanDetailsScreen(),
                        ),
                      );
                      */
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // أيقونة السهم الأيمن للانتقال للتفاصيل
                          const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.grey),
                          const Spacer(),
                          // تفاصيل الطفل (الاسم والصف والحالة)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                child.name,
                                style: const TextStyle(
                                  color: textDark,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                child.grade,
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F7FA), // لون خلفية شارة "نشط" الفيروزية
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  child.status,
                                  style: const TextStyle(
                                    color: Color(0xFF00ACC1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // صورة الطفل المكفول الدائرية أو المربعة بزوايا ناعمة
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              child.imagePath,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // في حال لم يتم العثور على المسار بعد، يتم إظهار عنصر بديل مؤقت
                                return Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.person, color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 4. بنر "أثر عطاؤك" السفلي
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/orphan_profile.jpg'), // استبدليها بصورة الأيدي الملونة لاحقاً
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أثر عطاؤك',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'تم توفير وجبات تعليمية هذا الشهر بفضل عطائك',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
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
    );
  }
}