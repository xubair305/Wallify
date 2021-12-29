import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  double size;
  final String text;
  final Color? color;
  final String fontFamily;
  final double? height;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  AppText({
    Key? key,
    required this.text,
    this.size = 16,
    this.height,
    this.color,
    this.fontFamily = "Poppins",
    this.fontWeight,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        height: height,
      ),
    );
  }
}
