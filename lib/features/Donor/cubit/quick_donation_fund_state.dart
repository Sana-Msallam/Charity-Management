import 'package:charity_management/features/Donor/model/quick_donation_fund_payment_intent_model.dart';
import 'package:charity_management/features/Donor/model/quick_donation_fund_wallet_donation_model.dart';

enum QuickDonationFundPaymentStatus {
  initial,
  loading,
  success,
  failure,
  canceled,
}

enum QuickDonationFundErrorType {
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

class QuickDonationFundState {
  const QuickDonationFundState({
    required this.cardStatus,
    required this.walletStatus,
    this.paymentIntent,
    this.walletDonation,
    this.cardMessage,
    this.walletMessage,
    this.cardErrorType,
    this.walletErrorType,
  });

  const QuickDonationFundState.initial()
    : cardStatus = QuickDonationFundPaymentStatus.initial,
      walletStatus = QuickDonationFundPaymentStatus.initial,
      paymentIntent = null,
      walletDonation = null,
      cardMessage = null,
      walletMessage = null,
      cardErrorType = null,
      walletErrorType = null;

  final QuickDonationFundPaymentStatus cardStatus;
  final QuickDonationFundPaymentStatus walletStatus;
  final QuickDonationFundPaymentIntentModel? paymentIntent;
  final QuickDonationFundWalletDonationModel? walletDonation;
  final String? cardMessage;
  final String? walletMessage;
  final QuickDonationFundErrorType? cardErrorType;
  final QuickDonationFundErrorType? walletErrorType;

  bool get isCardLoading =>
      cardStatus == QuickDonationFundPaymentStatus.loading;

  bool get isWalletLoading =>
      walletStatus == QuickDonationFundPaymentStatus.loading;

  bool get isAnyLoading => isCardLoading || isWalletLoading;

  QuickDonationFundState copyWith({
    QuickDonationFundPaymentStatus? cardStatus,
    QuickDonationFundPaymentStatus? walletStatus,
    QuickDonationFundPaymentIntentModel? paymentIntent,
    QuickDonationFundWalletDonationModel? walletDonation,
    String? cardMessage,
    String? walletMessage,
    QuickDonationFundErrorType? cardErrorType,
    QuickDonationFundErrorType? walletErrorType,
    bool clearCardMessage = false,
    bool clearWalletMessage = false,
    bool clearCardError = false,
    bool clearWalletError = false,
  }) {
    return QuickDonationFundState(
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
