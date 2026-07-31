import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';

import '../../../../constants/api_exception.dart';
import '../../services/auth_service.dart';
import '../models/register_beneficiary_request_model.dart';
import 'register_beneficiary_state.dart';

class RegisterBeneficiaryCubit extends Cubit<RegisterBeneficiaryState> {
  final AuthService authService;

  RegisterBeneficiaryCubit({required this.authService})
    : super(const RegisterBeneficiaryInitial());

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String number,
    required String countryName,
    required String countryCode,
    required String gender,
    required File personalPhoto,
    required File familyStatement,
    required String address,
    required String socialStatus,
    required bool isUnemployed,
    required String monthlyIncome,
    required String numberOfChildren,
    required AppLocalizations localizations,
  }) async {
    if (state is RegisterBeneficiaryLoading) return;

    emit(const RegisterBeneficiaryLoading());

    try {
      final request = RegisterBeneficiaryRequestModel(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        password: password,
        number: _cleanPhoneNumber(number),
        countryName: countryName.trim(),
        countryCode: countryCode.trim(),

        gender: gender,

        personalPhoto: personalPhoto,
        familyStatement: familyStatement,

        address: address.trim(),

        socialStatus: socialStatus,

        isUnemployed: isUnemployed,

        monthlyIncome: isUnemployed
            ? 0
            : double.tryParse(monthlyIncome.trim()) ?? 0,

        numberOfChildren: socialStatus == 'SINGLE'
            ? 0
            : int.tryParse(numberOfChildren.trim()) ?? 0,
      );

      final response = await authService.registerBeneficiary(
        request: request,
        fallbackMessage: localizations.otpSent,
      );

      emit(RegisterBeneficiarySuccess(response));
    } on DioException catch (error) {
      emit(
        RegisterBeneficiaryFailure(
          ApiException.getMessage(error, localizations),
        ),
      );
    } on FormatException {
      emit(RegisterBeneficiaryFailure(localizations.unexpectedError));
    } catch (error) {
      emit(RegisterBeneficiaryFailure(localizations.unexpectedError));
    }
  }

  String _cleanPhoneNumber(String value) {
    String number = value.trim().replaceAll(' ', '').replaceAll('-', '');

    if (number.startsWith('0')) {
      number = number.substring(1);
    }

    return number;
  }
}
