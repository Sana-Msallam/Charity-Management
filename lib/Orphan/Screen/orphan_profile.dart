import 'package:charity_management/Payment/cubit/wallet_sponsorship_donation_cubit.dart';
import 'package:charity_management/Payment/cubit/wallet_sponsorship_donation_state.dart';
import 'package:charity_management/Sponsership/cubit/cancel_sponsorship_cubit.dart';
import 'package:charity_management/Sponsership/cubit/cancel_sponsorship_state.dart';
import 'package:charity_management/Sponsership/model/sponsorship_list_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
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
