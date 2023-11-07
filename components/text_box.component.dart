import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox(
      {super.key,
      required this.color,
      this.textColor = Colors.white,
      required this.text,
      this.radius = 9.0,
      this.width = 90,
      this.height = 45});
  final Color color;
  final Color textColor;
  final String text;
  final double radius;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: color,
      ),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: textColor,
        ),
      )),
    );
  }
}
