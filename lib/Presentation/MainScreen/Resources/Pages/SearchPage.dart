import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';

import 'HomePage.dart';

class Searchpage extends StatelessWidget {
  Searchpage({super.key,
    required this.controller,
    required this.searchResult,});

  final TextEditingController controller;
  
  final VoidCallback searchResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
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
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.clear();
                    },
                    icon: Icon(Icons.close))),
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) {
              searchResult();

            },
          ),
        ),

             Expanded(
               child: BlocBuilder<MainScreenCubit, MainScreenState>(
                         builder: (context, state) {
                           final cubit =context.read<MainScreenCubit>();
                           return cubit.searched?
                           MasonryGridView.count(
                             controller: cubit.scrollController,
                             physics: cubit.isPaginationLoading?NeverScrollableScrollPhysics():const ClampingScrollPhysics(),
                             crossAxisCount: 2,
                             mainAxisSpacing: 8,
                             crossAxisSpacing: 8,
                             itemCount: cubit.SearchimageData.length,
                             itemBuilder: (context, index) {
                               final imageUrl = cubit.SearchimageData[index]['url'] as String;
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
                                           placeholder: (context, url) =>
                                               Container(
                                                 height: randomHeight,
                                                 color: Colors.transparent,
                                               ),
                                           errorWidget: (context, url, error) =>
                                           const Icon(Icons.error),
                                         ),
                                       )));
                             },
                           ):SizedBox();
                         },
                       ),
             )
      ],
    );
  }
}
