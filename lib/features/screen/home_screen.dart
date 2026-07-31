import 'package:charity_management/features/components/about_section_card.dart';
import 'package:charity_management/features/components/completed_projects_section.dart';
import 'package:charity_management/features/components/large_category_card.dart';
import 'package:charity_management/features/components/small_category_card.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/routes/app_routes.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/widgets/custom_app_bar.dart';
import 'package:charity_management/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToApplicantInfo(BuildContext context, String requestType) {
    Navigator.pushNamed(
      context,
      AppRoutes.applicantInfo,
      arguments: ApplicantInfoRouteArguments(requestType: requestType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AboutSectionCard(),
              const SizedBox(height: 32.0),
              Text(
                l10n.newAidRequest,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              _buildCategoriesGrid(context),
              const SizedBox(height: 32.0),
              const CompletedProjectsSection(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SmallCategoryCard(
                title: l10n.healthRequest,
                subtitle: l10n.healthRequestSubtitle,
                icon: Icons.medical_services_outlined,
                color: AppColors.error,
                onTap: () => _navigateToApplicantInfo(context, 'صحي'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SmallCategoryCard(
                title: l10n.foodRequest,
                subtitle: l10n.foodRequestSubtitle,
                icon: Icons.shopping_basket_outlined,
                color: AppColors.secondary,
                onTap: () => _navigateToApplicantInfo(context, 'غذائي'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LargeCategoryCard(
          onTap: () => _navigateToApplicantInfo(context, 'سكني'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SmallCategoryCard(
                title: l10n.educationRequest,
                subtitle: l10n.educationRequestSubtitle,
                icon: Icons.auto_stories_outlined,
                color: AppColors.primary,
                onTap: () => _navigateToApplicantInfo(context, 'تعليمي'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _navigateToApplicantInfo(context, 'دعم مشاريع'),
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
                        child: const Icon(
                          Icons.trending_up,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.projectSupport,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.projectSupportSubtitle,
                        style: TextStyle(
                          color: AppColors.primary.withOpacity(0.8),
                          fontSize: 12,
                        ),
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
