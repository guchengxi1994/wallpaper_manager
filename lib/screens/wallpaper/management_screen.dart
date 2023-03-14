// ignore_for_file: unnecessary_cast

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';

import 'add_one_image_card.dart';
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
                  children: ctx
                      .watch<WallpaperController>()
                      .images
                      .map((e) => ImageCard(
                            paper: e,
                          ) as Widget)
                      .toList()
                    ..add(const AddOneImageCard()),
                )),
          ),
        );
      },
    );
  }
}
