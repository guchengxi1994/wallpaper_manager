// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager/app_style.dart';
import 'package:wallpaper_manager/screens/wallpaper/sub_process_controller.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';

import '../../bridge/native.dart';
import 'preview/gif_preview.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.paper});
  final WallPaper paper;

  bool isInputAnImage(String s) {
    final ext = path.extension(s);
    return [
      'jpg',
      'jpx',
      'apng',
      'png',
      'gif',
      'webp',
      'tiff',
      'bmp',
    ].contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    final isImage = isInputAnImage(paper.filePath);
    return HoverWidget(
      hoverChild: _onHovering(context, isImage),
      onHover: (event) {},
      child: _beforeHover(isImage),
    );
  }

  Widget _beforeHover(bool isImage) {
    return Card(
      elevation: 4,
      child: SizedBox(
        width: AppStyle.cardWidth,
        height: AppStyle.cardHeight,
        child: Stack(
          children: [
            isImage
                ? ExtendedImage.file(
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
                : Lottie.asset(
                    "asset/image/player.json",
                    fit: BoxFit.fill,
                  )
          ],
        ),
      ),
    );
  }

  Widget _onHovering(BuildContext ctx, bool isImage) {
    return GestureDetector(
      onDoubleTap: () async {
        final fileType =
            await ctx.read<WallpaperController>().getFileType(paper.filePath);
        if (fileType == "gif") {
          showGeneralDialog(
              context: ctx,
              pageBuilder: (c, f, s) {
                return Center(
                  child: GifPreviewWidget(
                    filePath: paper.filePath,
                  ),
                );
              });
          return;
        }

        if (!isImage) {
          await ctx
              .read<SubProcessController>()
              .watchVideo(videoPath: paper.filePath);
        }
      },
      child: Card(
        elevation: 10,
        child: SizedBox(
          width: AppStyle.cardWidth,
          height: AppStyle.cardHeight,
          child: Stack(
            children: [
              isImage
                  ? ExtendedImage.file(
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
                  : Lottie.asset(
                      "asset/image/player.json",
                      fit: BoxFit.fill,
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
                          final s = await api.getCurrentWallPaper();
                          final r = await showCupertinoDialog(
                              context: ctx,
                              builder: (c) {
                                return CupertinoAlertDialog(
                                  title: Text("是否要将壁纸$s替换为${paper.filePath}?"),
                                  actions: [
                                    CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(-1);
                                        },
                                        child: const Text("取消")),
                                    CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(0);
                                        },
                                        child: const Text("确定"))
                                  ],
                                );
                              });

                          if (r == -1) {
                            return;
                          }

                          if (isImage) {
                            await api.setWallPaper(s: paper.filePath);
                          } else {
                            await ctx
                                .read<SubProcessController>()
                                .run(videoPath: paper.filePath);

                            Future.delayed(const Duration(seconds: 5)).then(
                                (value) async => {
                                      await api.setDynamicWallpaper(
                                          pid: ctx
                                              .read<SubProcessController>()
                                              .playerPid)
                                    });
                          }
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
      ),
    );
  }
}
