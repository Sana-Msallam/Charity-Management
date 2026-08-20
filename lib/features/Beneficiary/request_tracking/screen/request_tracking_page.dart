import 'package:charity_management/features/Beneficiary/request_tracking/edit_request/screen/edit_request_loader_page.dart';
import 'package:charity_management/features/components/request_tracking_card.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/cancel_request/cubit/cancel_request_cubit.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/cancel_request/cubit/cancel_request_state.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/cancel_request/service/cancel_request_service.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/request_tracking_cubit.dart';
import '../cubit/request_tracking_state.dart';
import '../service/request_tracking_service.dart';

class RequestTrackingPage extends StatelessWidget {
  const RequestTrackingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return RequestTrackingCubit(
              RequestTrackingService(),
            )..getMyRequests(
                localizations: l10n,
              );
          },
        ),
        BlocProvider(
          create: (_) {
            return CancelRequestCubit(
              CancelRequestService(),
            );
          },
        ),
      ],
      child: const _RequestTrackingView(),
    );
  }
}

// ======================================================
// REQUEST TRACKING VIEW
// ======================================================

class _RequestTrackingView extends StatefulWidget {
  const _RequestTrackingView();

  @override
  State<_RequestTrackingView> createState() {
    return _RequestTrackingViewState();
  }
}

