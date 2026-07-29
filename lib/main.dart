import 'package:charity_management/features/screen/home_screen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(
    const Directionality(
      textDirection: TextDirection.rtl,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          
          home: HomePage(),
        );
      }
    
  
}
