import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:remix/remix.dart' hide Scaffold;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              RxChip(
                label: 'Click Me',
                selected: selected,
                onChanged: (value) {
                  setState(() {
                    selected = value;
                  });
                },
                iconRight: Icons.add,
                style: RxChipStyle(),
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
