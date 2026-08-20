import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../model/profile_model.dart';
import '../service/profile_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileService)
      : super(const ProfileInitial());

  final ProfileService _profileService;

  // ==================================================
  // GET PROFILE FOR SPECIFIC LANGUAGE
  // ==================================================

  Future<ProfileModel> getProfileForLanguage(
    String languageCode,
  ) {
    return _profileService.getProfile(
      languageCode: languageCode,
    );
  }

  // ==================================================
  // UPDATE PROFILE
  // ==================================================

  Future<void> updateProfile({
    required ProfileModel currentProfile,
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String dateOfBirth,
    required String addressAr,
    required String addressEn,
    required String socialStatus,
    required bool isUnemployed,
    required AppLocalizations localizations,
    XFile? personalPhoto,
  }) async {
    if (state is ProfileUpdating) {
      return;
    }

    emit(
      ProfileUpdating(
        currentProfile,
      ),
    );

    try {
      await _profileService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        dateOfBirth: dateOfBirth,
        addressAr: addressAr,
        addressEn: addressEn,
        socialStatus: socialStatus,
        isUnemployed: isUnemployed,
        personalPhoto: personalPhoto,
      );

      final ProfileModel refreshedProfile =
          await _profileService.getProfile();

      emit(
        ProfileSuccess(
          refreshedProfile,
        ),
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ProfileCubit update DioException: '
        '${error.message}',
      );

      debugPrint(
        'Response: '
        '${error.response?.data}',
      );

      debugPrint(
        'Status code: '
        '${error.response?.statusCode}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ProfileUpdateFailure(
          currentProfile,
          _extractDioMessage(
            error,
            localizations: localizations,
            fallback:
                localizations.unexpectedError,
          ),
        ),
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ProfileCubit update unexpected error: '
        '$error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ProfileUpdateFailure(
          currentProfile,
          localizations.unexpectedError,
        ),
      );
    }
  }

  // ==================================================
  // LOAD PROFILE
  // ==================================================

  Future<void> loadProfile({
    required AppLocalizations localizations,
  }) async {
    if (state is ProfileLoading) {
      return;
    }

    emit(
      const ProfileLoading(),
    );

    try {
      final ProfileModel profile =
          await _profileService.getProfile();

      emit(
        ProfileSuccess(
          profile,
        ),
      );
    } on FormatException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ProfileCubit FormatException: '
        '${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ProfileFailure(
          error.message,
        ),
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ProfileCubit DioException: '
        '${error.message}',
      );

      debugPrint(
        'Response: '
        '${error.response?.data}',
      );

      debugPrint(
        'Status code: '
        '${error.response?.statusCode}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ProfileFailure(
          _extractDioMessage(
            error,
            localizations: localizations,
            fallback:
                localizations.profileLoadError,
          ),
        ),
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ProfileCubit unexpected error: '
        '$error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ProfileFailure(
          localizations.unexpectedError,
        ),
      );
    }
  }

  // ==================================================
  // EXTRACT DIO MESSAGE
  // ==================================================

  String _extractDioMessage(
    DioException error, {
    required AppLocalizations localizations,
    required String fallback,
  }) {
    final dynamic data =
        error.response?.data;

    // إذا الباك رجع message
    // منستخدمها مباشرة.
    // DioClient أصلاً يرسل لغة التطبيق للباك.
    if (data is Map) {
      final dynamic message =
          data['message'];

      if (message is String &&
          message.trim().isNotEmpty) {
        return message;
      }

      if (message is List &&
          message.isNotEmpty) {
        return message.join(
          '\n',
        );
      }
    }

    // ==========================================
    // CONNECTION ERRORS
    // ==========================================

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return localizations
            .connectionTimeout;

      case DioExceptionType.connectionError:
        return localizations
            .connectionError;

      default:
        break;
    }

    // ==========================================
    // HTTP STATUS CODES
    // ==========================================

    switch (
        error.response?.statusCode) {
      case 400:
        return localizations
            .badRequest;

      case 401:
        return localizations
            .unauthorized;

      case 403:
        return localizations
            .forbidden;

      case 404:
        return localizations
            .notFound;

      case 500:
        return localizations
            .serverError;

      default:
        return fallback;
    }
  }

  // ==================================================
  // REFRESH PROFILE
  // ==================================================

  Future<void> refreshProfile({
    required AppLocalizations localizations,
  }) async {
    await loadProfile(
      localizations: localizations,
    );
  }

  // ==================================================
  // RESET
  // ==================================================

  void reset() {
    emit(
      const ProfileInitial(),
    );
  }
}