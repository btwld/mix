import 'package:flutter/material.dart';
import 'package:remix/remix.dart' hide Scaffold;

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
              RxAvatar(
                label: 'CA',
              ),
              const RxAvatar.raw(
                image: NetworkImage('https://i.pravatar.cc/150?img=48'),
                child: Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
