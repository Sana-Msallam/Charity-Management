import 'package:charity_management/Orphan/Screen/orphan_profile.dart';
import 'package:charity_management/Sponsership/cubit/sponsorship_list_cubit.dart';
import 'package:charity_management/Sponsership/cubit/sponsorship_list_state.dart';
import 'package:charity_management/Sponsership/model/sponsorship_list_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SponsorshipsScreen extends StatelessWidget {
  const SponsorshipsScreen({Key? key}) : super(key: key);

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

    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/orphan_profile.jpg'),
            ),
          ),
          title: Text(
            l10n.currentSponsorships,
            style: const TextStyle(
              color: primaryYellow,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: textDark),
              onPressed: () {},
            ),
          ],
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
                        child: const Text('إعادة المحاولة'),
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
                        sponsorship.status == 'ACCEPTED' 
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
                            Text(
                              l10n.overview,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.currentSponsorships,
                              style: const TextStyle(
                                color: textDark,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.sponsoredChildrenCount,
                                  style: const TextStyle(
                                    color: textDark,
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
                              color: textDark,
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
                                'لا توجد كفالات بهذه الحالة',
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

                            final orphan = sponsorship.orphan;

                            final name = orphan != null
                                ? orphan.fullName
                                : 'الكفالة قيد المراجعة';

                            final grade = orphan?.className ?? '';

                            return InkWell(
                              onTap: sponsorship.status == 'CANCELLED'
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrphanDetailsScreen(
                                                sponsorship: sponsorship,
                                              ),
                                        ),
                                      );
                                    },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_back_ios_new,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const Spacer(),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            color: textDark,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        if (grade.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            grade,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],

                                        const SizedBox(height: 6),

                                        _buildStatusBadge(sponsorship.status),
                                      ],
                                    ),

                                    const SizedBox(width: 16),

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/orphan_profile.jpg',
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      ),
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

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case 'ACCEPTED':
        backgroundColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        text = 'مقبولة';
        break;

      case 'PENDING':
        backgroundColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57F17);
        text = 'قيد الانتظار';
        break;

      case 'CANCELLED':
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        text = 'ملغاة';
        break;

      case 'REJECTED':
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        text = 'مرفوضة';
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
            crossAxisAlignment: CrossAxisAlignment.end,
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

              const Text(
                'تصفية الكفالات',
                style: TextStyle(
                  color: Color(0xFF1A2E40),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildFilterOption(title: 'جميع الكفالات', value: null),

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
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFD4AF37) : Colors.grey,
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF765A00)
                    : const Color(0xFF1A2E40),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusName(String status) {
    switch (status) {
      case 'ACCEPTED':
        return 'مقبولة';

      case 'PENDING':
        return 'قيد الانتظار';

      case 'CANCELLED':
        return 'ملغاة';

      case 'REJECTED':
        return 'مرفوضة';

      default:
        return status;
    }
  }
}
