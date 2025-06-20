import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              RxButton(
                label: 'Click Me',
                onPressed: () {
                  log('Button pressed!');
                },
                style: RxButtonStyle()
                  ..container.color.black()
                  ..container.animated.linear(100.ms)
                  ..on.hover(
                    RxButtonStyle()
                      ..container.color.grey.shade800()
                      ..textStyle.color.white(),
                  ),
              ),
              RxButton.icon(
                Icons.add,
                onPressed: () {
                  log('Button pressed!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
