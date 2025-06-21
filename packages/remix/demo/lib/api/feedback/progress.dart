import 'package:flutter/material.dart';
import 'package:remix/remix.dart' hide Scaffold;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RxProgress(
            value: 0.3,
            style: RxProgressStyle()..container.width(200),
          ),
        ),
      ),
    );
  }
}
