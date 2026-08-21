import 'package:charity_management/Donor/Profile/Cubit/profile_cubit.dart';
import 'package:charity_management/Donor/Profile/Cubit/profile_state.dart';
import 'package:charity_management/Donor/guest_login_required_dialog.dart';
import 'package:charity_management/Donor/cubit/aid_request_details_cubit.dart';
import 'package:charity_management/Donor/cubit/aid_request_details_state.dart';
import 'package:charity_management/Payment/Screen/checkout.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AidRequestDetailsScreen extends StatefulWidget {
  const AidRequestDetailsScreen({
    super.key,
    required this.id,
    this.isGuest = false,
  });

  final int id;
  final bool isGuest;

  @override
  State<AidRequestDetailsScreen> createState() =>
      _AidRequestDetailsScreenState();
}

class _AidRequestDetailsScreenState extends State<AidRequestDetailsScreen> {
  late final ProfileCubit _profileCubit;
  double? _walletBalanceAfterDonation;

  static const bool _fallbackIsSponsorForTesting = true;
  static const double _fallbackWalletBalanceForTesting = 1000;

  static const _backgroundColor = Color(0xFFFFFCF8);
  static const _primaryColor = Color(0xFF735C00);
  static const _greenColor = Color(0xFF3D523A);
  static const _accentColor = Color(0xFFF5D166);
  static const _textColor = Color(0xFF292B3D);
  static const _mutedTextColor = Color(0xFF817D78);

