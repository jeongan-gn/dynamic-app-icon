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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  AppIcon? appliedIcon;
  AppIcon? selectedIcon;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCurrentIcon();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadCurrentIcon();
    }
  }

  Future<void> _loadCurrentIcon() async {
    final String? activeIconName = await FlutterDynamicIconPlus.alternateIconName;

    setState(() {
      appliedIcon = AppIcon.values.firstWhere(
        (icon) => icon.iconName == activeIconName,
        orElse: () => AppIcon.defaultIcon,
      );
    });
  }

  void changeAppIcon(AppIcon icon) async {
    try {
      if (await FlutterDynamicIconPlus.supportsAlternateIcons) {
        await FlutterDynamicIconPlus.setAlternateIconName(
          iconName: icon.iconName,
        );
        setState(() => selectedIcon = icon);
        if (mounted && Platform.isAndroid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('앱을 다시 시작하면 새로운 아이콘이 적용됩니다.'),
            ),
          );
        }
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
            Text('current icon: ${appliedIcon?.iconName ?? 'DefaultIcon'}'),
            for (AppIcon appIcon in AppIcon.values) ...[
              TextButton(
                  onPressed: () => changeAppIcon(appIcon),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (selectedIcon == appIcon)
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
      return this == defaultIcon ? null : 'appicon.$rawName';
    }
    return this == defaultIcon ? null : rawName;
  }
}
