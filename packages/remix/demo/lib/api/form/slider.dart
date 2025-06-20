import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _value = 0.5;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 200,
            child: RxSlider(
              value: _value,
              style: RxSliderStyle(),
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
