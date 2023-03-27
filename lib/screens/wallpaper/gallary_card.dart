// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager/app_style.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';

import 'easy_button.dart';

class GallaryCard extends StatelessWidget {
  const GallaryCard({super.key, required this.gallery});
  final Gallery gallery;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        await api.setGalleryId(id: gallery.galleryId);
        await context.read<WallpaperController>().init();
      },
      child: Card(
        elevation: 4,
        child: SizedBox(
          width: AppStyle.cardWidth,
          height: AppStyle.cardHeight,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: ExtendedImage.asset(
                  "asset/image/gallery.png",
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      // the size where the blurring starts
                      height: 30,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: 5,
                  bottom: 5,
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppStyle.cardWidth - 60,
                        child: Text(
                          gallery.galleryName,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      EasyButton(
                        onClick: () async {
                          await api.deleteGalleryKeepChildrenById(
                              i: gallery.galleryId);
                          await context.read<WallpaperController>().init();
                        },
                        child: const Tooltip(
                          message: "删除保留子文件",
                          child: Icon(Icons.delete),
                        ),
                      ),
                      EasyButton(
                        onClick: () async {
                          debugPrint("[flutter] delete folder");
                          await api.deleteGalleryDirectlyById(
                              i: gallery.galleryId);
                          await context.read<WallpaperController>().init();
                        },
                        child: const Tooltip(
                          message: "直接删除",
                          child: Icon(Icons.delete_forever),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
