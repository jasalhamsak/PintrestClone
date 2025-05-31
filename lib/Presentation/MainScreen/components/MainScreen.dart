import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/Resources/Pages/HomePage/HomePage.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/Resources/Pages/SearchPage/SearchPage.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';

import '../Resources/Pages/Add/AddTab.dart';
import '../Resources/TopBar.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenCubit, MainScreenState>(
      builder: (context, state) {
        final cubit = context.read<MainScreenCubit>();

        return SafeArea(
          child: Scaffold(
            bottomNavigationBar: Container(
              height: 60,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        cubit.changePage(1);
                      },
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        cubit.changePage(2);
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        showAddTabModal(context);
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.chat_rounded,
                        color: Colors.white,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      )),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
            body: cubit.navigationPage == 1
                ? Homepage()
                : cubit.navigationPage == 2
                ? Searchpage(
              controller: cubit.searchController,
              searchResult: () {
                cubit.getSearchImage();
              },
            )
                : Text("something wrong"),
          ),
        );
      },
    );
  }
}
