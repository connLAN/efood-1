import 'package:flutter/material.dart';
import 'icons_page.dart'; // Import the IconsPage class
import 'dinning-table.dart'; // Import the DinningTablesPage class
import 'new_page.dart'; // Import the NewPage class

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

void handleDinningTablePressed(BuildContext context) {
  print('Dinning Table Icon pressed');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DinningTablesPage()),
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
        () => handleDinningTablePressed(context),
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
              fontSize: 16.0, // Adjusted font size for better fit
            ),
          ),
        ),
      ],
    ),
  );
}
