import 'package:flutter/material.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';

// استيراد المكونات الموحدة والمخصصة
import 'package:charity_management/widgets/beneficiaries_counter.dart';
import 'package:charity_management/widgets/custom_text_field.dart';
import 'package:charity_management/features/components/selection_chip.dart'; // 👇 تم استدعاء الـ Chip المخصص هنا
import '../../../../components/education_components.dart';

class EducationRequestPage extends StatefulWidget {
  const EducationRequestPage({Key? key}) : super(key: key);

  @override
  State<EducationRequestPage> createState() => _EducationRequestPageState();
}

class _EducationRequestPageState extends State<EducationRequestPage> {
  // تعريف الـ Controllers لإدارة نصوص المدخلات
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  String _selectedEduLevel = 'مدرسي';
  String? _selectedGrade;
  int _beneficiariesCount = 1;
  
  // الاحتفاظ بالأنواع المختارة داخل لستة
  final List<String> _selectedAssistanceTypes = ['ثياب مدرسية'];
  final List<String> _assistanceTypes = ['ثياب مدرسية', 'مستلزمات دراسية', 'أقساط جامعة', 'أخرى'];
  
  final List<String> _gradeOptions = [
    'المرحلة الابتدائية', 
    'المرحلة المتوسطة', 
    'المرحلة الثانوية', 
    'سنة أولى جامعي', 
    'سنة ثانية جامعي'
  ];

  @override
  void dispose() {
    // تنظيف الـ Controllers عند إغلاق الشاشة لمنع تسريب الذاكرة
    _institutionController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
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
            icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تفاصيل الطلب التعليمي',
            style: TextStyle(
              color: AppColors.primary, 
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              fontFamily: AppTextStyles.fontFamily
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // قسم التحصيل الدراسي (استبدال بالـ SelectionChip المخصص الموحد)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
                  child: const Text(
                    'التحصيل الدراسي',
                    style: TextStyle(color: AppColors.brandGray, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SelectionChip(
                        label: 'مدرسي',
                        isSelected: _selectedEduLevel == 'مدرسي',
                        onTap: () => setState(() => _selectedEduLevel = 'مدرسي'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SelectionChip(
                        label: 'جامعي',
                        isSelected: _selectedEduLevel == 'جامعي',
                        onTap: () => setState(() => _selectedEduLevel = 'جامعي'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // تطبيق الـ CustomTextField لحقل اسم المنشأة التعليمية
                CustomTextField(
                  label: 'اسم المدرسة / الجامعة',
                  hint: 'أدخل الاسم هنا...',
                  controller: _institutionController,
                ),
                const SizedBox(height: 24),

                // قسم القائمة المنسدلة للمرحلة الدراسية
                Padding(
                  padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
                  child: const Text(
                    'الصف / السنة الدراسية',
                    style: TextStyle(color: AppColors.brandGray, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                _buildDropdownField(),
                const SizedBox(height: 24),

                // قسم كبسولات الاختيار لنوع المساعدة (استبدال بالـ SelectionChip المخصص الموحد)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
                  child: const Text(
                    'نوع المساعدة المطلوبة',
                    style: TextStyle(color: AppColors.brandGray, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _assistanceTypes.map((type) {
                    final bool isSelected = _selectedAssistanceTypes.contains(type);
                    return SelectionChip(
                      label: type,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedAssistanceTypes.remove(type);
                          } else {
                            _selectedAssistanceTypes.add(type);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // العداد التفاعلي لعدد الأفراد
                BeneficiariesCounter(
                  count: _beneficiariesCount,
                  onIncrement: () => setState(() => _beneficiariesCount++),
                  onDecrement: () {
                    if (_beneficiariesCount > 1) {
                      setState(() => _beneficiariesCount--);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // تطبيق الـ CustomTextField لحقل وصف الحالة (متعدد الأسطر)
                CustomTextField(
                  label: 'وصف الحالة بالتفصيل',
                  hint: 'اشرح لنا حاجتك التعليمية لتقديم أفضل دعم ممكن...',
                  controller: _descriptionController,
                  maxLines: 4,
                ),
                const SizedBox(height: 24),

                // تطبيق الـ CustomTextField كحقل عملة مالي (مع لاصقة ريال التلقائية)
                CustomTextField(
                  label: 'التكلفة الإجمالية المتوقعة',
                  hint: '0.00',
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  isCurrency: true,
                ),
                const SizedBox(height: 32),

                const EducationalDecorativeCard(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomSubmitButton(),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12.0), 
        border: Border.all(color: AppColors.brandGray.withOpacity(0.1))
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGrade,
          hint: Text('اختر المرحلة...', style: TextStyle(color: AppColors.brandGray.withOpacity(0.5), fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.brandGray),
          items: _gradeOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value, 
              child: Text(value, style: const TextStyle(color: AppColors.onSurface, fontSize: 14))
            );
          }).toList(),
          onChanged: (newValue) => setState(() => _selectedGrade = newValue),
        ),
      ),
    );
  }

  Widget _buildBottomSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: ElevatedButton(
        onPressed: () {
          // جمع البيانات وطباعتها عند الإرسال
          print('التحصيل الدراسي: $_selectedEduLevel');
          print('اسم المنشأة: ${_institutionController.text}');
          print('المرحلة الدراسية: $_selectedGrade');
          print('أنواع المساعدة المحددة: $_selectedAssistanceTypes');
          print('عدد الأفراد: $_beneficiariesCount');
          print('الوصف: ${_descriptionController.text}');
          print('التكلفة المتوقعة: ${_costController.text}');
          
          // هنا يمكنك إضافة منطق الـ API الخاص بـ إرسال الطلب (POST request)
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('إرسال الطلب للمراجعة', style: TextStyle(fontSize: 16, color: Color(0xFF2C2A29),
            fontWeight: FontWeight.bold)),
            SizedBox(width: 12),
            Icon(Icons.send, size: 18,color: Color(0xFF2C2A29),)
          ],
        ),
      ),
    );
  }
}