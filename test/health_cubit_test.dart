import 'dart:async';

import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/health_aid_type.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/health_request_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/service/health_request_service.dart';
import 'package:charity_management/l10n/generated/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final localizations = AppLocalizationsEn();

  group('HealthAidType', () {
    test(
      'provides the backend values for all supported types',
      () {
        expect(
          HealthAidType.values.map(
            (type) => type.apiValue,
          ),
          [
            'MEDICINE_INSURANCE',
            'SURGERY',
            'MEDICAL_DEVICES',
          ],
        );
      },
    );
  });

  group('HealthCubit', () {
    test(
      'emits loading and success',
      () async {
        final service =
            _FakeHealthRequestService();

        final cubit =
            HealthCubit(service);

        final states = <HealthState>[];

        final subscription =
            cubit.stream.listen(
          states.add,
        );

        final submission =
            cubit.submitHealthRequest(
          _request,
          localizations,
        );

        service.complete(
          'تم إرسال الطلب',
        );

        await submission;

        await Future<void>.delayed(
          Duration.zero,
        );

        expect(
          states,
          [
            isA<HealthLoading>(),
            isA<HealthSuccess>().having(
              (state) => state.message,
              'message',
              'تم إرسال الطلب',
            ),
          ],
        );

        await subscription.cancel();

        await cubit.close();
      },
    );

    test(
      'ignores a duplicate submission while loading',
      () async {
        final service =
            _FakeHealthRequestService();

        final cubit =
            HealthCubit(service);

        final firstSubmission =
            cubit.submitHealthRequest(
          _request,
          localizations,
        );

        await cubit.submitHealthRequest(
          _request,
          localizations,
        );

        expect(
          service.callCount,
          1,
        );

        service.complete(
          'تم إرسال الطلب',
        );

        await firstSubmission;

        await cubit.close();
      },
    );

    test(
      'converts a format exception to failure state',
      () async {
        final service =
            _FakeHealthRequestService();

        final cubit =
            HealthCubit(service);

        final submission =
            cubit.submitHealthRequest(
          _request,
          localizations,
        );

        service.completeError(
          const FormatException(
            'استجابة غير صالحة',
          ),
        );

        await submission;

        expect(
          cubit.state,
          isA<HealthFailure>().having(
            (state) => state.message,
            'message',
            'استجابة غير صالحة',
          ),
        );

        await cubit.close();
      },
    );
  });
}

// ============================================
// TEST REQUEST
// ============================================

final _request = HealthRequestModel(
  applicantInfo:
      const ApplicantInfoModel(
    firstName: 'محمد',
    fatherName: 'أحمد',
    lastName: 'العلي',
    age: 30,
    gender: 'ذكر',
    socialStatus: 'متزوج',
    phoneNumber: '0999999999',

    // العنوان صار عربي + إنكليزي
    addressAr: 'دمشق',
    addressEn: 'Damascus',

    isUnemployed: false,
  ),

  typeAid: HealthAidType.surgery,

  // بدل description القديم
  detailsAr: 'وصف الحالة',
  detailsEn: 'Case description',

  cost: 100,

  media: const [],
);

// ============================================
// FAKE SERVICE
// ============================================

class _FakeHealthRequestService
    extends HealthRequestService {
  final Completer<String> _completer =
      Completer<String>();

  int callCount = 0;

  @override
  Future<String> submitHealthRequest(
    HealthRequestModel request,
  ) {
    callCount++;

    return _completer.future;
  }

  void complete(
    String message,
  ) {
    _completer.complete(
      message,
    );
  }

  void completeError(
    Object error,
  ) {
    _completer.completeError(
      error,
    );
  }
}