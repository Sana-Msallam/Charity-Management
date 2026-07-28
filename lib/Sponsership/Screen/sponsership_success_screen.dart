import 'package:flutter/material.dart';

class SponsorshipSuccessScreen extends StatelessWidget {
  const SponsorshipSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7), // لون الخلفية المعتمد
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // 1. أيقونة النجاح المتحركة أو الثابتة بتصميم أنيق
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F2EA), // اللون البيج الناعم كخلفية للأيقونة
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined, // أيقونة تعبر عن إرسال الطلب بنجاح
                    color: Color(0xFF3D523A), // اللون الأخضر الداكن للهوية
                    size: 48,
                  ),
                ),
                const SizedBox(height: 32),

                // 2. جملة الشكر والتقدير
                const Text(
                  'جزاك الله خيراً وغفر لك',
                  style: TextStyle(
                    color: Color(0xFF765A00), // اللون الذهبي العريق للعنوان رئيسي
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                const SizedBox(height: 12),

                // 3. نص حالة الطلب والتنبيه بالإشعار
                const Text(
                  'تم استلام طلب الكفالة الخاص بك بنجاح، ويتم الآن مراجعته وتدقيقه من قِبل القسم المختص.\n\nسيرسل لك التطبيق إشعاراً فور قبول الطلب واعتماده لتتمكن من متابعة حالة اليتيم.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2B2D42), // لون النص الداكن المريح للعين
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                
                const Spacer(),

                // 4. زر العودة للرئيسية
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D523A), // اللون الأخضر الداكن للأزرار الأساسية
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // العودة إلى الشاشة الرئيسية للتطبيق وإغلاق شاشات الطلب المتراكمة
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      'العودة للرئيسية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}