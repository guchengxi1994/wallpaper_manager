import 'package:flutter/material.dart';
import 'screens/splash/spash_screen.dart';
import 'screens/wallpaper/management_screen.dart' deferred as main;
import 'future_builder.dart';

class Routers {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static String mainScreen = "/mainScreen";
  static String splashScreen = "/splashScreen";
  static Map<String, WidgetBuilder> routers = {
    mainScreen: (context) => FutureLoaderWidget(
        builder: (context) => main.WallpaperManagerScreen(),
        loadWidgetFuture: main.loadLibrary()),
    splashScreen: (context) => const SplashPage()
  };
}
