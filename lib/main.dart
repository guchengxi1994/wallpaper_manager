import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_manager/bridge/native.dart';
import 'package:wallpaper_manager/routers.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:wallpaper_manager/utils.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';

import 'screens/wallpaper/sub_process_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await api.setJsonPath(s: "${DevUtils.executableDir.path}/struct.json");
  await api.setDbPath(s: "${DevUtils.executableDir.path}/data.db");

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      minimumSize: Size(1280, 720),
      maximumSize: Size(1280, 720),
      center: false,
      // backgroundColor: Colors.transparent,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    await trayManager.setIcon(
      Platform.isWindows
          ? 'asset/icons/tray_icon.ico'
          : 'asset/icons/tray_icon.png',
    );
    List<MenuItem> items = [
      MenuItem(
        key: 'show_window',
        label: 'Show Window',
        onClick: (menuItem) async {
          await windowManager.maximize();
        },
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'hide_window',
        label: 'Hide Window',
        onClick: (menuItem) async {
          await windowManager.minimize();
        },
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'exit_app',
        label: 'Exit App',
        onClick: (menuItem) async {
          await trayManager.destroy();
          exit(0);
        },
      ),
    ];

    await trayManager.setContextMenu(Menu(items: items));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubProcessController()..init()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: Routers.routers,
          initialRoute: Routers.splashScreen,
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
        );
      },
    );
  }
}
