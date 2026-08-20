import 'package:charity_management/features/Donor/cubit/profile_cubit.dart';
import 'package:charity_management/features/Donor/cubit/profile_state.dart';
import 'package:charity_management/features/Donor/cubit/update_profile_cubit.dart';
import 'package:charity_management/features/Donor/cubit/update_profile_state.dart';
import 'package:charity_management/features/Donor/model/profile_model.dart';
import 'package:charity_management/features/Donor/model/profile_update_model.dart';
import 'package:charity_management/features/language/cubit/language_cubit.dart';
import 'package:charity_management/features/language/cubit/language_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:charity_management/routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const Color primary = Color(0xFF765A00);
  static const Color gold = Color(0xFFF5C84C);
  static const Color darkText = Color(0xFF292B3A);
  static const Color grayText = Color(0xFF817B76);
  static const Color green = Color(0xFF3D523A);
  static const Color background = Color(0xFFF9F7F2);
  static const Color softGold = Color(0xFFFFF4D5);
  static const Color softGreen = Color(0xFFEAF1E8);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  final TextEditingController _fullNameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _countryCodeController =
      TextEditingController();

  final TextEditingController _numberController =
      TextEditingController();

  String? _selectedGender;

  ProfileModel? _currentProfile;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _countryCodeController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _startEditing(ProfileModel profile) {
    _currentProfile = profile;

    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _countryCodeController.text = profile.countryCode;
    _numberController.text = profile.number;
    _selectedGender = profile.gender;

    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    FocusScope.of(context).unfocus();

    if (_currentProfile != null) {
      _fullNameController.text = _currentProfile!.fullName;
      _emailController.text = _currentProfile!.email;
      _countryCodeController.text = _currentProfile!.countryCode;
      _numberController.text = _currentProfile!.number;
      _selectedGender = _currentProfile!.gender;
    }

    setState(() {
      _isEditing = false;
    });
  }
