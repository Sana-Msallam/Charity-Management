import 'dart:typed_data';

import 'package:charity_management/Orphan/cubit/annual_reports_cubit.dart';
import 'package:charity_management/Orphan/cubit/annual_reports_state.dart';
import 'package:charity_management/Orphan/model/annual_report_model.dart';
import 'package:charity_management/Payment/cubit/wallet_sponsorship_donation_cubit.dart';
import 'package:charity_management/Payment/cubit/wallet_sponsorship_donation_state.dart';
import 'package:charity_management/Sponsership/cubit/cancel_sponsorship_cubit.dart';
import 'package:charity_management/Sponsership/cubit/cancel_sponsorship_state.dart';
import 'package:charity_management/Sponsership/model/sponsorship_list_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrphanDetailsScreen extends StatefulWidget {
  final SponsorshipListModel sponsorship;

  const OrphanDetailsScreen({super.key, required this.sponsorship});

  @override
  State<OrphanDetailsScreen> createState() => _OrphanDetailsScreenState();
}

class _OrphanDetailsScreenState extends State<OrphanDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final orphan = widget.sponsorship.orphan;
    final l10n = AppLocalizations.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CancelSponsorshipCubit()),
        BlocProvider(create: (_) => WalletSponsorshipDonationCubit()),
        BlocProvider(
          create: (_) {
            final cubit = AnnualReportsCubit();
            if (_canShowAnnualReports()) {
              cubit.loadAnnualReports(
                sponsorshipId: widget.sponsorship.id,
                localizations: l10n,
              );
            }

            return cubit;
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CancelSponsorshipCubit, CancelSponsorshipState>(
            listener: (context, state) {
              if (state is CancelSponsorshipSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.response.message),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context, true);
              }

              if (state is CancelSponsorshipError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<
            WalletSponsorshipDonationCubit,
            WalletSponsorshipDonationState
          >(
            listener: (context, state) {
              if (state is WalletSponsorshipDonationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.donation.message),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context, true);
              }

              if (state is WalletSponsorshipDonationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FF),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              l10n.orphanSponsorshipDetails,
              style: const TextStyle(
                color: Color(0xFF765A00),
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFF765A00)),
            actions: [
              if (_canCancelSponsorship())
                PopupMenuButton<_OrphanProfileAction>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (action) {
                    switch (action) {
                      case _OrphanProfileAction.cancelSponsorship:
                        _showCancelConfirmation(context);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: _OrphanProfileAction.cancelSponsorship,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cancel_outlined,
                              color: Color(0xFFC62828),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.cancelSponsorship,
                              style: const TextStyle(
                                color: Color(0xFFC62828),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
            ],
          ),
          body: SafeArea(
            child: orphan == null
                ? _buildNoOrphanData(context)
                : SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildProfileCard(orphan),
                              const SizedBox(height: 20),
                              _buildPersonalDataCard(orphan, l10n, isRtl),
                              const SizedBox(height: 20),
                              _buildSponsorshipCard(
                                widget.sponsorship,
                                l10n,
                                isRtl,
                              ),
                              if (_canShowAnnualReports()) ...[
                                const SizedBox(height: 20),
                                _buildAnnualReportsSection(context, isRtl),
                              ],
                              if (widget.sponsorship.rejectionReason !=
                                  null) ...[
                                const SizedBox(height: 20),
                                _buildInfoCard(
                                  title: l10n.sponsorshipRejectionReason,
                                  value: widget.sponsorship.rejectionReason!,
                                  icon: Icons.info_outline,
                                  isRtl: isRtl,
                                ),
                              ],
                              if (widget.sponsorship.cancellationSource !=
                                  null) ...[
                                const SizedBox(height: 20),
                                _buildInfoCard(
                                  title: l10n.sponsorshipCancellationSource,
                                  value: widget.sponsorship.cancellationSource!,
                                  icon: Icons.cancel_outlined,
                                  isRtl: isRtl,
                                ),
                              ],
                              if (_canPayMonthlySponsorship()) ...[
                                const SizedBox(height: 20),
                                _buildMonthlyPaymentButton(context, l10n),
                              ],
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoOrphanData(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 90),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E7),
                borderRadius: BorderRadius.circular(45),
              ),
              child: const Icon(
                Icons.hourglass_empty,
                size: 42,
                color: Color(0xFF765A00),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.noOrphanDataTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF765A00),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.noOrphanDataDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            if (_canPayMonthlySponsorship())
              _buildMonthlyPaymentButton(context, l10n),
          ],
        ),
      ),
    );
  }

  bool _canCancelSponsorship() {
    final status = widget.sponsorship.status.toUpperCase();

    return status == 'PENDING' || status == 'ACCEPTED';
  }

  bool _canPayMonthlySponsorship() {
    return widget.sponsorship.status.toUpperCase() == 'ACCEPTED';
  }

  bool _canShowAnnualReports() {
    return widget.sponsorship.status.toUpperCase() == 'ACCEPTED';
  }

  Widget _buildAnnualReportsSection(BuildContext context, bool isRtl) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1C5B1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE6A3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF735C00),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.annualReportsTitle,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF735C00),
                        fontSize: 18,
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.annualReportsSubtitle,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF7C766C),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          BlocBuilder<AnnualReportsCubit, AnnualReportsState>(
            builder: (context, state) {
              return _buildAnnualReportsContent(context, state, l10n, isRtl);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnualReportsContent(
    BuildContext context,
    AnnualReportsState state,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    if (state is AnnualReportsLoading || state is AnnualReportsInitial) {
      return _buildAnnualReportsLoading(l10n);
    }

    if (state is AnnualReportsFailure) {
      return _buildAnnualReportsError(context, state.message, l10n);
    }

    if (state is AnnualReportsEmpty) {
      return _buildEmptyAnnualReports(l10n);
    }

    if (state is AnnualReportsSuccess) {
      return Column(
        children: state.reports
            .map(
              (report) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildAnnualReportCard(context, report, l10n, isRtl),
              ),
            )
            .toList(),
      );
    }

    return _buildEmptyAnnualReports(l10n);
  }

  Widget _buildAnnualReportCard(
    BuildContext context,
    AnnualReportModel report,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1DEAA)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE3D5B3)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      color: Color(0xFF735C00),
                      size: 28,
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB2E7C6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.annualReportYear(report.reportYear),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF1F1B14),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.annualReportNumber(report.reportNumber),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF735C00),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Color(0xFF7C766C),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _formatDate(report.createdAt),
                            style: const TextStyle(
                              color: Color(0xFF7C766C),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () => _showReportPreview(context, report, isRtl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF735C00),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.visibility_outlined, size: 19),
                    label: Text(
                      l10n.viewReport,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 46,
                height: 42,
                child: OutlinedButton(
                  onPressed: () => _downloadAnnualReport(context, report, l10n),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF735C00),
                    padding: EdgeInsets.zero,
                    side: const BorderSide(color: Color(0xFF735C00)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.download_outlined, size: 21),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnualReportsLoading(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF735C00),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.annualReportsLoading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7C766C),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnualReportsError(
    BuildContext context,
    String message,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFC62828), size: 36),
          const SizedBox(height: 10),
          Text(
            message.isEmpty ? l10n.annualReportsLoadFailed : message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7C766C),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AnnualReportsCubit>().loadAnnualReports(
                sponsorshipId: widget.sponsorship.id,
                localizations: l10n,
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF735C00),
              side: const BorderSide(color: Color(0xFF735C00)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAnnualReports(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            color: Color(0xFFB6AD9E),
            size: 38,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.noAnnualReportsYet,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7C766C),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportPreview(
    BuildContext context,
    AnnualReportModel report,
    bool _,
  ) {
    final l10n = AppLocalizations.of(context);
    final imageUrl = _buildReportImageUrl(report.imageUrl);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: Text(l10n.annualReportPreviewTitle(report.reportYear)),
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 0.7,
                maxScale: 4,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.reportImageLoadFailed,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _downloadAnnualReport(
    BuildContext context,
    AnnualReportModel report,
    AppLocalizations l10n,
  ) async {
    try {
      final response = await DioClient.dio.get<dynamic>(
        _buildReportImageUrl(report.imageUrl),
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(List<int>.from(response.data as List));
      final fileName = _annualReportFileName(report);

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: l10n.saveAnnualReportDialogTitle,
        fileName: fileName,
        bytes: bytes,
      );

      if (!context.mounted || savedPath == null) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.downloadReportSuccess(fileName)),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.downloadReportFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _buildReportImageUrl(String imageUrl) {
    final trimmedUrl = imageUrl.trim();
    final uri = Uri.tryParse(trimmedUrl);

    if (uri != null && uri.hasScheme) {
      return trimmedUrl;
    }

    final baseUrl = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl.substring(0, ApiConstants.baseUrl.length - 1)
        : ApiConstants.baseUrl;
    final path = trimmedUrl.startsWith('/')
        ? trimmedUrl.substring(1)
        : trimmedUrl;

    return '$baseUrl/$path';
  }

  String _annualReportFileName(AnnualReportModel report) {
    final extension = _reportFileExtension(report.imageUrl);

    return 'annual_report_${report.reportYear}_${report.reportNumber}.$extension';
  }

  String _reportFileExtension(String imageUrl) {
    final path = Uri.tryParse(imageUrl)?.path ?? imageUrl;
    final segments = path.split('/').where((part) => part.isNotEmpty);
    final lastSegment = segments.isEmpty ? '' : segments.last;
    final extension = lastSegment.contains('.')
        ? lastSegment.split('.').last.toLowerCase()
        : 'jpg';

    if (extension.length > 5 || extension.isEmpty) {
      return 'jpg';
    }

    return extension;
  }

  Widget _buildProfileCard(SponsoredOrphanModel orphan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 32, bottom: 24, left: 16, right: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD1C5B1)),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C0B1C30),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 110,
                height: 110,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD56B),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/orphan_profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF765A00),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            orphan.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF765A00),
              fontSize: 22,
              fontFamily: 'IBM Plex Sans Arabic',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildPersonalDataCard(
    SponsoredOrphanModel orphan,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1C5B1)),
      ),
      child: Column(
        crossAxisAlignment: _cardCrossAxisAlignment(isRtl),
        children: [
          Row(
            mainAxisAlignment: _cardMainAxisAlignment(isRtl),
            children: _orderedHeaderChildren(
              title: l10n.orphanPersonalData,
              icon: Icons.person_outline,
            ),
          ),
          const SizedBox(height: 16),
          _buildDataRow(l10n.orphanName, orphan.fullName, isRtl),
          _buildDataRow(
            l10n.gender,
            _translateGender(orphan.gender, l10n),
            isRtl,
          ),
          _buildDataRow(l10n.birthDate, _formatDate(orphan.birthOfDate), isRtl),
          _buildDataRow(l10n.orphanClass, orphan.className, isRtl),
          if (orphan.talent != null && orphan.talent!.trim().isNotEmpty)
            _buildDataRow(l10n.talent, orphan.talent!, isRtl),
        ],
      ),
    );
  }

  Widget _buildSponsorshipCard(
    SponsorshipListModel sponsorship,
    AppLocalizations l10n,
    bool isRtl,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1C5B1)),
      ),
      child: Column(
        crossAxisAlignment: _cardCrossAxisAlignment(isRtl),
        children: [
          Row(
            mainAxisAlignment: _cardMainAxisAlignment(isRtl),
            children: _orderedHeaderChildren(
              title: l10n.sponsorshipData,
              icon: Icons.volunteer_activism_outlined,
            ),
          ),
          const SizedBox(height: 16),
          _buildDataRow(
            l10n.monthlySponsorshipAmount,
            sponsorship.monthlyAmount,
            isRtl,
          ),
          _buildDataRow(
            l10n.sponsorshipStatusLabel,
            _translateSponsorshipStatus(sponsorship.status, l10n),
            isRtl,
          ),
          if (sponsorship.startDate != null)
            _buildDataRow(
              l10n.sponsorshipStartDate,
              _formatDate(sponsorship.startDate!),
              isRtl,
            ),
          if (sponsorship.endDate != null)
            _buildDataRow(
              l10n.sponsorshipEndDate,
              _formatDate(sponsorship.endDate!),
              isRtl,
            ),
          _buildDataRow(
            l10n.sponsorshipCreatedDate,
            _formatDate(sponsorship.createdAt),
            isRtl,
          ),
        ],
      ),
    );
  }

  // Kept for the temporary cancel-button rollback path; cancel is shown
  // from the AppBar menu for now.
  // ignore: unused_element
  Widget _buildCancelButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<CancelSponsorshipCubit, CancelSponsorshipState>(
      builder: (context, state) {
        final isLoading = state is CancelSponsorshipLoading;

        return SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: isLoading
                ? null
                : () => _showCancelConfirmation(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFC62828),
              side: const BorderSide(color: Color(0xFFC62828)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFC62828),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cancel_outlined, size: 21),
                      const SizedBox(width: 8),
                      Text(
                        l10n.cancelSponsorship,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l10n.cancelSponsorship, textAlign: _textAlign(isRtl)),
          content: Text(
            l10n.cancelSponsorshipConfirmation,
            textAlign: _textAlign(isRtl),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                l10n.goBack,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<CancelSponsorshipCubit>().cancelSponsorship(
                  widget.sponsorship.id,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.cancelSponsorship),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMonthlyPaymentButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return BlocBuilder<
      WalletSponsorshipDonationCubit,
      WalletSponsorshipDonationState
    >(
      builder: (context, state) {
        final isLoading = state is WalletSponsorshipDonationLoading;

        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () => _showMonthlyPaymentConfirmation(context, l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF765A00),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 21,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.confirmMonthlySponsorshipPayment,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _showMonthlyPaymentConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.confirmMonthlySponsorshipPayment,
            textAlign: _textAlign(isRtl),
          ),
          content: Text(
            l10n.monthlySponsorshipPaymentConfirmation,
            textAlign: _textAlign(isRtl),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                l10n.goBack,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<WalletSponsorshipDonationCubit>().donate(
                  sponsorshipId: widget.sponsorship.id,
                  localizations: l10n,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF765A00),
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.confirmPayment),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isRtl,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1C5B1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _orderedInfoChildren(
          icon: icon,
          child: Expanded(
            child: Column(
              crossAxisAlignment: _cardCrossAxisAlignment(isRtl),
              children: [
                Text(
                  title,
                  textAlign: _textAlign(isRtl),
                  style: const TextStyle(
                    color: Color(0xFF586377),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  textAlign: _textAlign(isRtl),
                  style: const TextStyle(
                    color: Color(0xFF0B1C30),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String title, String value, bool isRtl) {
    final titleWidget = Text(
      title,
      textAlign: _textAlign(isRtl),
      style: const TextStyle(color: Color(0xFF4D4636), fontSize: 15),
    );
    final valueWidget = Expanded(
      child: Text(
        value,
        textAlign: _textAlign(isRtl),
        style: const TextStyle(
          color: Color(0xFF0B1C30),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    final children = <Widget>[
      titleWidget,
      const SizedBox(width: 16),
      valueWidget,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEFF4FF), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _translateGender(String gender, AppLocalizations l10n) {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return l10n.male;
      case 'FEMALE':
        return l10n.female;
      default:
        return gender;
    }
  }

  String _translateSponsorshipStatus(String status, AppLocalizations l10n) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return l10n.sponsorshipStatusPending;
      case 'ACCEPTED':
        return l10n.sponsorshipStatusAccepted;
      case 'REJECTED':
        return l10n.sponsorshipStatusRejected;
      case 'CANCELLED':
        return l10n.sponsorshipStatusCancelled;
      default:
        return status;
    }
  }

  CrossAxisAlignment _cardCrossAxisAlignment(bool isRtl) {
    return CrossAxisAlignment.start;
  }

  MainAxisAlignment _cardMainAxisAlignment(bool isRtl) {
    return MainAxisAlignment.start;
  }

  TextAlign _textAlign(bool isRtl) {
    return TextAlign.start;
  }

  List<Widget> _orderedHeaderChildren({
    required String title,
    required IconData icon,
  }) {
    const style = TextStyle(
      color: Color(0xFF765A00),
      fontSize: 18,
      fontFamily: 'IBM Plex Sans Arabic',
      fontWeight: FontWeight.bold,
    );
    final iconWidget = Icon(icon, color: const Color(0xFF765A00));
    final titleWidget = Text(title, style: style);

    return [iconWidget, const SizedBox(width: 8), titleWidget];
  }

  List<Widget> _orderedInfoChildren({
    required IconData icon,
    required Widget child,
  }) {
    final iconWidget = Icon(icon, color: const Color(0xFF765A00));

    return [iconWidget, const SizedBox(width: 12), child];
  }
}

enum _OrphanProfileAction { cancelSponsorship }
