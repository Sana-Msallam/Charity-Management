import 'dart:async';

import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AboutSectionCard extends StatefulWidget {
  const AboutSectionCard({super.key});

  @override
  State<AboutSectionCard> createState() => _AboutSectionCardState();
}

class _AboutSectionCardState extends State<AboutSectionCard> {
  final PageController _pageController = PageController();

  Timer? _timer;
  int _currentPage = 0;

  final List<AboutSlide> _slides = const [
    AboutSlide(
      title: 'نبذة عن الجمعية',
      description:
          'نحن في جمعيتنا نسعى لتوفير الدعم الشامل للمحتاجين، '
          'ونهدف إلى بناء مستقبل يسوده التكافل الاجتماعي والرحمة '
          'من خلال برامجنا التنموية والإغاثية المبتكرة.',
      icon: Icons.volunteer_activism_outlined,
    ),
    AboutSlide(
      title: 'رؤيتنا',
      description:
          'نسعى إلى أن نكون جمعية رائدة في العمل الإنساني، '
          'وأن نساهم في بناء مجتمع متكافل يحصل فيه كل فرد '
          'على الدعم والرعاية التي يحتاجها.',
      icon: Icons.visibility_outlined,
    ),
    AboutSlide(
      title: 'رسالتنا',
      description:
          'تقديم المساعدات والخدمات الإنسانية بكفاءة وشفافية، '
          'والوصول إلى الفئات الأكثر احتياجًا من خلال مبادرات '
          'تنموية تصنع أثرًا إيجابيًا ومستدامًا.',
      icon: Icons.favorite_outline,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (!_pageController.hasClients) {
          return;
        }

        final int nextPage = (_currentPage + 1) % _slides.length;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );

    // إعادة حساب الوقت بعد انتقال المستخدم يدويًا.
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 245,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });

              // إعادة تشغيل المؤقت بعد سحب المستخدم للشريحة.
              _startAutoSlide();
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
                child: _AboutSlideCard(
                  slide: _slides[index],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 4),

        // مؤشرات الشرائح.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (index) {
              final bool isActive = index == _currentPage;

              return GestureDetector(
                onTap: () => _goToPage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.secondary.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.20),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
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

class _AboutSlideCard extends StatefulWidget {
  final AboutSlide slide;

  const _AboutSlideCard({
    required this.slide,
  });

  @override
  State<_AboutSlideCard> createState() => _AboutSlideCardState();
}

class _AboutSlideCardState extends State<_AboutSlideCard> {
  bool _isPressed = false;

  void _changePressedState(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _changePressedState(true),
      onTapUp: (_) => _changePressedState(false),
      onTapCancel: () => _changePressedState(false),
      child: AnimatedScale(
        scale: _isPressed ? 0.985 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          transform: Matrix4.translationValues(
            0,
            _isPressed ? 4 : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(
                _isPressed ? 0.18 : 0.12,
              ),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(
                  124,
                  118,
                  108,
                  0.05,
                ),
                blurRadius: _isPressed ? 7 : 5,
                offset: const Offset(0, 2),
              ),

              // الظل السفلي يجعل البطاقة تبدو مرتفعة مثل الزر.
              BoxShadow(
                color: AppColors.primary.withOpacity(
                  _isPressed ? 0.06 : 0.14,
                ),
                blurRadius: _isPressed ? 8 : 18,
                spreadRadius: _isPressed ? 0 : 1,
                offset: Offset(
                  0,
                  _isPressed ? 3 : 9,
                ),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  // صندوق الأيقونة.
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.slide.icon,
                      color: AppColors.primary,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      widget.slide.title,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withOpacity(0.02),
                      AppColors.secondary.withOpacity(0.18),
                      AppColors.secondary.withOpacity(0.02),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Text(
                  widget.slide.description,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: AppColors.brandGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutSlide {
  final String title;
  final String description;
  final IconData icon;

  const AboutSlide({
    required this.title,
    required this.description,
    required this.icon,
  });
}