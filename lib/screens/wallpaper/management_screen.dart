// ignore_for_file: unnecessary_cast, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';
import 'package:window_manager/window_manager.dart';

import '../tree_view/lazy_tree_view.dart';
import 'add_one_image_card.dart';
import 'gallary_card.dart';
import 'image_card.dart';
import 'sub_process_controller.dart';

class WallpaperManagerScreen extends StatefulWidget {
  const WallpaperManagerScreen({super.key});

  @override
  State<WallpaperManagerScreen> createState() => _WallpaperManagerScreenState();
}

class _WallpaperManagerScreenState extends State<WallpaperManagerScreen>
    with TrayListener, WindowListener {
  late final Stream switchImageStream =
      context.read<WallpaperController>().switchRandomFavs();
  late final listener;
  @override
  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);
    _init();
    listener = switchImageStream.listen((event) {});
    super.initState();
  }

  void _init() async {
    // 添加此行以覆盖默认关闭处理程序
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title:
                const Text('Are you sure you want to close this application?'),
            actions: [
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  context.read<SubProcessController>().killProcess();
                  Navigator.of(context).pop();
                  await windowManager.destroy();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    listener.cancel();
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconRightMouseDown() {
    // print('onTrayIconRightMouseDown');
    trayManager.popUpContextMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        width: 300,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Color.fromARGB(255, 216, 207, 207), blurRadius: 1)
          ],
        ),
        child: Row(
          children: [
            HoverWidget(
              hoverChild: GestureDetector(
                onTap: () async {
                  final s = await api.getParentId();
                  debugPrint(s.toString());
                  if (s != -1) {
                    await api.setGalleryId(id: s);
                    context.read<WallpaperController>().init();
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
            ),
            HoverWidget(
              hoverChild: GestureDetector(
                onTap: () async {
                  await context
                      .read<WallpaperController>()
                      .switchAutoWallpaper();
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
                      child: Icon(Icons.play_arrow),
                    ),
                  ),
                ),
              ),
              onHover: (event) {},
              child: const SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: Icon(Icons.play_arrow),
                ),
              ),
            ),
            HoverWidget(
              hoverChild: GestureDetector(
                onTap: () async {
                  final r = await showGeneralDialog(
                      context: context,
                      pageBuilder: (c, a1, a2) {
                        return Center(
                          child: Container(
                            width: 500,
                            height: 600,
                            color: Colors.white,
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 500,
                                  height: 500,
                                  child: LazyTreeview(),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text("退出")),
                                TextButton(
                                    onPressed: () async {
                                      // Navigator.of(context).pop();
                                      await api.moveItem(
                                          toId: 6,
                                          f: context
                                              .read<WallpaperController>()
                                              .images[1]);
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text("测试移动"))
                              ],
                            ),
                          ),
                        );
                      });

                  if (r == true) {
                    await context.read<WallpaperController>().init();
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
                      child: Icon(Icons.tab),
                    ),
                  ),
                ),
              ),
              onHover: (event) {},
              child: const SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: Icon(Icons.tab),
                ),
              ),
            ),
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
                await context
                    .read<WallpaperController>()
                    .addNewImage(file.path);
              }
            },
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: _buildContent(),
            )),
      ),
    );
  }

  List<Widget> _buildContent() {
    final children = context.watch<WallpaperController>().images;
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
