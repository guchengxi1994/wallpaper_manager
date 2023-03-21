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

  final String newFolder = "新建Gallery";
  final String newFile = "导入图片";
  late String groupString = newFolder;

  late double folderHeight = 150;
  late double fileHeight = 400;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(groupString);
    return Container(
      // padding: const EdgeInsets.all(10),
      width: 500,
      height: groupString == newFolder ? folderHeight : fileHeight,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 193, 196, 198),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            height: 30,
            child: Row(
              children: [
                const Text("添加..."),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop("");
                  },
                  child: const Icon(Icons.close),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Radio<String>(
                value: newFolder,
                groupValue: groupString,
                onChanged: (value) {
                  setState(() {
                    groupString = value!;
                  });
                },
              ),
              Text(newFolder),
              const SizedBox(
                width: 30,
              ),
              Radio<String>(
                value: newFile,
                groupValue: groupString,
                onChanged: (value) {
                  setState(() {
                    groupString = value!;
                  });
                },
              ),
              Text(newFile),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 25,
              ),
              Container(
                padding: padding,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 218, 223, 229)),
                    borderRadius: BorderRadius.circular(5)),
                width: 160,
                height: 27,
                child: TextField(
                  style: const TextStyle(fontSize: 12),
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "输入Gallery名",
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(controller.text);
                  },
                  child: const Text("确定")),
            ],
          )
        ],
      ),
    );
  }

  final padding = const EdgeInsets.only(left: 5, bottom: 4);
}
