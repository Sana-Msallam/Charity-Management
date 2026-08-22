import 'package:charity_management/Orphan/Screen/orphan_profile.dart';
import 'package:charity_management/Sponsership/cubit/sponsorship_list_cubit.dart';
import 'package:charity_management/Sponsership/cubit/sponsorship_list_state.dart';
import 'package:charity_management/Sponsership/model/sponsorship_list_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SponsorshipsScreen extends StatelessWidget {
  const SponsorshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SponsorshipListCubit()..getSponsorships(),
      child: const _SponsorshipsView(),
    );
  }
}

class _SponsorshipsView extends StatefulWidget {
  const _SponsorshipsView();

  @override
  State<_SponsorshipsView> createState() => _SponsorshipsViewState();
}

class _SponsorshipsViewState extends State<_SponsorshipsView> {
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    const Color primaryYellow = Color(0xFFD4AF37);
    const Color lightCardBg = Color(0xFFFDF8EB);
    const Color textDark = Color(0xFF1A2E40);
    const Color primaryGold = Color(0xFF765A00);

    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          leading: BackButton(color: primaryGold),
          title: Text(
            l10n.currentSponsorships,
            style: const TextStyle(
              color: primaryGold,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<SponsorshipListCubit, SponsorshipListState>(
          builder: (context, state) {
            if (state is SponsorshipListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SponsorshipListError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 12),
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<SponsorshipListCubit>()
                              .getSponsorships();
                        },
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is SponsorshipListSuccess) {
              final sponsorships = state.sponsorships;

              final currentSponsorships = sponsorships
                  .where(
                    (sponsorship) =>
                        sponsorship.status.trim().toUpperCase() == 'ACCEPTED',
                    // ||
                    // sponsorship.status == 'PENDING',
                  )
                  .toList();

              final filteredSponsorships = selectedStatus == null
                  ? sponsorships
                  : sponsorships.where((sponsorship) {
                      return sponsorship.status == selectedStatus;
                    }).toList();

              return RefreshIndicator(
                onRefresh: () {
                  return context.read<SponsorshipListCubit>().getSponsorships();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: lightCardBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   l10n.overview,
                            //   style: const TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 14,
                            //   ),
                            // ),
                            // const SizedBox(height: 4),
                            // Text(
                            //   l10n.currentSponsorships,
                            //   style: const TextStyle(
                            //     color: textDark,
                            //     fontSize: 22,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.sponsoredChildrenCount,
                                  style: const TextStyle(
                                    color: primaryGold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryYellow,
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: Text(
                                    l10n.sponsoredChildrenTotal(
                                      currentSponsorships.length,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.sponsoredList,
                            style: const TextStyle(
                              color: primaryGold,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          IconButton(
                            icon: Icon(
                              Icons.tune,
                              color: selectedStatus == null
                                  ? Colors.grey
                                  : primaryYellow,
                            ),
                            onPressed: () {
                              _showFilterBottomSheet(context, sponsorships);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (filteredSponsorships.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.filter_alt_off_outlined,
                                size: 42,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.noSponsorshipsForStatus,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredSponsorships.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final sponsorship = filteredSponsorships[index];

                            final name = _sponsorshipCardTitle(
                              sponsorship,
                              l10n,
                            );

                            return InkWell(
                              onTap: () async {
                                final shouldRefresh =
                                    await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrphanDetailsScreen(
                                              sponsorship: sponsorship,
                                            ),
                                      ),
                                    );
                                if (!context.mounted) {
                                  return;
                                }
                                if (shouldRefresh == true) {
                                  context
                                      .read<SponsorshipListCubit>()
                                      .getSponsorships();
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.02,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: lightCardBg,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.child_care,
                                        color: primaryGold,
                                        size: 34,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              color: textDark,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          _buildStatusBadge(
                                            sponsorship.status,
                                            l10n,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 24),

                      // Container(
                      //   width: double.infinity,
                      //   height: 140,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(16),
                      //     image: const DecorationImage(
                      //       image: AssetImage('assets/orphan_profile.jpg'),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(16),
                      //       gradient: LinearGradient(
                      //         begin: Alignment.bottomCenter,
                      //         end: Alignment.topCenter,
                      //         colors: [
                      //           Colors.black.withOpacity(0.8),
                      //           Colors.transparent,
                      //         ],
                      //       ),
                      //     ),
                      //     padding: const EdgeInsets.all(16),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [

                      //         const SizedBox(height: 4),
                      //         Text(
                      //           l10n.givingImpactDescription,
                      //           style: const TextStyle(
                      //             color: Colors.white70,
                      //             fontSize: 13,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, AppLocalizations l10n) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status.trim().toUpperCase()) {
      case 'ACCEPTED':
        backgroundColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        text = l10n.sponsorshipStatusAccepted;
        break;

      case 'PENDING':
        backgroundColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57F17);
        text = l10n.sponsorshipStatusPending;
        break;

      case 'CANCELLED':
      case 'CANCELED':
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        text = l10n.sponsorshipStatusCancelled;
        break;

      case 'REJECTED':
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        text = l10n.sponsorshipStatusRejected;
        break;

      default:
        backgroundColor = const Color(0xFFE0F7FA);
        textColor = const Color(0xFF00838F);
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _sponsorshipCardTitle(
    SponsorshipListModel sponsorship,
    AppLocalizations l10n,
  ) {
    final orphan = sponsorship.orphan;
    final status = sponsorship.status.trim().toUpperCase();

    switch (status) {
      case 'PENDING':
        return l10n.sponsorshipUnderReview;
      case 'REJECTED':
        return l10n.sponsorshipRejectedTitle;
      case 'ACCEPTED':
        return orphan?.fullName ?? l10n.sponsorshipDetailsUnavailableTitle;
      case 'CANCELLED':
      case 'CANCELED':
        return orphan?.fullName ?? l10n.cancelledSponsorshipNoOrphanTitle;
      default:
        return orphan?.fullName ?? l10n.sponsorshipDetailsUnavailableTitle;
    }
  }

  void _showFilterBottomSheet(
    BuildContext context,
    List<SponsorshipListModel> sponsorships,
  ) {
    final statuses = <String>{
      ...sponsorships.map((sponsorship) => sponsorship.status),
    }.toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                AppLocalizations.of(context).filterSponsorships,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Color(0xFF1A2E40),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildFilterOption(
                title: AppLocalizations.of(context).allSponsorships,
                value: null,
              ),

              ...statuses.map((status) {
                return _buildFilterOption(
                  title: _statusName(status),
                  value: status,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({required String title, required String? value}) {
    final isSelected = selectedStatus == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedStatus = value;
        });

        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDF8EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF765A00)
                      : const Color(0xFF1A2E40),
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFD4AF37) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  String _statusName(String status) {
    final l10n = AppLocalizations.of(context);

    switch (status.trim().toUpperCase()) {
      case 'ACCEPTED':
        return l10n.sponsorshipStatusAccepted;

      case 'PENDING':
        return l10n.sponsorshipStatusPending;

      case 'CANCELLED':
      case 'CANCELED':
        return l10n.sponsorshipStatusCancelled;

      case 'REJECTED':
        return l10n.sponsorshipStatusRejected;

      default:
        return status;
    }
  }
}
