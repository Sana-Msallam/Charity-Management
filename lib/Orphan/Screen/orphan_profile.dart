import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class OrphanDetailsScreen extends StatelessWidget {
  const OrphanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ), // للحفاظ على مظهر متناسق
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),

                    // 1. كرت البيانات الشخصية العلوي
                    buildUpperProfileCard(context),

                    const SizedBox(height: 20),

                    // 2. كرت البيانات العائلية والشخصية
                    buildFamilyDataCard(context),

                    const SizedBox(height: 20),

                    // 3. كرت الوضع التعليمي والصحي
                    buildEducationalAndHealthCard(context),

                    const SizedBox(height: 20),

                    // 4. كرت بيانات ولي الأمر والمسؤولين
                    buildGuardianDataCard(context),

                    const SizedBox(height: 24),

                    // 5. زر تجديد الكفالة
                    buildActionButton(context),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // الكرت العلوي المحسن بالكامل بدون تداخل نصوص
  Widget buildUpperProfileCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
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
      child: Stack(
        children: [
          // الخط الذهبي العلوي في التغليف
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(height: 4, color: const Color(0xFF765A00)),
          ),

          // محتوى الكرت مرتب عمودياً بشكل سليم
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            child: Column(
              children: [
                // مجمع الصورة مع الرمز الصغير
                Center(
                  child: Stack(
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
                      // الأيقونة الذهبية الصغيرة أسفل اليمين من الصورة
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
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // الاسم
                const Text(
                  'أحمد محمد',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF765A00),
                    fontSize: 22,
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                // الرقم الرقمي
                Text(
                  l10n.digitalNumber('1045'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4D4636),
                    fontSize: 14,
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // شارة حالة الرعاية
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
                      width: 1,
                    ),
                  ),
                  child: Text(
                    l10n.underCareNow,
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
          ),
        ],
      ),
    );
  }

  // كرت البيانات العائلية والشخصية
  Widget buildFamilyDataCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1C5B1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                l10n.familyAndPersonalData,
                style: const TextStyle(
                  color: Color(0xFF765A00),
                  fontSize: 18,
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.people_outline, color: Color(0xFF765A00)),
            ],
          ),
          const SizedBox(height: 16),
          buildDataRow(l10n.fatherName, 'محمد علي'),
          buildDataRow(l10n.motherName, 'سارة حسن'),
          buildDataRow(l10n.gender, l10n.male),
          buildDataRow(l10n.dateOfBirth, '2014-05-12'),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0x1F0B1C30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.familyStatus,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF586377),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.sampleFamilyStatusDescription,
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

  // كرت الوضع التعليمي والصحي الجديد
  Widget buildEducationalAndHealthCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1C5B1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                l10n.educationAndHealthStatus,
                style: const TextStyle(
                  color: Color(0xFF765A00),
                  fontSize: 18,
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.school_outlined, color: Color(0xFF765A00)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: buildStatusBox(
                  l10n.healthStatus,
                  l10n.healthy,
                  Icons.local_hospital_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildStatusBox(
                  l10n.schoolGrade,
                  l10n.fourthGrade,
                  Icons.menu_book_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      l10n.healthDetails,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF586377),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.medical_services_outlined,
                      size: 16,
                      color: Color(0xFF586377),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.sampleHealthDetails,
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

  // كرت بيانات ولي الأمر والمسؤولين الجديد
  Widget buildGuardianDataCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1C5B1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                l10n.guardianAndOfficialsData,
                style: const TextStyle(
                  color: Color(0xFF765A00),
                  fontSize: 18,
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.assignment_ind_outlined,
                color: Color(0xFF765A00),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildDataRow(l10n.guardian, 'سارة حسن'),
          buildDataRow(l10n.contactNumber, '0599123456'),
          buildDataRow(l10n.siblingsCount, l10n.sampleSiblingsCount),
        ],
      ),
    );
  }

  // مربعات العرض الصغيرة (المرحلة الدراسية / الحالة الصحية)
  Widget buildStatusBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF586377), size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF586377), fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0B1C30),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDataRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEFF4FF), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0B1C30),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF4D4636), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF765A00),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.renewSponsorshipOrDonate,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.card_giftcard, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
