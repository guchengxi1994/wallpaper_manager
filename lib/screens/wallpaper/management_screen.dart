// ignore_for_file: unnecessary_cast, use_build_context_synchronously

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';

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
        ChangeNotifierProvider(create: (_) => WallpaperController()..init()),
        ChangeNotifierProvider(create: (_) => SubProcessController()..init()),
      ],
      builder: (ctx, child) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 216, 207, 207), blurRadius: 1)
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
                ),
                HoverWidget(
                  hoverChild: GestureDetector(
                    onTap: () async {
                      await ctx.read<SubProcessController>().run();
                      Future.delayed(Duration(seconds: 5)).then((value) async =>
                          {
                            await api.setDynamicWallpaper(
                                pid: ctx.read<SubProcessController>().playerPid)
                          });
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
                          child: Icon(Icons.set_meal),
                        ),
                      ),
                    ),
                  ),
                  onHover: (event) {},
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: Icon(Icons.set_meal),
                    ),
                  ),
                ),
                HoverWidget(
                  hoverChild: GestureDetector(
                    onTap: () async {
                      ctx.read<SubProcessController>().killProcess();
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
                          child:
                              Icon(Icons.keyboard_double_arrow_right_outlined),
                        ),
                      ),
                    ),
                  ),
                  onHover: (event) {},
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: Icon(Icons.keyboard_double_arrow_right_outlined),
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
                                    SizedBox(
                                      width: 500,
                                      height: 500,
                                      child: LazyTreeview(),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text("退出")),
                                    TextButton(
                                        onPressed: () async {
                                          // Navigator.of(context).pop();
                                          await api.moveItem(
                                              toId: 6,
                                              f: ctx
                                                  .read<WallpaperController>()
                                                  .images[1]);
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text("测试移动"))
                                  ],
                                ),
                              ),
                            );
                          });

                      if (r == true) {
                        await ctx.read<WallpaperController>().init();
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
