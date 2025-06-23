import 'package:flutter/material.dart';

Widget highlightsWidget() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        SizedBox(height: 4),
        Text('Highlights'),
      ],
    ),
  );
}