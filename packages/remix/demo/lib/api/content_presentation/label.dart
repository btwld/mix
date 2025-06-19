import 'package:flutter/material.dart';
import 'package:remix/remix.dart' hide Scaffold;

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
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              RxLabel(
                'Remix is awesome!',
                icon: Icons.music_note,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
