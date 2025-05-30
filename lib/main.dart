import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';
import 'package:pintrestcloneapk/Presentation/SplashScreen/Components/Splash.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => MainScreenCubit()..getImage(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinterest Clone By j',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Splash(),
    );
  }
}
