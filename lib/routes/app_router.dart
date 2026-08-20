import 'package:charity_management/features/Beneficiary/Help_request/education_request/screen/education_request_page.dart';
import 'package:charity_management/features/Donor/Screen/donor_home_screen.dart';
import 'package:charity_management/features/auth/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:charity_management/features/auth/forgot_password/screen/forgot_password_screen.dart';
import 'package:charity_management/features/auth/forgot_password/screen/new_password.dart';
import 'package:charity_management/features/auth/login/cubit/login_cubit.dart';
import 'package:charity_management/features/auth/login/screen/login.dart';
import 'package:charity_management/features/auth/otp/cubit/otp_cubit.dart';
import 'package:charity_management/features/auth/otp/screen/otp_screen.dart';
import 'package:charity_management/features/auth/register_beneficiary/cubit/register_beneficiary_cubit.dart';
import 'package:charity_management/features/auth/register_beneficiary/screen/signup_beneficiary.dart';
import 'package:charity_management/features/auth/register_donor/cubit/register_donor_cubit.dart';
import 'package:charity_management/features/auth/register_donor/screen/signup_donor.dart';
import 'package:charity_management/features/auth/screens/auth_gate.dart';
import 'package:charity_management/features/auth/screens/pending_approval_screen.dart';
import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:charity_management/features/screen/applicant_info_page.dart';
import 'package:charity_management/features/screen/home_screen.dart';
import 'package:charity_management/features/screen/housing_request_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (context) => _buildRoute(settings),
    );
  }

  static Widget _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.authGate:
        return AuthGate();
      case AppRoutes.login:
        return _buildLogin();
      case AppRoutes.registerDonor:
        return BlocProvider(
          create: (_) => RegisterDonorCubit(authService: AuthService()),
          child: const SignUpDonorScreen(),
        );
      case AppRoutes.registerBeneficiary:
        return BlocProvider(
          create: (_) => RegisterBeneficiaryCubit(authService: AuthService()),
          child: const SignUpBeneficiaryScreen(),
        );
      case AppRoutes.otp:
        final arguments = settings.arguments;

        if (arguments is OtpRouteArguments) {
          return BlocProvider(
            create: (_) => OtpCubit(),
            child: OtpScreen(
              countryCode: arguments.countryCode,
              phoneNumber: arguments.phoneNumber,
              userType: arguments.userType,
            ),
          );
        }

        return _buildLogin();
      case AppRoutes.pendingApproval:
        return const PendingApprovalScreen();
      case AppRoutes.donorHome:
        return DonorHomeScreen();
      case AppRoutes.beneficiaryHome:
        return const HomePage();
      case AppRoutes.applicantInfo:
        final arguments = settings.arguments;

        if (arguments is ApplicantInfoRouteArguments) {
          return ApplicantInfoPage(requestType: arguments.requestType);
        }

        return const HomePage();
      case AppRoutes.educationRequest:
        return const EducationRequestPage();
      case AppRoutes.housingRequest:
        return const HousingRequestPage();
      case AppRoutes.forgotPassword:
        return BlocProvider(
          create: (_) => ForgotPasswordCubit(authService: AuthService()),
          child: const ForgotPasswordScreen(),
        );
      case AppRoutes.newPassword:
        final arguments = settings.arguments;

        if (arguments is ForgotPasswordCubit) {
          return BlocProvider.value(
            value: arguments,
            child: const NewPasswordScreen(),
          );
        }

        return BlocProvider(
          create: (_) => ForgotPasswordCubit(authService: AuthService()),
          child: const NewPasswordScreen(),
        );
      default:
        return _buildLogin();
    }
  }

  static Widget _buildLogin() {
    return BlocProvider(
      create: (_) => LoginCubit(authService: AuthService()),
      child: const LoginScreen(),
    );
  }
}
