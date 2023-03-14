import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallpaper_manager/routers.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMaxSize(const Size(1280, 720));
    setWindowMinSize(const Size(1280, 720));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routers.routers,
      initialRoute: Routers.splashScreen,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}
