import 'package:flutter/material.dart';

// DinningTableSettingsPage widget
class DinningTableSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DinningTable Settings'),
      ),
      body: Center(
        child: Text(
            'This is the dinningtable settings page. Configure your dinningtable settings here.'),
      ),
    );
  }
}

// DinningTableLogPage widget
class DinningTableLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DinningTable Log'),
      ),
      body: Center(
        child: Text(
            'This is the dinningtable log page. View your dinningtable logs here.'),
      ),
    );
  }
}

// MainPage widget with navigation buttons
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DinningTableSettingsPage()),
                );
              },
              child: Text('Go to DinningTable Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DinningTableLogPage()),
                );
              },
              child: Text('Go to DinningTable Log'),
            ),
          ],
        ),
      ),
    );
  }
}

// Callback function to navigate to DinningTableSettingsPage
void onDinningTableIconClicked(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DinningTableSettingsPage()),
  );
}

// Function to handle dinningtable action
void handleDinningTableAction(BuildContext context) {
  onDinningTableIconClicked(context);
}

// Callback function to navigate to DinningTableLogPage
void onDinningTableLogIconClicked(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DinningTableLogPage()),
  );
}
