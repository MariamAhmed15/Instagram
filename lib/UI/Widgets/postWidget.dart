import 'package:flutter/material.dart';

Widget postWidget (){
  return   GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
    ),
    itemCount:9,
    itemBuilder: (context, index) {
      return Container(
        color: Colors.grey[300],
        child: Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTc9APxkj0xClmrU3PpMZglHQkx446nQPG6lA&s',
          fit: BoxFit.cover,
        ),
      );
    },
  );
}