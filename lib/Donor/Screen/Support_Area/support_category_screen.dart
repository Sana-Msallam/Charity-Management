import 'package:charity_management/Donor/Screen/Support_Area/aid_request_details_screen.dart';
import 'package:charity_management/Donor/cubit/aid_request_details_cubit.dart';
import 'package:charity_management/Donor/model/aid_request_model.dart';
import 'package:charity_management/Donor/cubit/aid_request_cubit.dart';
import 'package:charity_management/Donor/cubit/aid_request_state.dart';
import 'package:charity_management/Payment/Screen/checkout.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportCategoryScreen extends StatelessWidget {
  final String categoryTitle;
  final Color bannerColor;
  final int categoryId;
  const SupportCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.bannerColor,
    required this.categoryId,
  });
  @override
  Widget build(BuildContext context) {
    // تغليف واجهة القسم بـ Directionality لتصبح RTL بالكامل من اليمين
    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFBF7),
          elevation: 0,
          leading: IconButton(
            // قلب السهم البرمجي تلقائياً للخلف بناءً على الاتجاه
            icon: const Icon(Icons.arrow_back, color: Color(0xFF765A00)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            categoryTitle,
            style: const TextStyle(
              color: Color(0xFF765A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF765A00)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Color(0xFF765A00)),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),

                BlocBuilder<AidRequestCubit, AidRequestState>(
                  builder: (context, state) {
                    int count = 0;

                    if (state is AidRequestSuccessState) {
                      count = state.requests.length;
                    }

                    return buildActiveCasesBanner(context, count);
                  },
                ),
                const SizedBox(height: 20),

                BlocBuilder<AidRequestCubit, AidRequestState>(
                  builder: (context, state) {
                    if (state is AidRequestLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is AidRequestErrorState) {
                      return Center(child: Text(state.errorMessage));
                    }

                    if (state is AidRequestSuccessState) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.requests.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),

                        itemBuilder: (context, index) {
                          return buildCaseCard(context, state.requests[index]);
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActiveCasesBanner(BuildContext context, int count) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // يبدأ من اليمين
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.activeCases,
                style: const TextStyle(
                  color: Color(0xFF3D523A),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D523A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.availableCases(count), // عدد الحالات النشطة
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.supportCategoryDescription(categoryTitle),
            style: const TextStyle(
              color: Color(0xFF5D754C),
              fontSize: 12,
              height: 1.4,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCaseCard(BuildContext context, AidRequestModel item) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => AidRequestDetailsCubit()..fetchDetails(item.id),

              child: AidRequestDetailsScreen(id: item.id),
            ),
          ),
        );
      },

      child: Container(
        width: double.infinity,

        clipBehavior: Clip.antiAlias,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: const Color(0xFFEFEAE4)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(
              height: 160,

              width: double.infinity,

              child: Image.network(
                '${ApiConstants.baseUrl}/${item.image}',

                fit: BoxFit.cover,

                errorBuilder: (context, error, stack) {
                  return const Icon(Icons.image);
                },
              ),
            ),

            if (item.isUrgent)
              Container(
                margin: const EdgeInsets.all(12),

                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  l10n.urgent,
                  style: const TextStyle(
                    color: Color(0xFFA8201A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    item.title,

                    style: const TextStyle(
                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                      color: Color(0xFF2B2D42),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.remainingAmount('${item.remainingAmount}\$'),

                    style: const TextStyle(
                      color: Color(0xFFFFD56B),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(l10n.collected),

                          Text(
                            '${item.paidAmount}\$',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          Text(l10n.target),

                          Text(
                            '${item.totalCost}\$',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: item.completionPercentage / 100,

                    minHeight: 8,
                  ),

                  const SizedBox(height: 8),

                  Text('${item.completionPercentage}%'),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,

                    height: 46,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5D166),
                        foregroundColor: const Color(0xFF765A00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              requestId: item.id,
                              title: item.title,
                              totalCost: item.totalCost,
                              paidAmount: item.paidAmount,
                              remainingAmount: item.remainingAmount,
                            ),
                          ),
                        ).then((paymentCompleted) {
                          if (paymentCompleted == true && context.mounted) {
                            context.read<AidRequestCubit>().fetchAidRequests(
                              categoryId: categoryId,
                            );
                          }
                        });
                      },

                      child: Text(l10n.donateNow),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
