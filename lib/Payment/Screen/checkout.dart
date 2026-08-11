import 'package:charity_management/Payment/cubit/aid_request_payment_cubit.dart';
import 'package:charity_management/Payment/cubit/aid_request_payment_state.dart';
import 'package:charity_management/Payment/cubit/wallet_aid_request_donation_cubit.dart';
import 'package:charity_management/Payment/cubit/wallet_aid_request_donation_state.dart';
import 'package:charity_management/Donor/model/aid_request_details_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CheckoutPaymentMethod { card, wallet }

class WalletDonationCheckoutResult {
  const WalletDonationCheckoutResult({
    required this.balanceAfter,
    this.request,
  });

  final String balanceAfter;
  final AidRequestDetailsModel? request;
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.requestId,
    required this.title,
    required this.totalCost,
    required this.paidAmount,
    required this.remainingAmount,
    this.paymentMethod = CheckoutPaymentMethod.card,
    this.walletBalance = 0,
  });

  final int requestId;
  final String title;
  final String totalCost;
  final String paidAmount;
  final String remainingAmount;
  final CheckoutPaymentMethod paymentMethod;
  final double walletBalance;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final TextEditingController _amountController;
  final FocusNode _amountFocusNode = FocusNode();

  static const Color _backgroundColor = Color(0xFFFDFBF7);
  static const Color _primaryColor = Color(0xFF765A00);
  static const Color _accentColor = Color(0xFFF5D166);
  static const Color _textColor = Color(0xFF2B2D42);
  static const Color _mutedColor = Color(0xFF8A817C);
  static const Color _borderColor = Color(0xFFEFEAE4);

  @override
  void initState() {
    super.initState();
    final suggestedAmount = _remainingAmount >= 25 ? 25.0 : _remainingAmount;
    _amountController = TextEditingController(
      text: suggestedAmount > 0 ? _formatAmount(suggestedAmount) : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  double get _remainingAmount => _parseAmount(widget.remainingAmount);

  double get _enteredAmount =>
      double.tryParse(_amountController.text.trim()) ?? 0;

  bool get _isAmountValid =>
      _enteredAmount > 0 && _enteredAmount <= _remainingAmount;

  bool get _isWalletPayment =>
      widget.paymentMethod == CheckoutPaymentMethod.wallet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AidRequestPaymentCubit()),
        BlocProvider(create: (_) => WalletAidRequestDonationCubit()),
      ],
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Scaffold(
          backgroundColor: _backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: _primaryColor),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: Text(
              l10n.donationCheckoutTitle,
              style: const TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: _isWalletPayment
                ? BlocConsumer<
                    WalletAidRequestDonationCubit,
                    WalletAidRequestDonationState
                  >(
                    listener: (context, state) {
                      if (state is WalletAidRequestDonationSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.paymentCompletedRefresh)),
                        );
                        _amountController.clear();
                        Navigator.pop(
                          context,
                          WalletDonationCheckoutResult(
                            balanceAfter: state.donation.balanceAfter,
                            request: state.donation.request,
                          ),
                        );
                      }

                      if (state is WalletAidRequestDonationFailure) {
                        _showMessage(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      return _buildCheckoutContent(
                        context,
                        l10n,
                        state is WalletAidRequestDonationLoading,
                      );
                    },
                  )
                : BlocConsumer<AidRequestPaymentCubit, AidRequestPaymentState>(
                    listener: (context, state) {
                      if (state is AidRequestPaymentSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.paymentCompletedRefresh)),
                        );
                        Navigator.pop(context, true);
                      }

                      if (state is AidRequestPaymentCanceled) {
                        _showMessage(context, state.message);
                      }

                      if (state is AidRequestPaymentFailure) {
                        _showMessage(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      return _buildCheckoutContent(
                        context,
                        l10n,
                        state is AidRequestPaymentLoading,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutContent(
    BuildContext context,
    AppLocalizations l10n,
    bool isLoading,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequestSummary(l10n),
                const SizedBox(height: 24),
                _buildAmountField(l10n, isLoading),
                const SizedBox(height: 16),
                _buildPaymentNotice(l10n),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/orphan_profile.jpg',
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isLoading ? null : () => _submitPayment(context, l10n),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                disabledBackgroundColor: _accentColor.withValues(alpha: 0.55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: _primaryColor,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isWalletPayment
                              ? Icons.account_balance_wallet_outlined
                              : Icons.verified_user_outlined,
                          color: _primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l10n.completeDonation,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestSummary(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.aidRequestDonation,
            style: const TextStyle(
              color: _mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(
              color: _textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 28, color: _borderColor),
          _buildMoneyRow(l10n.requiredAmount, _currency(widget.totalCost)),
          _buildMoneyRow(l10n.amountCollected, _currency(widget.paidAmount)),
          _buildMoneyRow(
            l10n.amountRemaining,
            _currency(widget.remainingAmount),
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(AppLocalizations l10n, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.donationAmountUsd,
          style: const TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _amountController,
          focusNode: _amountFocusNode,
          enabled: !isLoading,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: l10n.donationAmountHint,
            prefixIcon: const Icon(Icons.attach_money, color: _primaryColor),
            suffixText: 'USD',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _accentColor, width: 1.5),
            ),
            errorText: _amountController.text.trim().isEmpty || _isAmountValid
                ? null
                : l10n.invalidDonationAmount,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentNotice(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5DD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, color: _primaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _isWalletPayment
                  ? _walletPaymentNotice(l10n)
                  : l10n.stripePaymentSheetNotice,
              style: const TextStyle(
                color: _primaryColor,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyRow(
    String title,
    String value, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: _mutedColor)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isHighlighted ? _primaryColor : const Color(0xFF3D523A),
            ),
          ),
        ],
      ),
    );
  }

  void _submitPayment(BuildContext context, AppLocalizations l10n) {
    _amountFocusNode.unfocus();

    if (!_isAmountValid) {
      _showMessage(context, l10n.invalidDonationAmount);
      setState(() {});
      return;
    }

    if (_isWalletPayment) {
      context.read<WalletAidRequestDonationCubit>().donate(
        requestId: widget.requestId,
        amount: _enteredAmount,
        remainingAmount: _remainingAmount,
        walletBalance: widget.walletBalance,
        localizations: l10n,
      );
      return;
    }

    context.read<AidRequestPaymentCubit>().payForAidRequest(
      requestId: widget.requestId,
      amount: _enteredAmount,
      remainingAmount: _remainingAmount,
      localizations: l10n,
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _currency(String value) => '${_formatAmount(_parseAmount(value))} USD';

  static double _parseAmount(String value) {
    final normalized = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  static String _formatAmount(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  String _walletPaymentNotice(AppLocalizations l10n) {
    if (l10n.localeName == 'ar') {
      return 'سيتم خصم مبلغ التبرع مباشرة من رصيد محفظتك.';
    }

    return 'The donation amount will be deducted directly from your wallet balance.';
  }
}
