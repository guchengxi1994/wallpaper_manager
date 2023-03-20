import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_manager/app_style.dart';

class GallaryCard extends StatelessWidget {
  const GallaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: SizedBox(
        width: AppStyle.cardWidth,
        height: AppStyle.cardHeight,
        child: Stack(
          children: [
            ExtendedImage.asset(
              "asset/image/no.png",
              loadStateChanged: (state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case LoadState.completed:
                    return ExtendedRawImage(
                      width: AppStyle.cardWidth,
                      height: AppStyle.cardHeight,
                      image: state.extendedImageInfo?.image,
                      fit: BoxFit.fitWidth,
                    );
                  case LoadState.failed:
                    return Image.asset(
                      "asset/image/no.png",
                      fit: BoxFit.fill,
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
