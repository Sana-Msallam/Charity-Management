import 'package:charity_management/Payment/Screen/payment_success.dart';
import 'package:flutter/material.dart';
// import 'payment_success_screen.dart'; // تأكدي من تعديل المسار حسب مشروعك

class CheckoutScreen extends StatefulWidget {
  final String currentCaseName; // اسم الحالة التي ضغطنا منها "تبرع الآن"

  const CheckoutScreen({super.key, required this.currentCaseName});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? selectedDonationType;
  int paymentMethod = 1; // 1 للبطاقة المصرفية، 2 لمحفظة التطبيق

  @override
  void initState() {
    super.initState();
    // جعل الخيار الافتراضي هو الحالة الحالية
    selectedDonationType = widget.currentCaseName;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context), // يتبع لغة التطبيق الحالية
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF765A00)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'إتمام عملية التبرع',
            style: TextStyle(
              color: Color(0xFF765A00),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'IBM Plex Sans Arabic',
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // كرت معلومات التبرع (نوع التبرع والمبلغ)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF765A00)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'نوع التبرع:',
                                  style: TextStyle(
                                    color: Color(0xFF8A817C),
                                    fontSize: 14,
                                  ),
                                ),
                                // القائمة المنسدلة المطلوبة
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedDonationType,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF765A00),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF2B2D42),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'IBM Plex Sans Arabic',
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDonationType = newValue;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: widget.currentCaseName,
                                        child: Text(widget.currentCaseName),
                                      ),
                                      const DropdownMenuItem(
                                        value: 'سلة الخير',
                                        child: Text('سلة الخير'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24, color: Color(0xFFEFEAE4)),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'إجمالي المبلغ:',
                                  style: TextStyle(
                                    color: Color(0xFF8A817C),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '400 ر.س',
                                  style: TextStyle(
                                    color: Color(0xFF765A00),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'طريقة الدفع',
                        style: TextStyle(
                          color: Color(0xFF2B2D42),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // خيار البطاقة المصرفية
                      buildPaymentMethodTile(
                        value: 1,
                        title: 'البطاقة المصرفية',
                        subtitle: 'دفع آمن عبر Visa أو Mastercard',
                        icon: Icons.credit_card,
                      ),
                      const SizedBox(height: 12),

                      // خيار محفظة التطبيق
                      buildPaymentMethodTile(
                        value: 2,
                        title: 'محفظة التطبيق',
                        subtitle: 'الرصيد المتوفر: 500 ر.س',
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                      const SizedBox(height: 24),

                      // قسم بيانات البطاقة (يظهر فقط إذا تم اختيار البطاقة المصرفية)
                      if (paymentMethod == 1) ...[
                        const Text(
                          'بيانات البطاقة',
                          style: TextStyle(
                            color: Color(0xFF2B2D42),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEFEAE4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextField(
                                label: 'اسم حامل البطاقة',
                                hint: 'الاسم كما هو مكتوب على البطاقة',
                              ),
                              const SizedBox(height: 16),
                              buildTextField(
                                label: 'رقم البطاقة',
                                hint: '0000 0000 0000 0000',
                                icon: Icons.credit_card,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildTextField(
                                      label: 'تاريخ الانتهاء',
                                      hint: 'MM/YY',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: buildTextField(
                                      label: 'الرمز السري (CVV)',
                                      hint: '***',
                                      icon: Icons.help_outline,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // إشعار الأمان المشفر
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F5DD),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF765A00),
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'تتم معالجة بياناتك بشكل مشفر وآمن بالكامل (PCI DSS)',
                                        style: TextStyle(
                                          color: Color(0xFF765A00),
                                          fontSize: 11,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // صورة أشجار الزيتون السفلية لإعطاء الطابع الروحاني الجميل للتطبيق
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/orphan_profile.jpg',
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(), // تتفادى الخطأ إذا لم تكن الصورة جاهزة
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // زر تأكيد الدفع السفلي الثابت
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      // عند النجاح، نتوجه لواجهة نجاح عملية الدفع
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentSuccessScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFF5D166,
                      ), // اللون الأصفر المعتمد للهوية
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF765A00),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'تأكيد الدفع الآمن بقيمة 400 ر.س',
                          style: TextStyle(
                            color: Color(0xFF765A00),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodTile({
    required int value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = paymentMethod == value;
    return InkWell(
      onTap: () => setState(() => paymentMethod = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF5D166)
                : const Color(0xFFEFEAE4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF765A00), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF2B2D42),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF8A817C),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Radio<int>(
              value: value,
              groupValue: paymentMethod,
              activeColor: const Color(0xFF765A00),
              onChanged: (int? newValue) {
                setState(() => paymentMethod = newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A817C),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFC2B9B0), fontSize: 13),
            prefixIcon: icon != null
                ? Icon(icon, color: const Color(0xFFC2B9B0), size: 20)
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEFEAE4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFF5D166),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
