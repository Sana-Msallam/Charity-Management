import 'package:charity_management/features/Beneficiary/request_tracking/model/request_tracking_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';

class RequestTrackingCard extends StatelessWidget {
  const RequestTrackingCard({
    super.key,
    required this.request,
    required this.onEdit,
    required this.onCancel,
  });

  final RequestTrackingModel request;

  final VoidCallback onEdit;

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final _StatusStyle statusStyle =
        _getStatusStyle();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: AppColors.brandGray.withOpacity(
            0.10,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.03,
            ),
            blurRadius: 14,
            offset: const Offset(
              0,
              5,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ==========================================
          // HEADER
          // ==========================================

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      l10n.requestNumber(
                        request.id,
                      ),
                      style: const TextStyle(
                        color:
                            AppColors.onSurface,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
                      ),
                    ),

                    if (request.isUrgent ==
                        true) ...[
                      const SizedBox(
                        width: 8,
                      ),

                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration:
                            BoxDecoration(
                          color: AppColors.error
                              .withOpacity(
                            0.10,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),
                        child: Text(
                          l10n.urgent,
                          style:
                              const TextStyle(
                            color:
                                AppColors.error,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                            fontFamily:
                                AppTextStyles
                                    .fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ========================================
              // STATUS
              // ========================================

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      statusStyle.background,
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      statusStyle.icon,
                      size: 15,
                      color: statusStyle.color,
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Text(
                      _localizedStatus(
                        l10n,
                      ),
                      style: TextStyle(
                        color:
                            statusStyle.color,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w700,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          // ==========================================
          // CATEGORY
          // ==========================================

          _buildMainInfoRow(
            icon: _getCategoryIcon(),
            title: l10n.requestType,
            value: request.category.name
                    .trim()
                    .isEmpty
                ? l10n.unspecified
                : request.category.name,
          ),

          // ==========================================
          // SUB CATEGORY
          // ==========================================

          if (request.subCategory !=
              null) ...[
            const SizedBox(
              height: 12,
            ),

            _buildMainInfoRow(
              icon:
                  Icons.category_outlined,
              title: l10n.subCategory,
              value: request
                      .subCategory!
                      .name
                      .trim()
                      .isEmpty
                  ? l10n.unspecified
                  : request
                      .subCategory!
                      .name,
            ),
          ],

          // ==========================================
          // AID TYPE
          // ==========================================

          if (_hasTypeAid()) ...[
            const SizedBox(
              height: 12,
            ),

            _buildMainInfoRow(
              icon: Icons
                  .volunteer_activism_outlined,
              title: l10n.aidType,
              value:
                  _typeAidDisplayValue(
                l10n,
              ),
            ),
          ],

          const SizedBox(
            height: 18,
          ),

          Divider(
            height: 1,
            color: AppColors.brandGray
                .withOpacity(
              0.08,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          // ==========================================
          // COST + DATE
          // ==========================================

          Row(
            children: [
              Expanded(
                child: _buildValueBox(
                  icon:
                      Icons.payments_outlined,
                  title: l10n.cost,
                  value:
                      l10n.amountRiyal(
                    request.cost
                        .toStringAsFixed(
                      0,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: _buildValueBox(
                  icon: Icons
                      .calendar_today_outlined,
                  title:
                      l10n.submissionDate,
                  value: _formatDate(
                    request.createdAt,
                    l10n,
                  ),
                ),
              ),
            ],
          ),

          // ==========================================
          // ACCEPTED
          // ==========================================

          if (request.isAccepted) ...[
            const SizedBox(
              height: 20,
            ),

            _buildPaymentProgress(
              l10n,
            ),
          ],

          // ==========================================
          // REJECTED
          // ==========================================

          if (request.isRejected) ...[
            const SizedBox(
              height: 20,
            ),

            _buildRejectionReason(
              l10n,
            ),
          ],

          // ==========================================
          // CANCELLED
          // ==========================================

          if (request.isCancelled) ...[
            const SizedBox(
              height: 20,
            ),

            _buildCancelledMessage(
              l10n,
            ),
          ],

          // ==========================================
          // PENDING
          // ==========================================

          if (request.isPending) ...[
            const SizedBox(
              height: 22,
            ),

            _buildPendingActions(
              l10n,
            ),
          ],
        ],
      ),
    );
  }

  // =================================================
  // LOCALIZED STATUS
  // =================================================

  String _localizedStatus(
    AppLocalizations l10n,
  ) {
    switch (
        request.status.toUpperCase()) {
      case 'PENDING':
        return l10n.pendingRequests;

      case 'ACCEPTED':
        return l10n.acceptedRequests;

      case 'REJECTED':
        return l10n.rejectedRequests;

      case 'CANCELLED':
        return l10n.cancelledRequests;

      default:
        return request.status.trim().isEmpty
            ? l10n.unspecified
            : request.status;
    }
  }

  // =================================================
  // PENDING BUTTONS
  // =================================================

  Widget _buildPendingActions(
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        // ============================================
        // EDIT
        // ============================================

        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  AppColors.primary,
              side: BorderSide(
                color: AppColors.primary
                    .withOpacity(
                  0.35,
                ),
              ),
              minimumSize:
                  const Size(
                double.infinity,
                50,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
            ),
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
            ),
            label: Text(
              l10n.editRequest,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
                fontFamily:
                    AppTextStyles.fontFamily,
              ),
            ),
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        // ============================================
        // CANCEL
        // ============================================

        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCancel,
            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  AppColors.error,
              side: BorderSide(
                color: AppColors.error
                    .withOpacity(
                  0.30,
                ),
              ),
              minimumSize:
                  const Size(
                double.infinity,
                50,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
            ),
            icon: const Icon(
              Icons.close_rounded,
              size: 19,
            ),
            label: Text(
              l10n.cancelRequestTitle,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
                fontFamily:
                    AppTextStyles.fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =================================================
  // ACCEPTED PAYMENT PROGRESS
  // =================================================

  Widget _buildPaymentProgress(
    AppLocalizations l10n,
  ) {
    final int percentage =
        request.paymentPercentage.round();

    final String currentAmount =
        request.currentPayment
            .toStringAsFixed(
      0,
    );

    final String totalAmount =
        request.cost.toStringAsFixed(
      0,
    );

    final String remaining =
        request.remainingAmount
            .toStringAsFixed(
      0,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color:
            AppColors.secondary.withOpacity(
          0.07,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              AppColors.secondary.withOpacity(
            0.14,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons
                    .account_balance_wallet_outlined,
                color:
                    AppColors.secondary,
                size: 20,
              ),

              const SizedBox(
                width: 8,
              ),

              Text(
                l10n.fundingProgress,
                style: const TextStyle(
                  color:
                      AppColors.onSurface,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.fundingAmountOf(
                    currentAmount,
                    totalAmount,
                  ),
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color:
                        AppColors.secondary,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.bold,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              Text(
                '$percentage%',
                textDirection:
                    TextDirection.ltr,
                style: const TextStyle(
                  color:
                      AppColors.primary,
                  fontSize: 13,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              100,
            ),
            child:
                LinearProgressIndicator(
              value:
                  request.paymentProgress,
              minHeight: 8,
              backgroundColor:
                  AppColors.brandGray
                      .withOpacity(
                0.10,
              ),
              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                AppColors.secondary,
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            l10n.remainingAmount(
              l10n.amountRiyal(
                remaining,
              ),
            ),
            style: const TextStyle(
              color:
                  AppColors.brandGray,
              fontSize: 12,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  // =================================================
  // REJECTION
  // =================================================

  Widget _buildRejectionReason(
    AppLocalizations l10n,
  ) {
    final String? rejectionReason =
        request.rejectionReason
            ?.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        15,
      ),
      decoration: BoxDecoration(
        color:
            AppColors.error.withOpacity(
          0.05,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
              AppColors.error.withOpacity(
            0.12,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.error,
            size: 21,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rejectionReason,
                  style:
                      const TextStyle(
                    color:
                        AppColors.error,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.bold,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  rejectionReason == null ||
                          rejectionReason
                              .isEmpty
                      ? l10n
                          .noRejectionReason
                      : rejectionReason,
                  style:
                      const TextStyle(
                    color: AppColors
                        .onSurface,
                    fontSize: 13,
                    height: 1.6,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =================================================
  // CANCELLED
  // =================================================

  Widget _buildCancelledMessage(
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        14,
      ),
      decoration: BoxDecoration(
        color: AppColors.brandGray
            .withOpacity(
          0.06,
        ),
        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cancel_outlined,
            color:
                AppColors.brandGray,
            size: 20,
          ),

          const SizedBox(
            width: 9,
          ),

          Expanded(
            child: Text(
              l10n.requestWasCancelled,
              style:
                  const TextStyle(
                color:
                    AppColors.brandGray,
                fontSize: 13,
                fontWeight:
                    FontWeight.w500,
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

  // =================================================
  // MAIN INFO ROW
  // =================================================

  Widget _buildMainInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors
                .primaryContainer
                .withOpacity(
              0.30,
            ),
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),
          child: Icon(
            icon,
            color:
                AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      AppColors.brandGray,
                  fontSize: 11,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                value,
                style:
                    const TextStyle(
                  color:
                      AppColors.onSurface,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =================================================
  // VALUE BOX
  // =================================================

  Widget _buildValueBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                AppColors.primary,
            size: 19,
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    color: AppColors
                        .brandGray,
                    fontSize: 10,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color: AppColors
                        .onSurface,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =================================================
  // HAS TYPE AID
  // =================================================

  bool _hasTypeAid() {
    if (request.typeAid == null) {
      return false;
    }

    return request.typeAid
        .toString()
        .trim()
        .isNotEmpty;
  }

  // =================================================
  // TYPE AID DISPLAY
  // =================================================

  String _typeAidDisplayValue(
    AppLocalizations l10n,
  ) {
    final String value =
        request.typeAid
                ?.toString()
                .trim() ??
            '';

    if (value.isEmpty) {
      return l10n.unspecified;
    }

    return value;
  }

  // =================================================
  // FORMAT DATE
  // =================================================

  String _formatDate(
    DateTime? date,
    AppLocalizations l10n,
  ) {
    if (date == null) {
      return l10n.unspecified;
    }

    final String day =
        date.day
            .toString()
            .padLeft(
              2,
              '0',
            );

    final String month =
        date.month
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$day/$month/${date.year}';
  }

  // =================================================
  // CATEGORY ICON
  // =================================================

  IconData _getCategoryIcon() {
    switch (request.category.id) {
      case 1:
        return Icons
            .medical_services_outlined;

      case 2:
        return Icons
            .shopping_basket_outlined;

      case 3:
        return Icons.home_outlined;

      case 4:
        return Icons
            .auto_stories_outlined;

      case 5:
        return Icons.trending_up;

      default:
        return Icons
            .volunteer_activism_outlined;
    }
  }

  // =================================================
  // STATUS STYLE
  // =================================================

  _StatusStyle _getStatusStyle() {
    if (request.isPending) {
      return _StatusStyle(
        color:
            const Color(0xFFB18424),
        background:
            const Color(0xFFB18424)
                .withOpacity(
          0.10,
        ),
        icon:
            Icons.schedule_rounded,
      );
    }

    if (request.isAccepted) {
      return _StatusStyle(
        color:
            AppColors.secondary,
        background:
            AppColors.secondary
                .withOpacity(
          0.10,
        ),
        icon: Icons
            .check_circle_outline_rounded,
      );
    }

    if (request.isRejected) {
      return _StatusStyle(
        color: AppColors.error,
        background:
            AppColors.error
                .withOpacity(
          0.08,
        ),
        icon: Icons
            .highlight_off_rounded,
      );
    }

    return _StatusStyle(
      color: AppColors.brandGray,
      background:
          AppColors.brandGray
              .withOpacity(
        0.08,
      ),
      icon:
          Icons.cancel_outlined,
    );
  }
}

// =====================================================
// STATUS STYLE
// =====================================================

class _StatusStyle {
  const _StatusStyle({
    required this.color,
    required this.background,
    required this.icon,
  });

  final Color color;

  final Color background;

  final IconData icon;
}