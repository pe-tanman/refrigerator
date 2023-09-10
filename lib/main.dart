import 'package:flutter/material.dart';
import 'package:refrigerator/Screen/home_screen.dart';
import 'package:refrigerator/Screen/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Refrigerator',
        theme: ThemeData(
          fontFamily: "NotoSansJP",
          colorScheme: ColorScheme.light(
            primary: Colors.lightBlue.shade300,
          ),
        ),
        home: StartScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
        });
  }
}
