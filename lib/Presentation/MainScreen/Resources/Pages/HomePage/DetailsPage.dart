import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';

import '../../masonoryGrid.dart';

class Detailspage extends StatelessWidget {
  const Detailspage({super.key, required this.onClick, required this.url, required this.download});

  final VoidCallback onClick;
  final VoidCallback download;
  final String url;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Image.network(url),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius:
                    BorderRadius.circular(20), // or make it circular
                  ),
                  child: IconButton(
                      onPressed: () {
                        onClick();
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        size: 40,
                        color: Colors.black,
                      )),
                ),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.heart_broken)),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.messenger_outline)),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.ios_share_outlined)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      download();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      side: BorderSide(color: Colors.black, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 18),
                    )),
              ],
            ),
            Text("From jasal"),
            Text(
                "The sky shifted hues as the sun dipped below the horizon,\n casting golden streaks across the rooftopsThis "),
            BlocBuilder<MainScreenCubit, MainScreenState>(
              builder: (context, state) {
                final cubit =context.read<MainScreenCubit>();
      
                return SizedBox(
                  height: 3250,
                  child: ImageMasonryGrid(
                    imageList: cubit.SearchimageData,
                    scrollController: cubit.scrollController,
                    isLoading: cubit.isPaginationLoading,
                    onClicked: (imageUrl,alt) {
                      cubit.isImageClicked(false, imageUrl,alt);
                    }, changeQuery: (String query) {  },
                    getImage: () {  cubit.getSearchImage(loadMore: false); }, isImageClicked: cubit.imageClicked,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
