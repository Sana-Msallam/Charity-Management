import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/features/Beneficiary/profile/cubit/profile_cubit.dart';
import 'package:charity_management/features/Beneficiary/profile/cubit/profile_state.dart';
import 'package:charity_management/features/Beneficiary/profile/model/profile_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  final ProfileModel profile;

  @override
  State<EditProfileScreen> createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  static const Set<String> _allowedGenders =
      <String>{
    'MALE',
    'FEMALE',
  };

  static const Set<String>
      _allowedSocialStatuses = <String>{
    'SINGLE',
    'MARRIED',
    'WIDOWED',
    'DIVORCED',
  };

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final ImagePicker _imagePicker =
      ImagePicker();

  late final TextEditingController
      _firstNameController;

  late final TextEditingController
      _lastNameController;

  late final TextEditingController
      _emailController;

  late final TextEditingController
      _dateOfBirthController;

  late final TextEditingController
      _addressArController;

  late final TextEditingController
      _addressEnController;

  late String _selectedGender;

  late String _selectedSocialStatus;

  late bool _isUnemployed;

  XFile? _newPersonalPhoto;

  Uint8List? _newPersonalPhotoBytes;

  bool _isLoadingAlternateAddress = true;

  String? _alternateAddressError;

  bool _submitted = false;

  // ==================================================
  // INIT
  // ==================================================

  @override
  void initState() {
    super.initState();

    _firstNameController =
        TextEditingController(
      text: widget.profile.firstName,
    );

    _lastNameController =
        TextEditingController(
      text: widget.profile.lastName,
    );

    _emailController =
        TextEditingController(
      text: widget.profile.email,
    );

    _dateOfBirthController =
        TextEditingController(
      text: _formatStoredDate(
        widget.profile.dateOfBirth,
      ),
    );

    _addressArController =
        TextEditingController();

    _addressEnController =
        TextEditingController();

    _selectedGender =
        widget.profile.gender;

    _selectedSocialStatus =
        widget.profile.socialStatus;

    _isUnemployed =
        widget.profile.isUnemployed;

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        _loadAddresses();
      },
    );
  }

  // ==================================================
  // DISPOSE
  // ==================================================

  @override
  void dispose() {
    _firstNameController.dispose();

    _lastNameController.dispose();

    _emailController.dispose();

    _dateOfBirthController.dispose();

    _addressArController.dispose();

    _addressEnController.dispose();

    super.dispose();
  }

  // ==================================================
  // LOAD BOTH ADDRESSES
  // ==================================================

  Future<void> _loadAddresses() async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String currentLanguage =
        Localizations.localeOf(context)
                    .languageCode ==
                'ar'
            ? 'ar'
            : 'en';

    final String alternateLanguage =
        currentLanguage == 'ar'
            ? 'en'
            : 'ar';

    // ================================================
    // العنوان الموجود في Profile الحالي
    // هو حسب لغة التطبيق الحالية
    // ================================================

    if (currentLanguage == 'ar') {
      _addressArController.text =
          widget.profile.address;
    } else {
      _addressEnController.text =
          widget.profile.address;
    }

    setState(() {
      _isLoadingAlternateAddress = true;

      _alternateAddressError = null;
    });

    try {
      final ProfileModel alternateProfile =
          await context
              .read<ProfileCubit>()
              .getProfileForLanguage(
                alternateLanguage,
              );

      if (!mounted) {
        return;
      }

      if (alternateLanguage == 'ar') {
        _addressArController.text =
            alternateProfile.address;
      } else {
        _addressEnController.text =
            alternateProfile.address;
      }

      setState(() {
        _isLoadingAlternateAddress =
            false;
      });
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'Failed to load alternate profile address: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingAlternateAddress =
            false;

        _alternateAddressError =
            l10n.alternateAddressLoadError;
      });
    }
  }

  // ==================================================
  // PICK DATE OF BIRTH
  // ==================================================

  Future<void> _pickDateOfBirth() async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final DateTime today =
        _dateOnly(
      DateTime.now(),
    );

    final DateTime? parsed =
        DateTime.tryParse(
      _dateOfBirthController.text,
    );

    final DateTime initialDate =
        parsed == null ||
                parsed.isAfter(today)
            ? DateTime(
                today.year - 18,
                today.month,
                today.day,
              )
            : parsed;

    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: today,
      helpText:
          l10n.selectDateOfBirth,
    );

    if (pickedDate == null ||
        !mounted) {
      return;
    }

    setState(() {
      _dateOfBirthController.text =
          _formatDate(
        pickedDate,
      );
    });
  }

  // ==================================================
  // PICK IMAGE
  // ==================================================

  Future<void> _pickImage(
    ImageSource source,
  ) async {
    try {
      final XFile? selectedImage =
          await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (selectedImage == null) {
        return;
      }

      final Uint8List bytes =
          await selectedImage
              .readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        _newPersonalPhoto =
            selectedImage;

        _newPersonalPhotoBytes =
            bytes;
      });
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'Profile image selection failed: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      if (!mounted) {
        return;
      }

      _showError(
        AppLocalizations.of(context)
            .imageSelectionFailed,
      );
    }
  }

  // ==================================================
  // IMAGE SOURCE SHEET
  // ==================================================

  void _showImageSourceSheet() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      builder: (
        BuildContext bottomSheetContext,
      ) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons
                      .photo_library_outlined,
                ),
                title: Text(
                  l10n.chooseFromGallery,
                ),
                onTap: () {
                  Navigator.pop(
                    bottomSheetContext,
                  );

                  _pickImage(
                    ImageSource.gallery,
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons
                      .camera_alt_outlined,
                ),
                title: Text(
                  l10n.takePhoto,
                ),
                onTap: () {
                  Navigator.pop(
                    bottomSheetContext,
                  );

                  _pickImage(
                    ImageSource.camera,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================================================
  // SUBMIT
  // ==================================================

  void _submit() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    FocusScope.of(context).unfocus();

    if (_isLoadingAlternateAddress ||
        _alternateAddressError != null) {
      _showError(
        l10n
            .loadBothAddressesBeforeSave,
      );

      return;
    }

    if (!_allowedGenders.contains(
      _selectedGender,
    )) {
      _showError(
        l10n.unsupportedGenderValue,
      );

      return;
    }

    if (!_allowedSocialStatuses
        .contains(
      _selectedSocialStatus,
    )) {
      _showError(
        l10n
            .unsupportedSocialStatusValue,
      );

      return;
    }

    final bool isValid =
        _formKey.currentState
                ?.validate() ??
            false;

    if (!isValid) {
      return;
    }

    _submitted = true;

    context
        .read<ProfileCubit>()
        .updateProfile(
          currentProfile:
              widget.profile,
          firstName:
              _firstNameController.text,
          lastName:
              _lastNameController.text,
          email:
              _emailController.text,
          gender:
              _selectedGender,
          dateOfBirth:
              _dateOfBirthController
                  .text
                  .trim(),
          addressAr:
              _addressArController.text,
          addressEn:
              _addressEnController.text,
          socialStatus:
              _selectedSocialStatus,
          isUnemployed:
              _isUnemployed,
          personalPhoto:
              _newPersonalPhoto,
          localizations:
              l10n,
        );
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return BlocConsumer<
        ProfileCubit,
        ProfileState>(
      listener: (
        BuildContext context,
        ProfileState state,
      ) {
        if (_submitted &&
            state is ProfileSuccess) {
          Navigator.of(context)
              .pop(true);
        } else if (state
            is ProfileUpdateFailure) {
          _submitted = false;

          _showError(
            state.message,
          );
        }
      },
      builder: (
        BuildContext context,
        ProfileState state,
      ) {
        final bool isUpdating =
            state is ProfileUpdating;

        return Scaffold(
          backgroundColor:
              AppColors.background,

          // ==========================================
          // APP BAR
          // ==========================================

          appBar: AppBar(
            backgroundColor:
                AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              l10n.editProfile,
              style:
                  const TextStyle(
                color:
                    AppColors.primary,
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),
          ),

          // ==========================================
          // BODY
          // ==========================================

          body: Form(
            key: _formKey,
            child:
                SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,
              padding:
                  const EdgeInsets
                      .fromLTRB(
                20,
                8,
                20,
                32,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: <Widget>[
                  // ==================================
                  // PHOTO
                  // ==================================

                  _buildPhotoPicker(
                    isUpdating,
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  // ==================================
                  // PERSONAL INFO
                  // ==================================

                  _buildSection(
                    title: l10n
                        .personalInformation,
                    icon: Icons
                        .person_outline_rounded,
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: <Widget>[
                            Expanded(
                              child:
                                  CustomTextField(
                                label: l10n
                                    .firstName,
                                hint: l10n
                                    .firstNameHint,
                                controller:
                                    _firstNameController,
                                enabled:
                                    !isUpdating,
                                validator:
                                    _requiredValidator,
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child:
                                  CustomTextField(
                                label: l10n
                                    .lastName,
                                hint: l10n
                                    .lastNameHint,
                                controller:
                                    _lastNameController,
                                enabled:
                                    !isUpdating,
                                validator:
                                    _requiredValidator,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        CustomTextField(
                          label:
                              l10n.email,
                          hint:
                              'example@email.com',
                          controller:
                              _emailController,
                          keyboardType:
                              TextInputType
                                  .emailAddress,
                          isLtr: true,
                          enabled:
                              !isUpdating,
                          validator:
                              _emailValidator,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        _buildDateField(
                          isUpdating,
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // ============================
                        // GENDER
                        // ============================

                        _buildChoiceTitle(
                          l10n.gender,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Row(
                          children: <Widget>[
                            Expanded(
                              child:
                                  _buildChoice(
                                label:
                                    l10n.male,
                                selected:
                                    _selectedGender ==
                                        'MALE',
                                onTap: isUpdating
                                    ? null
                                    : () {
                                        setState(
                                          () {
                                            _selectedGender =
                                                'MALE';
                                          },
                                        );
                                      },
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child:
                                  _buildChoice(
                                label:
                                    l10n.female,
                                selected:
                                    _selectedGender ==
                                        'FEMALE',
                                onTap: isUpdating
                                    ? null
                                    : () {
                                        setState(
                                          () {
                                            _selectedGender =
                                                'FEMALE';
                                          },
                                        );
                                      },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // ============================
                        // SOCIAL STATUS
                        // ============================

                        _buildChoiceTitle(
                          l10n.socialStatus,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        _buildSocialStatusChoices(
                          isUpdating,
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // ============================
                        // EMPLOYMENT
                        // ============================

                        _buildChoiceTitle(
                          l10n
                              .employmentStatus,
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Row(
                          children: <Widget>[
                            Expanded(
                              child:
                                  _buildChoice(
                                label: l10n
                                    .unemployed,
                                selected:
                                    _isUnemployed,
                                onTap: isUpdating
                                    ? null
                                    : () {
                                        setState(
                                          () {
                                            _isUnemployed =
                                                true;
                                          },
                                        );
                                      },
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child:
                                  _buildChoice(
                                label: l10n
                                    .employed,
                                selected:
                                    !_isUnemployed,
                                onTap: isUpdating
                                    ? null
                                    : () {
                                        setState(
                                          () {
                                            _isUnemployed =
                                                false;
                                          },
                                        );
                                      },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================================
                  // ADDRESSES
                  // ==================================

                  _buildSection(
                    title:
                        l10n.bilingualAddress,
                    icon: Icons
                        .location_on_outlined,
                    child:
                        _buildAddressFields(
                      isUpdating,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================================
                  // READ ONLY INFO
                  // ==================================

                  _buildReadOnlyInfo(),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================
                  // SAVE BUTTON
                  // ==================================

                  SizedBox(
                    height: 54,
                    child:
                        ElevatedButton.icon(
                      onPressed: isUpdating ||
                              _isLoadingAlternateAddress ||
                              _alternateAddressError !=
                                  null
                          ? null
                          : _submit,
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            AppColors.primary,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),
                      ),
                      icon: isUpdating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                                color: Colors
                                    .white,
                              ),
                            )
                          : const Icon(
                              Icons
                                  .save_outlined,
                            ),
                      label: Text(
                        isUpdating
                            ? l10n
                                .savingChanges
                            : l10n
                                .saveChanges,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                          fontFamily:
                              AppTextStyles
                                  .fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==================================================
  // PHOTO PICKER
  // ==================================================

  Widget _buildPhotoPicker(
    bool isUpdating,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String? existingImageUrl =
        _getProfileImageUrl(
      widget.profile.personalPhoto,
    );

    return Center(
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 116,
                height: 116,
                padding:
                    const EdgeInsets.all(
                  4,
                ),
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,
                  border:
                      Border.all(
                    color:
                        AppColors.primary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child:
                      _newPersonalPhotoBytes !=
                              null
                          ? Image.memory(
                              _newPersonalPhotoBytes!,
                              fit:
                                  BoxFit.cover,
                            )
                          : _buildExistingProfileImage(
                              existingImageUrl,
                            ),
                ),
              ),

              PositionedDirectional(
                end: -4,
                bottom: 2,
                child: Material(
                  color:
                      AppColors.primary,
                  shape:
                      const CircleBorder(),
                  child: IconButton(
                    onPressed: isUpdating
                        ? null
                        : _showImageSourceSheet,
                    icon: const Icon(
                      Icons
                          .camera_alt_outlined,
                    ),
                    color: Colors.white,
                    iconSize: 20,
                    tooltip:
                        l10n.changePhoto,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            l10n.profilePhotoOptionalHint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color:
                  AppColors.brandGray,
              fontSize: 12,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // EXISTING PROFILE IMAGE
  // ==================================================

  Widget _buildExistingProfileImage(
    String? imageUrl,
  ) {
    if (imageUrl == null ||
        imageUrl.trim().isEmpty) {
      return _buildProfileImagePlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      fadeInDuration:
          const Duration(
        milliseconds: 120,
      ),
      fadeOutDuration:
          const Duration(
        milliseconds: 80,
      ),
      placeholder: (
        context,
        url,
      ) {
        return _buildProfileImagePlaceholder();
      },
      errorWidget: (
        context,
        url,
        error,
      ) {
        debugPrint(
          'Edit profile image error: $error',
        );

        return _buildProfileImagePlaceholder();
      },
    );
  }

  Widget _buildProfileImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors
          .primaryContainer
          .withValues(
        alpha: 0.35,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_rounded,
        size: 62,
        color: AppColors.primary,
      ),
    );
  }

  // ==================================================
  // DATE FIELD
  // ==================================================

  Widget _buildDateField(
    bool isUpdating,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsetsDirectional
                  .only(
            start: 4,
            bottom: 8,
          ),
          child: Text(
            l10n.dateOfBirth,
            style: const TextStyle(
              color:
                  AppColors.brandGray,
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),
        ),

        TextFormField(
          controller:
              _dateOfBirthController,
          readOnly: true,
          enabled: !isUpdating,
          onTap: _pickDateOfBirth,
          validator: _dateValidator,
          textDirection:
              TextDirection.ltr,
          decoration: InputDecoration(
            hintText:
                l10n.dateOfBirthHint,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(
              Icons
                  .calendar_month_outlined,
            ),
            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
              borderSide:
                  BorderSide(
                color: AppColors
                    .brandGray
                    .withOpacity(
                  0.32,
                ),
                width: 1.25,
              ),
            ),
            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
              borderSide:
                  const BorderSide(
                color:
                    AppColors.primary,
                width: 1.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================================================
  // ADDRESS FIELDS
  // ==================================================

  Widget _buildAddressFields(
    bool isUpdating,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    if (_isLoadingAlternateAddress) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 28,
        ),
        child: Column(
          children: <Widget>[
            const CircularProgressIndicator(
              color:
                  AppColors.primary,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              l10n.loadingAlternateAddress,
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_alternateAddressError !=
        null) {
      return Column(
        children: <Widget>[
          Text(
            _alternateAddressError!,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              color:
                  AppColors.error,
            ),
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed:
                _loadAddresses,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: Text(
              l10n.retry,
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        CustomTextField(
          label:
              l10n.arabicAddress,
          hint:
              l10n.arabicAddressHint,
          controller:
              _addressArController,
          maxLines: 2,
          enabled: !isUpdating,
          validator:
              _requiredValidator,
        ),

        const SizedBox(height: 16),

        CustomTextField(
          label:
              l10n.englishAddress,
          hint:
              l10n.englishAddressHint,
          controller:
              _addressEnController,
          maxLines: 2,
          isLtr: true,
          enabled: !isUpdating,
          validator:
              _requiredValidator,
        ),
      ],
    );
  }

  // ==================================================
  // SOCIAL STATUS
  // ==================================================

  Widget _buildSocialStatusChoices(
    bool isUpdating,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final List<
            MapEntry<String, String>>
        statuses =
        <MapEntry<String, String>>[
      MapEntry<String, String>(
        'SINGLE',
        l10n.single,
      ),
      MapEntry<String, String>(
        'MARRIED',
        l10n.married,
      ),
      MapEntry<String, String>(
        'WIDOWED',
        l10n.widowed,
      ),
      MapEntry<String, String>(
        'DIVORCED',
        l10n.divorced,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: statuses.map(
        (
          MapEntry<String, String>
              status,
        ) {
          return SizedBox(
            width:
                (MediaQuery.sizeOf(
                              context,
                            ).width -
                        74) /
                    2,
            child: _buildChoice(
              label:
                  status.value,
              selected:
                  _selectedSocialStatus ==
                      status.key,
              onTap: isUpdating
                  ? null
                  : () {
                      setState(
                        () {
                          _selectedSocialStatus =
                              status.key;
                        },
                      );
                    },
            ),
          );
        },
      ).toList(),
    );
  }

  // ==================================================
  // CHOICE
  // ==================================================

  Widget _buildChoice({
    required String label,
    required bool selected,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(12),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors
                  .primaryContainer
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
            12,
          ),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.brandGray
                    .withOpacity(
                    0.25,
                  ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                AppColors.onSurface,
            fontWeight: selected
                ? FontWeight.bold
                : FontWeight.normal,
            fontFamily:
                AppTextStyles
                    .fontFamily,
          ),
        ),
      ),
    );
  }

  // ==================================================
  // CHOICE TITLE
  // ==================================================

  Widget _buildChoiceTitle(
    String title,
  ) {
    return Align(
      alignment:
          AlignmentDirectional
              .centerStart,
      child: Text(
        title,
        style: const TextStyle(
          color:
              AppColors.brandGray,
          fontSize: 14,
          fontWeight:
              FontWeight.w600,
          fontFamily:
              AppTextStyles
                  .fontFamily,
        ),
      ),
    );
  }

  // ==================================================
  // READ ONLY INFO
  // ==================================================

  Widget _buildReadOnlyInfo() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return _buildSection(
      title: l10n.readOnlyData,
      icon:
          Icons.lock_outline_rounded,
      child: Column(
        children: <Widget>[
          _buildReadOnlyRow(
            l10n.phoneNumber,
            _formatPhone(
              widget.profile.countryCode,
              widget.profile.number,
            ),
            TextDirection.ltr,
          ),

          const Divider(
            height: 24,
          ),

          _buildReadOnlyRow(
            l10n.age,
            widget.profile.age == null
                ? l10n.unspecified
                : l10n.ageWithYears(
                    widget.profile.age!,
                  ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // READ ONLY ROW
  // ==================================================

  Widget _buildReadOnlyRow(
    String label,
    String value, [
    TextDirection? textDirection,
  ]) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style:
                const TextStyle(
              color:
                  AppColors.brandGray,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),
        ),

        Text(
          value,
          textDirection:
              textDirection,
          style: const TextStyle(
            color:
                AppColors.onSurface,
            fontWeight:
                FontWeight.w600,
            fontFamily:
                AppTextStyles
                    .fontFamily,
          ),
        ),
      ],
    );
  }

  // ==================================================
  // SECTION
  // ==================================================

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.brandGray
              .withOpacity(
            0.12,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                color:
                    AppColors.primary,
              ),

              const SizedBox(
                width: 8,
              ),

              Text(
                title,
                style:
                    const TextStyle(
                  color: AppColors
                      .onSurface,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          child,
        ],
      ),
    );
  }

  // ==================================================
  // REQUIRED VALIDATOR
  // ==================================================

  String? _requiredValidator(
    String? value,
  ) {
    if (value == null ||
        value.trim().isEmpty) {
      return AppLocalizations.of(
        context,
      ).fieldRequired;
    }

    return null;
  }

  // ==================================================
  // EMAIL VALIDATOR
  // ==================================================

  String? _emailValidator(
    String? value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String email =
        value?.trim() ?? '';

    if (email.isEmpty) {
      return l10n.emailRequired;
    }

    final RegExp emailPattern =
        RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    );

    if (!emailPattern
        .hasMatch(
      email,
    )) {
      return l10n.invalidEmail;
    }

    return null;
  }

  // ==================================================
  // DATE VALIDATOR
  // ==================================================

  String? _dateValidator(
    String? value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String dateValue =
        value?.trim() ?? '';

    if (dateValue.isEmpty) {
      return l10n
          .dateOfBirthRequired;
    }

    final DateTime? parsedDate =
        DateTime.tryParse(
      dateValue,
    );

    if (parsedDate == null ||
        _formatDate(parsedDate) !=
            dateValue) {
      return l10n
          .invalidDateOfBirth;
    }

    if (_dateOnly(parsedDate)
        .isAfter(
      _dateOnly(
        DateTime.now(),
      ),
    )) {
      return l10n
          .dateOfBirthFutureInvalid;
    }

    return null;
  }

  // ==================================================
  // SHOW ERROR
  // ==================================================

  void _showError(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          backgroundColor:
              AppColors.error,
        ),
      );
  }

  // ==================================================
  // DATE ONLY
  // ==================================================

  DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // ==================================================
  // FORMAT STORED DATE
  // ==================================================

  String _formatStoredDate(
    String? value,
  ) {
    final DateTime? date =
        DateTime.tryParse(
      value?.trim() ?? '',
    );

    return date == null
        ? (value?.trim() ?? '')
        : _formatDate(date);
  }

  // ==================================================
  // FORMAT DATE
  // ==================================================

  String _formatDate(
    DateTime date,
  ) {
    final String year =
        date.year
            .toString()
            .padLeft(
              4,
              '0',
            );

    final String month =
        date.month
            .toString()
            .padLeft(
              2,
              '0',
            );

    final String day =
        date.day
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$year-$month-$day';
  }

  // ==================================================
  // FORMAT PHONE
  // ==================================================

  String _formatPhone(
    String countryCode,
    String number,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String code =
        countryCode.trim();

    final String value =
        number.trim();

    if (value.isEmpty) {
      return l10n.unspecified;
    }

    if (value.startsWith('+')) {
      return value;
    }

    if (code.isEmpty) {
      return value;
    }

    final String normalizedNumber =
        value.startsWith('0')
            ? value.substring(1)
            : value;

    return '$code $normalizedNumber';
  }

  // ==================================================
  // PROFILE IMAGE URL
  // ==================================================

  String? _getProfileImageUrl(
    String? url,
  ) {
    if (url == null ||
        url.trim().isEmpty) {
      return null;
    }

    String fixedUrl =
        url.trim();

    fixedUrl =
        fixedUrl.replaceFirst(
      'http://localhost:3000',
      ApiConstants.baseUrl,
    );

    fixedUrl =
        fixedUrl.replaceFirst(
      'http://127.0.0.1:3000',
      ApiConstants.baseUrl,
    );

    if (fixedUrl.startsWith('/')) {
      fixedUrl =
          '${ApiConstants.baseUrl}$fixedUrl';
    }

    return fixedUrl;
  }
}