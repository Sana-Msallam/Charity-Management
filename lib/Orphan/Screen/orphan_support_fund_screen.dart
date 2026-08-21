import 'dart:async';

import 'package:charity_management/features/Donor/guest_login_required_dialog.dart';
import 'package:charity_management/features/Donor/cubit/profile_cubit.dart';
import 'package:charity_management/features/Donor/cubit/profile_state.dart';
import 'package:charity_management/Orphan/cubit/orphan_support_fund_cubit.dart';
import 'package:charity_management/Orphan/cubit/orphan_support_fund_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrphanSupportFundScreen extends StatefulWidget {
  const OrphanSupportFundScreen({
    super.key,
    required this.isSponsor,
    this.isGuest = false,
    this.onDonateWithCard,
    this.onDonateWithWallet,
  });

  /// تأتي لاحقًا من بيانات بروفايل المتبرع.
  final bool isSponsor;
  final bool isGuest;

  /// مؤقتًا الواجهة مستقلة عن الـ API. نربط هذين الحدثين بالـ Cubit لاحقًا.
  final ValueChanged<double>? onDonateWithCard;
  final ValueChanged<double>? onDonateWithWallet;

  @override
  State<OrphanSupportFundScreen> createState() =>
      _OrphanSupportFundScreenState();
}

class _OrphanSupportFundScreenState extends State<OrphanSupportFundScreen> {
  final TextEditingController _amountController = TextEditingController();
  final PageController _pageController = PageController();
  late final OrphanSupportFundCubit _fundCubit;
  late final ProfileCubit _profileCubit;
  Timer? _sliderTimer;

  final List<int> _quickAmounts = const [10, 25, 50, 100];
  int _currentSlide = 0;
  int? _selectedQuickAmount;
  double? _walletBalanceAfterDonation;

  bool get _isArabic =>
      Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

  @override
  void initState() {
    super.initState();
    _fundCubit = OrphanSupportFundCubit();
    _profileCubit = ProfileCubit();

    if (!widget.isGuest) {
      _profileCubit.fetchProfile();
    }

    _startSliderTimer();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _sliderTimer?.cancel();
    _pageController.dispose();
    _fundCubit.close();
    _profileCubit.close();
    super.dispose();
  }

