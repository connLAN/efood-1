import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(FileMixerApp());
}

class FileMixerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileMixerHomePage(),
    );
  }
}

class FileMixerHomePage extends StatefulWidget {
  @override
  _FileMixerHomePageState createState() => _FileMixerHomePageState();
}

class _FileMixerHomePageState extends State<FileMixerHomePage> {
  String? _filePath;
  String? _statusMessage;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        _statusMessage = 'File selected: ${result.files.single.name}';
      });
    }
  }

  Future<void> _mixFile() async {
    if (_filePath == null) return;
    File file = File(_filePath!);
    List<int> bytes = await file.readAsBytes();
    List<int> mixedBytes = bytes.map((byte) => byte ^ 0xFF).toList();
    await file.writeAsBytes(mixedBytes);
    setState(() {
      _statusMessage = 'File mixed successfully';
    });
  }

  Future<void> _remixFile() async {
    if (_filePath == null) return;
    File file = File(_filePath!);
    List<int> bytes = await file.readAsBytes();
    List<int> remixedBytes = bytes.map((byte) => byte ^ 0xFF).toList();
    await file.writeAsBytes(remixedBytes);
    setState(() {
      _statusMessage = 'File re-mixed successfully';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Mixer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick File'),
            ),
            ElevatedButton(
              onPressed: _mixFile,
              child: Text('Mix File'),
            ),
            ElevatedButton(
              onPressed: _remixFile,
              child: Text('Re-mix File'),
            ),
            if (_statusMessage != null) Text(_statusMessage!),
          ],
        ),
      ),
    );
  }
}