// widgets/image_masonry_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pintrestcloneapk/Presentation/MainScreen/Resources/Pages/HomePage/DetailsPage.dart';

class ImageMasonryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> imageList;
  final ScrollController? scrollController;
  final bool isLoading;
  final void Function(String imageUrl,String alt) onClicked;
  final void Function(String query) changeQuery;
  final VoidCallback getImage;
  final bool isImageClicked;



  const ImageMasonryGrid({
    Key? key,
    required this.imageList,
    this.scrollController,
    this.isLoading = false, required this.onClicked, required this.changeQuery, required this.getImage, required this.isImageClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool imageClicked = isImageClicked;
    return MasonryGridView.count(
      shrinkWrap: true,
      controller: scrollController,
      physics: isLoading && imageClicked
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        final imageUrl = imageList[index]['url'] as String;
        final alt = imageList[index]['alt'];
        final double randomHeight = 250 + (index % 5) * 30;

        return InkWell(
          onTap: () {
            changeQuery(alt as String);
            onClicked(imageUrl,alt);
            getImage();
          },
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        );
      },
    );
  }
}
