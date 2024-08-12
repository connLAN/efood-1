import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'config_manager.dart';

void main() {
  runApp(MyApp(config: Config(title: 'My App', size: Size(300, 600))));
}

class Config {
  final String title;
  final Size size;

  Config({required this.title, required this.size});

  Map<String, dynamic> toJson() => {
        'title': title,
        'size': {
          'width': size.width,
          'height': size.height,
        },
      };
}

class MyApp extends StatefulWidget {
  final Config config;

  MyApp({required this.config});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Config _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
    print('Config loaded: ${_config.title}');
  }

  void updateConfig(Config newConfig) {
    setState(() {
      _config = newConfig;
      print('Config updated: ${_config.title}');
      saveConfig();
    });
  }

  void saveConfig() async {
    final file = File('assets/config.json');
    final jsonConfig = jsonEncode(_config.toJson());
    await file.writeAsString(jsonConfig);
    print('Config saved: ${_config.title}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _config.title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_config.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Window size: ${_config.size.width} x ${_config.size.height}'),
              ElevatedButton(
                onPressed: () {
                  updateConfig(
                      Config(title: 'Updated App', size: Size(400, 800)));
                },
                child: Text('Update Config'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
