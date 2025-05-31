import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../cubit/main_screen_cubit.dart';
import 'SearchPage.dart';

class Searchresultpage extends StatelessWidget {
  const Searchresultpage({super.key, required this.controller, required this.searchResult});

  final TextEditingController controller;
  final VoidCallback searchResult;

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.chevron_left)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15,bottom: 15,top: 15),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        prefixIcon: Icon(Icons.search),
                    ),
                    textInputAction: TextInputAction.search,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    onFieldSubmitted: (value) {
                      searchResult();
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<MainScreenCubit, MainScreenState>(
              builder: (context, state) {
                final cubit = context.read<MainScreenCubit>();
                return cubit.searched
                    ? MasonryGridView.count(
                  controller: cubit.scrollController,
                  physics: cubit.isPaginationLoading
                      ? NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: cubit.SearchimageData.length,
                  itemBuilder: (context, index) {
                    final imageUrl =
                    cubit.SearchimageData[index]['url'] as String;
                    final double randomHeight = 250 + (index % 5) * 30;
                    return InkWell(
                        onTap: () {},
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              height: randomHeight,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: randomHeight,
                                  color: Colors.transparent,
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            )));
                  },
                )
                    : SizedBox();
              },
            ),
          )
        ],
      );
  }
}
