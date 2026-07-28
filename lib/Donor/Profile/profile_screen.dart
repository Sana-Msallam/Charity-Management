import 'package:charity_management/Donor/Profile/Cubit/profile_cubit.dart';
import 'package:charity_management/Donor/Profile/Cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),

        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFBF7),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'الحساب',
            style: TextStyle(
              color: Color(0xFF765A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFF765A00),
          ),
        ),

        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProfileErrorState) {
              return Center(
                child: Text(state.errorMessage),
              );
            }

            if (state is ProfileSuccessState) {
              final profile = state.profile;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF7F2EA),
                        border: Border.all(
                          color: const Color(0xFFF5D166),
                          width: 3,
                        ),
                      ),
                      child: profile.personalPhoto != null &&
                              profile.personalPhoto!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                'http://192.168.1.14:3000/${profile.personalPhoto}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Color(0xFF765A00),
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 60,
                              color: Color(0xFF765A00),
                            ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        color: Color(0xFF2B2D42),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      profile.gender == 'MALE' ? 'ذكر' : 'أنثى',
                      style: const TextStyle(
                        color: Color(0xFF3D523A),
                        fontSize: 14,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),

                    const SizedBox(height: 30),

                    buildInfoCard(
                      icon: Icons.phone,
                      title: 'رقم الهاتف',
                      value: profile.number,
                    ),

                    buildInfoCard(
                      icon: Icons.cake_outlined,
                      title: 'العمر',
                      value: '${profile.age} سنة',
                    ),

                    buildInfoCard(
                      icon: Icons.location_on_outlined,
                      title: 'العنوان',
                      value: profile.address.toString(),
                    ),

                    buildInfoCard(
                      icon: Icons.work_outline,
                      title: 'حالة العمل',
                      value:
                          profile.isUnemployed ? 'غير موظف' : 'موظف',
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

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEFEAE4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F2EA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF765A00),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF8A817C),
                  fontSize: 12,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF2B2D42),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}