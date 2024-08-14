import 'package:flutter/material.dart';
import 'icons_page.dart'; // Import the IconsPage class
import 'dinning_table.dart'; // Import the DinningTablesPage class
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

void handleEmployeePressed(BuildContext context) {
  print('Employee Icon pressed');
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
