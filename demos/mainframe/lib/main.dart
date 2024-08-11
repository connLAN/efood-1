import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'icons_page.dart'; // Import the IconsPage
import 'utils.dart'; // Import utility functions
import 'clock.dart'; // Import the Clock widget
import 'dinning-table.dart'; // Import the DinningTablesPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    title: 'My App',
    size: Size(1024, 768),
    minimumSize: Size(800, 600),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Initialize tables
  addTables(30); // Add 10 tables for example

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IconsPage(), // Set IconsPage as the home page
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}