  @override
  void initState() {
    super.initState();
    _profileCubit = ProfileCubit();

    if (!widget.isGuest) {
      _profileCubit.fetchProfile();
    }
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider.value(
      value: _profileCubit,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: _backgroundColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward
                  : Icons.arrow_back,
              color: _primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.caseDetails,
            style: const TextStyle(
              color: _primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ),
        body: BlocBuilder<AidRequestDetailsCubit, AidRequestDetailsState>(
          builder: (context, state) {
            if (state is AidRequestDetailsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: _primaryColor),
              );
            }

            if (state is AidRequestDetailsErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.error, textAlign: TextAlign.center),
                ),
              );
            }

            if (state is! AidRequestDetailsSuccessState) {
              return const SizedBox.shrink();
            }

            final item = state.request;
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRequestImage(
                    imagePath: item.image,
                    isUrgent: item.isUrgent,
                    urgentText: l10n.urgent,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.65,
                      color: _mutedTextColor,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDonationProgressCard(
                    requiredTitle: l10n.requiredAmount,
                    requiredValue: '${item.totalCost} USD',
                    collectedTitle: l10n.amountCollected,
                    collectedValue: '${item.paidAmount} USD',
                    remainingTitle: l10n.amountRemaining,
                    remainingValue: '${item.remainingAmount} USD',
                    percentageText: l10n.completionPercentage(
                      item.completionPercentage,
                    ),
                    percentage: item.completionPercentage,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    isArabic ? 'اختر طريقة التبرع' : 'Choose a donation method',
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, profileState) {
                      final donorWallet = _donorWalletInfo(profileState);

                      return _buildDonationButtons(
                        context,
                        isArabic: isArabic,
                        isFullyFunded: item.isFullyFunded,
                        title: item.title,
                        totalCost: item.totalCost,
                        paidAmount: item.paidAmount,
                        remainingAmount: item.remainingAmount,
                        donorWallet: donorWallet,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRequestImage({
    required String imagePath,
    required bool isUrgent,
    required String urgentText,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.network(
            '${ApiConstants.baseUrl}/$imagePath',
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 220,
                width: double.infinity,
                color: const Color(0xFFF0EEEE),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  size: 52,
                  color: Color(0xFF918A86),
                ),
              );
            },
          ),
        ),
        if (isUrgent)
          PositionedDirectional(
            top: 14,
            end: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9E6),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    size: 18,
                    color: Color(0xFFA52B23),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    urgentText,
                    style: const TextStyle(
                      color: Color(0xFFA52B23),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDonationProgressCard({
    required String requiredTitle,
    required String requiredValue,
    required String collectedTitle,
    required String collectedValue,
    required String remainingTitle,
    required String remainingValue,
    required String percentageText,
    required num percentage,
  }) {
    final progress = (percentage.toDouble() / 100).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9E0D5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMoneyRow(requiredTitle, requiredValue),
          const Divider(height: 24, color: Color(0xFFF0EBE5)),
          _buildMoneyRow(collectedTitle, collectedValue),
          const Divider(height: 24, color: Color(0xFFF0EBE5)),
          _buildMoneyRow(remainingTitle, remainingValue, emphasize: true),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress,
                    backgroundColor: const Color(0xFFF1ECE5),
                    valueColor: const AlwaysStoppedAnimation(_greenColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  percentageText,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: _greenColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyRow(String title, String value, {bool emphasize = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: _mutedTextColor, fontSize: 14),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            color: emphasize ? _primaryColor : _greenColor,
            fontSize: emphasize ? 17 : 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildDonationButtons(
    BuildContext context, {
    required bool isArabic,
    required bool isFullyFunded,
    required String title,
    required String totalCost,
    required String paidAmount,
    required String remainingAmount,
    required _DonorWalletInfo donorWallet,
  }) {
    if (isFullyFunded) {
      return _buildCompletedDonationState(isArabic);
    }

    if (widget.isGuest) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: () => showGuestLoginRequiredDialog(context),
              icon: const Icon(Icons.credit_card_rounded),
              label: Text(
                isArabic ? 'التبرع بالبطاقة البنكية' : 'Donate by bank card',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: _primaryColor,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () => showGuestLoginRequiredDialog(context),
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: Text(isArabic ? 'التبرع من المحفظة' : 'Donate from wallet'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _greenColor,
                side: const BorderSide(color: _greenColor, width: 1.4),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final walletDisabledMessage = _walletDisabledMessage(isArabic, donorWallet);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: () => _openCardCheckout(
              context,
              title: title,
              totalCost: totalCost,
              paidAmount: paidAmount,
              remainingAmount: remainingAmount,
            ),
            icon: const Icon(Icons.credit_card_rounded),
            label: Text(
              isArabic ? 'التبرع بالبطاقة البنكية' : 'Donate by bank card',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: _primaryColor,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: donorWallet.canUseWallet
                ? () => _openWalletCheckout(
                    context,
                    title: title,
                    totalCost: totalCost,
                    paidAmount: paidAmount,
                    remainingAmount: remainingAmount,
                    walletBalance: donorWallet.walletBalance!,
                  )
                : null,
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: Text(isArabic ? 'التبرع من المحفظة' : 'Donate from wallet'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _greenColor,
              side: const BorderSide(color: _greenColor, width: 1.4),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        if (walletDisabledMessage != null) ...[
          const SizedBox(height: 10),
          _buildWalletMessage(walletDisabledMessage),
        ],
      ],
    );
  }

  Widget _buildWalletMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0DDA4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: _primaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: _primaryColor,
                fontSize: 12,
                height: 1.4,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedDonationState(bool isArabic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3E6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBDD6B4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: _greenColor, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isArabic
                  ? 'منجزة'
                  : 'Completed',
              style: const TextStyle(
                color: _greenColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCardCheckout(
    BuildContext context, {
    required String title,
    required String totalCost,
    required String paidAmount,
    required String remainingAmount,
  }) {
    if (widget.isGuest) {
      showGuestLoginRequiredDialog(context);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          requestId: widget.id,
          paymentMethod: CheckoutPaymentMethod.card,
          title: title,
          totalCost: totalCost,
          paidAmount: paidAmount,
          remainingAmount: remainingAmount,
        ),
      ),
    ).then((paymentCompleted) {
      if (paymentCompleted == true && context.mounted) {
        context.read<AidRequestDetailsCubit>().refreshDetailsAfterPayment(
          widget.id,
        );
      }
    });
  }

  void _openWalletCheckout(
    BuildContext context, {
    required String title,
    required String totalCost,
    required String paidAmount,
    required String remainingAmount,
    required double walletBalance,
  }) {
    if (widget.isGuest) {
      showGuestLoginRequiredDialog(context);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          requestId: widget.id,
          paymentMethod: CheckoutPaymentMethod.wallet,
          walletBalance: walletBalance,
          title: title,
          totalCost: totalCost,
          paidAmount: paidAmount,
          remainingAmount: remainingAmount,
        ),
      ),
    ).then((result) {
      if (!context.mounted) {
        return;
      }

      if (result is WalletDonationCheckoutResult) {
        setState(() {
          _walletBalanceAfterDonation = _parseAmount(result.balanceAfter);
        });
        context.read<AidRequestDetailsCubit>().refreshDetailsAfterPayment(
          widget.id,
        );
      }
    });
  }

  _DonorWalletInfo _donorWalletInfo(ProfileState state) {
    if (state is ProfileLoadingState || state is ProfileInitialState) {
      return const _DonorWalletInfo(isLoading: true);
    }

    if (state is! ProfileSuccessState) {
      return const _DonorWalletInfo(
        isSponsor: _fallbackIsSponsorForTesting,
        walletBalance: _fallbackWalletBalanceForTesting,
      );
    }

    final profile = state.profile;
    final isSponsor = _readIsSponsor(profile) ?? _fallbackIsSponsorForTesting;

    final walletBalance =
        _walletBalanceAfterDonation ??
        _readWalletBalance(profile) ??
        _fallbackWalletBalanceForTesting;

    return _DonorWalletInfo(isSponsor: isSponsor, walletBalance: walletBalance);
  }

  bool? _readIsSponsor(Object profile) {
    try {
      final value = (profile as dynamic).isSponsor;
      if (value is bool) {
        return value;
      }
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  double? _readWalletBalance(Object profile) {
    try {
      final value = (profile as dynamic).walletBalance;
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return _parseAmount(value);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  String? _walletDisabledMessage(bool isArabic, _DonorWalletInfo donorWallet) {
    if (donorWallet.isLoading) {
      return isArabic
          ? 'جاري تحميل بيانات المحفظة...'
          : 'Loading wallet data...';
    }

    if (donorWallet.isSponsor == true) {
      return 'لا يمكنك التبرع من المحفظة لأن رصيدها مخصص لدفعات الكفالة';
    }

    if (donorWallet.profileFieldsUnavailable) {
      return isArabic
          ? 'ينتظر ربط التبرع من المحفظة دمج حقول البروفايل isSponsor و walletBalance.'
          : 'Wallet donation is waiting for the profile branch fields isSponsor and walletBalance.';
    }

    if (donorWallet.profileUnavailable) {
      return isArabic
          ? 'تعذر تحميل بيانات المحفظة حاليًا.'
          : 'Wallet data could not be loaded right now.';
    }

    return null;
  }

  static double _parseAmount(String value) {
    final normalized = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(normalized) ?? 0;
  }
}

class _DonorWalletInfo {
  const _DonorWalletInfo({
    this.isSponsor,
    this.walletBalance,
    this.isLoading = false,
    this.profileUnavailable = false,
    this.profileFieldsUnavailable = false,
  });

  final bool? isSponsor;
  final double? walletBalance;
  final bool isLoading;
  final bool profileUnavailable;
  final bool profileFieldsUnavailable;

  bool get canUseWallet =>
      isSponsor == false && walletBalance != null && !isLoading;
}
