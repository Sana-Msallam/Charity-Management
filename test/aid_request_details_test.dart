import 'package:charity_management/Donor/cubit/aid_request_details_cubit.dart';
import 'package:charity_management/Donor/cubit/aid_request_details_state.dart';
import 'package:charity_management/Donor/model/aid_request_details_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AidRequestDetailsModel', () {
    test('parses money fields when backend sends strings', () {
      final model = AidRequestDetailsModel.fromJson(
        _detailsJson(
          totalCost: '100.00',
          paidAmount: '25.00',
          remainingAmount: '75.00',
          completionPercentage: '25.5',
        ),
      );

      expect(model.totalCost, '100.00');
      expect(model.paidAmount, '25.00');
      expect(model.remainingAmount, '75.00');
      expect(model.completionPercentage, 25.5);
    });

    test('parses money fields when backend sends numbers', () {
      final model = AidRequestDetailsModel.fromJson(
        _detailsJson(
          totalCost: 100,
          paidAmount: 25.5,
          remainingAmount: 74.5,
          completionPercentage: 25,
        ),
      );

      expect(model.totalCost, '100');
      expect(model.paidAmount, '25.5');
      expect(model.remainingAmount, '74.5');
      expect(model.completionPercentage, 25);
    });
  });

  group('AidRequestDetailsCubit', () {
    test('refreshes once after payment and emits latest details', () async {
      final responseData = _detailsJson(
        paidAmount: '50.00',
        remainingAmount: '50.00',
        completionPercentage: 50,
      );
      var callCount = 0;
      late RequestOptions capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'http://example.test'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedOptions = options;
              callCount++;
              handler.resolve(
                Response<dynamic>(
                  requestOptions: options,
                  statusCode: 200,
                  data: responseData,
                ),
              );
            },
          ),
        );
      final cubit = AidRequestDetailsCubit(dio: dio);
      final states = <AidRequestDetailsState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.refreshDetailsAfterPayment(42);

      expect(callCount, 1);
      expect(capturedOptions.path, '${ApiConstants.aidRequests}/42');
      expect(states, [
        isA<AidRequestDetailsLoadingState>(),
        isA<AidRequestDetailsSuccessState>(),
      ]);
      expect(
        cubit.state,
        isA<AidRequestDetailsSuccessState>()
            .having((state) => state.request.paidAmount, 'paidAmount', '50.00')
            .having(
              (state) => state.request.remainingAmount,
              'remainingAmount',
              '50.00',
            )
            .having(
              (state) => state.request.completionPercentage,
              'completionPercentage',
              50,
            ),
      );

      await subscription.cancel();
      await cubit.close();
    });
  });
}

Map<String, dynamic> _detailsJson({
  Object? totalCost = '100.00',
  Object? paidAmount = '25.00',
  Object? remainingAmount = '75.00',
  Object? completionPercentage = 25,
}) {
  return {
    'image': 'request.jpg',
    'title': 'Medical aid',
    'description': 'Aid request description',
    'totalCost': totalCost,
    'paidAmount': paidAmount,
    'remainingAmount': remainingAmount,
    'completionPercentage': completionPercentage,
    'isUrgent': true,
  };
}
