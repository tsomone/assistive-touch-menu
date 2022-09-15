import 'dart:developer';

import 'package:assistive_touch_menu/assistive_touch_menu.dart';
import 'package:example/assistant_menu.dart';
import 'package:example/test_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTheme appTheme = AppTheme();

  @override
  void initState() {
    super.initState();
    appTheme.addListener(() {
      log('theme changed');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size overlaySize = const Size(60, 60);

    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: AssistiveTouchMenu(
        overlayChild: AssistantMenu(
          overlaySize:
              overlaySize, // TODO get size from child widget using render object
          onChange: () {
            appTheme.switchTheme();
          },
        ),
        overlaySize:
            overlaySize, // TODO get size from child widget using render object
        child: MaterialApp(
          // showPerformanceOverlay: true,
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: appTheme.currentTheme(),
          home: const TestPage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class AppTheme with ChangeNotifier {
  static bool _isDark = false;

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  // static final dark = ThemeData(
  //   scaffoldBackgroundColor: Colors.grey.shade900,
  //   colorScheme: const ColorScheme.dark(),
  // );

  // static final light = ThemeData(
  //   scaffoldBackgroundColor: Colors.white,
  //   colorScheme: const ColorScheme.light(),
  // );
}
