import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:wallpaper_manager/bridge/native.dart';

class WallpaperController extends ChangeNotifier {
  List<WallPaper> images = [];
  init() async {
    images = await api.getAllPapers();
    notifyListeners();
  }

  Future deleteImage(WallPaper i) async {
    final r = await api.deletePaperById(i: i.wallPaperId);
    if (r == -1) {
      SmartDialog.showToast("删除失败");
    } else {
      images.remove(i);
      notifyListeners();
    }
  }

  Future setIsFav(WallPaper paper) async {
    final result =
        await api.setIsFavById(i: paper.wallPaperId, isFav: 1 - paper.isFav);
    if (result == -1) {
      SmartDialog.showToast("修改失败");
    } else {
      // paper.isFav = 1 - paper.isFav;
      WallPaper newPaper = WallPaper(
          wallPaperId: paper.wallPaperId,
          filePath: paper.filePath,
          fileHash: paper.fileHash,
          createAt: paper.createAt,
          isDeleted: paper.isDeleted,
          isFav: 1 - paper.isFav);

      final index = images.indexOf(paper);
      images[index] = newPaper;
      notifyListeners();
    }
  }

  Future addNewImage(String s) async {
    final result = await api.newPaper(s: s);
    if (result == 1) {
      SmartDialog.showToast("已存在相同文件");
    } else if (result == -1) {
      SmartDialog.showToast("添加失败");
    } else {
      WallPaper? p = await api.getPaperById(i: result);
      if (p != null) {
        images.add(p);
        notifyListeners();
      }
    }
  }
}
