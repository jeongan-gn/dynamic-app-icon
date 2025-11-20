import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_dynamic/flutter_icon_dynamic.dart';
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
  final _flutterIconDynamicPlugin = FlutterIconDynamic();
  final List<String> appIconList = AppIcon.values.map((e) => e.iconName!).toList();

  @override
  void initState() {
    super.initState();
  }

  void changeAppIcon(AppIcon icon) async {
    try {
      final isSupported = await _flutterIconDynamicPlugin.isSupported;
      if (isSupported == true) {
        await _flutterIconDynamicPlugin.setIcon(icon.iconName!, androidIcons: appIconList);
        setState(() {
          currentIcon = icon;
        });
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
  defaultIcon('DefaultIcon'),
  blueIcon('BlueIcon'),
  yellowIcon('YellowIcon'),
  redIcon('RedIcon');

  final String? rawName;
  const AppIcon(this.rawName);

  String? get iconName {
    if (Platform.isAndroid) {
      return 'appicon.$rawName';
    }
    return rawName;
  }
}
