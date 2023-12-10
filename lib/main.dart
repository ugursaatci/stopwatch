import 'package:flutter/material.dart';
import 'stopwatch.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StopwatchApp(),
        ),
      ),
    );
  }
}