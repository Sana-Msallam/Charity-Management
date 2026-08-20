import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/screen/applicant_info_page.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/edit_request/cubit/request_details_cubit.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/edit_request/cubit/request_details_state.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/model/request_details_model.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/service/request_tracking_service.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditRequestLoaderPage extends StatelessWidget {
  const EditRequestLoaderPage({
    super.key,
    required this.requestId,
  });

  final int requestId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => RequestDetailsCubit(
        RequestTrackingService(),
      )..getRequestDetails(
          requestId: requestId,
          localizations: l10n,
        ),
      child: const _EditRequestLoaderView(),
    );
  }
}

class _EditRequestLoaderView extends StatefulWidget {
  const _EditRequestLoaderView();

  @override
  State<_EditRequestLoaderView> createState() {
    return _EditRequestLoaderViewState();
  }
}

class _EditRequestLoaderViewState
    extends State<_EditRequestLoaderView> {
  bool _hasNavigated = false;

  // =================================================
  // OPEN APPLICANT INFO PAGE
  // =================================================

  void _openApplicantInfoPage(
    RequestDetailsModel request,
  ) {
    if (_hasNavigated) {
      return;
    }

    _hasNavigated = true;

    final String requestType =
        _getRequestType(
      request,
    );

    debugPrint(
      '======================================',
    );

    debugPrint(
      'OPENING APPLICANT INFO FOR EDIT',
    );

    debugPrint(
      'Request id: ${request.id}',
    );

    debugPrint(
      'Category id: ${request.categoryId}',
    );

    debugPrint(
      'Category name: ${request.category.name}',
    );

    debugPrint(
      'Request type: $requestType',
    );

    debugPrint(
      '======================================',
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return ApplicantInfoPage(
            requestType: requestType,
            requestDetails: request,
          );
        },
      ),
    );
  }

  // =================================================
  // REQUEST TYPE
  // =================================================

  String _getRequestType(
    RequestDetailsModel request,
  ) {
    switch (request.categoryId) {
      case 1:
        return 'صحي';

      case 2:
        return 'غذائي';

      case 3:
        return 'سكني';

      case 4:
        return 'تعليمي';

      case 5:
        return 'مشاريع صغيرة';

      default:
        return request.category.name;
    }
  }

  // =================================================
  // BUILD
  // =================================================

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return BlocListener<
        RequestDetailsCubit,
        RequestDetailsState>(
      listener: (
        context,
        state,
      ) {
        // ==========================================
        // SUCCESS
        // ==========================================

        if (state is RequestDetailsSuccess) {
          debugPrint(
            '======================================',
          );

          debugPrint(
            'REQUEST DETAILS LOADED',
          );

          debugPrint(
            'Request id: ${state.request.id}',
          );

          debugPrint(
            'Category: ${state.request.category.name}',
          );

          debugPrint(
            '======================================',
          );

          _openApplicantInfoPage(
            state.request,
          );
        }
      },

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
            l10n.editRequest,
            style: const TextStyle(
              color:
                  AppColors.primary,
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

        body: BlocBuilder<
            RequestDetailsCubit,
            RequestDetailsState>(
          builder: (
            context,
            state,
          ) {
            // ======================================
            // INITIAL / LOADING
            // ======================================

            if (state
                    is RequestDetailsInitial ||
                state
                    is RequestDetailsLoading) {
              return _buildLoading(
                context,
              );
            }

            // ======================================
            // FAILURE
            // ======================================

            if (state
                is RequestDetailsFailure) {
              return _buildError(
                context,
                state.message,
              );
            }

            // ======================================
            // SUCCESS
            // ======================================

            if (state
                is RequestDetailsSuccess) {
              // الانتقال يتم من BlocListener.
              // نخلي Loading ظاهر لحد ما تفتح
              // ApplicantInfoPage.
              return _buildLoading(
                context,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // =================================================
  // LOADING
  // =================================================

  Widget _buildLoading(
    BuildContext context,
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
            const CircularProgressIndicator(
              color:
                  AppColors.primary,
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              l10n.loadingRequestData,
              textAlign:
                  TextAlign.center,
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

            const SizedBox(
              height: 8,
            ),

            Text(
              l10n.pleaseWaitMoment,
              textAlign:
                  TextAlign.center,
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
      ),
    );
  }

  // =================================================
  // ERROR
  // =================================================

  Widget _buildError(
    BuildContext context,
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
              l10n.requestDetailsLoadFailed,
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.onSurface,
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
                fontFamily:
                    AppTextStyles.fontFamily,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              message,
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.brandGray,
                fontSize: 13,
                height: 1.6,
                fontFamily:
                    AppTextStyles.fontFamily,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(
                  context,
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
                  horizontal: 20,
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),

              icon: const Icon(
                Icons.arrow_back,
              ),

              label: Text(
                l10n.back,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}