    import 'package:flutter/cupertino.dart';
    import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
    import 'package:pintrestcloneapk/Presentation/MainScreen/cubit/main_screen_cubit.dart';
    import 'package:cached_network_image/cached_network_image.dart';

    import '../TopBar.dart';


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
            return Column(
              children: [
             if(cubit.navigationPage==1)PinterestCategoryBar(),
                Expanded(
                  child: MasonryGridView.count(
                    controller: cubit.scrollController,
                    physics: cubit.isPaginationLoading?NeverScrollableScrollPhysics():const ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: cubit.imageData.length,
                    itemBuilder: (context, index) {

                      final imageUrl = cubit.imageData[index]['url'] as String;
                      final double randomHeight =  250 + (index % 5) * 30;
                      return InkWell(
                          onTap: () {},
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child:
                              SizedBox(
                                height: randomHeight,
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration: Duration.zero,
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) => Container(
                                    height: randomHeight,
                                    color: Colors.transparent,
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              )

                          ));
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
    }
