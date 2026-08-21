import 'dart:async';

import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';

class AboutSectionCard extends StatefulWidget {
  const AboutSectionCard({
    super.key,
  });

  @override
  State<AboutSectionCard> createState() {
    return _AboutSectionCardState();
  }
}

class _AboutSectionCardState extends State<AboutSectionCard> {
  static const int _slidesCount = 3;

  final PageController _pageController = PageController();

  Timer? _timer;

  int _currentPage = 0;

  // =====================================================
  // SLIDES
  // =====================================================

  List<AboutSlide> _slides(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context);

    return [
      AboutSlide(
        title: l10n.aboutAssociationTitle,
        description: l10n.aboutAssociationDescription,
        imagePath: 'assets/img/about_1.jpg',
        imageBadge: l10n.togetherWeMakeImpact,
      ),
      AboutSlide(
        title: l10n.ourVision,
        description: l10n.ourVisionDescription,
        imagePath: 'assets/img/about_2.jpg',
        imageBadge: l10n.renewedHope,
      ),
      AboutSlide(
  title: l10n.ourMission,
  description: l10n.ourMissionDescription,
  imagePath: 'assets/img/about_3.jpg',
  imageBadge: l10n.givingMakesDifference,
),
    ];
  }

  @override
  void initState() {
    super.initState();

    _startAutoSlide();
  }

  // =====================================================
  // AUTO SLIDE
  // =====================================================

  void _startAutoSlide() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (!_pageController.hasClients) {
          return;
        }

        final int nextPage =
            (_currentPage + 1) % _slidesCount;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(
            milliseconds: 600,
          ),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  // =====================================================
  // GO TO PAGE
  // =====================================================

  void _goToPage(
    int index,
  ) {
    _pageController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: 450,
      ),
      curve: Curves.easeInOut,
    );

    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();

    _pageController.dispose();

    super.dispose();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final List<AboutSlide> slides =
        _slides(context);

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            physics:
                const BouncingScrollPhysics(),
            onPageChanged: (
              int index,
            ) {
              setState(() {
                _currentPage = index;
              });

              _startAutoSlide();
            },
            itemBuilder: (
              context,
              index,
            ) {
              return Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  4,
                  4,
                  4,
                  12,
                ),
                child: _AboutSlideCard(
                  slide: slides[index],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 4),

        // =================================================
        // SLIDE INDICATORS
        // =================================================

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: List.generate(
            slides.length,
            (
              int index,
            ) {
              final bool isActive =
                  index == _currentPage;

              return GestureDetector(
                onTap: () {
                  _goToPage(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.easeInOut,
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  width: isActive ? 26 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.primary
                            .withOpacity(
                            0.12,
                          ),
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =====================================================
// تصميم كل Slide
// =====================================================

class _AboutSlideCard extends StatelessWidget {
  const _AboutSlideCard({
    required this.slide,
  });

  final AboutSlide slide;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          28,
        ),
        border: Border.all(
          color: AppColors.primary.withOpacity(
            0.09,
          ),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ),
            blurRadius: 20,
            offset: const Offset(
              0,
              8,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ============================================
          // العنوان
          // ============================================

          Text(
            slide.title,
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.35,
              letterSpacing: -0.25,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),

          const SizedBox(height: 8),

          // ============================================
          // الخط الصغير تحت العنوان
          // ============================================

          Container(
            width: 44,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ============================================
          // الوصف
          // ============================================

          Text(
            slide.description,
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.onSurface
                  .withOpacity(
                0.66,
              ),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.8,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),

          const SizedBox(height: 12),

          // ============================================
          // الصورة
          // ============================================

          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      slide.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: AppColors.primary
                              .withOpacity(
                            0.06,
                          ),
                          child: Center(
                            child: Icon(
                              Icons
                                  .volunteer_activism_outlined,
                              color: AppColors
                                  .primary
                                  .withOpacity(
                                0.45,
                              ),
                              size: 54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ========================================
                // Gradient خفيف أسفل الصورة
                // ========================================

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                        22,
                      ),
                      gradient: LinearGradient(
                        begin:
                            Alignment.topCenter,
                        end:
                            Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(
                            0.10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ========================================
                // العبارة الصغيرة فوق الصورة
                // PositionedDirectional يتغير تلقائياً
                // حسب RTL / LTR
                // ========================================

                PositionedDirectional(
                  start: 12,
                  bottom: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(
                        0.94,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(
                            0.08,
                          ),
                          blurRadius: 10,
                          offset: const Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons
                              .favorite_border_rounded,
                          color:
                              AppColors.primary,
                          size: 17,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          slide.imageBadge,
                          style:
                              const TextStyle(
                            color: AppColors
                                .onSurface,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                            fontFamily:
                                AppTextStyles
                                    .fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// MODEL
// =====================================================

class AboutSlide {
  const AboutSlide({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.imageBadge,
  });

  final String title;

  final String description;

  final String imagePath;

  final String imageBadge;
}