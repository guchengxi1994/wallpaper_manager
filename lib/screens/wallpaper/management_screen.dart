// ignore_for_file: unnecessary_cast, use_build_context_synchronously

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';

import 'add_one_image_card.dart';
import 'gallary_card.dart';
import 'image_card.dart';

class WallpaperManagerScreen extends StatefulWidget {
  const WallpaperManagerScreen({super.key});

  @override
  State<WallpaperManagerScreen> createState() => _WallpaperManagerScreenState();
}

class _WallpaperManagerScreenState extends State<WallpaperManagerScreen>
    with TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconRightMouseDown() {
    // print('onTrayIconRightMouseDown');
    trayManager.popUpContextMenu();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallpaperController()..init())
      ],
      builder: (ctx, child) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            width: 300,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 216, 207, 207), blurRadius: 1)
              ],
            ),
            child: Row(
              children: [
                // InkWell(
                //   highlightColor: Colors.white,
                //   borderRadius: const BorderRadius.only(
                //       topLeft: Radius.circular(20),
                //       bottomLeft: Radius.circular(20)),
                //   onTap: () async {
                //     final s = await api.getParentId();
                //     debugPrint(s.toString());
                //     if (s != -1) {
                //       await api.setGalleryId(id: s);
                //       ctx.read<WallpaperController>().init();
                //     }
                //   },
                //   child: const SizedBox(
                //     width: 30,
                //     child: Center(
                //       child: Icon(Icons.chevron_left),
                //     ),
                //   ),
                // )
                HoverWidget(
                  hoverChild: GestureDetector(
                    onTap: () async {
                      final s = await api.getParentId();
                      debugPrint(s.toString());
                      if (s != -1) {
                        await api.setGalleryId(id: s);
                        ctx.read<WallpaperController>().init();
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        width: 30,
                        height: 30,
                        child: const Center(
                          child: Icon(Icons.chevron_left),
                        ),
                      ),
                    ),
                  ),
                  onHover: (event) {},
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: Icon(Icons.chevron_left),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            // color: Colors.amber,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: DropTarget(
                onDragDone: (details) async {
                  for (final file in details.files) {
                    await ctx
                        .read<WallpaperController>()
                        .addNewImage(file.path);
                  }
                },
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: _buildContent(ctx),
                )),
          ),
        );
      },
    );
  }

  List<Widget> _buildContent(BuildContext ctx) {
    final children = ctx.watch<WallpaperController>().images;
    final result = <Widget>[];
    for (final i in children) {
      i.map(gallery: (c) {
        result.add(GallaryCard(
          gallery: c.field0,
        ));
      }, wallPaper: (w) {
        result.add(ImageCard(paper: w.field0));
      });
    }
    result.add(const AddOneImageCard());
    return result;
  }
}
