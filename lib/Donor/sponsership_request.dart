import 'package:charity_management/Donor/sponsership_success_screen.dart';
import 'package:flutter/material.dart';

class SponsorshipRequestScreen extends StatelessWidget {
  const SponsorshipRequestScreen({super.key});

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
            'طلب كفالة جديدة',
            style: TextStyle(
              color: Color(0xFF765A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. بنر الإعلان الرئيسي لتقديم الطلب
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/sponsorship_banner.jpg',
                      ), // مسار تعبيري لخلفية البنر
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.bottomRight,
                    child: const Text(
                      'ساهم في تغيير حياة طفل',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. كرت موثوقية تامة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEFEAE4)),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: Color(0xFF765A00),
                        size: 28,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'موثوقية تامة',
                        style: TextStyle(
                          color: Color(0xFF2B2D42),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'جميع البيانات والمعلومات يتم التعامل معها بأعلى معايير الخصوصية والأمان وفق الضوابط الشرعية.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8A817C),
                          fontSize: 12,
                          height: 1.4,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. قسم شروط وأحكام الكفالة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEFEAE4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.gavel_outlined,
                            color: Color(0xFF765A00),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'شروط وأحكام الكفالة',
                            style: TextStyle(
                              color: Color(0xFF765A00),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      buildConditionRow(
                        'يجب أن يتوفر في المحفظة رصيد يغطي 4 أشهر من الكفالة مسبقاً، على أن يتم استقطاع رصيد الكفالة شهرياً بشكل تلقائي.',
                      ),
                      buildConditionRow(
                        'بمجرد تخصيص رصيد الكفالة سلفاً لمصاريف كفالة اليتيم المحددة، لا يجوز استخدامه في أغراض أخرى.',
                      ),
                      buildConditionRow(
                        'تلغى الكفالة تلقائياً في حال انخفاض الرصيد عن قيمة شهرين دون تعويض المبلّغ المعني.',
                      ),
                      buildConditionRow(
                        'تتم عملية اختيار اليتيم من قبل الإدارة بناءً على قوائم الاحتياج والأولوية لضمان العدالة وتغطية الحالات الأكثر تضرراً.',
                      ),
                      buildConditionRow(
                        'تتاح ملفات اليتيم والتقارير الدورية بالكامل فقط عبر لوحة التحكم الخاصة بالحساب بعد اعتماد الطلب بنجاح.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 4. زر تأكيد وقبول الشروط السفلي
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D523A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                   onPressed: () {
  // الانتقال لواجهة تم تقديم الطلب بنجاح
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SponsorshipSuccessScreen(),
    ),
  );
},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تأكيد وقبول الشروط',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.assignment_turned_in_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. قسم فضل كفالة الأيتام مع الحديث النبوي
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F2EA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'ـ فضل كفالة الأيتام ـ',
                        style: TextStyle(
                          color: Color(0xFF765A00),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'عن سهل بن سعد رضي الله عنه قال: قال رسول الله صلى الله عليه وسلم: "أَنَا وَكَافِلُ الْيَتِيمِ فِي الْجَنَّةِ هَكَذَا" وَأَشَارَ بِالسَّبَّابَةِ وَالْوُسْطَى، وَفَرَّجَ بَيْنَهُمَا شَيْئًا.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3D523A),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ـ رواه البخاري',
                        style: TextStyle(
                          color: const Color(0xFF3D523A).withOpacity(0.6),
                          fontSize: 11,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // الدالة المحدثة تستقبل الآن String بشكل مباشر وتضعه داخل ويدجت الـ Text
  Widget buildConditionRow(String conditionText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF3D523A), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              conditionText, // هنا نمرر النص مباشرة
              style: const TextStyle(
                color: Color(0xFF2B2D42),
                fontSize: 12,
                height: 1.5,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
