import 'package:charity_management/Sponsership/cubit/cancel_sponsorship_cubit.dart';
import 'package:charity_management/Sponsership/cubit/cancel_sponsorship_state.dart';
import 'package:charity_management/Sponsership/model/sponsorship_list_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrphanDetailsScreen extends StatefulWidget {
  final SponsorshipListModel sponsorship;

  const OrphanDetailsScreen({
    super.key,
    required this.sponsorship,
  });

  @override
  State<OrphanDetailsScreen> createState() =>
      _OrphanDetailsScreenState();
}

class _OrphanDetailsScreenState
    extends State<OrphanDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final orphan = widget.sponsorship.orphan;
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => CancelSponsorshipCubit(),
      child: BlocListener<
          CancelSponsorshipCubit,
          CancelSponsorshipState>(
        listener: (context, state) {
          if (state is CancelSponsorshipSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.response.message,
                ),
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
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FF),

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: const Text(
              'تفاصيل الكفالة',
              style: TextStyle(
                color: Color(0xFF765A00),
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Color(0xFF765A00),
            ),
          ),

          body: SafeArea(
            child: orphan == null
                ? _buildNoOrphanData(context)
                : SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 600,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              _buildProfileCard(orphan),

                              const SizedBox(height: 20),

                              _buildPersonalDataCard(
                                orphan,
                                l10n,
                              ),

                              const SizedBox(height: 20),

                              _buildSponsorshipCard(
                                widget.sponsorship,
                              ),

                              if (widget.sponsorship
                                      .rejectionReason !=
                                  null) ...[
                                const SizedBox(height: 20),
                                _buildInfoCard(
                                  title: 'سبب الرفض',
                                  value: widget.sponsorship
                                      .rejectionReason!,
                                  icon: Icons.info_outline,
                                ),
                              ],

                              if (widget.sponsorship
                                      .cancellationSource !=
                                  null) ...[
                                const SizedBox(height: 20),
                                _buildInfoCard(
                                  title: 'مصدر الإلغاء',
                                  value: widget.sponsorship
                                      .cancellationSource!,
                                  icon: Icons.cancel_outlined,
                                ),
                              ],

                              if (_canCancelSponsorship()) ...[
                                const SizedBox(height: 20),
                                _buildCancelButton(context),
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

            const Text(
              'لا توجد معلومات عن اليتيم حالياً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF765A00),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'طلب الكفالة ما زال قيد الانتظار ولم يتم تخصيص يتيم لك حتى الآن.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 30),

            if (widget.sponsorship.status.toUpperCase() ==
                'PENDING')
              _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  bool _canCancelSponsorship() {
    final status =
        widget.sponsorship.status.toUpperCase();

    return status == 'PENDING' ||
        status == 'ACCEPTED';
  }

  Widget _buildProfileCard(
    SponsoredOrphanModel orphan,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 32,
        bottom: 24,
        left: 16,
        right: 16,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFD1C5B1),
          ),
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
                      image: AssetImage(
                        'assets/orphan_profile.jpg',
                      ),
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
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
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

          const SizedBox(height: 6),

          Text(
            'رقم اليتيم: ${orphan.id}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF4D4636),
              fontSize: 14,
              fontFamily: 'IBM Plex Sans Arabic',
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD5E0F8),
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                color: const Color(0x33545F73),
              ),
            ),
            child: Text(
              widget.sponsorship.status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF586377),
                fontSize: 12,
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataCard(
    SponsoredOrphanModel orphan,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD1C5B1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'البيانات الشخصية',
                style: TextStyle(
                  color: Color(0xFF765A00),
                  fontSize: 18,
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.person_outline,
                color: Color(0xFF765A00),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildDataRow(
            'الاسم',
            orphan.fullName,
          ),

          _buildDataRow(
            'الجنس',
            _translateGender(
              orphan.gender,
              l10n,
            ),
          ),

          _buildDataRow(
            'تاريخ الميلاد',
            _formatDate(
              orphan.birthOfDate,
            ),
          ),

          _buildDataRow(
            'الصف',
            orphan.className,
          ),

          if (orphan.talent != null &&
              orphan.talent!.trim().isNotEmpty)
            _buildDataRow(
              'الموهبة',
              orphan.talent!,
            ),
        ],
      ),
    );
  }

  Widget _buildSponsorshipCard(
    SponsorshipListModel sponsorship,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD1C5B1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'بيانات الكفالة',
                style: TextStyle(
                  color: Color(0xFF765A00),
                  fontSize: 18,
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.volunteer_activism_outlined,
                color: Color(0xFF765A00),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildDataRow(
            'رقم الكفالة',
            sponsorship.id.toString(),
          ),

          _buildDataRow(
            'المبلغ الشهري',
            sponsorship.monthlyAmount,
          ),

          _buildDataRow(
            'حالة الكفالة',
            sponsorship.status,
          ),

          if (sponsorship.startDate != null)
            _buildDataRow(
              'تاريخ بدء الكفالة',
              _formatDate(
                sponsorship.startDate!,
              ),
            ),

          if (sponsorship.endDate != null)
            _buildDataRow(
              'تاريخ انتهاء الكفالة',
              _formatDate(
                sponsorship.endDate!,
              ),
            ),

          _buildDataRow(
            'تاريخ إنشاء الكفالة',
            _formatDate(
              sponsorship.createdAt,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(
    BuildContext context,
  ) {
    return BlocBuilder<
        CancelSponsorshipCubit,
        CancelSponsorshipState>(
      builder: (context, state) {
        final isLoading =
            state is CancelSponsorshipLoading;

        return SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: isLoading
                ? null
                : () => _showCancelConfirmation(
                      context,
                    ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  const Color(0xFFC62828),
              side: const BorderSide(
                color: Color(0xFFC62828),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFC62828),
                    ),
                  )
                : const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 21,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'إلغاء الكفالة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _showCancelConfirmation(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
          title: const Text(
            'إلغاء الكفالة',
            textAlign: TextAlign.right,
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في إلغاء هذه الكفالة؟',
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'تراجع',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context
                    .read<
                        CancelSponsorshipCubit>()
                    .cancelSponsorship(
                      widget.sponsorship.id,
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFC62828),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'إلغاء الكفالة',
              ),
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
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD1C5B1),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF765A00),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF586377),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF0B1C30),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEFF4FF),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFF0B1C30),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF4D4636),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _translateGender(
    String gender,
    AppLocalizations l10n,
  ) {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return l10n.male;

      case 'FEMALE':
        return 'أنثى';

      default:
        return gender;
    }
  }
}