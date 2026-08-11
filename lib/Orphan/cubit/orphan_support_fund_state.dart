import 'package:charity_management/Orphan/model/orphan_support_fund_payment_intent_model.dart';
import 'package:charity_management/Orphan/model/orphan_support_fund_wallet_donation_model.dart';

enum OrphanSupportFundPaymentStatus {
  initial,
  loading,
  success,
  failure,
  canceled,
}

enum OrphanSupportFundErrorType {
  validation,
  network,
  backend,
  unauthorized,
  forbidden,
  stripe,
  stripeConfiguration,
  canceled,
  unexpected,
}

class OrphanSupportFundState {
  const OrphanSupportFundState({
    required this.cardStatus,
    required this.walletStatus,
    this.paymentIntent,
    this.walletDonation,
    this.cardMessage,
    this.walletMessage,
    this.cardErrorType,
    this.walletErrorType,
  });

  const OrphanSupportFundState.initial()
    : cardStatus = OrphanSupportFundPaymentStatus.initial,
      walletStatus = OrphanSupportFundPaymentStatus.initial,
      paymentIntent = null,
      walletDonation = null,
      cardMessage = null,
      walletMessage = null,
      cardErrorType = null,
      walletErrorType = null;

  final OrphanSupportFundPaymentStatus cardStatus;
  final OrphanSupportFundPaymentStatus walletStatus;
  final OrphanSupportFundPaymentIntentModel? paymentIntent;
  final OrphanSupportFundWalletDonationModel? walletDonation;
  final String? cardMessage;
  final String? walletMessage;
  final OrphanSupportFundErrorType? cardErrorType;
  final OrphanSupportFundErrorType? walletErrorType;

  bool get isCardLoading =>
      cardStatus == OrphanSupportFundPaymentStatus.loading;

  bool get isWalletLoading =>
      walletStatus == OrphanSupportFundPaymentStatus.loading;

  bool get isAnyLoading => isCardLoading || isWalletLoading;

  OrphanSupportFundState copyWith({
    OrphanSupportFundPaymentStatus? cardStatus,
    OrphanSupportFundPaymentStatus? walletStatus,
    OrphanSupportFundPaymentIntentModel? paymentIntent,
    OrphanSupportFundWalletDonationModel? walletDonation,
    String? cardMessage,
    String? walletMessage,
    OrphanSupportFundErrorType? cardErrorType,
    OrphanSupportFundErrorType? walletErrorType,
    bool clearCardMessage = false,
    bool clearWalletMessage = false,
    bool clearCardError = false,
    bool clearWalletError = false,
  }) {
    return OrphanSupportFundState(
      cardStatus: cardStatus ?? this.cardStatus,
      walletStatus: walletStatus ?? this.walletStatus,
      paymentIntent: paymentIntent ?? this.paymentIntent,
      walletDonation: walletDonation ?? this.walletDonation,
      cardMessage: clearCardMessage ? null : cardMessage ?? this.cardMessage,
      walletMessage: clearWalletMessage
          ? null
          : walletMessage ?? this.walletMessage,
      cardErrorType: clearCardError
          ? null
          : cardErrorType ?? this.cardErrorType,
      walletErrorType: clearWalletError
          ? null
          : walletErrorType ?? this.walletErrorType,
    );
  }
}
