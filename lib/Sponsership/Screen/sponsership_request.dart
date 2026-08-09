 import 'package:charity_management/Sponsership/Cubit/sponsership_cubit.dart';
// import 'package:charity_management/Sponsership/Repository/sponsership_repository.dart';
import 'package:charity_management/Sponsership/Screen/sponsership_success_screen.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SponsorshipRequestScreen extends StatelessWidget {
  const SponsorshipRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final conditions = [
      l10n.sponsorshipTermWalletBalance,
      l10n.sponsorshipTermReservedBalance,
      l10n.sponsorshipTermLowBalance,
      l10n.sponsorshipTermOrphanSelection,
      l10n.sponsorshipTermFilesAccess,
    ];

    return BlocProvider(
     create: (_) => SponsorshipCubit(),
      child: BlocListener<SponsorshipCubit, SponsorshipState>(
        listener: (context, state) {
          if (state is SponsorshipSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const SponsorshipSuccessScreen(),
              ),
            );
          }


if (state is SponsorshipError) {
  if (state.message.contains('المحفظة') ||
      state.message.contains('رصيد') ||
      state.message.contains('wallet') ||
      state.message.contains('balance')) {
    showWalletEmptyDialog(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.message,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
      ),
    );
  }


          }
        },
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Scaffold(
            backgroundColor: const Color(0xFFFDFBF7),
            appBar: AppBar(
              backgroundColor: const Color(0xFFFDFBF7),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF765A00),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                l10n.newSponsorshipRequest,
                style: const TextStyle(
                  color: Color(0xFF765A00),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/orphan_profile.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
 end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          l10n.changeChildLife,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFEFEAE4),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            color: Color(0xFF765A00),
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.completeTrust,
                            style: const TextStyle(
                              color: Color(0xFF2B2D42),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.completeTrustDescription,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF8A817C),
                              fontSize: 12,
                              height: 1.4,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFEFEAE4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.gavel_outlined,
                                color: Color(0xFF765A00),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.sponsorshipTermsTitle,
                                style: const TextStyle(
                                  color: Color(0xFF765A00),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'IBM Plex Sans Arabic',
                                ),
                              ),
                            ],
                          ),
 const SizedBox(height: 16),

                          for (final condition in conditions)
                            buildConditionRow(condition),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    BlocBuilder<SponsorshipCubit, SponsorshipState>(
                      builder: (context, state) {
                        final isLoading =
                            state is SponsorshipLoading;

                        return SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF3D523A),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    context
                                        .read<SponsorshipCubit>()
                                        .createSponsorship();
                                  },
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<
                                              Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        l10n.acceptSponsorshipTerms,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight.bold,
                                          fontFamily:
                                              'IBM Plex Sans Arabic',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons
                                            .assignment_turned_in_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
color: const Color(0xFFF7F2EA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.orphanSponsorshipVirtue,
                            style: const TextStyle(
                              color: Color(0xFF765A00),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.orphanSponsorshipHadith,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF3D523A),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.narratedByBukhari,
                            style: TextStyle(
                              color: const Color(0xFF3D523A)
                                  .withOpacity(0.6),
                              fontSize: 11,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildConditionRow(String conditionText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF3D523A),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              conditionText,
              style: const TextStyle(
                color: Color(0xFF2B2D42),
                fontSize: 12,
                height: 1.5,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showWalletEmptyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE6A3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFF735C00),
                  size: 32,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'المحفظة فارغة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF735C00),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'لا يمكن تقديم طلب الكفالة لأن رصيد محفظتك غير كافٍ. يرجى شحن المحفظة للمتابعة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7C766C),
                  fontSize: 13,
                  height: 1.6,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // سيتم ربط شاشة شحن المحفظة لاحقًا
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF735C00),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'شحن المحفظة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF735C00),
                    side: const BorderSide(
                      color: Color(0xFFFCE6A3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
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

