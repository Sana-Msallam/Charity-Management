import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/features/Beneficiary/completed_project/cubit/completed_projects_cubit.dart';
import 'package:charity_management/features/Beneficiary/completed_project/cubit/completed_projects_state.dart';
import 'package:charity_management/features/Beneficiary/completed_project/model/completed_project_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedProjectsSection extends StatelessWidget {
  const CompletedProjectsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.completedProjectsTitle,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),

        const SizedBox(height: 16),

        BlocBuilder<CompletedProjectsCubit, CompletedProjectsState>(
          builder: (context, state) {
            if (state is CompletedProjectsInitial) {
              return const SizedBox.shrink();
            }

            if (state is CompletedProjectsLoading) {
              return _buildLoading();
            }

            if (state is CompletedProjectsFailure) {
              return _buildError(
                state.message,
              );
            }

            if (state is CompletedProjectsSuccess) {
              if (state.projects.isEmpty) {
                return _buildEmpty();
              }

              return SizedBox(
                height: 235,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.projects.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 14);
                  },
                  itemBuilder: (context, index) {
                    return _CompletedProjectCard(
                      project: state.projects[index],
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: 235,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildError(
    String message,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.error.withOpacity(0.12),
        ),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.error,
          fontSize: 13,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.brandGray.withOpacity(0.10),
        ),
      ),
      child: const Text(
        'لا توجد مشاريع مكتملة حالياً',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.brandGray,
          fontSize: 13,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }
}

class _CompletedProjectCard extends StatelessWidget {
  const _CompletedProjectCard({
    required this.project,
  });

  final CompletedProjectModel project;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.brandGray.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // الصورة
            // ==========================================

            SizedBox(
              height: 125,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(),

                  // ====================================
                  // عاجل
                  // تظهر فقط إذا كان الطلب عاجلاً
                  // ====================================

                  if (project.isUrgent)
                    PositionedDirectional(
                      end: 10,
                      top: 10,
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'عاجل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTextStyles.fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ==========================================
            // معلومات المشروع
            // ==========================================

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  10,
                  12,
                  10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================
                    // Category
                    // مثال: سكني - صحي - غذائي
                    // ==================================

                    Text(
                      project.category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // ==================================
                    // Title
                    // ==================================

                    Text(
                      project.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),

                    const Spacer(),

                    // ==================================
                    // النسبة + التكلفة
                    // ==================================

                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.secondary,
                          size: 16,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          '${project.completionPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: AppColors.brandGray,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTextStyles.fontFamily,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          '${project.totalCost.toStringAsFixed(0)} ريال',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppTextStyles.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // الصورة
  // ===================================================

  Widget _buildImage() {
    // إذا الباك ما رجع صورة
    // منستخدم الصورة الافتراضية حسب الـ Category
    if (!project.hasImage) {
      return Image.asset(
        project.defaultImagePath,
        fit: BoxFit.cover,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _buildFallback();
        },
      );
    }

    // إذا الباك رجع صورة
    final String imageUrl = _fixImageUrl(
      project.image!,
    );

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        // إذا صورة السيرفر فشلت
        // نجرب الصورة الافتراضية
        return Image.asset(
          project.defaultImagePath,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            // وإذا حتى الصورة الافتراضية غير موجودة
            // نعرض Icon حسب النوع
            return _buildFallback();
          },
        );
      },
    );
  }

  // ===================================================
  // Fallback إذا ما في أي صورة
  // ===================================================

  Widget _buildFallback() {
    return Container(
      color: AppColors.primaryContainer.withOpacity(0.25),
      alignment: Alignment.center,
      child: Icon(
        _getCategoryIcon(),
        size: 48,
        color: AppColors.primary,
      ),
    );
  }

  // ===================================================
  // Icon افتراضي حسب Category
  // ===================================================

  IconData _getCategoryIcon() {
    switch (project.category.id) {
      case 1:
        return Icons.medical_services_outlined;

      case 2:
        return Icons.shopping_basket_outlined;

      case 3:
        return Icons.home_outlined;

      case 4:
        return Icons.auto_stories_outlined;

      case 5:
        return Icons.trending_up;

      default:
        return Icons.volunteer_activism_outlined;
    }
  }

  // ===================================================
  // معالجة رابط الصورة
  // ===================================================

  String _fixImageUrl(
    String url,
  ) {
    String result = url.trim();

    result = result.replaceFirst(
      'http://localhost:3000',
      ApiConstants.baseUrl,
    );

    result = result.replaceFirst(
      'http://127.0.0.1:3000',
      ApiConstants.baseUrl,
    );

    if (result.startsWith('/')) {
      result = '${ApiConstants.baseUrl}$result';
    }

    return result;
  }
}