// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/utils.dart';

class SubProcessController extends ChangeNotifier {
  late final playerPath;
  late int playerPid = -1;

  init() {
    if (Platform.isWindows) {
      playerPath = "${DevUtils.executableDir.path}/player/player.exe";
    } else {
      /// TODO
      playerPath = "";
    }

    var f = File(playerPath);

    if (!f.existsSync()) {
      return;
    }
  }

  run({String? videoPath}) async {
    if (playerPid != -1) {
      return;
    }

    if (playerPath == "") {
      return;
    }
    try {
      final screenParams = await api.getScreenSize();
      final process = await Process.start(playerPath, [
        "--video_path",
        r"C:\Users\xiaoshuyui\Desktop\不常用的东西\result_voice.mp4",
        "--width",
        "400",
        "--height",
        "300",
      ]);
      playerPid = process.pid;
    } catch (_) {
      SmartDialog.showToast("失败");
    }
  }

  killProcess() {
    if (playerPid != -1) {
      Process.killPid(playerPid);
    }
  }
}