Future<void> _saveChanges(
  UpdateProfileCubit cubit,
) async {
  final profile = _currentProfile;

  if (profile == null) {
    return;
  }

  FocusScope.of(context).unfocus();

  final fullName = _fullNameController.text.trim();
  final email = _emailController.text.trim();
  final countryCode = _countryCodeController.text.trim();
  final number = _numberController.text.trim();

  if (fullName.isEmpty ||
      email.isEmpty ||
      countryCode.isEmpty ||
      number.isEmpty ||
      _selectedGender == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'يرجى تعبئة جميع معلومات الملف الشخصي',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
      ),
    );

    return;
  }

  // تقسيم الاسم الكامل إلى firstName و lastName
  final nameParts = fullName.split(RegExp(r'\s+'));

  final firstName = nameParts.first;

  final lastName = nameParts.length > 1
      ? nameParts.sublist(1).join(' ')
      : '';

  final updateData = ProfileUpdateModel(
    firstName: firstName,
    lastName: lastName,
    email: email,
    countryCode: countryCode,
    number: number,
    gender: _selectedGender!,
  );

  print('');
  print('========================================');
  print('           SAVING PROFILE');
  print('========================================');
  print('FULL NAME: $fullName');
  print('FIRST NAME: $firstName');
  print('LAST NAME: $lastName');
  print('EMAIL: $email');
  print('COUNTRY CODE: $countryCode');
  print('NUMBER: $number');
  print('GENDER: $_selectedGender');
  print('REQUEST BODY: ${updateData.toJson()}');
  print('========================================');

  await cubit.updateProfile(updateData);
}
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => UpdateProfileCubit(),
      child: BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            print('');
            print('========================================');
            print('       PROFILE UPDATE SUCCESS');
            print('========================================');
            print('PROFILE UPDATE COMPLETED');
            print('========================================');

            /*
             * الـ PATCH يرجع null عندك.
             * لذلك لا نعتمد على response تبع PATCH.
             *
             * بعد نجاح التعديل نطلب GET /profile
             * حتى نجيب البيانات الجديدة من السيرفر.
             */

            setState(() {
              _isEditing = false;
            });

            context.read<ProfileCubit>().fetchProfile();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم تحديث معلوماتك بنجاح',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ),
            );

            return;
          }

          if (state is UpdateProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ),
            );
          }
        },
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Scaffold(
            backgroundColor: ProfileScreen.background,

            appBar: AppBar(
              backgroundColor: ProfileScreen.background,
              elevation: 0,
              centerTitle: true,

              title: Text(
                l10n.profileTitle,
                style: const TextStyle(
                  color: ProfileScreen.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),

              iconTheme: const IconThemeData(
                color: ProfileScreen.primary,
              ),

              actions: [
                BlocBuilder<
                    UpdateProfileCubit,
                    UpdateProfileState>(
                  builder: (context, updateState) {
                    final isSaving =
                        updateState is UpdateProfileLoading;

                    return IconButton(
                      tooltip: _isEditing
                          ? 'حفظ التعديلات'
                          : 'تعديل الملف الشخصي',

                      onPressed: isSaving
                          ? null
                          : () {
                              if (_isEditing) {
                                _saveChanges(
                                  context.read<UpdateProfileCubit>(),
                                );
                              } else if (_currentProfile != null) {
                                _startEditing(
                                  _currentProfile!,
                                );
                              }
                            },

                      icon: isSaving
                          ? const SizedBox(
                              width: 21,
                              height: 21,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ProfileScreen.primary,
                              ),
                            )
                          : Icon(
                              _isEditing
                                  ? Icons.check_rounded
                                  : Icons.edit_outlined,
                              color: ProfileScreen.primary,
                            ),
                    );
                  },
                ),

                if (_isEditing)
                  IconButton(
                    tooltip: 'إلغاء',
                    onPressed: _cancelEditing,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: ProfileScreen.grayText,
                    ),
                  ),
              ],
            ),

            body: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ProfileScreen.primary,
                    ),
                  );
                }

                if (state is ProfileErrorState) {
                  return _buildErrorState(
                    context,
                    l10n,
                  );
                }

                if (state is ProfileSuccessState) {
                  _syncProfile(state.profile);

                  return _buildContent(
                    context,
                    state.profile,
                    l10n,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _syncProfile(ProfileModel profile) {
    _currentProfile = profile;

    if (!_isEditing) {
      _fullNameController.text = profile.fullName;
      _emailController.text = profile.email;
      _countryCodeController.text = profile.countryCode;
      _numberController.text = profile.number;
      _selectedGender = profile.gender;
    }
  }

  Widget _buildContent(
    BuildContext context,
    ProfileModel profile,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          _buildProfileHeader(
            profile,
            l10n,
          ),

          const SizedBox(height: 22),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildWalletCard(
                  profile,
                  l10n,
                ),

                const SizedBox(height: 20),

                _buildSectionTitle(
                  l10n.personalInformation,
                  Icons.person_outline_rounded,
                ),

                const SizedBox(height: 12),

                _buildInfoGrid(
                  profile,
                  l10n,
                ),

                const SizedBox(height: 25),

                if (!_isEditing) ...[
                  _buildSettingsButton(
                    context,
                    l10n,
                  ),

                  const SizedBox(height: 20),

                  _buildLogoutButton(
                    context,
                    l10n,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    ProfileModel profile,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        25,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF4D5),
            Color(0xFFFDFBF7),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 122,
            height: 122,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: ProfileScreen.gold,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      ProfileScreen.primary.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: _defaultProfileIcon(),
            ),
          ),

          const SizedBox(height: 14),

          if (_isEditing)
            _buildEditField(
              controller: _fullNameController,
              label: 'الاسم الكامل',
              icon: Icons.person_outline_rounded,
            )
          else
            Text(
              profile.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ProfileScreen.darkText,
                fontSize: 23,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: ProfileScreen.primary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color:
                      ProfileScreen.primary.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  profile.isSponsor
                      ? Icons.child_care_rounded
                      : Icons.volunteer_activism_rounded,
                  size: 16,
                  color: Colors.white,
                ),

                const SizedBox(width: 6),

                Text(
                  profile.isSponsor
                      ? l10n.sponsor
                      : l10n.donor,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultProfileIcon() {
    return Container(
      color: ProfileScreen.softGold,
      child: const Icon(
        Icons.person_rounded,
        size: 65,
        color: ProfileScreen.primary,
      ),
    );
  }

  Widget _buildWalletCard(
    ProfileModel profile,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ProfileScreen.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: ProfileScreen.primary.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.walletBalance,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${profile.walletBalance} \$',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 1,
            height: 42,
            color: Colors.white.withOpacity(0.18),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.totalDonaited,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${profile.totalDonated} \$',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: ProfileScreen.softGold,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: ProfileScreen.primary,
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            color: ProfileScreen.darkText,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(
    ProfileModel profile,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        if (_isEditing) ...[
          _buildEditField(
            controller: _emailController,
            label: l10n.email,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              SizedBox(
                width: 105,
                child: _buildEditField(
                  controller: _countryCodeController,
                  label: 'الرمز',
                  icon: Icons.public_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildEditField(
                  controller: _numberController,
                  label: l10n.phoneNumber,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildGenderField(),
        ] else ...[
          _buildInfoCard(
            icon: Icons.phone_outlined,
            title: l10n.phoneNumber,
            value:
                '${profile.countryCode} ${profile.number}',
            color: const Color(0xFFEAF1FF),
            iconColor: const Color(0xFF4567A8),
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            icon: Icons.email_outlined,
            title: l10n.email,
            value: profile.email,
            color: const Color(0xFFF3EAFE),
            iconColor: const Color(0xFF7950A8),
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            icon: Icons.person_outline_rounded,
            title: 'الجنس',
            value: profile.gender,
            color: ProfileScreen.softGreen,
            iconColor: ProfileScreen.green,
          ),
        ],
      ],
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: ProfileScreen.darkText,
        fontSize: 14,
        fontFamily: 'IBM Plex Sans Arabic',
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: ProfileScreen.grayText,
          fontFamily: 'IBM Plex Sans Arabic',
        ),
        prefixIcon: Icon(
          icon,
          color: ProfileScreen.primary,
          size: 21,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.06),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.06),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: ProfileScreen.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: const InputDecoration(
          labelText: 'الجنس',
          labelStyle: TextStyle(
            color: ProfileScreen.grayText,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            color: ProfileScreen.primary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 'MALE',
            child: Text(
              'ذكر',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
          DropdownMenuItem(
            value: 'FEMALE',
            child: Text(
              'أنثى',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: ProfileScreen.grayText,
                    fontSize: 11,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value.isEmpty ? 'غير محدد' : value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ProfileScreen.darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return _buildMainAction(
      icon: Icons.settings_outlined,
      title: l10n.settings,
      subtitle: l10n.languageAndAppearance,
      background: Colors.white,
      iconBackground: ProfileScreen.softGold,
      iconColor: ProfileScreen.primary,
      textColor: ProfileScreen.darkText,
      subtitleColor: ProfileScreen.grayText,
      arrowColor: ProfileScreen.primary,
      border: true,
      onTap: () {
        _showSettingsBottomSheet(
          context,
          l10n,
        );
      },
    );
  }

  Widget _buildMainAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color background,
    required Color iconBackground,
    required Color iconColor,
    required Color textColor,
    required Color subtitleColor,
    required Color arrowColor,
    required VoidCallback onTap,
    bool border = false,
  }) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: border
                ? Border.all(
                    color: Colors.black.withOpacity(0.06),
                  )
                : null,
            boxShadow: border
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.025),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 11,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: arrowColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          _showLogoutDialog(
            context,
            l10n,
          );
        },
        icon: Icon(
          Icons.logout_rounded,
          size: 20,
          color: Colors.red.shade700,
        ),
        label: Text(
          l10n.logout,
          style: TextStyle(
            color: Colors.red.shade700,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          side: BorderSide(
            color: Colors.red.shade100,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: Directionality.of(context),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              28,
            ),
            decoration: const BoxDecoration(
              color: ProfileScreen.background,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    l10n.settings,
                    style: const TextStyle(
                      color: ProfileScreen.darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                BlocBuilder<LanguageCubit, LanguageState>(
                  builder: (context, state) {
                    final isArabic =
                        state.locale.languageCode == 'ar';

                    return _buildSettingsItem(
                      icon: Icons.language_rounded,
                      title: l10n.language,
                      subtitle: isArabic
                          ? l10n.arabic
                          : l10n.english,
                      onTap: () {
                        context
                            .read<LanguageCubit>()
                            .toggleLanguage();
                      },
                    );
                  },
                ),

                _buildSettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: l10n.darkMode,
                  subtitle: l10n.changeAppAppearance,
                  trailing: Switch(
                    value:
                        Theme.of(context).brightness ==
                            Brightness.dark,
                    activeColor: ProfileScreen.primary,
                    onChanged: (value) {},
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: ProfileScreen.softGold,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: ProfileScreen.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: ProfileScreen.darkText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: ProfileScreen.grayText,
            fontSize: 11,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: Directionality.of(context),
              child: AlertDialog(
                backgroundColor: ProfileScreen.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                title: Text(
                  l10n.logout,
                  style: const TextStyle(
                    color: ProfileScreen.darkText,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                content: Text(
                  isLoading
                      ? l10n.loggingOut
                      : l10n.logoutConfirmation,
                  style: const TextStyle(
                    color: ProfileScreen.grayText,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                actions: [
                  if (!isLoading)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
                          color: ProfileScreen.grayText,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                    ),

                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await AuthService().logout();

                              if (!context.mounted) {
                                return;
                              }

                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                AppRoutes.authGate,
                                (route) => false,
                              );
                            } catch (_) {
                              if (!context.mounted) {
                                return;
                              }

                              setState(() {
                                isLoading = false;
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.logoutError,
                                    style: const TextStyle(
                                      fontFamily:
                                          'IBM Plex Sans Arabic',
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                    child: Text(
                      l10n.logout,
                      style: TextStyle(
                        color: isLoading
                            ? Colors.grey
                            : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: ProfileScreen.softGold,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person_off_outlined,
                color: ProfileScreen.primary,
                size: 30,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'حدث خطأ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ProfileScreen.darkText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton(
              onPressed: () {
                context
                    .read<ProfileCubit>()
                    .fetchProfile();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    ProfileScreen.primary,
                side: const BorderSide(
                  color: ProfileScreen.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              child: Text(
                l10n.retry,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}