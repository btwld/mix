import 'package:flutter/material.dart';

class _ExampleApp extends StatelessWidget {
  final Widget child;
  const _ExampleApp({required this.child});

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
