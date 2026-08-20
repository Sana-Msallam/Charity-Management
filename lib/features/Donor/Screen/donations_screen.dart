
import 'package:charity_management/features/Donor/cubit/donor_history_cubit.dart';
import 'package:charity_management/features/Donor/cubit/donor_history_state.dart';
import 'package:charity_management/features/Donor/model/donor_history_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({
    super.key,
    this.onCaseTap,
    this.onSponsorshipTap,
  });

  final void Function(DonorOperation operation)? onCaseTap;
  final void Function(DonorOperation operation)? onSponsorshipTap;

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  DonationType _selectedType = DonationType.all;

  bool _isDonation(DonorOperation operation) {
    return operation.type ==
            DonorOperationType.aidRequestDonation ||
        operation.type ==
            DonorOperationType.sponsorshipDonation ||
        operation.type ==
            DonorOperationType.generalDonation;
  }

  List<DonorOperation> _filterOperations(
    List<DonorOperation> operations,
  ) {
    switch (_selectedType) {
      case DonationType.all:
        return operations;

      case DonationType.caseDonation:
        return operations
            .where(
              (operation) =>
                  operation.type ==
                  DonorOperationType.aidRequestDonation,
            )
            .toList();

      case DonationType.sponsorship:
        return operations
            .where(
              (operation) =>
                  operation.type ==
                  DonorOperationType.sponsorshipDonation,
            )
            .toList();

      case DonationType.generalDonation:
        return operations
            .where(
              (operation) =>
                  operation.type ==
                  DonorOperationType.generalDonation,
            )
            .toList();

      case DonationType.walletTopUp:
        return operations
            .where(
              (operation) =>
                  operation.type ==
                  DonorOperationType.walletTopUp,
            )
            .toList();
    }
  }

  double _calculateTotalDonated(
    List<DonorOperation> operations,
  ) {
    return operations
        .where(_isDonation)
        .fold(
          0,
          (sum, operation) => sum + operation.amount,
        );
  }

  bool _hasSponsorships(
    List<DonorOperation> operations,
  ) {
    return operations.any(
      (operation) =>
          operation.type ==
          DonorOperationType.sponsorshipDonation,
    );
  }

  String _getOperationTitle(
    AppLocalizations l10n,
    DonorOperation operation,
  ) {
    switch (operation.type) {
      case DonorOperationType.sponsorshipDonation:
        return l10n.sponsorship;

      case DonorOperationType.aidRequestDonation:
        return operation.aidRequest?.title ?? l10n.aidRequestDonation;

      case DonorOperationType.generalDonation:
        return l10n.orphanFund;

      case DonorOperationType.walletTopUp:
        return l10n.walletTopUp;

      case DonorOperationType.unknown:
        return l10n.operation;
    }
  }

  String? _getOperationSubtitle(
    DonorOperation operation,
  ) {
    if (operation.type ==
        DonorOperationType.sponsorshipDonation) {
      return operation.orphan?.fullName;
    }

    return null;
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year.toString();

    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: false,
          title: Text(
            l10n.title,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ),
        body: BlocBuilder<DonorHistoryCubit, DonorHistoryState>(
          builder: (context, state) {
            if (state is DonorHistoryLoading ||
                state is DonorHistoryInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (state is DonorHistoryFailure) {
              return _buildErrorState(context);
            }

            if (state is DonorHistorySuccess) {
              return _buildContent(
                context,
                state.history,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DonorHistoryModel history,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final operations = history.allOperations;

    final hasSponsorships = _hasSponsorships(operations);

    final filteredOperations =
        _filterOperations(operations);

    final totalDonated =
        _calculateTotalDonated(operations);

    return Column(
      children: [
        const SizedBox(height: 4),

        _buildTotalCard(
          l10n,
          totalDonated,
        ),

        const SizedBox(height: 20),

        _buildFilters(
          l10n,
          hasSponsorships,
        ),

        const SizedBox(height: 20),

        Expanded(
          child: filteredOperations.isEmpty
              ? _buildEmptyState(l10n)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    30,
                  ),
                  itemCount: filteredOperations.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final operation =
                        filteredOperations[index];

                    return _DonationCard(
                      operation: operation,
                      title: _getOperationTitle(
                        l10n,
                        operation,
                      ),
                      subtitle:
                          _getOperationSubtitle(operation),
                      date: _formatDate(
                        operation.createdAt,
                      ),
                      onTap:
                          _getOperationTap(operation),
                    );
                  },
                ),
        ),
      ],
    );
  }

  VoidCallback? _getOperationTap(
    DonorOperation operation,
  ) {
    switch (operation.type) {
      case DonorOperationType.aidRequestDonation:
        return widget.onCaseTap == null
            ? null
            : () => widget.onCaseTap!.call(operation);

      case DonorOperationType.sponsorshipDonation:
        return widget.onSponsorshipTap == null
            ? null
            : () =>
                widget.onSponsorshipTap!.call(operation);

      case DonorOperationType.generalDonation:
      case DonorOperationType.walletTopUp:
      case DonorOperationType.unknown:
        return null;
    }
  }

  Widget _buildTotalCard(
    AppLocalizations l10n,
    double totalDonated,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.total,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontFamily:
                        AppTextStyles.fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${totalDonated.toStringAsFixed(0)} \$',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    fontFamily:
                        AppTextStyles.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(
    AppLocalizations l10n,
    bool hasSponsorships,
  ) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterItem(
            icon: Icons.grid_view_rounded,
            label: l10n.all,
            selected:
                _selectedType == DonationType.all,
            onTap: () {
              setState(() {
                _selectedType = DonationType.all;
              });
            },
          ),

          const SizedBox(width: 8),

          _FilterItem(
            icon: Icons.favorite_rounded,
            label: l10n.aidRequestDonation,
            selected:
                _selectedType ==
                    DonationType.caseDonation,
            onTap: () {
              setState(() {
                _selectedType =
                    DonationType.caseDonation;
              });
            },
          ),

          if (hasSponsorships) ...[
            const SizedBox(width: 8),

            _FilterItem(
              icon: Icons.child_care_rounded,
              label: l10n.sponsorships,
              selected:
                  _selectedType ==
                      DonationType.sponsorship,
              onTap: () {
                setState(() {
                  _selectedType =
                      DonationType.sponsorship;
                });
              },
            ),
          ],

          const SizedBox(width: 8),

          _FilterItem(
            icon: Icons.volunteer_activism_rounded,
            label: l10n.orphanFund,
            selected:
                _selectedType ==
                    DonationType.generalDonation,
            onTap: () {
              setState(() {
                _selectedType =
                    DonationType.generalDonation;
              });
            },
          ),

          const SizedBox(width: 8),

          _FilterItem(
            icon: Icons.account_balance_wallet_rounded,
            label: l10n.wallet,
            selected:
                _selectedType ==
                    DonationType.walletTopUp,
            onTap: () {
              setState(() {
                _selectedType =
                    DonationType.walletTopUp;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 45,
            color: AppColors.brandGray,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.empty,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color:
                    AppColors.error.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 36,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.loadError,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<DonorHistoryCubit>()
                    .getDonorHistory();
              },
              icon: const Icon(
                Icons.refresh_rounded,
                size: 18,
              ),
              label: Text(
                l10n.retry,
                style: const TextStyle(
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonationCard extends StatelessWidget {
  const _DonationCard({
    required this.operation,
    required this.title,
    required this.date,
    this.subtitle,
    this.onTap,
  });

  final DonorOperation operation;
  final String title;
  final String date;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final config =
        _DonationConfig.fromType(operation.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      config.color.withOpacity(.10),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  config.icon,
                  color: config.color,
                  size: 24,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color:
                            AppColors.onSurface,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                        fontFamily:
                            AppTextStyles.fontFamily,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Text(
                          date,
                          style:
                              const TextStyle(
                            color:
                                AppColors.brandGray,
                            fontSize: 12,
                            fontFamily:
                                AppTextStyles
                                    .fontFamily,
                          ),
                        ),

                        if (subtitle != null) ...[
                          const SizedBox(width: 7),

                          Container(
                            width: 3,
                            height: 3,
                            decoration:
                                const BoxDecoration(
                              color: AppColors
                                  .brandGray,
                              shape:
                                  BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 7),

                          Expanded(
                            child: Text(
                              subtitle!,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style:
                                  const TextStyle(
                                color: AppColors
                                    .brandGray,
                                fontSize: 12,
                                fontFamily:
                                    AppTextStyles
                                        .fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,
                children: [
                  Text(
                    '${operation.amount.toStringAsFixed(0)} \$',
                    style: TextStyle(
                      color: config.color,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w700,
                      fontFamily:
                          AppTextStyles.fontFamily,
                    ),
                  ),

                  if (onTap != null) ...[
                    const SizedBox(height: 5),
                    const Icon(
                      Icons
                          .arrow_back_ios_new_rounded,
                      size: 13,
                      color:
                          AppColors.brandGray,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  const _FilterItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary
          : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 180),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 13,
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? Colors.white
                    : AppColors.brandGray,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : AppColors.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonationConfig {
  const _DonationConfig({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  factory _DonationConfig.fromType(
    DonorOperationType type,
  ) {
    switch (type) {
      case DonorOperationType.aidRequestDonation:
        return const _DonationConfig(
          icon: Icons.favorite_rounded,
          color: AppColors.primary,
        );

      case DonorOperationType.sponsorshipDonation:
        return const _DonationConfig(
          icon: Icons.child_care_rounded,
          color: AppColors.tertiary,
        );

      case DonorOperationType.generalDonation:
        return const _DonationConfig(
          icon: Icons.volunteer_activism_rounded,
          color: AppColors.primary,
        );

      case DonorOperationType.walletTopUp:
        return const _DonationConfig(
          icon:
              Icons.account_balance_wallet_rounded,
          color: AppColors.primary,
        );

      case DonorOperationType.unknown:
        return const _DonationConfig(
          icon: Icons.receipt_long_rounded,
          color: AppColors.primary,
        );
    }
  }
}

enum DonationType {
  all,
  caseDonation,
  sponsorship,
  generalDonation,
  walletTopUp,
}