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

enum Options {
  banana,
  apple,
  orange,
}

class _MyAppState extends State<MyApp> {
  Options? _value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RxRadioGroup(
            value: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
            child: const Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RxRadio(
                  label: 'Banana',
                  value: Options.banana,
                ),
                RxRadio(
                  label: 'Apple',
                  value: Options.apple,
                ),
                RxRadio(
                  label: 'Orange',
                  value: Options.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
