import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

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
  String? _statusMessage;
  String? _defaultDir;
  String? _selectedPath;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _setDefaultDir();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // Permission granted, proceed with file operations
    } else {
      // Handle the case where the user denies the permission
      setState(() {
        _statusMessage = 'Storage permission denied';
      });
    }
  }

  Future<void> _setDefaultDir() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _defaultDir = directory.path;
    });
  }

  Future<void> _selectFileOrDir() async {
    if (await Permission.storage.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
        allowCompression: false,
        withData: false,
        withReadStream: false,
      );

      if (result != null) {
        setState(() {
          _selectedPath = result.files.single.path;
        });
      }
    } else {
      setState(() {
        _statusMessage = 'Storage permission denied';
      });
    }
  }

  Future<void> _processSubdirectory() async {
    if (_selectedPath == null) return;

    final subDir = Directory(_selectedPath!);
    if (!await subDir.exists()) {
      setState(() {
        _statusMessage = 'Selected path does not exist';
      });
      return;
    }

    final files = subDir.listSync();
    for (var file in files) {
      if (file is File) {
        List<int> bytes = await file.readAsBytes();
        List<int> mixedBytes = bytes.map((byte) => byte ^ 0xFF).toList();
        await file.writeAsBytes(mixedBytes);
      }
    }

    setState(() {
      _statusMessage = 'Processed ${files.length} files in subdir';
    });
  }

  Future<void> _mixOrRemixFile() async {
    if (_selectedPath == null) return;

    final file = File(_selectedPath!);
    if (!await file.exists()) {
      setState(() {
        _statusMessage = 'Selected file does not exist';
      });
      return;
    }

    List<int> bytes = await file.readAsBytes();
    List<int> mixedBytes = bytes.map((byte) => byte ^ 0xFF).toList();
    await file.writeAsBytes(mixedBytes);

    setState(() {
      _statusMessage = 'File processed successfully';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Mixer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Default Directory:'),
            SizedBox(height: 8),
            Text(_defaultDir ?? 'Loading...'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectFileOrDir,
              child: Text('Select File or Directory'),
            ),
            SizedBox(height: 8),
            Text(_selectedPath ?? 'No file or directory selected'),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _mixOrRemixFile,
                  child: Text('Mix/Re-mix File'),
                ),
                ElevatedButton(
                  onPressed: _processSubdirectory,
                  child: Text('Process Subdirectory'),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_statusMessage != null) Text(_statusMessage!),
          ],
        ),
      ),
    );
  }
}