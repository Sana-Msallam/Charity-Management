import 'package:charity_management/Payment/cubit/wallet_top_up_cubit.dart';
import 'package:charity_management/Payment/cubit/wallet_top_up_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletTopUpScreen extends StatefulWidget {
  const WalletTopUpScreen({super.key, this.currency = 'USD'});

  final String currency;

  @override
  State<WalletTopUpScreen> createState() => _WalletTopUpScreenState();
}

class _WalletTopUpScreenState extends State<WalletTopUpScreen> {
  static const _backgroundColor = Color(0xFFFDFBF7);
  static const _primaryColor = Color(0xFF765A00);
  static const _darkGreen = Color(0xFF3A5A40);
  static const _lightGreen = Color(0xFFD2E794);
  static const _yellow = Color(0xFFF5D166);
  static const _borderColor = Color(0xFFE9E1D7);
  static const _secondaryTextColor = Color(0xFF8A817C);

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  final List<double> _suggestedAmounts = const [10, 25, 50, 100];
  double? _selectedAmount;

  bool get _isArabic =>
      Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

  String _text(String arabic, String english) => _isArabic ? arabic : english;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectAmount(double amount, bool isLoading) {
    if (isLoading) {
      return;
    }

    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toStringAsFixed(0);
      _amountController.selection = TextSelection.collapsed(
        offset: _amountController.text.length,
      );
    });
  }

  void _onAmountChanged(String value) {
    final amount = double.tryParse(value);
    setState(() {
      _selectedAmount = _suggestedAmounts.contains(amount) ? amount : null;
    });
  }

  String? _validateAmount(String? value) {
    final amount = double.tryParse(value ?? '');

    if (amount == null || amount <= 0) {
      return _text('أدخل مبلغًا صحيحًا', 'Enter a valid amount');
    }

    if (amount < 1) {
      return _text(
        'الحد الأدنى للشحن هو 1 دولار',
        'The minimum top-up amount is 1 USD',
      );
    }

    return null;
  }

  void _continueToPayment(
    BuildContext context,
    AppLocalizations localizations,
    bool isLoading,
  ) {
    if (isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    context.read<WalletTopUpCubit>().topUpWallet(
      amount: amount,
      localizations: localizations,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) =>
          WalletTopUpCubit()..fetchBalance(localizations: localizations),
      child: BlocConsumer<WalletTopUpCubit, WalletTopUpState>(
        listenWhen: (previous, current) =>
            previous.topUpStatus != current.topUpStatus,
        listener: (context, state) {
          if (state.topUpStatus == WalletTopUpStatus.success) {
            _showMessage(
              context,
              _text(
                'تمت عملية الدفع بنجاح، وسيتم تحديث الرصيد بعد تأكيد العملية',
                'Payment completed successfully. The balance will update after confirmation.',
              ),
              backgroundColor: _darkGreen,
            );
          }

          if (state.topUpStatus == WalletTopUpStatus.failure) {
            _showMessage(
              context,
              state.topUpMessage ?? localizations.unexpectedError,
              backgroundColor:
                  state.topUpErrorType == WalletTopUpErrorType.canceled
                  ? _darkGreen
                  : Colors.redAccent,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.isTopUpLoading;
          final enteredAmount = double.tryParse(_amountController.text) ?? 0;
          final currency = state.balance?.currency ?? widget.currency;

          return Scaffold(
            backgroundColor: _backgroundColor,
            appBar: AppBar(
              backgroundColor: _backgroundColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                onPressed: isLoading ? null : () => Navigator.maybePop(context),
                icon: Icon(
                  _isArabic
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios_new,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              title: Text(
                _text('شحن المحفظة', 'Top up wallet'),
                style: const TextStyle(
                  color: _primaryColor,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  children: [
                    _buildBalanceCard(context, state, localizations),
                    const SizedBox(height: 28),
                    _buildSectionTitle(
                      _text('اختر مبلغ الشحن', 'Choose top-up amount'),
                    ),
                    const SizedBox(height: 12),
                    _buildAmountField(isLoading, currency),
                    const SizedBox(height: 14),
                    _buildSuggestedAmounts(isLoading),
                    const SizedBox(height: 28),
                    _buildSectionTitle(_text('طريقة الدفع', 'Payment method')),
                    const SizedBox(height: 12),
                    _buildPaymentMethodCard(),
                    const SizedBox(height: 24),
                    _buildSummaryCard(enteredAmount, currency),
                    const SizedBox(height: 22),
                    _buildContinueButton(context, localizations, isLoading),
                    const SizedBox(height: 14),
                    _buildSecurityNote(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    WalletTopUpState state,
    AppLocalizations localizations,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE2F0B9), _lightGreen],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.62),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: _darkGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _text('رصيد المحفظة', 'Wallet balance'),
                  style: const TextStyle(
                    color: Color(0xFF5D754C),
                    fontSize: 13,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                const SizedBox(height: 5),
                _buildBalanceContent(context, state, localizations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceContent(
    BuildContext context,
    WalletTopUpState state,
    AppLocalizations localizations,
  ) {
    if (state.balanceStatus == WalletBalanceStatus.loading) {
      return Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: _darkGreen,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              _text('جاري جلب الرصيد...', 'Loading balance...'),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF384D2B),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
      );
    }

    if (state.balanceStatus == WalletBalanceStatus.failure) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.balanceErrorMessage ??
                _text('تعذر جلب الرصيد', 'Could not load balance'),
            style: const TextStyle(
              color: Color(0xFF384D2B),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: state.isBalanceLoading
                ? null
                : () => context.read<WalletTopUpCubit>().fetchBalance(
                    localizations: localizations,
                    force: true,
                  ),
            style: TextButton.styleFrom(
              foregroundColor: _primaryColor,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              _text('إعادة المحاولة', 'Retry'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
      );
    }

    final balance = state.balance;
    if (state.balanceStatus == WalletBalanceStatus.success && balance != null) {
      return Text(
        '${balance.balance} ${balance.currency}',
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          color: Color(0xFF384D2B),
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'IBM Plex Sans Arabic',
        ),
      );
    }

    return Text(
      _text('الرصيد غير متاح حاليًا', 'Balance is currently unavailable'),
      style: const TextStyle(
        color: Color(0xFF384D2B),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'IBM Plex Sans Arabic',
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'IBM Plex Sans Arabic',
      ),
    );
  }

  Widget _buildAmountField(bool isLoading, String currency) {
    return TextFormField(
      controller: _amountController,
      enabled: !isLoading,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      validator: _validateAmount,
      onChanged: _onAmountChanged,
      style: const TextStyle(
        color: Color(0xFF3F3834),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: '0.00',
        hintStyle: const TextStyle(color: Color(0xFFB7AEA8)),
        suffixText: currency,
        suffixStyle: const TextStyle(
          color: _primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: const Icon(
          Icons.attach_money_rounded,
          color: _primaryColor,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _borderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _yellow, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildSuggestedAmounts(bool isLoading) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _suggestedAmounts.map((amount) {
        final isSelected = _selectedAmount == amount;

        return ChoiceChip(
          selected: isSelected,
          showCheckmark: false,
          onSelected: isLoading
              ? null
              : (_) => _selectAmount(amount, isLoading),
          backgroundColor: Colors.white,
          selectedColor: _yellow,
          disabledColor: const Color(0xFFF7F2EA),
          side: BorderSide(color: isSelected ? _primaryColor : _borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          label: Text(
            '\$${amount.toStringAsFixed(0)}',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: isSelected ? _primaryColor : _secondaryTextColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _yellow, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D765A00),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6D8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.credit_card_rounded,
              color: _primaryColor,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _text('بطاقة بنكية', 'Bank card'),
                  style: const TextStyle(
                    color: Color(0xFF3F3834),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _text(
                    'Visa أو Mastercard عبر Stripe',
                    'Visa or Mastercard via Stripe',
                  ),
                  style: const TextStyle(
                    color: _secondaryTextColor,
                    fontSize: 12,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: _primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(double amount, String currency) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2EA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            _text('مبلغ الشحن', 'Top-up amount'),
            '${amount.toStringAsFixed(2)} $currency',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFE1D8CE)),
          ),
          _buildSummaryRow(
            _text('الإجمالي', 'Total'),
            '${amount.toStringAsFixed(2)} $currency',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? _primaryColor : _secondaryTextColor,
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        Text(
          value,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: isTotal ? _primaryColor : const Color(0xFF3F3834),
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(
    BuildContext context,
    AppLocalizations localizations,
    bool isLoading,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: isLoading
            ? null
            : () => _continueToPayment(context, localizations, isLoading),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          disabledBackgroundColor: _primaryColor.withValues(alpha: 0.55),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.lock_outline_rounded, size: 20),
        label: Text(
          isLoading
              ? _text('جاري فتح الدفع...', 'Opening payment...')
              : _text('متابعة للدفع الآمن', 'Continue to secure payment'),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.verified_user_outlined, color: _darkGreen, size: 17),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            _text(
              'بيانات بطاقتك تُعالج بأمان بواسطة Stripe',
              'Your card details are securely processed by Stripe',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _secondaryTextColor,
              fontSize: 11,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ),
      ],
    );
  }

  void _showMessage(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
