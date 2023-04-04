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

  run({required String videoPath}) async {
    if (playerPid != -1) {
      killProcess();
    }

    if (playerPath == "") {
      SmartDialog.showToast("播放器不存在");
      return;
    }
    try {
      final screenParams = await api.getScreenSize();
      final process = await Process.start(playerPath, [
        "--video_path",
        videoPath,
        "--width",
        screenParams.width.toString(),
        "--height",
        screenParams.height.toString(),
      ]);
      playerPid = process.pid;
      debugPrint("[flutter-player-pid]:$playerPid");
    } catch (_) {
      SmartDialog.showToast("失败");
    }
  }

  watchVideo({required String videoPath}) async {
    if (playerPid != -1) {
      killProcess();
    }

    if (playerPath == "") {
      SmartDialog.showToast("播放器不存在");
      return;
    }
    try {
      final process = await Process.run(playerPath, [
        "--video_path",
        videoPath,
        "--width",
        "800",
        "--height",
        "600",
        "--show_border",
        "true"
      ]);
      playerPid = process.pid;
      debugPrint("[flutter-player-pid]:$playerPid");
    } catch (_) {
      SmartDialog.showToast("失败");
    }
  }

  killProcess() {
    if (playerPid != -1) {
      Process.killPid(playerPid);
      playerPid = -1;
    }
  }
}
