import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui'; // Import for Size

class Config {
  String title;
  Size size;
  Size minimumSize;

  Config({required this.title, required this.size, required this.minimumSize});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      title: json['title'],
      size: Size(json['size']['width'], json['size']['height']),
      minimumSize:
          Size(json['minimumSize']['width'], json['minimumSize']['height']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'size': {'width': size.width, 'height': size.height},
      'minimumSize': {'width': minimumSize.width, 'height': minimumSize.height},
    };
  }
}

Future<Config> loadConfig() async {
  final configString = await rootBundle.loadString('assets/config.json');
  final configJson = json.decode(configString);
  return Config.fromJson(configJson);
}

Future<void> saveConfig(Config config) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/config.json');
  final configJson = json.encode(config.toJson());
  await file.writeAsString(configJson);
}
