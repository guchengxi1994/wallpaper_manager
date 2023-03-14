import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';

import 'image_card.dart';

class WallpaperManagerScreen extends StatefulWidget {
  const WallpaperManagerScreen({super.key});

  @override
  State<WallpaperManagerScreen> createState() => _WallpaperManagerScreenState();
}

class _WallpaperManagerScreenState extends State<WallpaperManagerScreen> {
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
                          ))
                      .toList(),
                )),
          ),
        );
      },
    );
  }
}
