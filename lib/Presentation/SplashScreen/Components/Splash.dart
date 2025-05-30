import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/components/MainScreen.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainScreenCubit, MainScreenState>(
      listener: (context, state) {
        if (state is ImageLoaded) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Mainscreen(),
            ),
          );
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("assets/logo.png")],
            )
          ],
        ),
      ),
    );
  }
}
