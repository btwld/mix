import 'package:flutter/material.dart';

class _ExampleApp extends StatelessWidget {
  const _ExampleApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }
}

void runMixApp(Widget child) {
  runApp(_ExampleApp(child: child));
}
