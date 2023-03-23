// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager/app_style.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/screens/wallpaper/wallpaper_controller.dart';
import 'package:wallpaper_manager/utils.dart';

class AddOneImageCard extends StatelessWidget {
  const AddOneImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DialogResponse? s = await showGeneralDialog(
            context: context,
            pageBuilder: (c, f, s) {
              return const Center(
                child: AddDialog(),
              );
            });
        debugPrint(s.toString());
        if (s == null) {
          return;
        }
        if (s.type == "gallery" && s.name != "") {
          final res = await api.createNewGallery(s: s.name.toString());
          if (res != 0 || res != -1) {
            await context.read<WallpaperController>().init();
          } else {
            debugPrint(res.toString());
          }
          return;
        }

        if (s.type == "file" && s.name != "") {
          if (s.imageType == "file") {
            await context.read<WallpaperController>().addNewImage(s.name);
            return;
          }
        }

        if (s.type == "file" && s.name != "") {
          if (s.imageType == "url") {
            debugPrint("[flutter] down load ${s.name}");
            // 下载文件到cache文件夹
            final r = await api.downloadFile(
                url: s.name, savePath: "${DevUtils.executableDir.path}/cache");
            if (r != "") {
              await context.read<WallpaperController>().addNewImage(r);
            }
            return;
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
  final TextEditingController controller2 = TextEditingController();

  final String newFolder = "新建Gallery";
  final String newFile = "导入图片";
  late String groupString = newFolder;

  late double folderHeight = 150;
  late double fileHeight = 185;

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(groupString);
    return Container(
      // padding: const EdgeInsets.all(10),
      width: 400,
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
                    Navigator.of(context).pop(null);
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
          Visibility(
              visible: groupString == newFolder,
              child: Row(
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
                    width: 260,
                    height: 30,
                    child: TextField(
                      style: const TextStyle(fontSize: 14),
                      controller: controller,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 15),
                        hintText: "输入Gallery名",
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              )),
          _newImage(groupString == newFile),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () async {
                    DialogResponse response = DialogResponse(
                        name: groupString == newFolder
                            ? controller.text
                            : fromNotifier.value == url
                                ? controller2.text
                                : selectedFileName,
                        type: groupString == newFolder ? "gallery" : "file",
                        imageType: fromNotifier.value == url ? "url" : "file");
                    Navigator.of(context).pop(response);
                  },
                  child: const Text("确定")),
            ],
          )
        ],
      ),
    );
  }

  final padding = const EdgeInsets.only(left: 5, bottom: 4);

  static const local = "本地图片";
  static const url = "网络图片";

  ValueNotifier<String> fromNotifier = ValueNotifier(local);

  String selectedFileName = "";

  Widget _newImage(bool visiable) {
    return Visibility(
      visible: visiable,
      child: Row(
        children: [
          const SizedBox(
            width: 25,
          ),
          ValueListenableBuilder(
              valueListenable: fromNotifier,
              builder: (ctx, val, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            fromNotifier.value = local;
                          },
                          child: Chip(
                            label: const Text(local),
                            backgroundColor: fromNotifier.value == local
                                ? const Color.fromARGB(255, 122, 210, 225)
                                : Colors.grey[200],
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            fromNotifier.value = url;
                          },
                          child: Chip(
                            label: const Text(url),
                            backgroundColor: fromNotifier.value == url
                                ? const Color.fromARGB(255, 122, 210, 225)
                                : Colors.grey[200],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: fromNotifier.value == local,
                        child: Row(
                          children: [
                            Container(
                              // padding: padding,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 218, 223, 229)),
                                  borderRadius: BorderRadius.circular(5)),
                              width: 260,
                              height: 30,
                              child: Text(
                                selectedFileName,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  File file = File(result.files.single.path!);

                                  setState(() {
                                    selectedFileName = file.path;
                                  });
                                }
                              },
                              child: const MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Icon(Icons.file_open_outlined),
                              ),
                            )
                          ],
                        )),
                    Visibility(
                        visible: fromNotifier.value == url,
                        child: Row(
                          children: [
                            Container(
                              padding: padding,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 218, 223, 229)),
                                  borderRadius: BorderRadius.circular(5)),
                              width: 260,
                              height: 30,
                              child: TextField(
                                maxLines: 1,
                                minLines: 1,
                                style: const TextStyle(fontSize: 14),
                                controller: controller2,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 15),
                                  hintText: "输入Url",
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                );
              })
        ],
      ),
    );
  }
}

class DialogResponse {
  final String name;
  final String type;
  final String imageType;
  DialogResponse(
      {required this.name, required this.type, required this.imageType});

  @override
  String toString() {
    return "name:$name  type:$type  imageType:$imageType";
  }
}
