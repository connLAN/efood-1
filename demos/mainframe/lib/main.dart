import 'package:flutter/material.dart';
import 'new_page.dart'; // Import the new page
import 'clock.dart'; // Import the Clock widget
import 'help.dart'; // Import the HelpPage widget
import 'network.dart'; // Import the NetworkSettingsPage widget
import 'print.dart'; // Import the PrintSettingsPage widget
import 'settings.dart'; // Import the CommonSettingsPage widget

void main() {
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

class IconsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.apple, size: 48.0), // Set the icon size to 48.0
        ),
        title: Clock(), // Replace with the Clock widget
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            iconSize: 48.0, // Set the icon size to 48.0
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.print),
            iconSize: 48.0, // Set the icon size to 48.0
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrintSettingsPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.network_check),
            iconSize: 48.0, // Set the icon size to 48.0
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NetworkSettingsPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 48.0, // Set the icon size to 48.0
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommonSettingsPage(
                          shopName: 'My Shop',
                          bannerImage: 'https://example.com/shop_banner.jpg',
                        )),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double buttonSize = (constraints.maxWidth - 70) /
              8; // Calculate button size based on window width
          return GridView.count(
            crossAxisCount: 8, // 8 icons per line
            crossAxisSpacing: 10.0, // 10 pixels margin between buttons
            mainAxisSpacing: 10.0, // 10 pixels margin between buttons
            padding: EdgeInsets.all(10.0), // Padding around the grid
            children: _generateIconItems(
                context, buttonSize), // Provide the correct number of arguments
          );
        },
      ),
    );
  }

  void onPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPage()),
    );
  }

  void handlePersonOutlinePressed(BuildContext context) {
    print('Person Outline Icon pressed');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPage()),
    );
  }

  List<Widget> _generateIconItems(BuildContext context, double buttonSize) {
    return [
      _createIconItem(Icon(Icons.people, size: buttonSize * 0.4), 'People',
          Colors.lightBlueAccent, () => onPressed(context), buttonSize),
      _createIconItem(
          Icon(Icons.person_outline, size: buttonSize * 0.4),
          'Person Outline',
          Colors.lightGreenAccent,
          () => handlePersonOutlinePressed(context),
          buttonSize),
      _createIconItem(
          Image.asset('assets/dinning-table.jpg',
              width: buttonSize * 0.4, height: buttonSize * 0.4),
          '桌台',
          Color.fromARGB(255, 197, 140, 179),
          () => handlePersonOutlinePressed(context),
          buttonSize),
      _createIconItem(
          Image.asset('assets/crown.jpg',
              width: buttonSize * 0.4, height: buttonSize * 0.4),
          'V.I.P',
          Color.fromARGB(255, 222, 233, 6),
          () => handlePersonOutlinePressed(context),
          buttonSize),
      _createIconItem(Icon(Icons.thumb_up, size: buttonSize * 0.4), 'Thumb Up',
          Colors.cyanAccent, () => onPressed(context), buttonSize),
      _createIconItem(
          Icon(Icons.thumb_down, size: buttonSize * 0.4),
          'Thumb Down',
          Colors.purpleAccent,
          () => onPressed(context),
          buttonSize),
      _createIconItem(Icon(Icons.favorite, size: buttonSize * 0.4), 'Favorite',
          Colors.orangeAccent, () => onPressed(context), buttonSize),
      _createIconItem(
          Icon(Icons.favorite_border, size: buttonSize * 0.4),
          'Favorite Border',
          Colors.redAccent,
          () => onPressed(context),
          buttonSize),
    ];
  }

  Widget _createIconItem(Widget icon, String label, Color color,
      VoidCallback onPressed, double buttonSize) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
        children: [
          Container(
            width: buttonSize,
            height: buttonSize * 0.8, // Reduce the height to avoid overflow
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black), // Rectangular border
              borderRadius:
                  BorderRadius.circular(4.0), // Slightly rounded corners
            ),
            child: icon,
          ),
          SizedBox(height: 4.0),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis, // Handle overflow text
              style: TextStyle(
                fontWeight: FontWeight.bold, // Bold font
                fontSize: 32.0, // Twice the original font size
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IconItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  IconItem({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: Colors.black), // Rectangular border
              borderRadius:
                  BorderRadius.circular(4.0), // Slightly rounded corners
            ),
            child: icon,
          ),
          SizedBox(height: 4.0),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis, // Handle overflow text
              style: TextStyle(
                fontWeight: FontWeight.bold, // Bold font
                fontSize: 32.0, // Twice the original font size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
