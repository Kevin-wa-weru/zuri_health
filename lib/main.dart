import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zuri_health/cubit/get_hospital_details_cubit.dart';
import 'package:zuri_health/cubit/get_hospital_list_cubit.dart';
import 'package:zuri_health/features/landing_page.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<GetHospitalListCubit>(
      create: (context) => GetHospitalListCubit(),
    ),
    BlocProvider<GetHospitalDetailsCubit>(
      create: (context) => GetHospitalDetailsCubit(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LandingPage());
  }
}
