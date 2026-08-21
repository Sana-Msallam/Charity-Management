import 'dart:async';

import 'package:charity_management/features/Donor/guest_login_required_dialog.dart';
import 'package:charity_management/features/Donor/cubit/quick_donation_fund_cubit.dart';
import 'package:charity_management/features/Donor/cubit/quick_donation_fund_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickDonationFundScreen extends StatefulWidget {
  const QuickDonationFundScreen({super.key, this.isGuest = false});

  final bool isGuest;

  @override
  State<QuickDonationFundScreen> createState() =>
      _QuickDonationFundScreenState();
}

class _QuickDonationFundScreenState extends State<QuickDonationFundScreen> {
  final TextEditingController _amountController = TextEditingController();
  final PageController _pageController = PageController();
  late final QuickDonationFundCubit _fundCubit;
  Timer? _sliderTimer;

  final List<int> _quickAmounts = const [10, 25, 50, 100];
  int _currentSlide = 0;
  int? _selectedQuickAmount;
  bool _isWalletDisabledByForbidden = false;

  bool get _isArabic =>
      Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

  @override
  void initState() {
    super.initState();
    _fundCubit = QuickDonationFundCubit();
    _startSliderTimer();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _sliderTimer?.cancel();
    _pageController.dispose();
    _fundCubit.close();
    super.dispose();
  }

  void _startSliderTimer() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      final slides = _slides;
      final nextSlide = (_currentSlide + 1) % slides.length;

