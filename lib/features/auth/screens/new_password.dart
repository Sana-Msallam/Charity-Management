import '/widgets/custom_text_fields.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();

    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void saveNewPassword() {
    if (_formKey.currentState!.validate()) {
      final otpCode = otpController.text.trim();
      final newPassword = passwordController.text.trim();

      // هون بتبعتي للـ API:
      // otpCode
      // newPassword

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ كلمة المرور بنجاح'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFFFF8E6);
    const Color buttonColor = AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 14),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: buttonColor,
                        ),
                      ),

                      const Text(
                        'إعادة تعيين كلمة المرور',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize:22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  CustomTextField(
                    labelText:' رمز التحقق',
                    hintText: 'ادخل رمز التحقق',
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال رمز التحقق';
                      }

                      if (value.trim().length < 4) {
                        return 'رمز التحقق غير صالح';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  CustomTextField(
                    labelText: 'كلمة المرور الجديدة',
                                              hintText: '********',

                    controller: passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء إدخال كلمة المرور الجديدة';
                      }

                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  CustomTextField(
                    labelText: 'تأكيد كلمة المرور الجديدة',
                                              hintText: '********',

                    controller: confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الرجاء تأكيد كلمة المرور';
                      }

                      if (value != passwordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 38),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: saveNewPassword,
                      icon: const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'تغيير كلمة المرور',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        elevation: 8,
                        shadowColor: buttonColor.withOpacity(0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}