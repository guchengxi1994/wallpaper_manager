import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:wallpaper_manager/app_style.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/utils.dart';

class WallpaperController extends ChangeNotifier {
  List<GalleryOrWallpaper> images = [];
  List<WallPaper> favs = [];
  int currentFavId = 0;
  bool setSwitch = false;

  switchAutoWallpaper() async {
    favs = await api.getAllFavs();
    if (favs.isEmpty) {
      SmartDialog.showToast("无图片");
      setSwitch = false;
    } else {
      setSwitch = !setSwitch;
    }

    notifyListeners();
  }

  init() async {
    images = await api.getAllItems();
    favs = await api.getAllFavs();
    // print(images.length);
    notifyListeners();
  }

  Stream switchRandomFavs() async* {
    while (1 == 1) {
      await Future.delayed(
          const Duration(seconds: AppStyle.switchImageDuration));
      if (!setSwitch) {
        continue;
      }

      final currentPaper = favs[currentFavId];

      favs = await api.getAllFavs();
      if (favs.isEmpty) {
        continue;
      }
      final isExist = favs.firstWhere(
          (element) => element.filePath == currentPaper.filePath, orElse: () {
        return WallPaper(
            wallPaperId: -1,
            filePath: "",
            fileHash: "",
            createAt: -1,
            isDeleted: -1,
            isFav: -1);
      });

      if (isExist.wallPaperId == -1) {
        currentFavId = 0;
        await api.setWallPaper(s: favs[currentFavId].filePath);
        continue;
      }

      if (currentFavId == favs.length - 1) {
        currentFavId = 0;
        await api.setWallPaper(s: favs[currentFavId].filePath);
        continue;
      }

      currentFavId = currentFavId + 1;
      await api.setWallPaper(s: favs[currentFavId].filePath);
      continue;
    }
  }

  Future deleteImage(WallPaper i) async {
    final r = await api.deletePaperById(i: i.wallPaperId);
    if (r == -1) {
      SmartDialog.showToast("删除失败");
    } else {
      images.remove(GalleryOrWallpaper.wallPaper(i));
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

      final index = images.indexOf(GalleryOrWallpaper.wallPaper(paper));
      images[index] = GalleryOrWallpaper.wallPaper(newPaper);
      notifyListeners();
    }
  }

  Future<String> getFileType(String s) async {
    final matcher = await DevUtils.match.match(s);
    return matcher?.extension ?? "";
  }

  Future addNewImage(String s) async {
    final matcher = await DevUtils.match.match(s);
    if (matcher == null) {
      SmartDialog.showToast("无法判断文件类型");
      return;
    }

    if (![
      'jpg',
      'jpx',
      'apng',
      'png',
      'gif',
      'webp',
      'tiff',
      'bmp',
      'mp4',
      'm4v',
      'mkv',
      'mov',
      'avi'
    ].contains(matcher.extension)) {
      SmartDialog.showToast("不是支持的类型");
      return;
    }

    final result = await api.newPaper(s: s);
    if (result == 0) {
      SmartDialog.showToast("已存在相同文件");
    } else if (result == -1) {
      SmartDialog.showToast("添加失败");
    } else {
      WallPaper? p = await api.getPaperById(i: result);
      if (p != null) {
        images.add(GalleryOrWallpaper.wallPaper(p));
        notifyListeners();
      }
    }
  }
}
