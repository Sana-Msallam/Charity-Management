import 'dart:convert';

import 'package:charity_management/Donor/Screen/donor_home_screen.dart';
import 'package:charity_management/features/auth/login/cubit/login_cubit.dart';
import 'package:charity_management/features/auth/login/screen/login.dart';
import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:charity_management/features/auth/storage/auth_local_storage.dart';
import 'package:charity_management/features/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatefulWidget {
  AuthGate({super.key, AuthLocalStorage? localStorage})
    : _localStorage = localStorage ?? AuthLocalStorage();

  final AuthLocalStorage _localStorage;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<_AuthDestination> _destination = _resolveDestination();

  Future<_AuthDestination> _resolveDestination() async {
    final token = await widget._localStorage.getToken();
    final userType = await widget._localStorage.getUserType();

    if (token == null || userType == null || _isExpiredJwtWhenReadable(token)) {
      await widget._localStorage.deleteSession();
      return _AuthDestination.login;
    }

    if (userType == 'DONOR') {
      return _AuthDestination.donor;
    }

    if (userType == 'BENEFICIARY') {
      return _AuthDestination.beneficiary;
    }

    await widget._localStorage.deleteSession();
    return _AuthDestination.login;
  }

  bool _isExpiredJwtWhenReadable(String token) {
    final parts = token.split('.');

    if (parts.length < 2) {
      return false;
    }

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final decodedPayload = jsonDecode(payload);

      if (decodedPayload is! Map<String, dynamic>) {
        return false;
      }

      final exp = decodedPayload['exp'];
      final expSeconds = exp is num ? exp.toInt() : int.tryParse('$exp');

      if (expSeconds == null) {
        return false;
      }

      final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return expSeconds <= nowSeconds;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AuthDestination>(
      future: _destination,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return switch (snapshot.data!) {
          _AuthDestination.donor => DonorHomeScreen(),
          _AuthDestination.beneficiary => const HomePage(),
          _AuthDestination.login => BlocProvider(
            create: (_) => LoginCubit(authService: AuthService()),
            child: const LoginScreen(),
          ),
        };
      },
    );
  }
}

enum _AuthDestination { login, donor, beneficiary }
