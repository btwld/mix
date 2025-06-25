import 'package:flutter/material.dart';
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
              RxAvatar(
                label: 'CA',
                backgroundImage:
                    const NetworkImage('https://i.pravatar.cc/150?img=48'),
              ),
              RxAvatar(
                label: 'CA',
                foregroundImage:
                    const NetworkImage('https://i.pravatar.cc/150?img=48'),
              ),
              const RxAvatar.raw(
                foregroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=48'),
                child: Icon(Icons.person),
              ),
              const RxAvatar.raw(
                backgroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=48'),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
