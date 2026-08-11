
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/Donor/cubit/completed_aid_requests_cubit.dart';
import 'package:charity_management/Donor/cubit/completed_aid_requests_state.dart';
import 'package:charity_management/Donor/model/completed_aid_request_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedAidRequestsScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryTitle;

  const CompletedAidRequestsScreen({
    super.key,
    this.categoryId,
    this.categoryTitle,
  });

  @override
  State<CompletedAidRequestsScreen> createState() =>
      _CompletedAidRequestsScreenState();
}

class _CompletedAidRequestsScreenState
    extends State<CompletedAidRequestsScreen> {
  @override
  void initState() {
    super.initState();

    context
        .read<CompletedAidRequestsCubit>()
        .fetchCompletedAidRequests(
          categoryId: widget.categoryId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
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
          widget.categoryTitle ??
              l10n.completedAidCases,
          style: const TextStyle(
            color: Color(0xFF765A00),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
      ),

      body: BlocBuilder<
          CompletedAidRequestsCubit,
          CompletedAidRequestsState>(
        builder: (context, state) {
          if (state is CompletedAidRequestsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CompletedAidRequestsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ),
            );
          }

          if (state is CompletedAidRequestsSuccess) {
            if (state.requests.isEmpty) {
              return Center(
                child: Text(
                  l10n.noCompletedAidCases,
                  style: const TextStyle(
                    color: Color(0xFF765A00),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () {
                return context
                    .read<CompletedAidRequestsCubit>()
                    .fetchCompletedAidRequests(
                      categoryId: widget.categoryId,
                    );
              },

              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.requests.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return buildCompletedCaseCard(
                    context,
                    state.requests[index],
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget buildCompletedCaseCard(
    BuildContext context,
    CompletedAidRequestModel item,
  ) {
    final l10n = AppLocalizations.of(context);

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,

            child: Image.network(
              '${ApiConstants.baseUrl}/${item.image}',
              fit: BoxFit.cover,

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 50,
                    color: Color(0xFF8A817C),
                  ),
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
                borderRadius: BorderRadius.circular(12),
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
                    color: Color(0xFF765A00),
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
                            fontWeight: FontWeight.bold,
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
                            fontWeight: FontWeight.bold,
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
                  backgroundColor:
                      const Color(0xFFEFEAE4),
                  valueColor:
                      const AlwaysStoppedAnimation(
                    Color(0xFF3D523A),
                  ),
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
                    onPressed: null,

                    style:
                        ElevatedButton.styleFrom(
                      disabledBackgroundColor:
                          const Color(0xFFE7E3DA),
                      disabledForegroundColor:
                          const Color(0xFF3D523A),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),

                    child: Text(
                      l10n.completed,
                      style: const TextStyle(
                        fontFamily:
                            'IBM Plex Sans Arabic',
                        fontWeight: FontWeight.bold,
                      ),
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
}

