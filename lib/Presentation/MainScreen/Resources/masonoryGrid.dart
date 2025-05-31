// widgets/image_masonry_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageMasonryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> imageList;
  final ScrollController? scrollController;
  final bool isLoading;

  const ImageMasonryGrid({
    Key? key,
    required this.imageList,
    this.scrollController,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      controller: scrollController,
      physics: isLoading
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        final imageUrl = imageList[index]['url'] as String;
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        );
      },
    );
  }
}
