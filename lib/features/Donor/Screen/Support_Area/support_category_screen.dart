
import 'package:charity_management/Payment/Screen/checkout.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/features/Donor/Screen/Support_Area/aid_request_details_screen.dart';
import 'package:charity_management/features/Donor/cubit/aid_request_cubit.dart';
import 'package:charity_management/features/Donor/cubit/aid_request_details_cubit.dart';
import 'package:charity_management/features/Donor/cubit/aid_request_state.dart';
import 'package:charity_management/features/Donor/model/aid_request_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportCategoryScreen extends StatefulWidget {
  final String categoryTitle;
  final Color bannerColor;
  final int categoryId;
  final bool isGuest;

  const SupportCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.bannerColor,
    required this.categoryId,
    this.isGuest = false,
  });

  @override
  State<SupportCategoryScreen> createState() =>
      _SupportCategoryScreenState();
}

class _SupportCategoryScreenState extends State<SupportCategoryScreen> {
  String _urgentFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Directionality(
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

          title: Text(
            widget.categoryTitle,
            style: const TextStyle(
              color: Color(0xFF765A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(
                Icons.tune,
                color: Color(0xFF765A00),
              ),
              tooltip: 'فلترة حسب الاستعجال',
              onPressed: _showUrgentFilter,
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),

                // BlocBuilder<AidRequestCubit, AidRequestState>(
                //   builder: (context, state) {
                //     int count = 0;

                //     if (state is AidRequestSuccessState) {
                //       count = state.requests.length;
                //     }

                //     return buildActiveCasesBanner(
                //       context,
                //       count,
                //     );
                //   },
                // ),

                const SizedBox(height: 20),

                BlocBuilder<AidRequestCubit, AidRequestState>(
                  builder: (context, state) {
                    if (state is AidRequestLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
if (state is AidRequestErrorState) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'حدث خطأ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),

        const SizedBox(height: 12),

        ElevatedButton(
          onPressed: () {
            context.read<AidRequestCubit>().fetchAidRequests(
              categoryId: widget.categoryId,
            );
          },
          child: const Text(
            'إعادة المحاولة',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ),
      ],
    ),
  );
}

                    if (state is AidRequestSuccessState) {
                      final filteredRequests =
                          state.requests.where((item) {
                        if (_urgentFilter == 'urgent') {
                          return item.isUrgent;
                        }

                        if (_urgentFilter == 'notUrgent') {
                          return !item.isUrgent;
                        }

                        return true;
                      }).toList();

                      if (filteredRequests.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 40,
                          ),
                          child: Center(
                            child: Text(
                              'لا توجد حالات مطابقة للفلتر',
                              style: TextStyle(
                                color: Color(0xFF765A00),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily:
                                    'IBM Plex Sans Arabic',
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: filteredRequests.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          return buildCaseCard(
                            context,
                            filteredRequests[index],
                          );
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

  void _showUrgentFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'عرض الحالات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2D42),
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),

              const SizedBox(height: 16),

              RadioListTile<String>(
                value: 'all',
                groupValue: _urgentFilter,
                title: const Text(
                  'كل الحالات',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                activeColor: const Color(0xFF765A00),
                onChanged: (value) {
                  setState(() {
                    _urgentFilter = value!;
                  });

                  Navigator.pop(context);
                },
              ),

              RadioListTile<String>(
                value: 'urgent',
                groupValue: _urgentFilter,
                title: const Text(
                  'الحالات العاجلة',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                activeColor: const Color(0xFFA8201A),
                onChanged: (value) {
                  setState(() {
                    _urgentFilter = value!;
                  });

                  Navigator.pop(context);
                },
              ),

              RadioListTile<String>(
                value: 'notUrgent',
                groupValue: _urgentFilter,
                title: const Text(
                  'الحالات غير العاجلة',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                activeColor: const Color(0xFF765A00),
                onChanged: (value) {
                  setState(() {
                    _urgentFilter = value!;
                  });

                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Widget buildActiveCasesBanner(
  //   BuildContext context,
  //   int count,
  // ) {
  //   final l10n = AppLocalizations.of(context);

  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: widget.bannerColor,
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment:
  //               MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               l10n.activeCases,
  //               style: const TextStyle(
  //                 color: Color(0xFF3D523A),
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold,
  //                 fontFamily: 'IBM Plex Sans Arabic',
  //               ),
  //             ),

  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 10,
  //                 vertical: 4,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF3D523A),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Text(
  //                 l10n.availableCases(count),
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 11,
  //                   fontWeight: FontWeight.bold,
  //                   fontFamily: 'IBM Plex Sans Arabic',
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 8),

  //         Text(
  //           l10n.supportCategoryDescription(
  //             widget.categoryTitle,
  //           ),
  //           style: const TextStyle(
  //             color: Color(0xFF5D754C),
  //             fontSize: 12,
  //             height: 1.4,
  //             fontFamily: 'IBM Plex Sans Arabic',
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildCaseCard(
    BuildContext context,
    AidRequestModel item,
  ) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: () => _openAidRequestDetails(context, item),

      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFEFEAE4),
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            SizedBox(
              height: 160,
              width: double.infinity,

              child: Image.network(
                '${ApiConstants.baseUrl}/${item.image}',
                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stack) {
                  return const Icon(
                    Icons.image,
                  );
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
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Text(
                  l10n.urgent,
                  style: const TextStyle(
                    color: Color(0xFFA8201A),
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        'IBM Plex Sans Arabic',
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2D42),
                      fontFamily:
                          'IBM Plex Sans Arabic',
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.remainingAmount(
                      '${item.remainingAmount}\$',
                    ),
                    style: const TextStyle(
                      color: Color(0xFFFFD56B),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          'IBM Plex Sans Arabic',
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            l10n.collected,
                            style: const TextStyle(
                              fontFamily:
                                  'IBM Plex Sans Arabic',
                            ),
                          ),

                          Text(
                            '${item.paidAmount}\$',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,

                        children: [
                          Text(
                            l10n.target,
                            style: const TextStyle(
                              fontFamily:
                                  'IBM Plex Sans Arabic',
                            ),
                          ),

                          Text(
                            '${item.totalCost}\$',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value:
                        item.completionPercentage / 100,
                    minHeight: 8,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${item.completionPercentage}%',
                    style: const TextStyle(
                      fontFamily:
                          'IBM Plex Sans Arabic',
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 46,

                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFF5D166),
                        foregroundColor:
                            const Color(0xFF765A00),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutScreen(
                              requestId: item.id,
                              title: item.title,
                              totalCost: item.totalCost,
                              paidAmount: item.paidAmount,
                              remainingAmount:
                                  item.remainingAmount,
                            ),
                          ),
                        );
                      },

                      child: Text(
                        l10n.donateNow,
                        style: const TextStyle(
                          fontFamily:
                              'IBM Plex Sans Arabic',
                        ),
                      ),
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

  void _openAidRequestDetails(BuildContext context, AidRequestModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AidRequestDetailsCubit()..fetchDetails(item.id),
          child: AidRequestDetailsScreen(
            id: item.id,
            isGuest: widget.isGuest,
          ),
        ),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<AidRequestCubit>().fetchAidRequests(
          categoryId: widget.categoryId,
        );
      }
    });
  }
}

