import 'package:charity_management/Donor/Profile/Cubit/profile_cubit.dart';
import 'package:charity_management/Donor/Profile/profile_screen.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Drawer(
      backgroundColor: const Color(0xFFFDFBF7),

      child: Directionality(
        textDirection: Directionality.of(context),

        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // صورة المستخدم
              Container(
                width: 90,
                height: 90,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: const Color(0xFFF7F2EA),

                  border: Border.all(color: const Color(0xFFF5D166), width: 3),
                ),

                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF765A00),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'سارة أحمد',

                style: TextStyle(
                  color: Color(0xFF2B2D42),

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5D166),

                      foregroundColor: const Color(0xFF765A00),

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    icon: const Icon(Icons.person_outline),

                    label: Text(
                      l10n.profileTitle,

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,

                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ProfileCubit()..fetchProfile(),

                            child: const ProfileScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Divider(color: Color(0xFFEFEAE4)),
            ],
          ),
        ),
      ),
    );
  }
}
