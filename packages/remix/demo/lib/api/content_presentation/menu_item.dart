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
          child: RxMenuItem(
            title: 'Menu Item',
            subtitle: 'Subtitle',
            leading: CircleAvatar(
              child: Text('LF'),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
