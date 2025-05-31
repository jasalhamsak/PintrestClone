import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/Resources/Pages/SearchPage/SearchResultPage.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';

import '../../masonoryGrid.dart';
import '../HomePage/HomePage.dart';

class Searchpage extends StatefulWidget {
  Searchpage({
    super.key,
    required this.controller,
    required this.searchResult,
  });

  final TextEditingController controller;
  final VoidCallback searchResult;

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MainScreenCubit, MainScreenState, int>(
      selector: (state) {
        return context.read<MainScreenCubit>().currentSearchViewIndex;
      },
      builder: (context, selectedIndex) {
        final cubit = context.read<MainScreenCubit>();
        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            cubit.isWantToSearch(true);
          }
        });
        return Column(
          children: [
            Row(
              children: [
                cubit.searched
                    ? IconButton(
                        onPressed: () {
                          cubit.changeSearchedState(false);
                          cubit.isWantToSearch(true);
                        }, icon: Icon(Icons.chevron_left))
                    : SizedBox(),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 15, bottom: 15,right: 10),
                    child: TextFormField(
                      controller: widget.controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          prefixIcon: !cubit.wantToSearch &&!cubit.searched?Icon(Icons.search):null,
                          suffixIcon: cubit.searched?null:IconButton(
                              onPressed: () {
                                widget.controller.clear();
                              },
                              icon: Icon(Icons.close))),
                      textInputAction: TextInputAction.search,
                      onTap: () {
                        // cubit.changeSearchViewIndex(2);
                        cubit.isWantToSearch(true);
                      },
                      onFieldSubmitted: (value) {
                        widget.searchResult();
                        cubit.isWantToSearch(false);
                      },
                    ),
                  ),
                ),
                cubit.wantToSearch
                    ? Builder(builder: (context) {
                        return TextButton(
                            onPressed: () {
                              widget.controller.clear();
                              cubit.isWantToSearch(false);
                              focusNode.unfocus();
                              // context.read<MainScreenCubit>().changeSearchedState(false);
                            },
                            child: Text(
                              "cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ));
                      })
                    : SizedBox()
              ],
            ),
            Expanded(
              child: BlocBuilder<MainScreenCubit, MainScreenState>(
                builder: (context, state) {
                  final cubit = context.read<MainScreenCubit>();

                  return cubit.wantToSearch?
                  Text("Recent Searches"):
                  cubit.searched
                      ? ImageMasonryGrid(
                          imageList: cubit.SearchimageData,
                          scrollController: cubit.scrollController,
                          isLoading: cubit.isPaginationLoading,
                        )
                      : !cubit.wantToSearch? Column(
                          children: [
                            Text(
                              "Contailners",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Contailners",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ):SizedBox();
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class RecentSearchPage extends StatelessWidget {
  const RecentSearchPage({
    super.key,
    required this.controller,
    required this.searchResult,
    required this.canceled,
    required this.isSearched,
  });

  final TextEditingController controller;
  final VoidCallback searchResult;
  final VoidCallback canceled;
  final VoidCallback isSearched;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MainScreenCubit, MainScreenState, bool>(
      selector: (state) {
        return context.read<MainScreenCubit>().searched;
      },
      builder: (context, searched) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                      left: 15,
                    ),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                              onPressed: () {
                                controller.clear();
                              },
                              icon: Icon(Icons.close))),
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        isSearched();
                      },
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      controller.clear();
                      context
                          .read<MainScreenCubit>()
                          .changeSearchedState(false);
                      canceled();
                    },
                    child: Text(
                      "cancel",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ))
              ],
            ),
          ],
        );
      },
    );
  }
}
