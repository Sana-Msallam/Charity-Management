import 'package:charity_management/Sponsership/Screen/sponsership_success_screen.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

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

    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFBF7),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF765A00)),
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
                // 1. بنر الإعلان الرئيسي لتقديم الطلب
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/orphan_profile.jpg',
                      ), // مسار تعبيري لخلفية البنر
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

                // 2. كرت موثوقية تامة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEFEAE4)),
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

                // 3. قسم شروط وأحكام الكفالة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEFEAE4)),
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

                // 4. زر تأكيد وقبول الشروط السفلي
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D523A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // الانتقال لواجهة تم تقديم الطلب بنجاح
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SponsorshipSuccessScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.acceptSponsorshipTerms,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.assignment_turned_in_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. قسم فضل كفالة الأيتام مع الحديث النبوي
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
                          color: const Color(0xFF3D523A).withOpacity(0.6),
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
    );
  }

  // الدالة المحدثة تستقبل الآن String بشكل مباشر وتضعه داخل ويدجت الـ Text
  Widget buildConditionRow(String conditionText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF3D523A), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              conditionText, // هنا نمرر النص مباشرة
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
