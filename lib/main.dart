import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:refrigerator/Screens/quit_screen.dart';
import 'package:refrigerator/screens/ending_screen.dart';

import 'package:refrigerator/screens/home_screen.dart';
import 'package:refrigerator/screens/reference_screen.dart';
import 'package:refrigerator/screens/room4b_screen.dart';
import 'package:refrigerator/screens/start_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
          StartScreen.routeName: (ctx) => StartScreen(),
          EndingScreen.routeName: (ctx) => const EndingScreen(),
          QuitScreen.routeName: (ctx) => QuitScreen(),
          ReferenceScreen.routeName: (ctx) => ReferenceScreen(),
          Room4bScreen.routeName: (ctx) => const Room4bScreen(),
        });
  }
}
