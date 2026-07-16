import 'dart:async';

import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/cubit/login_cubit.dart';
import '../../login/screen/login.dart';
import '../../services/auth_service.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/otp_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.countryCode,
    required this.phoneNumber,
    required this.userType,
  });

  final String countryCode;
  final String phoneNumber;

  /// القيم المتوقعة:
  /// donor
  /// beneficiary
  final String userType;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(
    4,
    (_) => FocusNode(),
  );

  Timer? timer;
  int remainingSeconds = 57;

  String get otpCode {
    return otpControllers
        .map((controller) => controller.text.trim())
        .join();
  }

  @override
  void initState() {
    super.initState();

    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        focusNodes.first.requestFocus();
      }
    });
  }

  void _startTimer() {
    timer?.cancel();

    setState(() {
      remainingSeconds = 57;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (currentTimer) {
        if (!mounted) {
          currentTimer.cancel();
          return;
        }

        if (remainingSeconds <= 1) {
          currentTimer.cancel();

          setState(() {
            remainingSeconds = 0;
          });

          return;
        }

        setState(() {
          remainingSeconds--;
        });
      },
    );
  }

  void _confirmOtp() {
    FocusScope.of(context).unfocus();

    if (otpCode.length != 4) {
      _showMessage(
        'الرجاء إدخال رمز التحقق كاملاً',
      );
      return;
    }

    context.read<OtpCubit>().verifyOtp(
          countryCode: widget.countryCode,
          phoneNumber: widget.phoneNumber,
          code: otpCode,
        );
  }

  void _resendOtp() {
    if (remainingSeconds > 0) {
      return;
    }

    for (final controller in otpControllers) {
      controller.clear();
    }

    focusNodes.first.requestFocus();

    /*
      لم يتم ربط إعادة إرسال OTP بعد.

      لاحقًا يمكن استدعاء:
      context.read<OtpCubit>().resendOtp(...)
    */

    _startTimer();

    _showMessage(
      'تم طلب إعادة إرسال الرمز',
    );
  }

  void _handleOtpSuccess(OtpSuccess state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.message.isNotEmpty
              ? state.message
              : 'تم تفعيل الحساب بنجاح',
        ),
      ),
    );

    final normalizedUserType =
        widget.userType.trim().toLowerCase();

    if (normalizedUserType == 'beneficiary') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/pending-approval',
        (route) => false,
        arguments: state.userId,
      );

      return;
    }

    Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => LoginCubit(
        authService: AuthService(),
        ),
      child: const LoginScreen(),
    ),
  ),
  (route) => false,
);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFF8E6);
    const buttonColor = AppColors.primary;
    const greenColor = Color(0xFF2E7D5B);

    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpSuccess) {
          _handleOtpSuccess(state);
        }

        if (state is OtpFailure) {
          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is OtpLoading;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 14),

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            icon: const Icon(
                              Icons.arrow_back,
                            ),
                            color: AppColors.primary,
                          ),
                        ),
                        const Text(
                          'تفعيل الحساب',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD85A),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.verified_user_outlined,
                        size: 44,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'يرجى إدخال الرمز المكون من 4 أرقام المرسل\n'
                      'إلى الرقم ${widget.countryCode} '
                      '${widget.phoneNumber}',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Color(0xFF5E574A),
                        fontSize: 14,
                        height: 1.8,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 34),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.ltr,
                      children: List.generate(
                        4,
                        (index) {
                          return OtpBox(
                            controller: otpControllers[index],
                            focusNode: focusNodes[index],
                            enabled: !isLoading,
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                focusNodes[index + 1]
                                    .requestFocus();
                              }

                              if (value.isEmpty && index > 0) {
                                focusNodes[index - 1]
                                    .requestFocus();
                              }

                              setState(() {});
                            },
                            onSubmitted: (_) {
                              if (index == 3 &&
                                  otpCode.length == 4 &&
                                  !isLoading) {
                                _confirmOtp();
                              }
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 44),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            isLoading ? null : _confirmOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          disabledBackgroundColor:
                              buttonColor.withOpacity(0.6),
                          elevation: 6,
                          shadowColor:
                              buttonColor.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(9),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'تأكيد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed:
                            remainingSeconds == 0 && !isLoading
                                ? _resendOtp
                                : null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: remainingSeconds == 0
                                ? greenColor
                                : greenColor.withOpacity(0.45),
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(9),
                          ),
                          backgroundColor: backgroundColor,
                        ),
                        child: Text(
                          remainingSeconds == 0
                              ? 'إعادة إرسال الرمز'
                              : 'إعادة الإرسال بعد '
                                  '$remainingSeconds ثانية',
                          style: TextStyle(
                            color: remainingSeconds == 0
                                ? greenColor
                                : greenColor.withOpacity(0.55),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OtpBox extends StatelessWidget {
  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.enabled,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFE0D2B4),
              width: 1.4,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFE0D2B4),
              width: 1.4,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFF006D7C),
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}