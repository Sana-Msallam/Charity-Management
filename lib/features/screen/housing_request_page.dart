import 'package:flutter/material.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_field.dart';
import 'package:charity_management/features/components/selection_chip.dart';
// استيراد المكونات المشتركة الجديدة والموحدة للتطبيق
import 'package:charity_management/Beneficiary/components/custom_step_indicator.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';

class HousingRequestPage extends StatefulWidget {
  const HousingRequestPage({Key? key}) : super(key: key);

  @override
  State<HousingRequestPage> createState() => _HousingRequestPageState();
}

class _HousingRequestPageState extends State<HousingRequestPage> {
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _specsController = TextEditingController();

  String _selectedHousingStatus = 'إيجار';
  final List<String> _housingStatuses = ['ملك', 'إيجار', 'لا يوجد سكن'];

  @override
  void dispose() {
    _rentController.dispose();
    _addressController.dispose();
    _reasonController.dispose();
    _specsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background.withOpacity(0.8),
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward, color: AppColors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تفاصيل الطلب السكني',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 120.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📊 استخدام مؤشر الخطوات المشترك والموحد (Generic Step Indicator)
                const CustomStepIndicator(currentStep: 2, totalSteps: 2),
                const SizedBox(height: 24),

                const Text(
                  'الوضع الحالي للسكن',
                  style: TextStyle(color: AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // 🔘 خيارات الراديو (Chips)
                Wrap(
                  spacing: 12.0,
                  children: _housingStatuses.map((status) {
                    return SelectionChip(
                      label: status,
                      isSelected: _selectedHousingStatus == status,
                      onTap: () => setState(() => _selectedHousingStatus = status),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // 💰 حقل قيمة الإيجار (يظهر بشكل ديناميكي إذا كان السكن إيجار)
                if (_selectedHousingStatus == 'إيجار') ...[
                  CustomTextField(
                    label: 'قيمة الإيجار الحالي (إن وجد)',
                    hint: 'مثلاً: 1500',
                    controller: _rentController,
                    keyboardType: TextInputType.number,
                    suffixIcon: Icons.monetization_on_outlined, 
                  ),
                  const SizedBox(height: 24),
                ],

                // 📍 مكان الإقامة الحالي
                CustomTextField(
                  label: 'مكان الإقامة الحالي بالتفصيل',
                  hint: 'المدينة، الحي، اسم الشارع',
                  controller: _addressController,
                ),
                const SizedBox(height: 24),

                // 📝 سبب طلب الدعم
                CustomTextField(
                  label: 'سبب عدم وجود مأوى أو سبب طلب الدعم',
                  hint: 'يرجى كتابة شرح مفصل للحالة...',
                  controller: _reasonController,
                  maxLines: 4,
                ),
                const SizedBox(height: 24),

                // 🏠 مواصفات السكن
                CustomTextField(
                  label: 'مواصفات السكن المطلوب أو الحالي',
                  hint: 'عدد الغرف، الدور، الخدمات القريبة',
                  controller: _specsController,
                ),
                const SizedBox(height: 24),

                // 📂 استخدام مكون رفع الملفات المشترك والموحد (Generic Attachment Uploader)
                CustomAttachmentUploader(
                  title: 'إرفاق وثائق ثبوتية',
                  description: 'عقد إيجار، صور السكن الحالي، أو أي وثائق تدعم الطلب (JPG, PDF)',
                  icon: Icons.upload_file_rounded, 
                  onTap: () => print('رفع وثائق السكن'),
                ),
                const SizedBox(height: 28),

                // 🎨 بطاقة الصورة التوضيحية الجمالية (Illustration Section)
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Stack(
                      children: [
                        Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuB9FKQYSFEy-rg1OTqxswg8HiVH-xF02EPjCo68VtxKb5SNiOYrhxW3EJIIkOJIE-QfFs3kayaCDqXi3TR9xD8XK71W7XwrCzPg0qBXRoDOQDHNt-NKtkGBZ2SbFeRwPHVoHjdzG0t3AWI4rxJfini5tQLEGK3ql8j4JV_huYHiRfVXWVFXn-J2Xt0oqtYIZQiLxsxT_IgWM0Xz8VjW_mqp7UHSycIhblM74tSnn0bLMLbuv4cZQg6BD9iLgMq985xh3jz0etOwyqI',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 16,
                          right: 16,
                          left: 16,
                          child: Text(
                            '"نسعى لتوفير بيئة آمنة وكريمة لكل أسرة"',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomActionBar(),
      ),
    );
  }

  // 🏁 الزر السفلي العريض لإرسال الطلب
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          print('إرسال الطلب السكني للمراجعة');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'إرسال الطلب للمراجعة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            SizedBox(width: 8),
            Icon(Icons.send, size: 18, color: AppColors.onSurface),
          ],
        ),
      ),
    );
  }
}