// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager/app_style.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';

class AddOneImageCard extends StatelessWidget {
  const AddOneImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final s = await showGeneralDialog(
            context: context,
            pageBuilder: (c, f, s) {
              return const Center(
                child: AddDialog(),
              );
            });
        debugPrint(s.toString());
        if (s != "") {
          final res = await api.createNewGallery(s: s.toString());
          if (res != 0 || res != -1) {
            await context.read<WallpaperController>().init();
          } else {
            debugPrint(res.toString());
          }
        }
      },
      child: const Card(
        elevation: 4,
        child: SizedBox(
            width: AppStyle.cardWidth,
            height: AppStyle.cardHeight,
            child: Center(
              child: Icon(
                Icons.add,
                size: AppStyle.plusIconSize,
                color: Colors.black,
              ),
            )),
      ),
    );
  }
}

class AddDialog extends StatefulWidget {
  const AddDialog({super.key});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 400,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller,
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop("");
              },
              child: Text("取消")),
          TextButton(
              onPressed: () async {
                Navigator.of(context).pop(controller.text);
              },
              child: Text("确定"))
        ],
      ),
    );
  }
}