class _RequestTrackingViewState
    extends State<_RequestTrackingView> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return BlocListener<
        CancelRequestCubit,
        CancelRequestState>(
      listener: (
        context,
        state,
      ) async {
        // ==========================================
        // نجاح إلغاء الطلب
        // ==========================================

        if (state is CancelRequestSuccess) {
          debugPrint(
            '======================================',
          );

          debugPrint(
            'CANCEL REQUEST SUCCESS',
          );

          debugPrint(
            'Request id: ${state.requestId}',
          );

          debugPrint(
            'Message: ${state.message}',
          );

          debugPrint(
            '======================================',
          );

          await _showCancelSuccessDialog(
            context,
            state.message,
          );

          if (!context.mounted) {
            return;
          }

          await context
              .read<RequestTrackingCubit>()
              .getMyRequests(
                status: _selectedStatus,
                localizations: l10n,
              );

          if (!context.mounted) {
            return;
          }

          context
              .read<CancelRequestCubit>()
              .reset();
        }

        // ==========================================
        // فشل إلغاء الطلب
        // ==========================================

        if (state is CancelRequestFailure) {
          debugPrint(
            '======================================',
          );

          debugPrint(
            'CANCEL REQUEST FAILURE',
          );

          debugPrint(
            'Message: ${state.message}',
          );

          debugPrint(
            '======================================',
          );

          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar();

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),
              backgroundColor:
                  AppColors.error,
              behavior:
                  SnackBarBehavior.floating,
            ),
          );

          context
              .read<CancelRequestCubit>()
              .reset();
        }
      },

      // ==========================================
      // SCAFFOLD
      // ==========================================

      child: Scaffold(
        backgroundColor:
            AppColors.background,

        // ==========================================
        // APP BAR
        // ==========================================

        appBar: AppBar(
          backgroundColor:
              AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            l10n.requestTrackingTitle,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),
        ),

        // ==========================================
        // BODY
        // ==========================================

        body: SafeArea(
          child: Column(
            children: [
              // ====================================
              // FILTERS
              // ====================================

              _buildFilters(),

              // ====================================
              // REQUESTS
              // ====================================

              Expanded(
                child: BlocBuilder<
                    RequestTrackingCubit,
                    RequestTrackingState>(
                  builder: (
                    context,
                    state,
                  ) {
                    if (state
                        is RequestTrackingInitial) {
                      return const SizedBox
                          .shrink();
                    }

                    if (state
                        is RequestTrackingLoading) {
                      return const Center(
                        child:
                            CircularProgressIndicator(
                          color:
                              AppColors.primary,
                        ),
                      );
                    }

                    if (state
                        is RequestTrackingFailure) {
                      return _buildError(
                        state.message,
                      );
                    }

                    if (state
                        is RequestTrackingSuccess) {
                      if (state
                          .requests.isEmpty) {
                        return _buildEmpty();
                      }

                      return RefreshIndicator(
                        color:
                            AppColors.primary,
                        onRefresh: () {
                          return context
                              .read<
                                  RequestTrackingCubit>()
                              .getMyRequests(
                                status:
                                    _selectedStatus,
                                localizations:
                                    l10n,
                              );
                        },
                        child: ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          padding:
                              const EdgeInsets
                                  .fromLTRB(
                            20,
                            16,
                            20,
                            30,
                          ),
                          itemCount:
                              state.requests.length,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            final request =
                                state.requests[
                                    index];

                            return RequestTrackingCard(
                              request:
                                  request,

                              // =========================
                              // تعديل الطلب
                              // =========================

                              onEdit: () {
                                debugPrint(
                                  'Edit request #${request.id}',
                                );

                                Navigator.of(
                                  context,
                                ).push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return EditRequestLoaderPage(
                                        requestId:
                                            request.id,
                                      );
                                    },
                                  ),
                                );
                              },

                              // =========================
                              // إلغاء الطلب
                              // =========================

                              onCancel: () {
                                debugPrint(
                                  'Cancel button clicked '
                                  'for request #${request.id}',
                                );

                                _showCancelDialog(
                                  context,
                                  request.id,
                                );
                              },
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox
                        .shrink();
                  },
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar:
            const CustomBottomNavigation(
          currentIndex: 1,
        ),
      ),
    );
  }

  // =================================================
  // CANCEL CONFIRMATION DIALOG
  // =================================================

  Future<void> _showCancelDialog(
    BuildContext context,
    int requestId,
  ) async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    debugPrint(
      '======================================',
    );

    debugPrint(
      'OPEN CANCEL DIALOG',
    );

    debugPrint(
      'Request id: $requestId',
    );

    debugPrint(
      '======================================',
    );

    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          backgroundColor:
              AppColors.surface,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),
          titlePadding:
              const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            8,
          ),
          contentPadding:
              const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20,
          ),
          actionsPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),

          // =========================================
          // TITLE
          // =========================================

          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                    BoxDecoration(
                  color: AppColors.error
                      .withOpacity(
                    0.08,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: const Icon(
                  Icons
                      .warning_amber_rounded,
                  color:
                      AppColors.error,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  l10n.cancelRequestTitle,
                  style:
                      const TextStyle(
                    color:
                        AppColors.onSurface,
                    fontSize: 18,
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

          // =========================================
          // MESSAGE
          // =========================================

          content: Text(
            l10n.cancelRequestConfirmation(
              requestId,
            ),
            style: const TextStyle(
              color:
                  AppColors.brandGray,
              fontSize: 14,
              height: 1.7,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),

          // =========================================
          // ACTIONS
          // =========================================

          actions: [
            TextButton(
              onPressed: () {
                debugPrint(
                  'User cancelled cancel dialog '
                  'for request #$requestId',
                );

                Navigator.of(
                  dialogContext,
                ).pop(
                  false,
                );
              },
              child: Text(
                l10n.goBack,
                style:
                    const TextStyle(
                  color:
                      AppColors.brandGray,
                  fontWeight:
                      FontWeight.w600,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                debugPrint(
                  'User confirmed cancel '
                  'request #$requestId',
                );

                Navigator.of(
                  dialogContext,
                ).pop(
                  true,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.error,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              child: Text(
                l10n.confirmCancelRequest,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ),
          ],
        );
      },
    );

    debugPrint(
      'Cancel dialog result: $confirmed',
    );

    if (confirmed != true) {
      debugPrint(
        'Cancel request aborted by user',
      );

      return;
    }

    if (!context.mounted) {
      debugPrint(
        'Context is not mounted '
        'after cancel dialog',
      );

      return;
    }

    debugPrint(
      '======================================',
    );

    debugPrint(
      'CALLING CANCEL REQUEST CUBIT',
    );

    debugPrint(
      'Request id: $requestId',
    );

    debugPrint(
      '======================================',
    );

    await context
        .read<CancelRequestCubit>()
        .cancelRequest(
          requestId: requestId,
          localizations: l10n,
        );
  }

  // =================================================
  // CANCEL SUCCESS DIALOG
  // =================================================

  Future<void> _showCancelSuccessDialog(
    BuildContext context,
    String message,
  ) async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    debugPrint(
      'OPEN CANCEL SUCCESS DIALOG',
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          backgroundColor:
              AppColors.surface,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),
          titlePadding:
              const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            8,
          ),
          contentPadding:
              const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20,
          ),
          actionsPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),

          // =========================================
          // TITLE
          // =========================================

          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration:
                    BoxDecoration(
                  color:
                      AppColors.primary
                          .withOpacity(
                    0.08,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: const Icon(
                  Icons
                      .check_circle_outline_rounded,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  l10n
                      .requestCancelledTitle,
                  style:
                      const TextStyle(
                    color:
                        AppColors.onSurface,
                    fontSize: 18,
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

          // =========================================
          // BACKEND MESSAGE
          // =========================================

          content: Text(
            message,
            style: const TextStyle(
              color:
                  AppColors.brandGray,
              fontSize: 14,
              height: 1.7,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),

          // =========================================
          // OK
          // =========================================

          actions: [
            ElevatedButton(
              onPressed: () {
                debugPrint(
                  'Cancel success dialog closed',
                );

                Navigator.of(
                  dialogContext,
                ).pop();
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
              child: Text(
                l10n.confirm,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =================================================
  // FILTERS
  // =================================================

  Widget _buildFilters() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        8,
      ),
      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label:
                  l10n.allRequests,
              status: null,
            ),

            const SizedBox(
              width: 8,
            ),

            _buildFilterChip(
              label:
                  l10n.pendingRequests,
              status: 'PENDING',
            ),

            const SizedBox(
              width: 8,
            ),

            _buildFilterChip(
              label:
                  l10n.acceptedRequests,
              status: 'ACCEPTED',
            ),

            const SizedBox(
              width: 8,
            ),

            _buildFilterChip(
              label:
                  l10n.rejectedRequests,
              status: 'REJECTED',
            ),

            const SizedBox(
              width: 8,
            ),

            _buildFilterChip(
              label:
                  l10n.cancelledRequests,
              status: 'CANCELLED',
            ),
          ],
        ),
      ),
    );
  }

  // =================================================
  // FILTER CHIP
  // =================================================

  Widget _buildFilterChip({
    required String label,
    required String? status,
  }) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final bool isSelected =
        _selectedStatus == status;

    return InkWell(
      onTap: () {
        if (_selectedStatus ==
            status) {
          return;
        }

        setState(() {
          _selectedStatus =
              status;
        });

        context
            .read<RequestTrackingCubit>()
            .getMyRequests(
              status: status,
              localizations: l10n,
            );
      },
      borderRadius:
          BorderRadius.circular(
        20,
      ),
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.brandGray
                    .withOpacity(
                    0.12,
                  ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : AppColors.brandGray,
            fontSize: 12,
            fontWeight:
                isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
            fontFamily:
                AppTextStyles
                    .fontFamily,
          ),
        ),
      ),
    );
  }

  // =================================================
  // ERROR
  // =================================================

  Widget _buildError(
    String message,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration:
                  BoxDecoration(
                color:
                    AppColors.error
                        .withOpacity(
                  0.08,
                ),
                shape:
                    BoxShape.circle,
              ),
              child: const Icon(
                Icons
                    .error_outline_rounded,
                color:
                    AppColors.error,
                size: 36,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              l10n.requestsLoadError,
              style:
                  const TextStyle(
                color:
                    AppColors.onSurface,
                fontSize: 17,
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

            Text(
              message,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color:
                    AppColors.brandGray,
                fontSize: 13,
                height: 1.6,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<
                        RequestTrackingCubit>()
                    .getMyRequests(
                      status:
                          _selectedStatus,
                      localizations:
                          l10n,
                    );
              },
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    AppColors.primary,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 20,
                  vertical: 13,
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
              icon: const Icon(
                Icons.refresh_rounded,
                size: 19,
              ),
              label: Text(
                l10n.retry,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =================================================
  // EMPTY
  // =================================================

  Widget _buildEmpty() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons
                  .assignment_outlined,
              size: 64,
              color:
                  AppColors.brandGray,
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              l10n.noRequestsForStatus,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color:
                    AppColors.onSurface,
                fontSize: 16,
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
    );
  }
}