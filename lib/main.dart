import 'package:flutter/material.dart';
import 'package:wallify/themes/themes.dart';
import 'package:wallify/views/home/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallify',

      // theme: Themes.lightTheme,
      // darkTheme: Themes.darkTheme,
      home: HomeView(),
    );
  }
}
