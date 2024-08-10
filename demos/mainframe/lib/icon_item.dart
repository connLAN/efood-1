import 'package:flutter/material.dart';

Widget createIconItem(Widget icon, String label, Color color,
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
