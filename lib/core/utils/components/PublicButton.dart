import 'package:flutter/material.dart';

class PublicButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback function;
  final double width;
  final double height;
  final double borderRadius;
  final String text;

  const PublicButton({
    Key? key,
    required this.backgroundColor,
    required this.function,
    this.width = double.infinity,
    required this.text,
    this.borderRadius = 5,
    this.height = 52,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        height: height,
        color: backgroundColor,
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
