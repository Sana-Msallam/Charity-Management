import 'package:charity_management/Payment/model/aid_request_payment_intent_model.dart';
import 'package:charity_management/Payment/model/wallet_balance_model.dart';

enum WalletBalanceStatus { initial, loading, success, failure }

enum WalletTopUpStatus { initial, loading, success, failure }

enum WalletTopUpErrorType {
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

class WalletTopUpState {
  const WalletTopUpState({
    required this.balanceStatus,
    required this.topUpStatus,
    this.balance,
    this.paymentIntent,
    this.balanceErrorMessage,
    this.balanceErrorType,
    this.topUpMessage,
    this.topUpErrorType,
  });

  const WalletTopUpState.initial()
    : balanceStatus = WalletBalanceStatus.initial,
      topUpStatus = WalletTopUpStatus.initial,
      balance = null,
      paymentIntent = null,
      balanceErrorMessage = null,
      balanceErrorType = null,
      topUpMessage = null,
      topUpErrorType = null;

  final WalletBalanceStatus balanceStatus;
  final WalletTopUpStatus topUpStatus;
  final WalletBalanceModel? balance;
  final AidRequestPaymentIntentModel? paymentIntent;
  final String? balanceErrorMessage;
  final WalletTopUpErrorType? balanceErrorType;
  final String? topUpMessage;
  final WalletTopUpErrorType? topUpErrorType;

  bool get isBalanceLoading => balanceStatus == WalletBalanceStatus.loading;

  bool get isTopUpLoading => topUpStatus == WalletTopUpStatus.loading;

  WalletTopUpState copyWith({
    WalletBalanceStatus? balanceStatus,
    WalletTopUpStatus? topUpStatus,
    WalletBalanceModel? balance,
    AidRequestPaymentIntentModel? paymentIntent,
    String? balanceErrorMessage,
    WalletTopUpErrorType? balanceErrorType,
    String? topUpMessage,
    WalletTopUpErrorType? topUpErrorType,
    bool clearBalanceError = false,
    bool clearTopUpError = false,
    bool clearTopUpMessage = false,
  }) {
    return WalletTopUpState(
      balanceStatus: balanceStatus ?? this.balanceStatus,
      topUpStatus: topUpStatus ?? this.topUpStatus,
      balance: balance ?? this.balance,
      paymentIntent: paymentIntent ?? this.paymentIntent,
      balanceErrorMessage: clearBalanceError
          ? null
          : balanceErrorMessage ?? this.balanceErrorMessage,
      balanceErrorType: clearBalanceError
          ? null
          : balanceErrorType ?? this.balanceErrorType,
      topUpMessage: clearTopUpMessage
          ? null
          : topUpMessage ?? this.topUpMessage,
      topUpErrorType: clearTopUpError
          ? null
          : topUpErrorType ?? this.topUpErrorType,
    );
  }
}
