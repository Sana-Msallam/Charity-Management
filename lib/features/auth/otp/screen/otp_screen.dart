import 'dart:async';

import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/routes/app_routes.dart';

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

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  Timer? timer;
  int remainingSeconds = 57;

  String get otpCode {
    return otpControllers.map((controller) => controller.text.trim()).join();
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

    timer = Timer.periodic(const Duration(seconds: 1), (currentTimer) {
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
    });
  }

  void _confirmOtp() {
    FocusScope.of(context).unfocus();

    if (otpCode.length != 4) {
      _showMessage(AppLocalizations.of(context).otpRequired);
      return;
    }

    context.read<OtpCubit>().verifyOtp(
      countryCode: widget.countryCode,
      phoneNumber: widget.phoneNumber,
      code: otpCode,
      localizations: AppLocalizations.of(context),
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

    _showMessage(AppLocalizations.of(context).otpResendRequested);
  }

  void _handleOtpSuccess(OtpSuccess state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.message.isNotEmpty
              ? state.message
              : AppLocalizations.of(context).phoneVerified,
        ),
      ),
    );

    final normalizedUserType = widget.userType.trim().toLowerCase();

    if (normalizedUserType == 'beneficiary') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.pendingApproval,
        (route) => false,
      );

      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
    final localizations = AppLocalizations.of(context);

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
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final metrics = _OtpLayoutMetrics.from(
                  constraints,
                  MediaQuery.of(context).viewInsets.bottom > 0,
                );

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(
                    horizontal: metrics.horizontalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: metrics.topGap),

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: IconButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                      },
                                icon: const Icon(Icons.arrow_back),
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              localizations.accountActivation,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: metrics.titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: metrics.headerToIconGap),

                        Container(
                          width: metrics.iconContainerSize,
                          height: metrics.iconContainerSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD85A),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.verified_user_outlined,
                            size: metrics.iconSize,
                            color: AppColors.primary,
                          ),
                        ),

                        SizedBox(height: metrics.iconToTextGap),

                        Text(
                          localizations.otpInstructions(
                            '${widget.countryCode} ${widget.phoneNumber}',
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF5E574A),
                            fontSize: metrics.instructionsFontSize,
                            height: metrics.instructionsLineHeight,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: metrics.textToOtpGap),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.ltr,
                          children: List.generate(4, (index) {
                            return OtpBox(
                              size: metrics.otpBoxSize,
                              controller: otpControllers[index],
                              focusNode: focusNodes[index],
                              enabled: !isLoading,
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  focusNodes[index + 1].requestFocus();
                                }

                                if (value.isEmpty && index > 0) {
                                  focusNodes[index - 1].requestFocus();
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
                          }),
                        ),

                        SizedBox(height: metrics.otpToButtonGap),

                        SizedBox(
                          width: double.infinity,
                          height: metrics.buttonHeight,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _confirmOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              disabledBackgroundColor: buttonColor.withValues(
                                alpha: 0.6,
                              ),
                              elevation: 6,
                              shadowColor: buttonColor.withValues(alpha: 0.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    localizations.confirm,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: metrics.buttonGap),

                        SizedBox(
                          width: double.infinity,
                          height: metrics.buttonHeight,
                          child: OutlinedButton(
                            onPressed: remainingSeconds == 0 && !isLoading
                                ? _resendOtp
                                : null,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: remainingSeconds == 0
                                    ? greenColor
                                    : greenColor.withValues(alpha: 0.45),
                                width: 1.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              backgroundColor: backgroundColor,
                            ),
                            child: Text(
                              remainingSeconds == 0
                                  ? localizations.resendCode
                                  : localizations.resendAfter(remainingSeconds),
                              style: TextStyle(
                                color: remainingSeconds == 0
                                    ? greenColor
                                    : greenColor.withValues(alpha: 0.55),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: metrics.bottomGap),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _OtpLayoutMetrics {
  const _OtpLayoutMetrics({
    required this.horizontalPadding,
    required this.topGap,
    required this.titleFontSize,
    required this.headerToIconGap,
    required this.iconContainerSize,
    required this.iconSize,
    required this.iconToTextGap,
    required this.instructionsFontSize,
    required this.instructionsLineHeight,
    required this.textToOtpGap,
    required this.otpBoxSize,
    required this.otpToButtonGap,
    required this.buttonHeight,
    required this.buttonGap,
    required this.bottomGap,
  });

  factory _OtpLayoutMetrics.from(
    BoxConstraints constraints,
    bool keyboardOpen,
  ) {
    final availableHeight = constraints.maxHeight;
    final compactHeight = availableHeight < 640 || keyboardOpen;
    final horizontalPadding = constraints.maxWidth < 360 ? 16.0 : 22.0;
    final availableWidth = constraints.maxWidth - (horizontalPadding * 2);
    final targetGap = availableWidth < 300 ? 8.0 : 12.0;
    final otpBoxSize = ((availableWidth - (targetGap * 3)) / 4)
        .clamp(44.0, compactHeight ? 54.0 : 58.0)
        .toDouble();

    return _OtpLayoutMetrics(
      horizontalPadding: horizontalPadding,
      topGap: (availableHeight * 0.025).clamp(8.0, 14.0).toDouble(),
      titleFontSize: compactHeight ? 20.0 : 22.0,
      headerToIconGap: (availableHeight * 0.04).clamp(14.0, 28.0).toDouble(),
      iconContainerSize: (availableHeight * 0.13).clamp(64.0, 88.0).toDouble(),
      iconSize: (availableHeight * 0.065).clamp(34.0, 44.0).toDouble(),
      iconToTextGap: (availableHeight * 0.025).clamp(10.0, 18.0).toDouble(),
      instructionsFontSize: compactHeight ? 13.0 : 14.0,
      instructionsLineHeight: compactHeight ? 1.55 : 1.8,
      textToOtpGap: (availableHeight * 0.05).clamp(18.0, 34.0).toDouble(),
      otpBoxSize: otpBoxSize,
      otpToButtonGap: (availableHeight * 0.06).clamp(22.0, 44.0).toDouble(),
      buttonHeight: compactHeight ? 44.0 : 50.0,
      buttonGap: compactHeight ? 8.0 : 12.0,
      bottomGap: (availableHeight * 0.04).clamp(16.0, 28.0).toDouble(),
    );
  }

  final double horizontalPadding;
  final double topGap;
  final double titleFontSize;
  final double headerToIconGap;
  final double iconContainerSize;
  final double iconSize;
  final double iconToTextGap;
  final double instructionsFontSize;
  final double instructionsLineHeight;
  final double textToOtpGap;
  final double otpBoxSize;
  final double otpToButtonGap;
  final double buttonHeight;
  final double buttonGap;
  final double bottomGap;
}

class OtpBox extends StatelessWidget {
  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.enabled,
    required this.size,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool enabled;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 1,
        style: TextStyle(
          fontSize: size < 52 ? 20 : 22,
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
            borderSide: const BorderSide(color: Color(0xFFE0D2B4), width: 1.4),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFFE0D2B4), width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFF006D7C), width: 2),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
        ),
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}
