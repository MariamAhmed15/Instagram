import 'package:flutter/material.dart';

Widget numbersWidget(String number, String label) {
  return Column(
    children: [
      Text(
        number,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );
}