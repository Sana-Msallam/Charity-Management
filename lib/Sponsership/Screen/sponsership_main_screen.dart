import 'package:charity_management/Payment/Screen/wallet_top_up_screen.dart';
import 'package:charity_management/Payment/cubit/wallet_top_up_cubit.dart';
import 'package:charity_management/Payment/cubit/wallet_top_up_state.dart';
import 'package:charity_management/Sponsership/Screen/sponsership_request.dart';
import 'package:charity_management/Sponsership/Screen/sponsorships_screen.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SponsorshipMainScreen extends StatelessWidget {
  const SponsorshipMainScreen({super.key});

  static const Color primaryGreen = Color(0xFF3D523A);
  static const Color primaryGold = Color(0xFF765A00);
  static const Color lightGold = Color(0xFFF5D166);
  static const Color background = Color(0xFFFDFBF7);
  static const Color softBackground = Color(0xFFF7F2EA);
  static const Color borderColor = Color(0xFFEFEAE4);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => WalletTopUpCubit()..fetchBalance(localizations: l10n),
      child: Builder(
        builder: (context) {
          final isRtl = Directionality.of(context) == TextDirection.rtl;

          return Directionality(
            textDirection: Directionality.of(context),
            child: Scaffold(
              backgroundColor: background,
              appBar: AppBar(
                backgroundColor: background,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: primaryGold,
                    size: 20,
                  ),
                ),
                centerTitle: true,
                title: Text(
                  l10n.sponsorships,
                  style: const TextStyle(
                    color: primaryGold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: primaryGold,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   l10n.sponsorshipsPageDescription,
                      //   style: const TextStyle(
                      //     color: Color(0xFF77736B),
                      //     fontSize: 13,
                      //     height: 1.5,
                      //     fontFamily: 'IBM Plex Sans Arabic',
                      //   ),
                      // ),

                      // const SizedBox(height: 4),

                      // Wallet
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primaryGreen.withValues(alpha: 0.14),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: lightGold,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.currentWalletBalance,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontFamily: 'IBM Plex Sans Arabic',
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: Color(0xFF8BC48A),
                                        size: 7,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        l10n.active,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          fontFamily: 'IBM Plex Sans Arabic',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            BlocBuilder<WalletTopUpCubit, WalletTopUpState>(
                              builder: (context, state) {
                                return _buildWalletBalanceContent(
                                  context,
                                  state,
                                  l10n,
                                );
                              },
                            ),

                            const SizedBox(height: 4),

                            // Text(
                            //   l10n.availableForSponsorship,
                            //   textAlign: TextAlign.start,
                            //   style: const TextStyle(
                            //     color: Colors.white54,
                            //     fontSize: 11,
                            //     fontFamily: 'IBM Plex Sans Arabic',
                            //   ),
                            // ),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _openWalletTopUp(context, l10n),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: lightGold,
                                  foregroundColor: primaryGold,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add_rounded, size: 21),
                                    const SizedBox(width: 7),
                                    Text(
                                      l10n.topUpWallet,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'IBM Plex Sans Arabic',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 20),

                      // My Sponsorships
                      Row(
                        children: [
                          // Container(
                          //   width: 4,
                          //   height: 22,
                          //   decoration: BoxDecoration(
                          //     color: primaryGold,
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          // ),
                          // const SizedBox(width: 9),
                          // Text(
                          //   l10n.mySponsorships,
                          //   style: const TextStyle(
                          //     color: Color(0xFF29291F),
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //     fontFamily: 'IBM Plex Sans Arabic',
                          //   ),
                          // ),
                          // const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SponsorshipsScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: primaryGold,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Text(
                                //   l10n.viewAll,
                                //   style: const TextStyle(
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.w600,
                                //     fontFamily: 'IBM Plex Sans Arabic',
                                //   ),
                                // ),
                                // const SizedBox(width: 3),
                                // const Icon(
                                //   Icons.arrow_forward_ios_rounded,
                                //   size: 11,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SponsorshipsScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.025),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: primaryGold.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  color: primaryGold,
                                  size: 27,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.mySponsorships,
                                      style: const TextStyle(
                                        color: Color(0xFF29291F),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'IBM Plex Sans Arabic',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      l10n.manageCurrentSponsoredOrphans,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF817D75),
                                        fontSize: 11,
                                        height: 1.4,
                                        fontFamily: 'IBM Plex Sans Arabic',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: softBackground,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Icon(
                                  isRtl
                                      ? Icons.arrow_back_ios_new_rounded
                                      : Icons.arrow_forward_ios_rounded,
                                  color: primaryGold,
                                  size: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // New Sponsorship
                      // Text(
                      //   l10n.supportAChild,
                      //   style: const TextStyle(
                      //     color: Color(0xFF29291F),
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     fontFamily: 'IBM Plex Sans Arabic',
                      //   ),
                      // ),

                      // const SizedBox(height: 4),

                      // Text(
                      //   l10n.startNewSponsorshipDescription,
                      //   style: const TextStyle(
                      //     color: Color(0xFF77736B),
                      //     fontSize: 12,
                      //     fontFamily: 'IBM Plex Sans Arabic',
                      //   ),
                      // ),

                      // const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SponsorshipRequestScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: softBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: primaryGreen,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.person_add_alt_1_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.addNewSponsorship,
                                      style: const TextStyle(
                                        color: primaryGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'IBM Plex Sans Arabic',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.chooseOrphanAndStartSponsorship,
                                      style: const TextStyle(
                                        color: Color(0xFF77736B),
                                        fontSize: 11,
                                        height: 1.4,
                                        fontFamily: 'IBM Plex Sans Arabic',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              Icon(
                                isRtl
                                    ? Icons.arrow_back_ios_new_rounded
                                    : Icons.arrow_forward_ios_rounded,
                                color: primaryGreen,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: lightGold.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: lightGold.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: primaryGold,
                              size: 19,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.walletBalanceUsedForSponsorship,
                                style: const TextStyle(
                                  color: Color(0xFF765A00),
                                  fontSize: 11,
                                  height: 1.5,
                                  fontFamily: 'IBM Plex Sans Arabic',
                                ),
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
        },
      ),
    );
  }

  Widget _buildWalletBalanceContent(
    BuildContext context,
    WalletTopUpState state,
    AppLocalizations l10n,
  ) {
    if (state.balanceStatus == WalletBalanceStatus.loading) {
      return Row(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.3,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.walletBalanceLoading,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
      );
    }

    if (state.balanceStatus == WalletBalanceStatus.failure) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.balanceErrorMessage ?? l10n.couldNotLoadWalletBalance,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
          TextButton.icon(
            onPressed: state.isBalanceLoading
                ? null
                : () => context.read<WalletTopUpCubit>().fetchBalance(
                    localizations: l10n,
                    force: true,
                  ),
            style: TextButton.styleFrom(
              foregroundColor: lightGold,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 34),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              l10n.retry,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
      );
    }

    final balance = state.balance;
    if (state.balanceStatus == WalletBalanceStatus.success && balance != null) {
      return Text(
        '${balance.balance} ${balance.currency}',
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      );
    }

    return Text(
      l10n.walletBalanceUnavailable,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'IBM Plex Sans Arabic',
      ),
    );
  }

  Future<void> _openWalletTopUp(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletTopUpScreen()),
    );

    if (!context.mounted) {
      return;
    }

    context.read<WalletTopUpCubit>().fetchBalance(
      localizations: l10n,
      force: true,
    );
  }
}