  void _startSliderTimer() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
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
    if (!isEnabled) {
      return;
    }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isArabic
                ? 'أدخلي مبلغًا صحيحًا أكبر من صفر.'
                : 'Enter a valid amount greater than zero.',
            style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
          ),
        ),
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

  void _donateWithWallet(AppLocalizations l10n, _DonorWalletInfo donorWallet) {
    if (widget.isGuest) {
      showGuestLoginRequiredDialog(context);
      return;
    }

    if (donorWallet.isSponsor || !_validateAmount()) return;

    _fundCubit.donateFromWallet(amount: _readAmount()!, localizations: l10n);
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

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _fundCubit),
        BlocProvider.value(value: _profileCubit),
      ],
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
            _isArabic ? 'صندوق سند اليتيم' : 'Orphan Support Fund',
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
                BlocConsumer<OrphanSupportFundCubit, OrphanSupportFundState>(
                  listener: (context, state) {
                    if (state.cardStatus ==
                        OrphanSupportFundPaymentStatus.success) {
                      _amountController.clear();
                      setState(() => _selectedQuickAmount = null);
                      _showMessage(context, l10n.paymentCompletedRefresh);
                    }

                    if (state.cardStatus ==
                            OrphanSupportFundPaymentStatus.canceled &&
                        state.cardMessage != null) {
                      _showMessage(context, state.cardMessage!);
                    }

                    if (state.cardStatus ==
                            OrphanSupportFundPaymentStatus.failure &&
                        state.cardMessage != null) {
                      _showMessage(context, state.cardMessage!);
                    }

                    if (state.walletStatus ==
                            OrphanSupportFundPaymentStatus.success &&
                        state.walletDonation != null) {
                      _amountController.clear();
                      setState(() {
                        _selectedQuickAmount = null;
                        _walletBalanceAfterDonation = _parseAmount(
                          state.walletDonation!.balanceAfter,
                        );
                      });
                      _showMessage(context, state.walletDonation!.message);
                    }

                    if (state.walletStatus ==
                            OrphanSupportFundPaymentStatus.failure &&
                        state.walletMessage != null) {
                      _showMessage(context, state.walletMessage!);
                    }
                  },
                  builder: (context, fundState) {
                    return BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, profileState) {
                        return _buildDonationSection(
                          fundState,
                          _donorWalletInfo(profileState),
                          l10n,
                        );
                      },
                    );
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
        icon: Icons.workspace_premium_outlined,
        title: _isArabic ? 'رفقة النبي ﷺ في الجنة' : 'A noble reward',
        description: _isArabic
            ? 'قال رسول الله ﷺ: «أنا وكافل اليتيم في الجنة هكذا».'
            : 'The Prophet ﷺ highlighted the great reward of caring for an orphan.',
        colors: const [Color(0xFF304C39), Color(0xFF78904B)],
      ),
      _FundSlide(
        icon: Icons.shield_outlined,
        title: _isArabic
            ? 'لا ينقطع عنه الأمان'
            : 'Support without interruption',
        description: _isArabic
            ? 'مساهمتك تمنح اليتيم دعمًا مؤقتًا عندما تتوقف كفالته بشكل مفاجئ.'
            : 'Your contribution provides temporary help when sponsorship stops unexpectedly.',
        colors: const [Color(0xFF765A00), Color(0xFFC99732)],
      ),
      _FundSlide(
        icon: Icons.volunteer_activism_outlined,
        title: _isArabic ? 'مساهمتك تصنع سندًا' : 'Every gift matters',
        description: _isArabic
            ? 'حتى المساهمة البسيطة تساعد في حفظ استقرار اليتيم إلى أن يجد كفيلًا جديدًا.'
            : 'Even a small gift helps protect an orphan until a new sponsor is found.',
        colors: const [Color(0xFF475B3D), Color(0xFF9AAA64)],
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
                ? 'يوفّر الصندوق دعمًا مؤقتًا لليتيم عند انقطاع كفالته. يحصل اليتيم على 50% من مبلغ كفالته الأصلية شهريًا ولمدة شهرين كحد أقصى، أو حتى يحصل على كفيل جديد.'
                : 'The fund temporarily supports an orphan when sponsorship stops. It provides 50% of the original monthly sponsorship for up to two months, or until a new sponsor is found.',
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
                Icons.percent_rounded,
                _isArabic ? '50% من الكفالة' : '50% of sponsorship',
              ),
              _buildInfoChip(
                Icons.calendar_month_outlined,
                _isArabic ? 'شهران كحد أقصى' : 'Up to 2 months',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
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
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationSection(
    OrphanSupportFundState fundState,
    _DonorWalletInfo donorWallet,
    AppLocalizations l10n,
  ) {
    final isLoading = fundState.isAnyLoading;
    final isSponsor = donorWallet.isSponsor;
    final isWalletDisabled = widget.isGuest
        ? isLoading
        : isLoading || isSponsor || donorWallet.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isArabic ? 'ساهم في الصندوق' : 'Contribute to the fund',
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
          isLoading: fundState.isCardLoading,
          onPressed: isLoading ? null : () => _donateWithCard(l10n),
        ),
        const SizedBox(height: 12),
        _buildPaymentButton(
          icon: Icons.account_balance_wallet_outlined,
          title: _isArabic ? 'التبرع من المحفظة' : 'Donate from wallet',
          backgroundColor: isSponsor
              ? const Color(0xFFE8E4DC)
              : const Color(0xFFE2F0B9),
          foregroundColor: isSponsor
              ? const Color(0xFF9B958A)
              : const Color(0xFF304C39),
          isLoading: fundState.isWalletLoading,
          onPressed: isWalletDisabled
              ? null
              : () => _donateWithWallet(l10n, donorWallet),
        ),
        if (donorWallet.walletBalance != null) ...[
          const SizedBox(height: 8),
          Text(
            '${l10n.currentWalletBalance}: ${_formatAmount(donorWallet.walletBalance!)} USD',
            style: const TextStyle(
              color: AppColors.brandGray,
              fontSize: 12,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ],
        if (isSponsor) ...[
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
                      ? 'رصيد محفظتك مخصص حاليًا لدفعات الكفالة، ويمكنك التبرع للصندوق عبر البطاقة البنكية.'
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

  _DonorWalletInfo _donorWalletInfo(ProfileState state) {
    if (state is ProfileInitialState || state is ProfileLoadingState) {
      return _DonorWalletInfo(
        isSponsor: widget.isSponsor,
        walletBalance: _walletBalanceAfterDonation,
        isLoading: true,
      );
    }

    if (state is ProfileSuccessState) {
      return _DonorWalletInfo(
        isSponsor: state.profile.isSponsor,
        walletBalance:
            _walletBalanceAfterDonation ??
            state.profile.walletBalance.toDouble(),
      );
    }

    return _DonorWalletInfo(
      isSponsor: widget.isSponsor,
      walletBalance: _walletBalanceAfterDonation,
    );
  }

  static double? _parseAmount(String value) {
    final normalized = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(normalized);
  }

  static String _formatAmount(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }
}

class _DonorWalletInfo {
  const _DonorWalletInfo({
    required this.isSponsor,
    this.walletBalance,
    this.isLoading = false,
  });

  final bool isSponsor;
  final double? walletBalance;
  final bool isLoading;
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
