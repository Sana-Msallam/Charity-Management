import 'dart:async';

// import 'package:charity_management/Donor/Drawer/app_drawer.dart';
import 'package:charity_management/Donor/Profile/Cubit/profile_cubit.dart';
import 'package:charity_management/Donor/Profile/profile_screen.dart';
import 'package:charity_management/Donor/Screen/Support_Area/support_category_screen.dart';
import 'package:charity_management/Donor/Screen/completed_aid_requests_screen.dart';
import 'package:charity_management/Donor/Screen/donations_screen.dart' hide AppColors;
import 'package:charity_management/Donor/cubit/aid_request_cubit.dart';
import 'package:charity_management/Donor/cubit/completed_aid_cases_cubit.dart';
import 'package:charity_management/Donor/cubit/completed_aid_cases_state.dart';
import 'package:charity_management/Donor/cubit/completed_aid_requests_cubit.dart';
import 'package:charity_management/Donor/cubit/donor_history_cubit.dart';
import 'package:charity_management/Sponsership/Screen/sponsership_main_screen.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final PageController _pageController = PageController();

  int _currentPage = 0;
  Timer? _sliderTimer;

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_pageController.hasClients) return;

      int nextPage = _currentPage + 1;

      if (nextPage >= 2) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompletedAidCasesCubit()..fetchCompletedAidCases(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFFDFBF7),
        // drawer: const AppDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(context),

                const SizedBox(height: 20),

                buildMainCampaignSlider(context),

                const SizedBox(height: 28),

                buildSupportAreasSection(context),

                const SizedBox(height: 24),

                buildImpactStatsRow(context),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        bottomNavigationBar: buildBottomNavigationBar(context),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => ProfileCubit()..fetchProfile(),
                  child: const ProfileScreen(),
                ),
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF7F2EA),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF765A00),
              size: 24,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            l10n.associationName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF765A00),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ),

        IconButton(
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: Color(0xFF765A00),
            size: 26,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildMainCampaignSlider(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              buildSponsorshipCard(context),
              buildAssociationCard(context),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            final isActive = index == _currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF3A5A40)
                    : const Color(0xFFD5D0C8),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildSponsorshipCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE2F0B9), Color(0xFFD2E794)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;

          final hasImageSpace = cardWidth >= 340;

          final reservedImageWidth = hasImageSpace ? 150.0 : 0.0;

          final textWidth = (cardWidth - reservedImageWidth - 40).clamp(
            0.0,
            cardWidth,
          );

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: textWidth.toDouble(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x66FFFFFF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.specialAppeal,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF4A6438),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        l10n.sponsorAnOrphanToday,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF384D2B),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        l10n.sponsorAnOrphanDescription,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5D754C),
                          fontSize: 12,
                          height: 1.4,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SponsorshipMainScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A5A40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.learnMore,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (hasImageSpace)
                PositionedDirectional(
                  end: 16,
                  bottom: 0,
                  top: 20,
                  child: Image.asset(
                    'assets/img/logo_isolated.svg.png',
                    fit: BoxFit.contain,
                    width: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 120,
                        child: Icon(
                          Icons.volunteer_activism_outlined,
                          color: Color(0xFF4A6438),
                          size: 64,
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildAssociationCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF37513A), Color(0xFF7A8A43)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.aboutAtharAssociation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    l10n.aboutAtharAssociationDescription,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.learnMore,
                      style: const TextStyle(
                        color: Color(0xFFFFD56B),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/img/logo_isolated.svg.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.volunteer_activism,
                      color: Color(0xFFFFD56B),
                      size: 80,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(
    BuildContext context, {
    required int categoryId,
    required String title,
    required Color color,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) =>
              AidRequestCubit()..fetchAidRequests(categoryId: categoryId),
          child: SupportCategoryScreen(
            categoryTitle: title,
            bannerColor: color,
            categoryId: categoryId,
          ),
        ),
      ),
    );
  }

  Widget buildSupportAreasSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final areas = [
      _SupportArea(
        1,
        l10n.health,
        Icons.local_hospital_outlined,
        AppColors.error,
      ),
      _SupportArea(
        2,
        l10n.food,
        Icons.restaurant_outlined,
        AppColors.secondary,
      ),
      _SupportArea(
        3,
        l10n.housing,
        Icons.holiday_village_outlined,
        const Color(0xFFD3DC7C),
      ),
      _SupportArea(4, l10n.education, Icons.school_outlined, AppColors.primary),
      _SupportArea(
        5,
        l10n.smallProjects,
        Icons.rocket_launch_outlined,
        AppColors.primaryContainer,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.supportAreas,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF2B2D42),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: buildSmallCategoryCard(
                title: areas[0].title,
                subtitle: l10n.healthRequestSubtitle,
                icon: areas[0].icon,
                color: areas[0].color,
                onTap: () => _navigateToCategory(
                  context,
                  categoryId: areas[0].id,
                  title: areas[0].title,
                  color: areas[0].color,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: buildSmallCategoryCard(
                title: areas[1].title,
                subtitle: l10n.foodRequestSubtitle,
                icon: areas[1].icon,
                color: areas[1].color,
                onTap: () => _navigateToCategory(
                  context,
                  categoryId: areas[1].id,
                  title: areas[1].title,
                  color: areas[1].color,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        buildLargeCategoryCard(
          title: areas[2].title,
          onTap: () => _navigateToCategory(
            context,
            categoryId: areas[2].id,
            title: areas[2].title,
            color: areas[2].color,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: buildSmallCategoryCard(
                title: areas[3].title,
                subtitle: l10n.educationRequestSubtitle,
                icon: areas[3].icon,
                color: areas[3].color,
                onTap: () => _navigateToCategory(
                  context,
                  categoryId: areas[3].id,
                  title: areas[3].title,
                  color: areas[3].color,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: buildSmallCategoryCard(
                title: areas[4].title,
                subtitle: l10n.projectSupportSubtitle,
                icon: areas[4].icon,
                color: areas[4].color,
                onTap: () => _navigateToCategory(
                  context,
                  categoryId: areas[4].id,
                  title: areas[4].title,
                  color: areas[4].color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSmallCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: color.withOpacity(0.06),
          child: InkWell(
            onTap: onTap,
            splashColor: color.withOpacity(0.15),
            highlightColor: color.withOpacity(0.05),
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.15), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.onSurface.withOpacity(0.7),
                      fontSize: 12,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLargeCategoryCard({
    required String title,
    required VoidCallback onTap,
  }) {
    const cardColor = Color(0xFFD3DC7C);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: cardColor.withOpacity(0.15),
          child: InkWell(
            onTap: onTap,
            splashColor: cardColor.withOpacity(0.25),
            child: Container(
              height: 104,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cardColor.withOpacity(0.15),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: cardColor.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.home_outlined,
                          color: AppColors.tertiary,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTextStyles.fontFamily,
                            ),
                          ),

                          Text(
                            AppLocalizations.of(context).housingRequestSubtitle,
                            style: TextStyle(
                              color: AppColors.onSurface.withOpacity(0.7),
                              fontSize: 13,
                              fontFamily: AppTextStyles.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Icon(
                    Icons.chevron_left,
                    color: AppColors.onSurface,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImpactStatsRow(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<CompletedAidCasesCubit, CompletedAidCasesState>(
      builder: (context, state) {
        String completedCases = '...';

        if (state is CompletedAidCasesSuccessState) {
          completedCases = state.data.completedAidCasesCount.toString();
        }

        if (state is CompletedAidCasesErrorState) {
          completedCases = 'لا توجد حالات مكتملة حاليا';
        }

        return Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => CompletedAidRequestsCubit(),
                        child: const CompletedAidRequestsScreen(),
                      ),
                    ),
                  );
                },
                child: buildStatBox(
                  l10n.completedAidCases,
                  completedCases,
                  const Color(0xFF3D523A),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildStatBox(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2EA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF8A817C),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFDFBF7),
        border: Border(top: BorderSide(color: Color(0xFFEFEAE4), width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF765A00),
        unselectedItemColor: const Color(0xFF8A817C),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            scaffoldKey.currentState?.openDrawer();
          }
if (index == 1) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (_) => DonorHistoryCubit()
          ..getDonorHistory(),
        child: const DonationsScreen(),
      ),
    ),
  );
}
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SponsorshipMainScreen(),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu),
            label: l10n.menu,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_outlined),
            label: l10n.impact,
          ),

          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5D166),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.home, color: Color(0xFF765A00)),
            ),
            label: l10n.home,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: l10n.wallet,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            label: l10n.sponsorships,
          ),
        ],
      ),
    );
  }
}

class _SupportArea {
  const _SupportArea(this.id, this.title, this.icon, this.color);

  final int id;
  final String title;
  final IconData icon;
  final Color color;
}
