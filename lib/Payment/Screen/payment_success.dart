import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF765A00)),
            onPressed: () {
              // العودة للشاشة الرئيسية وإغلاق شاشات الدفع بالكامل
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          title: const Text(
            'السلة الخيرية',
            style: TextStyle(
              color: Color(0xFF765A00),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Color(0xFF765A00)),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // أيقونة النجاح الخضراء المستديرة
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEBF5EE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF3D523A),
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'تمت عملية الدفع بنجاح!',
                          style: TextStyle(
                            color: Color(0xFF2B2D42),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                          // textAlign: Center,
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          'شكراً لعطائك، يمكنك تتبع أثر تبرعك الآن من خلال سجل التبرعات.',
                          style: TextStyle(
                            color: Color(0xFF8A817C),
                            fontSize: 13,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // كرت الإيصال الصغير المخطط من الجانب بالأصفر ليتناسب مع الهوية البصرية
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDFBF7),
                            borderRadius: BorderRadius.circular(16),
                            border: const Border(
                              right: BorderSide(
                                color: Color(0xFFF5D166),
                                width: 5,
                              ), // الخط الجانبي الأصفر المتميز
                              left: BorderSide(color: Color(0xFFEFEAE4)),
                              top: BorderSide(color: Color(0xFFEFEAE4)),
                              bottom: BorderSide(color: Color(0xFFEFEAE4)),
                            ),
                          ),
                          child: Column(
                            children: [
                              buildReceiptRow('رقم العملية', '#NZ-82749'),
                              const Divider(
                                height: 20,
                                color: Color(0xFFEFEAE4),
                              ),
                              buildReceiptRow(
                                'المبلغ المدفوع',
                                '500 ر.س',
                                isBoldValue: true,
                              ),
                              const Divider(
                                height: 20,
                                color: Color(0xFFEFEAE4),
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.verified_outlined,
                                    color: Color(0xFF3D523A),
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'تأكيد المساهمة في مشاريع الإطعام',
                                    style: TextStyle(
                                      color: Color(0xFF3D523A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // أزرار التحكم والخيارات المتاحة بعد إتمام العملية
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // توجيه المستخدم لصفحة تبرعاتي
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5D166),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'الذهاب لتبرعاتي',
                              style: TextStyle(
                                color: Color(0xFF765A00),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              // منطق تحميل الفاتورة أو الـ PDF هنا
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFEFEAE4)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'تحميل الإيصال',
                              style: TextStyle(
                                color: Color(0xFF765A00),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // قسم وجوه المتبرعين السفلي الداعم للمصداقية والأثر الاجتماعي
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'أنت والآن +5,240 متبرعاً تساهمون في هذا المشروع',
                      style: TextStyle(color: Color(0xFF8A817C), fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    // تمثيل مبسط للأفاتار المتداخلة للمشتركين
                    SizedBox(
                      width: 50,
                      height: 24,
                      child: Stack(
                        children: [
                          Positioned(right: 0, child: buildMiniAvatar()),
                          Positioned(right: 12, child: buildMiniAvatar()),
                          Positioned(right: 24, child: buildMiniAvatar()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReceiptRow(
    String label,
    String value, {
    bool isBoldValue = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8A817C), fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF2B2D42),
            fontSize: isBoldValue ? 16 : 13,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildMiniAvatar() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        color: Colors.grey.shade300,
      ),
      child: const Icon(Icons.person, size: 12, color: Colors.white),
    );
  }
}
