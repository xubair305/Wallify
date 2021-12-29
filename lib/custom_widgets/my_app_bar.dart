import 'package:flutter/material.dart';
import 'package:wallify/constants/app_colors.dart';
import 'package:wallify/constants/app_text.dart';

PreferredSizeWidget myAppBar(BuildContext context) {
  return AppBar(
   
    title: Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          text: "Walli",
          color: Kolors.black,
          size: 24,
        ),
        AppText(
          text: "fy",
          color: Kolors.blue,
          size: 24,
          fontWeight: FontWeight.bold,
        ),
      ],
    ),
    backgroundColor: Kolors.white,
    elevation: 0.0,
  );
}
