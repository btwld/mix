import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              RxTooltip(
                tooltipChild: Text(
                  'This is a tooltip',
                  style: TextStyle(color: Colors.white),
                ),
                child: Text('Hello'),
              ),
              Tooltip(
                message: 'This is a tooltip',
                child: Text('Hello Mate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
