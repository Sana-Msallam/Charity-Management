import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations_en.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final localizations = AppLocalizationsEn();

  test('formats validation constraint objects as user-facing messages', () {
    final requestOptions = RequestOptions(path: '/wallet');
    final error = DioException(
      requestOptions: requestOptions,
      response: Response<dynamic>(
        requestOptions: requestOptions,
        statusCode: 400,
        data: const {
          'message': [
            {
              'property': 'amount',
              'value': 25,
              'target': {'amount': 25},
              'children': [],
              'constraints': {
                'matches':
                    'The payment amount must have exactly two decimal places.',
                'isString': 'The payment amount must be a decimal string.',
              },
            },
          ],
        },
      ),
    );

    final message = ApiException.getMessage(error, localizations);

    expect(
      message,
      'The payment amount must have exactly two decimal places.\n'
      'The payment amount must be a decimal string.',
    );
    expect(message, isNot(contains('property')));
    expect(message, isNot(contains('target')));
  });
}
