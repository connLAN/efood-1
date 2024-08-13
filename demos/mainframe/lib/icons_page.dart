import 'dart:async';
import 'package:flutter/material.dart';
import 'utils.dart'; // Import utility functions
import 'help.dart'; // Import the HelpPage
import 'print_settings.dart'; // Import the PrintSettingsPage
import 'store_settings.dart'; // Import the PrintSettingsPage
import 'network_settings.dart'; // Import the NetworkSettingsPage
import 'settings.dart'; // Import the CommonSettingsPage
import 'dinning_table_settings.dart'; // Import the DiningTableSettingsPage
import 'clock.dart'; // Import the Clock widget

/////////////////////

class IconsPage extends StatefulWidget {
  @override
  _IconsPageState createState() => _IconsPageState();
}

class _IconsPageState extends State<IconsPage> {
  String _currentDateTime = Clock().getCurrentDateTimeInChineseStyle();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = Clock().getCurrentDateTimeInChineseStyle();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(1.0),
          child: SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset(
              'assets/zcm0.jpg',
              fit: BoxFit.contain, // Adjust the fit property as needed
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '招财猫餐饮收银系统',
              style: TextStyle(
                fontSize:
                    32.0, // Set the font size to twice the default size (16.0 * 2)
              ),
            ),
            Text(
              _currentDateTime,
              style: TextStyle(
                fontSize: 16.0, // Set the font size for the date/time text
              ),
            ),
          ],
        ),
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
                          shopName: '招财猫3',
                          bannerImage: 'assets/3.jpg',
                        )),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double buttonSize = (constraints.maxWidth - 70) /
              6; // Calculate button size based on window width
          return GridView.count(
            crossAxisCount: 6, // 6 icons per line
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

  List<Widget> _generateIconItems(BuildContext context, double buttonSize) {
    return [
      _createIconItem(
          Icon(Icons.restaurant, size: buttonSize * 0.4),
          '门店信息',
          Colors.lightBlueAccent,
          () => onPressed(context),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoreSettingsPage()),
              ),
          buttonSize),
      _createIconItem(
          Icon(Icons.local_dining, size: buttonSize * 0.4),
          'local_dining',
          Colors.lightGreenAccent,
          () => handlePersonOutlinePressed(context),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NetworkSettingsPage()),
              ),
          buttonSize),
      _createIconItem(
          Image(
              image: AssetImage('assets/dinning-table.jpg'),
              width: buttonSize * 0.4,
              height: buttonSize * 0.4),
          '桌台',
          Color.fromARGB(255, 197, 140, 179),
          () => handleDinningTablePressed(context),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DinningTableSettingsPage()),
              ),
          buttonSize),
      _createIconItem(
          Image(
              image: AssetImage('assets/crown.jpg'),
              width: buttonSize * 0.4,
              height: buttonSize * 0.4),
          'V.I.P',
          Color.fromARGB(255, 222, 233, 6),
          () => handlePersonOutlinePressed(context),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              ),
          buttonSize),
      _createIconItem(
          Icon(Icons.thumb_up, size: buttonSize * 0.4),
          'Thumb Up',
          Colors.cyanAccent,
          () => onPressed(context),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrintSettingsPage()),
              ),
          buttonSize),
      _createIconItem(
          Icon(Icons.thumb_down, size: buttonSize * 0.4),
          'Thumb Down',
          Colors.purpleAccent,
          () => onPressed(context),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NetworkSettingsPage()),
              ),
          buttonSize),
      _createIconItem(
          Icon(Icons.favorite, size: buttonSize * 0.4),
          'Favorite',
          Colors.orangeAccent,
          () => onPressed(context),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NetworkSettingsPage()),
              ),
          buttonSize),
      _createIconItem(
          Icon(Icons.favorite_border, size: buttonSize * 0.4),
          'Favorite Border',
          const Color.fromARGB(255, 64, 106, 169),
          () => onPressed(context),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NetworkSettingsPage()),
              ),
          buttonSize),
    ];
  }

  Widget _createIconItem(Widget icon, String label, Color color,
      VoidCallback onPressed, VoidCallback onRightClick, double buttonSize) {
    return GestureDetector(
      onTap: onPressed,
      onSecondaryTap: onRightClick,
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
                fontSize: 16.0, // Adjusted font size for better fit
              ),
            ),
          ),
        ],
      ),
    );
  }
}
