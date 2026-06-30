import 'package:charity_management/Donor/donor_home_screen.dart';
import 'package:flutter/material.dart';
import 'Orphan/orphan_profile.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // لإخفاء شريط الـ Debug الافتراضي
      title: 'Charity Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: const DonorHomeScreen(), 
    );
  }
}