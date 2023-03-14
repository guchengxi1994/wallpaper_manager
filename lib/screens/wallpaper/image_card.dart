import 'dart:io';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager/app_style.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';

import '../../bridge/native.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.paper});
  final WallPaper paper;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      hoverChild: _onHovering(context),
      onHover: (event) {},
      child: _beforeHover(),
    );
  }

  Widget _beforeHover() {
    return Card(
      elevation: 4,
      child: SizedBox(
        width: AppStyle.cardWidth,
        height: AppStyle.cardHeight,
        child: Stack(
          children: [
            ExtendedImage.file(
              File(paper.filePath),
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

  Widget _onHovering(BuildContext ctx) {
    return Card(
      elevation: 10,
      child: SizedBox(
        width: AppStyle.cardWidth,
        height: AppStyle.cardHeight,
        child: Stack(
          children: [
            ExtendedImage.file(
              File(paper.filePath),
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
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    // the size where the blurring starts
                    height: 50,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 5,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await ctx
                            .read<WallpaperController>()
                            .deleteImage(paper);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () async {
                        await ctx.read<WallpaperController>().setIsFav(paper);
                      },
                      child: paper.isFav == 1
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () async {
                        await api.setWallPaper(s: paper.filePath);
                      },
                      child: const Icon(
                        Icons.wallpaper,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
