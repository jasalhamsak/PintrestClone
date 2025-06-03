import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/Resources/Pages/HomePage/DetailsPage.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../TopBar.dart';
import '../../masonoryGrid.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenCubit, MainScreenState>(
      builder: (context, state) {
        final cubit = context.read<MainScreenCubit>();
        if (!cubit.isScrollListenerAdded) {
          cubit.setupScrollListener();
        }
        return cubit.imageClicked
            ? Detailspage(
                onClick: () => cubit.isImageClicked(false, "",""),
                url: cubit.url,
                download: () {
                  cubit.downloadImage(cubit.url);
                },
              )
            : Column(
                children: [
                  if (cubit.navigationPage == 1) PinterestCategoryBar(),
                  Expanded(
                    child: ImageMasonryGrid(
                      imageList: cubit.imageData,
                      scrollController: cubit.scrollController,
                      isLoading: cubit.isPaginationLoading,
                      onClicked: (imageUrl,alt) {
                        cubit.isImageClicked(true, imageUrl,alt);
                      },
                      changeQuery: (query) {
                        cubit.changeSearchQuery(query);
                      },
                      getImage: () {
                        cubit.getSearchImage(loadMore: false);
                      },
                      isImageClicked: cubit.imageClicked,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
