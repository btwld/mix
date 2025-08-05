import 'package:flutter/material.dart';

import 'box_spec.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Text('Hello World'),
          ),
        ),
      ),
    );
  }
}

// Example of using the generated BoxSpec
final myBoxSpec = BoxSpec(
  width: 100,
  height: 100,
  color: Colors.red,
  alignment: Alignment.center,
);

final anotherBoxSpec = myBoxSpec.copyWith(color: Colors.green);
