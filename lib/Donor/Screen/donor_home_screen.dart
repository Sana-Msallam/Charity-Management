import 'package:charity_management/Donor/Drawer/app_drawer.dart';
import 'package:charity_management/Donor/Screen/Support_Area/support_category_screen.dart';
import 'package:charity_management/Donor/cubit/aid_request_cubit.dart';
import 'package:charity_management/Sponsership/Screen/sponsership_main_screen.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/widgets/language_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonorHomeScreen extends StatelessWidget {
  DonorHomeScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFDFBF7),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              const SizedBox(height: 20),
              buildMainCampaignCard(context),
              const SizedBox(height: 28),
              buildSupportAreasSection(context),
              const SizedBox(height: 28),
              buildCommunityCard(context),
              const SizedBox(height: 24),
              buildImpactStatsRow(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
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
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.welcomeBackName,
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
              const SizedBox(width: 4),
              const Text('👋', style: TextStyle(fontSize: 18)),
            ],
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
        const LanguageToggleButton(),
      ],
    );
  }

  Widget buildMainCampaignCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
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
          final cardWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
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
                        onPressed: () {},
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
                    'assets/orphan_profile.jpg',
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
        l10n.smallProjects,
        Icons.rocket_launch_outlined,
        const Color(0xFFF5EBE6),
      ),
      _SupportArea(
        2,
        l10n.education,
        Icons.school_outlined,
        const Color(0xFFFEF3D6),
      ),
      _SupportArea(
        3,
        l10n.health,
        Icons.local_hospital_outlined,
        const Color(0xFFEBF5EE),
      ),
      _SupportArea(
        4,
        l10n.food,
        Icons.restaurant_outlined,
        const Color(0xFFF7F5DD),
      ),
      _SupportArea(
        5,
        l10n.housing,
        Icons.holiday_village_outlined,
        const Color(0xFFEFEAE4),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
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
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                l10n.viewAll,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF765A00),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 390 ? 2 : 3;
            final spacing = 12.0;
            final itemWidth =
                (constraints.maxWidth - (spacing * (columns - 1))) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final area in areas)
                  SizedBox(
                    width: itemWidth,
                    child: InkWell(
                      onTap: () => _navigateToCategory(
                        context,
                        categoryId: area.id,
                        title: area.title,
                        color: area.color,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: buildSupportCard(
                        area.title,
                        area.icon,
                        area.color,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildSupportCard(String title, IconData icon, Color bgColor) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF3D523A), size: 24),
          const Spacer(),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF2B2D42),
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommunityCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF37513A), Color(0xFF7A8A43)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0x99000000), Color(0x00000000)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              l10n.communityInitiatives,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.communityInitiativesDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.4,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      l10n.explorePortal,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFFFD56B),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFFFD56B),
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImpactStatsRow(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: buildStatBox(
            l10n.totalImpact,
            '\$1,240.00',
            const Color(0xFF3D523A),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: buildStatBox(
            l10n.livesImpacted,
            l10n.sampleChildrenCount,
            const Color(0xFF765A00),
          ),
        ),
      ],
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
