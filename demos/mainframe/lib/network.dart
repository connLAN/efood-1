// this page should includes: custom app bar, custom name

import 'package:flutter/material.dart';
import 'help.dart';

class NetworkSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Settings'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              handleHelpAction(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
            'This is the network settings page. Configure your network settings here.'),
      ),
    );
  }
}

class NetworkLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Log'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              handleHelpAction(context);
            },
          ),
        ],
      ),
      body: Center(
        child:
            Text('This is the network log page. View your network logs here.'),
      ),
    );
  }
}

class NetworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              handleHelpAction(context);
            },
          ),
        ],
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
                      builder: (context) => NetworkSettingsPage()),
                );
              },
              child: Text('Go to Network Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NetworkLogPage()),
                );
              },
              child: Text('Go to Network Log'),
            ),
          ],
        ),
      ),
    );
  }
}

void onNetworkIconClicked(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NetworkPage()),
  );
}
