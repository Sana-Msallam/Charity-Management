import 'package:charity_management/features/components/about_section_card.dart';
import 'package:charity_management/features/components/completed_projects_section.dart';
import 'package:charity_management/features/components/large_category_card.dart';
import 'package:charity_management/features/components/small_category_card.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_navigation_bar.dart';
import '../Beneficiary/Help_request/applicantInfo/screen/applicant_info_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // 👇 تعديل الدالة لتستقبل الـ requestType وتمرره لصفحة معلومات مقدم الطلب
  void _navigateToApplicantInfo(BuildContext context, String requestType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicantInfoPage(requestType: requestType),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(), 
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. كارت نبذة عن الجمعية
                const AboutSectionCard(),
                const SizedBox(height: 32.0),
                
                // 2. العنوان الرئيسي الثابت
                const Text(
                  'تقديم طلب مساعدة جديد', 
                  style: TextStyle(color: AppColors.onSurface, fontSize: 28, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 24.0),
                
                // 3. شبكة فئات الطلبات
                _buildCategoriesGrid(context),
                const SizedBox(height: 32.0),
                
                // 4. قسم المشاريع المنجزة المعزول
                const CompletedProjectsSection(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigation(),
      ),
    );
  }

  // دالة بناء شبكة الكروت وتمرير نوع الطلب عند الضغط (onTap)
  Widget _buildCategoriesGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SmallCategoryCard(
                title: 'طلب صحي',
                subtitle: 'علاج وأدوية',
                icon: Icons.medical_services_outlined,
                color: AppColors.error,
                onTap: () => _navigateToApplicantInfo(context, 'صحي'), // 👈 تمرير النوع
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SmallCategoryCard(
                title: 'طلب غذائي',
                subtitle: 'سلال غذائية',
                icon: Icons.shopping_basket_outlined,
                color: AppColors.secondary,
                onTap: () => _navigateToApplicantInfo(context, 'غذائي'), // 👈 تمرير النوع
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // الكارت الكبير (غالباً مخصص للطلب السكني)
        LargeCategoryCard(
          onTap: () => _navigateToApplicantInfo(context, 'سكني'), // 👈 تمرير النوع
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: SmallCategoryCard(
                title: 'طلب تعليمي',
                subtitle: 'رسوم وكتب',
                icon: Icons.auto_stories_outlined,
                color: AppColors.primary,
                onTap: () => _navigateToApplicantInfo(context, 'تعليمي'), // 👈 هنا سيفتح واجهة التعليم لاحقاً
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToApplicantInfo(context, 'دعم مشاريع'), // 👈 تمرير النوع للبطاقة اليدوية
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(Icons.trending_up, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'دعم المشاريع', 
                        style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w500)
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تمويل وتطوير', 
                        style: TextStyle(color: AppColors.primary.withOpacity(0.8), fontSize: 12)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}