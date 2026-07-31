import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CompletedProjectsSection extends StatelessWidget {
  const CompletedProjectsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    //هون بدنا  نجيبه من ال api بس هاد شككل مؤقت

    final List<Map<String, String>> projects = [
      {
        'title': l10n.waterWellProject,
        'image':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD-kuabX-boPKskPS_H2kQweFRndQMI-qIkx2JwlmeaIuIFv9BD_dDAvoFhnECQ1-c0Gzt1ea-Ty7gFcMQKrRJ7wRo27nVrSV1t0huzSOVtIWSHQSyd1CVi3MOh9gv4G2e9QWn707Uw5Er4UMt0QOxiPYwW1VqRWnLb-B5Ev6OB2y1rEcpD0Lz0qJ3yavXkgo1okwv8a-iSPTClzcsiyZG_35QuHhocGIcE45favzL6uiz1BMvNn3lzJVsro5ZO-azOzGJK51Bhpt4',
      },
      {
        'title': l10n.schoolBuildingProject,
        'image':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDArY6r5__g1JCMjmSH6c8UAP27fiiiIa6ylpV6RMqbbcvAVXnxUW35QPiAjMHX6nmDgm1s87hRiB4q3cla15I-TOjJsZ0tRJcGR_2I7ZewIHQK6M0tqVLDDiT2fuPykCcFpU7I8w2akVpsyVA0Km4weNd_cFVyHnNdPnHKV4NDPK0uFNj_BDJS6lyjYLFcYl_IcK-Tmm-PvkmrA9JzynwcIE43od5kOrBLdZXqmwprIgwCLmWLVjrQYUC4evZoN5cVigAg1movQ2Y',
      },
      {
        'title': l10n.medicalComplexProject,
        'image':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBAvZT0n5bUsZYHCdmN7IKMG_QTZ2ngJsZEKNufxPgJCHFfS7r2QYJ0DME3Oidz9kCxa2OQdOYiyH-pYrRWB-qcQd-RPv0PkQChC5e6LAszTGsFHG8SgJppBWAQsQl0DGdQigFNDLVaG69seheZ9RszadiJC-0xI7764xJbHEE1o4nbhAuGK3328AqEjq7yNl6n-d6jYQjwDwbLhSEToCZr8DwF6NcFf12_QRNltg_t34X3c_yHGf0qBKGBHS2h0qvK7xI4_UwCX9c',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.completedProjectsTitle,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            //تاخذ مساحة العناصر فقط
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return Container(
                width: 192,
                margin: const EdgeInsets.only(left: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.1),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Column(
                    children: [
                      Image.network(
                        projects[index]['image']!,
                        height: 112,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            projects[index]['title']!,
                            style: const TextStyle(
                              color: AppColors.brandGray,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
