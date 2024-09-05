import 'package:flutter/material.dart';
import 'new_page.dart'; // Ensure this import is present
import 'dinning_table.dart'; // Ensure this import is present

String getFunctionName() {
  try {
    throw Exception();
  } catch (e, stackTrace) {
    var traceString = stackTrace.toString().split('\n')[1];
    var functionName = traceString.split(' ')[3];
    return functionName;
  }
}

void handlePressed(BuildContext context) {
  print('Icon pressed');
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
    MaterialPageRoute(
      builder: (context) => DinningTablesPage(
          // groupedMenuItems: {}, // Provide appropriate data
          // menu: [], // Provide appropriate data
          ),
    ),
  );
}

// // Placeholder for NewPage class
// class NewPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('New Page'),
//       ),
//       body: Center(
//         child: Text('This is a new page'),
//       ),
//     );
//   }
// }