      _pageController.animateToPage(
        nextSlide,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  double? _readAmount() {
    final normalized = _amountController.text.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  void _selectQuickAmount(int amount, {required bool isEnabled}) {
    if (!isEnabled) return;

    setState(() {
      _selectedQuickAmount = amount;
      _amountController.text = amount.toString();
      _amountController.selection = TextSelection.collapsed(
        offset: _amountController.text.length,
      );
    });
  }

  bool _validateAmount() {
    FocusScope.of(context).unfocus();
    final amount = _readAmount();

    if (amount == null || amount <= 0) {
      _showMessage(
        context,
        _isArabic
            ? 'أدخل مبلغًا صحيحًا أكبر من صفر.'
            : 'Enter a valid amount greater than zero.',
      );
      return false;
    }

    return true;
  }

  void _donateWithCard(AppLocalizations l10n) {
    if (widget.isGuest) {
      showGuestLoginRequiredDialog(context);
      return;
    }

    if (!_validateAmount()) return;
    _fundCubit.donateWithCard(amount: _readAmount()!, localizations: l10n);
  }

  void _donateWithWallet(AppLocalizations l10n) {
    if (widget.isGuest) {
      showGuestLoginRequiredDialog(context);
      return;
    }

    if (_isWalletDisabledByForbidden || !_validateAmount()) return;
    _fundCubit.donateFromWallet(amount: _readAmount()!, localizations: l10n);
  }

  void _clearAmount() {
    _amountController.clear();
    setState(() => _selectedQuickAmount = null);
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider.value(
      value: _fundCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFBF7),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
    color: AppColors.primary,
  ),
          title: Text(
            _isArabic ? 'صندوق التبرع السريع' : 'Quick Donation Fund',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroSlider(),
                const SizedBox(height: 24),
                _buildAboutFundCard(),
                const SizedBox(height: 28),
                BlocConsumer<QuickDonationFundCubit, QuickDonationFundState>(
                  listener: (context, state) {
                    if (state.cardStatus ==
                        QuickDonationFundPaymentStatus.success) {
                      _clearAmount();
                      _showMessage(context, l10n.paymentCompletedRefresh);
                    }

                    if (state.cardStatus ==
                            QuickDonationFundPaymentStatus.canceled &&
                        state.cardMessage != null) {
                      _showMessage(context, state.cardMessage!);
                    }

                    if (state.cardStatus ==
                            QuickDonationFundPaymentStatus.failure &&
                        state.cardMessage != null) {
                      _showMessage(context, state.cardMessage!);
                    }

                    if (state.walletStatus ==
                            QuickDonationFundPaymentStatus.success &&
                        state.walletDonation != null) {
                      _clearAmount();
                      _showMessage(context, state.walletDonation!.message);
                    }

                    if (state.walletStatus ==
                            QuickDonationFundPaymentStatus.failure &&
                        state.walletMessage != null) {
                      if (state.walletErrorType ==
                          QuickDonationFundErrorType.forbidden) {
                        setState(() => _isWalletDisabledByForbidden = true);
                      }
                      _showMessage(context, state.walletMessage!);
                    }
                  },
                  builder: (context, state) {
                    return _buildDonationSection(state, l10n);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_FundSlide> get _slides {
    return <_FundSlide>[
      _FundSlide(
        icon: Icons.favorite_outline_rounded,
        title: _isArabic ? 'تفريج الكرب' : 'Relieving hardship',
        description: _isArabic
            ? 'من أعظم أبواب الخير أن تكون سببًا في تفريج كربة إنسان محتاج.'
            : 'One of the greatest acts of kindness is helping relieve someoneâ€™s hardship.',
        colors: const [Color(0xFF9A651F), Color(0xFFD5A23E)],
      ),
      _FundSlide(
        icon: Icons.people_alt_outlined,
        title: _isArabic ? 'في عون المحتاج' : 'Helping those in need',
        description: _isArabic
            ? 'مساهمتك تتيح للجمعية الوقوف بجانب المحتاج عندما لا تحتمل حالته الانتظار.'
            : 'Your contribution helps the association respond when a person cannot wait.',
        colors: const [Color(0xFF765A00), Color(0xFFB88A2A)],
      ),
      _FundSlide(
        icon: Icons.bolt_rounded,
        title: _isArabic ? 'صدقة تصل في وقتها' : 'Help at the right time',
        description: _isArabic
            ? 'قد تصنع المساعدة السريعة فرقًا كبيرًا في حياة شخص يمر بظرف طارئ.'
            : 'Timely help can make a meaningful difference during an urgent situation.',
        colors: const [Color(0xFF8A571D), Color(0xFFE0AD45)],
      ),
    ];
  }

  Widget _buildIntroSlider() {
    final slides = _slides;

    return Column(
      children: [
        SizedBox(
          height: 184,
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (index) => setState(() => _currentSlide = index),
            itemBuilder: (context, index) => _buildSlide(slides[index]),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: _currentSlide == index ? 22 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _currentSlide == index
                    ? AppColors.primary
                    : const Color(0xFFD9D2C4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlide(_FundSlide slide) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.colors,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -26,
            top: -38,
            child: Container(
              width: 145,
              height: 145,
              decoration: const BoxDecoration(
                color: Color(0x1FFFFFFF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0x26FFFFFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(slide.icon, color: Colors.white, size: 27),
              ),
              const Spacer(),
              Text(
                slide.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                slide.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xEFFFFFFF),
                  fontSize: 13,
                  height: 1.5,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutFundCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0D997)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8A8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isArabic ? 'كيف يعمل الصندوق؟' : 'How does the fund work?',
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            _isArabic
                ? 'قد يصل إلى الجمعية شخص بحاجة مالية عاجلة لا تحتمل انتظار إنشاء طلب إعانة وجمع التبرعات. بعد التحقق من حالته، تستطيع الجمعية تقديم المساعدة له مباشرة من رصيد هذا الصندوق.'
                : 'Someone may come to the association with an urgent financial need that cannot wait for an aid request and donation collection. After verifying the case, the association can provide immediate help from this fund.',
            style: const TextStyle(
              color: Color(0xFF625B4E),
              fontSize: 14,
              height: 1.7,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                Icons.bolt_rounded,
                _isArabic ? 'استجابة سريعة' : 'Quick response',
              ),
              _buildInfoChip(
                Icons.fact_check_outlined,
                _isArabic ? 'بعد التحقق من الحالة' : 'After case verification',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width - 76,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                softWrap: true,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationSection(
    QuickDonationFundState state,
    AppLocalizations l10n,
  ) {
    final isLoading = state.isAnyLoading;
    final isWalletDisabled = isLoading || _isWalletDisabledByForbidden;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isArabic ? 'تبرع للصندوق' : 'Donate to the fund',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _isArabic
              ? 'اختر مبلغًا أو أدخل مبلغًا مخصصًا بالدولار.'
              : 'Choose an amount or enter a custom amount in USD.',
          style: const TextStyle(
            color: AppColors.brandGray,
            fontSize: 13,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _quickAmounts.map((amount) {
            final isSelected = _selectedQuickAmount == amount;
            return ChoiceChip(
              selected: isSelected,
              showCheckmark: false,
              label: Text('\$$amount'),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontFamily: AppTextStyles.fontFamily,
              ),
              selectedColor: AppColors.primary,
              backgroundColor: const Color(0xFFF7F2EA),
              side: BorderSide(
                color: isSelected ? AppColors.primary : const Color(0xFFE3DACB),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              onSelected: (_) =>
                  _selectQuickAmount(amount, isEnabled: !isLoading),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _amountController,
          enabled: !isLoading,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d{0,2}')),
          ],
          onChanged: (_) {
            if (_selectedQuickAmount != null) {
              setState(() => _selectedQuickAmount = null);
            }
          },
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: AppTextStyles.fontFamily,
          ),
          decoration: InputDecoration(
            labelText: _isArabic ? 'مبلغ التبرع' : 'Donation amount',
            hintText: '0.00',
            prefixIcon: const Icon(
              Icons.attach_money_rounded,
              color: AppColors.primary,
            ),
            suffixText: 'USD',
            suffixStyle: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextStyles.fontFamily,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE3DACB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE3DACB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _buildPaymentButton(
          icon: Icons.credit_card_rounded,
          title: _isArabic
              ? 'التبرع عبر البطاقة البنكية'
              : 'Donate with bank card',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          isLoading: state.isCardLoading,
          onPressed: isLoading ? null : () => _donateWithCard(l10n),
        ),
        const SizedBox(height: 12),
        _buildPaymentButton(
          icon: Icons.account_balance_wallet_outlined,
          title: _isArabic ? 'التبرع من المحفظة' : 'Donate from wallet',
          backgroundColor: _isWalletDisabledByForbidden
              ? const Color(0xFFE8E4DC)
              : const Color(0xFFE2F0B9),
          foregroundColor: _isWalletDisabledByForbidden
              ? const Color(0xFF9B958A)
              : const Color(0xFF304C39),
          isLoading: state.isWalletLoading,
          onPressed: isWalletDisabled ? null : () => _donateWithWallet(l10n),
        ),
        if (_isWalletDisabledByForbidden) ...[
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.brandGray,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isArabic
                      ? 'التبرع من المحفظة غير متاح لهذا الحساب، يمكنك استخدام البطاقة البنكية.'
                      : 'Your wallet balance is reserved for sponsorship payments. You can donate using a bank card.',
                  style: const TextStyle(
                    color: AppColors.brandGray,
                    fontSize: 12,
                    height: 1.5,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentButton({
    required IconData icon,
    required String title,
    required Color backgroundColor,
    required Color foregroundColor,
    required bool isLoading,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: foregroundColor,
                ),
              )
            : Icon(icon, color: foregroundColor, size: 22),
        label: Text(
          title,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _FundSlide {
  const _FundSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<Color> colors;
}
