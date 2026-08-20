import 'package:charity_management/features/Beneficiary/completed_project/cubit/completed_projects_cubit.dart';
import 'package:charity_management/features/Beneficiary/completed_project/service/completed_projects_service.dart';
import 'package:charity_management/features/Beneficiary/profile/cubit/profile_cubit.dart';
import 'package:charity_management/features/Beneficiary/profile/cubit/profile_state.dart';
import 'package:charity_management/features/Beneficiary/profile/screen/profile_screen.dart';
import 'package:charity_management/features/Beneficiary/profile/service/profile_service.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return BlocProvider(
      create: (_) {
        return ProfileCubit(
          ProfileService(),
        )..loadProfile(
            localizations: l10n,
          );
      },
      child: const _HomeView(),
    );
  }
}

// ==================================================
// HOME VIEW
// ==================================================

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return BlocBuilder<
        ProfileCubit,
        ProfileState>(
      builder: (
        context,
        profileState,
      ) {
        String? profileImageUrl;

        if (profileState
            is ProfileSuccess) {
          profileImageUrl =
              profileState
                  .profile
                  .personalPhoto;

          debugPrint(
            'Home profile image: '
            '$profileImageUrl',
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset:
              true,

          backgroundColor:
              AppColors.background,

          // ======================================
          // APP BAR
          // ======================================

          appBar: CustomAppBar(
            profileImageUrl:
                profileImageUrl,

            onProfileTap: () {
              _openProfile(
                context,
              );
            },
          ),

          // ======================================
          // BODY
          // ======================================

          body: SafeArea(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 20,
                vertical: 24,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  // ======================================
                  // ABOUT
                  // ======================================

                  const AboutSectionCard(),

                  const SizedBox(
                    height: 32,
                  ),

                  // ======================================
                  // NEW AID REQUEST TITLE
                  // ======================================

                  Text(
                    l10n.newAidRequest,
                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .onSurface,
                      fontSize: 28,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ======================================
                  // AID CATEGORIES
                  // ======================================

                  _buildCategoriesGrid(
                    context,
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  // ======================================
                  // COMPLETED PROJECTS
                  // ======================================

                  BlocProvider(
                    create: (_) {
                      return CompletedProjectsCubit(
                        CompletedProjectsService(),
                      )..loadCompletedProjects();
                    },
                    child:
                        const CompletedProjectsSection(),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          // ======================================
          // BOTTOM NAVIGATION
          // ======================================

          bottomNavigationBar:
              const CustomBottomNavigation(
            currentIndex: 0,
          ),
        );
      },
    );
  }

  // ==========================================
  // OPEN PROFILE
  // ==========================================

  Future<void> _openProfile(
    BuildContext context,
  ) async {
    debugPrint(
      '======================================',
    );

    debugPrint(
      'Profile image clicked',
    );

    debugPrint(
      'Opening ProfilePage',
    );

    debugPrint(
      '======================================',
    );

    await Navigator.of(context)
        .push<void>(
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return ProfileCubit(
                ProfileService(),
              );
            },
            child:
                const ProfilePage(),
          );
        },
      ),
    );

    if (!context.mounted) {
      return;
    }

    final AppLocalizations l10n =
        AppLocalizations.of(context);

    await context
        .read<ProfileCubit>()
        .refreshProfile(
          localizations: l10n,
        );
  }

  // ==========================================
  // OPEN APPLICANT INFO
  // ==========================================

  void _navigateToApplicantInfo(
    BuildContext context,
    String requestType,
  ) {
    Navigator.pushNamed(
      context,
      AppRoutes.applicantInfo,
      arguments:
          ApplicantInfoRouteArguments(
        requestType: requestType,
      ),
    );
  }

  // ==========================================
  // CATEGORIES
  // ==========================================

  Widget _buildCategoriesGrid(
    BuildContext context,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            // ======================================
            // HEALTH REQUEST
            // ======================================

            Expanded(
              child:
                  SmallCategoryCard(
                title:
                    l10n.healthRequest,
                subtitle:
                    l10n
                        .healthRequestSubtitle,
                icon: Icons
                    .medical_services_outlined,
                color:
                    AppColors.error,
                onTap: () {
                  _navigateToApplicantInfo(
                    context,
                    'صحي',
                  );
                },
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            // ======================================
            // FOOD REQUEST
            // ======================================

            Expanded(
              child:
                  SmallCategoryCard(
                title:
                    l10n.foodRequest,
                subtitle:
                    l10n
                        .foodRequestSubtitle,
                icon: Icons
                    .shopping_basket_outlined,
                color:
                    AppColors.secondary,
                onTap: () {
                  _navigateToApplicantInfo(
                    context,
                    'غذائي',
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 16,
        ),

        // ======================================
        // HOUSING REQUEST
        // ======================================

        LargeCategoryCard(
          onTap: () {
            _navigateToApplicantInfo(
              context,
              'سكني',
            );
          },
        ),

        const SizedBox(
          height: 16,
        ),

        Row(
          children: [
            // ======================================
            // EDUCATION REQUEST
            // ======================================

            Expanded(
              child:
                  SmallCategoryCard(
                title:
                    l10n.educationRequest,
                subtitle:
                    l10n
                        .educationRequestSubtitle,
                icon:
                    Icons.auto_stories_outlined,
                color:
                    AppColors.primary,
                onTap: () {
                  _navigateToApplicantInfo(
                    context,
                    'تعليمي',
                  );
                },
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            // ======================================
            // SMALL PROJECT SUPPORT
            // ======================================

            Expanded(
              child:
                  SmallCategoryCard(
                title:
                    l10n.projectSupport,
                subtitle:
                    l10n
                        .projectSupportSubtitle,
                icon:
                    Icons.trending_up,
                color:
                    const Color(
                  0xFFF4CF58,
                ),
                onTap: () {
                  _navigateToApplicantInfo(
                    context,
                    'دعم مشاريع',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}