import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';

import 'dart:developer';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppIcon? currentIcon;

  @override
  void initState() {
    super.initState();
    _loadCurrentIcon();
  }

  Future<void> _loadCurrentIcon() async {
    final iconName = await FlutterDynamicIconPlus.alternateIconName;
    if (mounted) {
      setState(() {
        currentIcon = AppIcon.fromIconName(iconName);
      });
    }
  }

  void changeAppIcon(AppIcon icon) async {
    try {
      final past = await FlutterDynamicIconPlus.alternateIconName;
      if (await FlutterDynamicIconPlus.supportsAlternateIcons) {
        await FlutterDynamicIconPlus.setAlternateIconName(iconName: icon.iconName);
        setState(() {
          currentIcon = icon;
        });

        final changed = await FlutterDynamicIconPlus.alternateIconName;
        log('Icon change requested from $past to $changed');
      }
    } on PlatformException catch (_) {
      log('Failed to change app icon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (AppIcon appIcon in AppIcon.values) ...[
              TextButton(
                  onPressed: () => changeAppIcon(appIcon),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentIcon == appIcon)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      Text('${appIcon.rawName}'),
                    ],
                  )),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
    );
  }
}

enum AppIcon {
  defaultIcon(null), // 기본 아이콘은 null
  blueIcon('icon_blue'),
  yellowIcon('icon_yellow'),
  redIcon('icon_red');

  final String? rawName;
  const AppIcon(this.rawName);

  String? get iconName {
    if (Platform.isIOS) {
      return rawName;
    } else {
      // Android: 점 없이 그대로 반환
      return rawName;
    }
  }

  static AppIcon fromIconName(String? iconName) {
    if (iconName == null) {
      return AppIcon.defaultIcon;
    }

    if (Platform.isIOS) {
      return AppIcon.values.firstWhere(
        (icon) => icon.rawName == iconName,
        orElse: () => AppIcon.defaultIcon,
      );
    } else {
      // Android: 전체 패키지 경로에서 이름 추출
      final parts = iconName.split('.');
      final aliasName = parts.last; // "icon_blue" 또는 "DEFAULT"

      return AppIcon.values.firstWhere(
        (icon) => icon.rawName == aliasName,
        orElse: () => AppIcon.defaultIcon,
      );
    }
  }
}
