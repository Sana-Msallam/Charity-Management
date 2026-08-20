import 'package:charity_management/Donor/zakat/cubit/zakat_cubit.dart';
import 'package:charity_management/Donor/zakat/cubit/zakat_state.dart';
import 'package:charity_management/Donor/zakat/model/zakat_result_model.dart';
import 'package:charity_management/Donor/zakat/model/zakat_type.dart';
import 'package:charity_management/Donor/zakat/service/zakat_service.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZakatCalculatorPage extends StatelessWidget {
  const ZakatCalculatorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ZakatCubit(
        ZakatService(),
      ),
      child: const _ZakatCalculatorView(),
    );
  }
}

class _ZakatCalculatorView extends StatefulWidget {
  const _ZakatCalculatorView();

  @override
  State<_ZakatCalculatorView> createState() {
    return _ZakatCalculatorViewState();
  }
}

class _ZakatCalculatorViewState
    extends State<_ZakatCalculatorView> {
  ZakatType? _selectedType;

  final GlobalKey _resultKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:
            AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l10n.zakatCalculator,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily:
                AppTextStyles.fontFamily,
          ),
        ),
      ),
      body: BlocConsumer<
          ZakatCubit,
          ZakatState>(
        listener: (
          context,
          state,
        ) {
          if (state is ZakatFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(
                      fontFamily:
                          AppTextStyles
                              .fontFamily,
                    ),
                  ),
                  backgroundColor:
                      AppColors.error,
                  behavior:
                      SnackBarBehavior
                          .floating,
                ),
              );
          }

          if (state is ZakatSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final BuildContext? resultContext =
                  _resultKey.currentContext;

              if (resultContext == null) {
                return;
              }

              Scrollable.ensureVisible(
                resultContext,
                duration: const Duration(
                  milliseconds: 500,
                ),
                curve: Curves.easeInOut,
                alignment: 0.08,
              );
            });
          }
        },
        builder: (
          context,
          state,
        ) {
          final bool isLoading =
              state is ZakatLoading;

          final ZakatResultModel? result =
              state is ZakatSuccess
                  ? state.result
                  : null;

          return SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                32,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  _buildConditionsCard(
                    l10n,
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  Text(
                    l10n.chooseZakatType,
                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .onSurface,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                      fontFamily:
                          AppTextStyles
                              .fontFamily,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    l10n.chooseZakatTypeHint,
                    style: TextStyle(
                      color: AppColors
                          .onSurface
                          .withValues(
                        alpha: 0.65,
                      ),
                      fontSize: 13,
                      height: 1.5,
                      fontFamily:
                          AppTextStyles
                              .fontFamily,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _buildZakatTypeCard(
                    type:
                        ZakatType.money,
                    title:
                        l10n.zakatMoney,
                    subtitle:
                        l10n.zakatMoneySubtitle,
                    icon:
                        Icons
                            .account_balance_wallet_outlined,
                    color:
                        AppColors.primary,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _buildZakatTypeCard(
                    type:
                        ZakatType.gold,
                    title:
                        l10n.zakatGold,
                    subtitle:
                        l10n.zakatGoldSubtitle,
                    icon:
                        Icons
                            .monetization_on_outlined,
                    color:
                        const Color(
                      0xFFD5A62A,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _buildZakatTypeCard(
                    type:
                        ZakatType.silver,
                    title:
                        l10n.zakatSilver,
                    subtitle:
                        l10n.zakatSilverSubtitle,
                    icon:
                        Icons
                            .diamond_outlined,
                    color:
                        AppColors.brandGray,
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  SizedBox(
                    height: 52,
                    child:
                        ElevatedButton(
                      onPressed:
                          _selectedType ==
                                      null ||
                                  isLoading
                              ? null
                              : () {
                                  _openCalculateSheet(
                                    context,
                                    _selectedType!,
                                  );
                                },
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            AppColors
                                .primary,
                        foregroundColor:
                            Colors.white,
                        disabledBackgroundColor:
                            AppColors
                                .brandGray
                                .withValues(
                          alpha: 0.25,
                        ),
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                                color:
                                    Colors
                                        .white,
                              ),
                            )
                          : Text(
                              l10n.calculateZakat,
                              style:
                                  const TextStyle(
                                fontSize:
                                    15,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontFamily:
                                    AppTextStyles
                                        .fontFamily,
                              ),
                            ),
                    ),
                  ),

                  if (result != null) ...[
                    const SizedBox(
                      height: 28,
                    ),
                    _buildResultCard(
                      result,
                      l10n,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConditionsCard(
    AppLocalizations l10n,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border:
            Border.all(
          color:
              AppColors.primary
                  .withValues(
            alpha: 0.12,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha: 0.025,
            ),
            blurRadius: 12,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(
                  color:
                      AppColors
                          .primaryContainer
                          .withValues(
                    alpha:
                        0.35,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                ),
                child:
                    const Icon(
                  Icons
                      .verified_outlined,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Text(
                  l10n.zakatConditionsTitle,
                  style:
                      const TextStyle(
                    color:
                        AppColors
                            .onSurface,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          _buildConditionItem(
            l10n.zakatConditionNisab,
          ),

          const SizedBox(
            height: 10,
          ),

          _buildConditionItem(
            l10n.zakatConditionOwnership,
          ),

          const SizedBox(
            height: 10,
          ),

          _buildConditionItem(
            l10n.zakatConditionYear,
          ),

          const SizedBox(
            height: 14,
          ),

          Container(
            padding:
                const EdgeInsets.all(
              12,
            ),
            decoration:
                BoxDecoration(
              color:
                  AppColors
                      .primaryContainer
                      .withValues(
                alpha: 0.16,
              ),
              borderRadius:
                  BorderRadius
                      .circular(
                12,
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                const Icon(
                  Icons
                      .info_outline_rounded,
                  size: 19,
                  color:
                      AppColors.primary,
                ),

                const SizedBox(
                  width: 8,
                ),

                Expanded(
                  child: Text(
                    l10n.zakatCalculatorDisclaimer,
                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .brandGray,
                      fontSize: 12,
                      height: 1.55,
                      fontFamily:
                          AppTextStyles
                              .fontFamily,
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

  Widget _buildConditionItem(
    String text,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:
              EdgeInsets.only(
            top: 2,
          ),
          child: Icon(
            Icons
                .check_circle_outline,
            size: 19,
            color:
                AppColors.primary,
          ),
        ),

        const SizedBox(
          width: 9,
        ),

        Expanded(
          child: Text(
            text,
            style:
                const TextStyle(
              color:
                  AppColors
                      .onSurface,
              fontSize: 13,
              height: 1.5,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZakatTypeCard({
    required ZakatType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final bool isSelected =
        _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType =
              type;
        });

        context
            .read<ZakatCubit>()
            .reset();
      },
      borderRadius:
          BorderRadius.circular(
        18,
      ),
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),
        padding:
            const EdgeInsets.all(
          16,
        ),
        decoration:
            BoxDecoration(
          color: isSelected
              ? color.withValues(
                  alpha: 0.08,
                )
              : AppColors.surface,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border:
              Border.all(
            color: isSelected
                ? color
                : AppColors
                    .brandGray
                    .withValues(
                  alpha: 0.12,
                ),
            width:
                isSelected
                    ? 1.5
                    : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(
                color:
                    color.withValues(
                  alpha: 0.1,
                ),
                borderRadius:
                    BorderRadius
                        .circular(
                  14,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .onSurface,
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .bold,
                      fontFamily:
                          AppTextStyles
                              .fontFamily,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      color:
                          AppColors
                              .brandGray,
                      fontSize: 12,
                      height: 1.4,
                      fontFamily:
                          AppTextStyles
                              .fontFamily,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            Icon(
              isSelected
                  ? Icons
                      .radio_button_checked
                  : Icons
                      .radio_button_off,
              color: isSelected
                  ? color
                  : AppColors
                      .brandGray,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCalculateSheet(
    BuildContext pageContext,
    ZakatType type,
  ) async {
    final AppLocalizations l10n =
        AppLocalizations.of(
      pageContext,
    );

    final TextEditingController
        amountController =
        TextEditingController();

    final TextEditingController
        gramPriceController =
        TextEditingController();

    final GlobalKey<FormState>
        formKey =
        GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
      builder: (
        sheetContext,
      ) {
        return Padding(
          padding:
              EdgeInsets.only(
            bottom: MediaQuery.of(
              sheetContext,
            ).viewInsets.bottom,
          ),
          child: Container(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              26,
            ),
            decoration:
                const BoxDecoration(
              color:
                  AppColors.surface,
              borderRadius:
                  BorderRadius.vertical(
                top:
                    Radius.circular(
                  28,
                ),
              ),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize
                          .min,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getSheetTitle(
                              type,
                              l10n,
                            ),
                            style:
                                const TextStyle(
                              color:
                                  AppColors
                                      .onSurface,
                              fontSize:
                                  19,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontFamily:
                                  AppTextStyles
                                      .fontFamily,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.of(
                              sheetContext,
                            ).pop();
                          },
                          icon:
                              const Icon(
                            Icons
                                .close_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      _getSheetDescription(
                        type,
                        l10n,
                      ),
                      style:
                          const TextStyle(
                        color:
                            AppColors
                                .brandGray,
                        fontSize: 13,
                        height: 1.55,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
                      ),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    _buildNumberField(
                      controller:
                          amountController,
                      label:
                          _getAmountLabel(
                        type,
                        l10n,
                      ),
                      suffixText:
                          type == ZakatType.money
                              ? r'$'
                              : null,
                      validator:
                          (
                        value,
                      ) {
                        final double?
                            parsed =
                            double
                                .tryParse(
                          value?.trim() ??
                              '',
                        );

                        if (parsed ==
                                null ||
                            parsed <= 0) {
                          return l10n
                              .zakatValidAmountRequired;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildNumberField(
                      controller:
                          gramPriceController,
                      label:
                          _getGramPriceLabel(
                        type,
                        l10n,
                      ),
                      suffixText: r'$',
                      validator:
                          (
                        value,
                      ) {
                        final double?
                            parsed =
                            double
                                .tryParse(
                          value?.trim() ??
                              '',
                        );

                        if (parsed ==
                                null ||
                            parsed <= 0) {
                          return l10n
                              .zakatValidGramPriceRequired;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    SizedBox(
                      height: 50,
                      child:
                          ElevatedButton(
                        onPressed:
                            () async {
                          if (!(formKey
                                  .currentState
                                  ?.validate() ??
                              false)) {
                            return;
                          }

                          final double
                              amount =
                              double.parse(
                            amountController
                                .text
                                .trim(),
                          );

                          final double
                              gramPrice =
                              double.parse(
                            gramPriceController
                                .text
                                .trim(),
                          );

                          Navigator.of(
                            sheetContext,
                          ).pop();

                          await pageContext
                              .read<
                                  ZakatCubit>()
                              .calculate(
                                type:
                                    type,
                                amount:
                                    amount,
                                gramPrice:
                                    gramPrice,
                                localizations:
                                    AppLocalizations.of(
                                  pageContext,
                                ),
                              );
                        },
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              AppColors
                                  .primary,
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                        ),
                        child: Text(
                          l10n.calculateZakat,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                            fontFamily:
                                AppTextStyles
                                    .fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

  }

  Widget _buildNumberField({
    required TextEditingController
        controller,
    required String label,
    String? suffixText,
    required String? Function(
      String?,
    ) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
          const TextInputType
              .numberWithOptions(
        decimal: true,
      ),
      validator: validator,
      style:
          const TextStyle(
        color:
            AppColors.onSurface,
        fontFamily:
            AppTextStyles.fontFamily,
      ),
      decoration:
          InputDecoration(
        labelText: label,
        suffixText: suffixText,
        suffixStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontFamily: AppTextStyles.fontFamily,
        ),
        filled: true,
        fillColor:
            AppColors.background,
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide.none,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide(
            color:
                AppColors.brandGray
                    .withValues(
              alpha: 0.14,
            ),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    ZakatResultModel result,
    AppLocalizations l10n,
  ) {
    final bool eligible =
        result.eligible;

    return Container(
      key: _resultKey,
      padding:
          const EdgeInsets.all(
        20,
      ),
      decoration:
          BoxDecoration(
        color:
            AppColors.surface,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border:
            Border.all(
          color: eligible
              ? AppColors.primary
                  .withValues(
                  alpha: 0.18,
                )
              : AppColors.brandGray
                  .withValues(
                  alpha: 0.15,
                ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration:
                BoxDecoration(
              color: eligible
                  ? AppColors
                      .primaryContainer
                      .withValues(
                      alpha: 0.35,
                    )
                  : AppColors
                      .brandGray
                      .withValues(
                      alpha: 0.1,
                    ),
              shape:
                  BoxShape.circle,
            ),
            child: Icon(
              eligible
                  ? Icons
                      .check_circle_outline_rounded
                  : Icons
                      .info_outline_rounded,
              color: eligible
                  ? AppColors.primary
                  : AppColors
                      .brandGray,
              size: 32,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            eligible
                ? l10n.zakatDueTitle
                : l10n.zakatNotDueTitle,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  AppColors
                      .onSurface,
              fontSize: 19,
              fontWeight:
                  FontWeight.bold,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          if (result.message
              .trim()
              .isNotEmpty)
            Text(
              result.message,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color:
                    AppColors
                        .brandGray,
                fontSize: 13,
                height: 1.55,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),

          const SizedBox(
            height: 20,
          ),

          _buildResultRow(
            l10n.zakatTypeLabel,
            _localizedTypeName(
              result.type,
              l10n,
            ),
          ),

          _buildResultRow(
            l10n.zakatAssetValue,
            '${_currencySymbol(result.currency)}${_formatNumber(result.assetValue)}',
          ),

          _buildResultRow(
            l10n.zakatNisabValue,
            _formatNisabValue(result),
          ),

          _buildResultRow(
            l10n.zakatRateLabel,
            '${_formatNumber(result.zakatPercentage)}%',
          ),

          const Divider(
            height: 28,
          ),

          _buildResultRow(
            l10n.zakatDueAmount,
            '${_currencySymbol(result.currency)}${_formatNumber(result.zakatDue)}',
            highlight: true,
          ),

          const SizedBox(
            height: 20,
          ),

          OutlinedButton(
            onPressed: () {
              context
                  .read<ZakatCubit>()
                  .reset();

              setState(() {
                _selectedType =
                    null;
              });
            },
            style:
                OutlinedButton
                    .styleFrom(
              foregroundColor:
                  AppColors.primary,
              side:
                  const BorderSide(
                color:
                    AppColors.primary,
              ),
              padding:
                  const EdgeInsets
                      .symmetric(
                vertical: 14,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                  14,
                ),
              ),
            ),
            child: Text(
              l10n.calculateAgain,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  TextStyle(
                color:
                    AppColors
                        .brandGray,
                fontSize: 13,
                fontWeight:
                    highlight
                        ? FontWeight
                            .bold
                        : FontWeight
                            .normal,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),
          ),
          Text(
            value,
            style:
                TextStyle(
              color: highlight
                  ? AppColors.primary
                  : AppColors
                      .onSurface,
              fontSize:
                  highlight
                      ? 16
                      : 13,
              fontWeight:
                  FontWeight.bold,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  String _getSheetTitle(
    ZakatType type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case ZakatType.money:
        return l10n.zakatMoneyInputTitle;

      case ZakatType.gold:
        return l10n.zakatGoldInputTitle;

      case ZakatType.silver:
        return l10n.zakatSilverInputTitle;
    }
  }

  String _getSheetDescription(
    ZakatType type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case ZakatType.money:
        return l10n.zakatMoneyInputDescription;

      case ZakatType.gold:
        return l10n.zakatGoldInputDescription;

      case ZakatType.silver:
        return l10n.zakatSilverInputDescription;
    }
  }

  String _getAmountLabel(
    ZakatType type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case ZakatType.money:
        return l10n.moneyAmount;

      case ZakatType.gold:
        return l10n.goldWeight;

      case ZakatType.silver:
        return l10n.silverWeight;
    }
  }

  String _getGramPriceLabel(
    ZakatType type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case ZakatType.money:
      case ZakatType.gold:
        return l10n.goldGramPriceToday;

      case ZakatType.silver:
        return l10n.silverGramPriceToday;
    }
  }

  String _localizedTypeName(
    String type,
    AppLocalizations l10n,
  ) {
    switch (type
        .trim()
        .toUpperCase()) {
      case 'MONEY':
        return l10n.zakatMoney;

      case 'GOLD':
        return l10n.zakatGold;

      case 'SILVER':
        return l10n.zakatSilver;

      default:
        return type;
    }
  }

  String _currencySymbol(
    String currency,
  ) {
    if (currency.trim().toUpperCase() == 'USD') {
      return r'$';
    }

    return '${currency.trim()} ';
  }

  String _formatNisabValue(
    ZakatResultModel result,
  ) {
    final String unit =
        result.nisabUnit.trim().toUpperCase();

    if (unit == 'USD') {
      return '${_currencySymbol('USD')}${_formatNumber(result.nisabAmount)}';
    }

    if (unit == 'GRAMS') {
      return '${_formatNumber(result.nisabAmount)} g';
    }

    return '${_formatNumber(result.nisabAmount)} ${result.nisabUnit}';
  }

  String _formatNumber(
    double value,
  ) {
    if (value ==
        value.roundToDouble()) {
      return value
          .toStringAsFixed(
        0,
      );
    }

    return value
        .toStringAsFixed(
      2,
    );
  }
}