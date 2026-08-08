import 'package:charity_management/Donor/cubit/aid_request_details_cubit.dart';
import 'package:charity_management/Donor/cubit/aid_request_details_state.dart';
import 'package:charity_management/Payment/Screen/checkout.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AidRequestDetailsScreen extends StatelessWidget {
  final int id;

  const AidRequestDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Directionality(
      textDirection: Directionality.of(context),

      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),

        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFBF7),

          elevation: 0,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF765A00)),

            onPressed: () {
              Navigator.pop(context);
            },
          ),

          title: Text(
            l10n.caseDetails,

            style: const TextStyle(
              color: Color(0xFF765A00),

              fontWeight: FontWeight.bold,

              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ),

        body: BlocBuilder<AidRequestDetailsCubit, AidRequestDetailsState>(
          builder: (context, state) {
            if (state is AidRequestDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AidRequestDetailsErrorState) {
              return Center(child: Text(state.error));
            }

            if (state is AidRequestDetailsSuccessState) {
              final item = state.request;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: Image.network(
                        '${ApiConstants.baseUrl}/${item.image}',

                        height: 220,

                        width: double.infinity,

                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stack) {
                          return Container(
                            height: 220,

                            color: Colors.grey.shade200,

                            child: const Icon(Icons.image, size: 50),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Expanded(
                          child: Text(
                            item.title,

                            style: const TextStyle(
                              fontSize: 22,

                              fontWeight: FontWeight.bold,

                              color: Color(0xFF2B2D42),

                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                        ),

                        if (item.isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: const Color(0xFFFBE8E7),

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
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      item.description,

                      style: const TextStyle(
                        fontSize: 15,

                        height: 1.6,

                        color: Color(0xFF7F8C8D),

                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        children: [
                          buildMoneyRow(
                            l10n.requiredAmount,
                            '${item.totalCost}\$',
                          ),

                          buildMoneyRow(
                            l10n.amountCollected,
                            '${item.paidAmount}\$',
                          ),

                          buildMoneyRow(
                            l10n.amountRemaining,
                            '${item.remainingAmount}\$',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      l10n.completionPercentage(item.completionPercentage),

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: LinearProgressIndicator(
                        minHeight: 10,

                        value: item.completionPercentage / 100,

                        backgroundColor: const Color(0xFFF2ECE4),

                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF3D523A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,

                      height: 50,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5D166),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                requestId: id,
                                title: item.title,
                                totalCost: item.totalCost,
                                paidAmount: item.paidAmount,
                                remainingAmount: item.remainingAmount,
                              ),
                            ),
                          ).then((paymentCompleted) {
                            if (paymentCompleted == true && context.mounted) {
                              context
                                  .read<AidRequestDetailsCubit>()
                                  .fetchDetails(id);
                            }
                          });
                        },

                        child: Text(
                          l10n.donateNow,

                          style: const TextStyle(
                            color: Color(0xFF765A00),

                            fontWeight: FontWeight.bold,

                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget buildMoneyRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title, style: const TextStyle(color: Color(0xFF8A817C))),

          Text(
            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,

              color: Color(0xFF3D523A),
            ),
          ),
        ],
      ),
    );
  }
}
