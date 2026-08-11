import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/profile_model.dart';
import '../service/profile_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._profileService,
  ) : super(
          const ProfileInitial(),
        );

  final ProfileService _profileService;

  Future<void> loadProfile() async {
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
        'ProfileCubit FormatException: ${error.message}',
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
        'ProfileCubit DioException: ${error.message}',
      );

      debugPrint(
        'Response: ${error.response?.data}',
      );

      debugPrint(
        'Status code: ${error.response?.statusCode}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ProfileFailure(
          _extractDioMessage(
            error,
          ),
        ),
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ProfileCubit unexpected error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        const ProfileFailure(
          'حدث خطأ غير متوقع أثناء تحميل الملف الشخصي',
        ),
      );
    }
  }

  String _extractDioMessage(
    DioException error,
  ) {
    final dynamic data =
        error.response?.data;

    if (data is Map) {
      final dynamic message =
          data['message'];

      if (message is String &&
          message.trim().isNotEmpty) {
        return message;
      }

      if (message is List &&
          message.isNotEmpty) {
        return message.join('\n');
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم، تأكد من تشغيل الباك إند';

      default:
        break;
    }

    switch (error.response?.statusCode) {
      case 400:
        return 'تعذر تحميل بيانات الملف الشخصي';

      case 401:
        return 'يرجى تسجيل الدخول لعرض الملف الشخصي';

      case 403:
        return 'ليس لديك صلاحية لعرض الملف الشخصي';

      case 404:
        return 'لم يتم العثور على بيانات الملف الشخصي';

      case 500:
        return 'حدث خطأ في الخادم أثناء تحميل الملف الشخصي';

      default:
        return 'تعذر تحميل الملف الشخصي';
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  void reset() {
    emit(
      const ProfileInitial(),
    );
  }
}