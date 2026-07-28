import 'package:charity_management/Donor/cubit/aid_request_cubit.dart';
import 'package:charity_management/Donor/Screen/donor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Orphan/Screen/orphan_profile.dart';
import 'package:charity_management/Sponsership/Screen/sponsorships_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AidRequestCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Charity Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        home:  DonorHomeScreen(),
      ),
    );
  }
}