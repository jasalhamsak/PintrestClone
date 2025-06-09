import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
                        },
                        icon: Icon(Icons.chevron_left))
                    : SizedBox(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 15, bottom: 15, right: 10),
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
                          prefixIcon: !cubit.wantToSearch && !cubit.searched
                              ? Icon(Icons.search)
                              : null,
                          suffixIcon: cubit.searched
                              ? null
                              : IconButton(
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
                        cubit.addItemToRecentList(value.trim());
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
                  cubit.getRecentList();
                  final recentList = cubit.recentSearches;
                  return cubit.wantToSearch
                      ? recentList.isEmpty
                          ? Center(
                              child: Text("No recent searches",
                                  style: TextStyle(color: Colors.white)),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: recentList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextButton(
                                              onPressed: () {
                                                widget.controller.text =
                                                    recentList[index];
                                                widget.searchResult();
                                                cubit.isWantToSearch(false);
                                              },
                                              child: Text(recentList[index],
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ),
                                        leading: Icon(Icons.search),
                                        trailing: IconButton(
                                          icon: Icon(Icons.close,
                                              color: Colors.white),
                                          onPressed: () {
                                            cubit.removeRecentItem(index);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                      : cubit.searched
                          ? ImageMasonryGrid(
                              imageList: cubit.SearchimageData,
                              scrollController: cubit.scrollController,
                              isLoading: cubit.isPaginationLoading,
                              onClicked: (imageUrl, alt) {
                                cubit.isImageClicked(true, imageUrl, alt);
                              },
                              changeQuery: (query) {
                                cubit.changeSearchQuery(query);
                              },
                              getImage: () {
                                cubit.getSearchImage(loadMore: false);
                              },
                              isImageClicked: cubit.imageClicked,
                            )
                          : !cubit.wantToSearch
                              ? Column(
                                  children: [
                                    // Text(
                                    //   "Contailners",
                                    //   style: TextStyle(color: Colors.white),
                                    // ),
                                    // Text(
                                    //   "Contailners",
                                    //   style: TextStyle(color: Colors.white),
                                    // ),
                                  ],
                                )
                              : SizedBox();
                },
              ),
            )
          ],
        );
      },
    );
  }
}
