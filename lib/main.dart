import 'package:flutter/material.dart';
import '/features/auth/login/screen/login.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/login/cubit/login_cubit.dart';
import 'features/auth/services/auth_service.dart';
// تأكدي من كتابة مسار ملف واجهة تسجيل الدخول بشكل صحيح

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // تعريف الألوان المتوافقة مع هوية جمعية النور (تصميم Tailwind)
    const Color primaryColor = Color(0xFF735C00); // اللون الذهبي البني الأساسي
    const Color backgroundColor = Color(0xFFFFF8F1); // اللون الفاتح المائل للبيج للـ Light Mode

    return MaterialApp(
      title: 'جمعية النور',
      debugShowCheckedModeBanner: false, // لإخفاء شريط التجريب المائل (Debug Banner)
      
      // إعدادات الثيم الخفيف (Light Theme)
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          brightness: Brightness.light,
        ),
        fontFamily: 'Noto Kufi Arabic', // تفعيل الخط العربي الافتراضي للمشروع
      ),

      // إعدادات الثيم الداكن (Dark Theme) لتتوافق مع ميزة الحقول الذكية لرفيقتك
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: Color(0xFF1A1C18),
        ),
        fontFamily: 'Noto Kufi Arabic',
      ),

      themeMode: ThemeMode.light, // يمكنكِ تغييرها إلى ThemeMode.system ليدعم الدارك مود تلقائياً حسب جهاز المستخدم

      // هنا نحدد أن الواجهة الأولى التي ستظهر عند تشغيل التطبيق هي صفحة تسجيل الدخول
      home: BlocProvider(
  create: (_) => LoginCubit(
    authService: AuthService(),
  ),
  child: const LoginScreen(),
),
    );
  }
}