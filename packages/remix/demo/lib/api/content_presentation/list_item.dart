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
        body: ListView.builder(
          itemCount: null,
          itemBuilder: (context, index) {
            return RxListItem(
              title: 'Item $index',
              subtitle: 'Subtitle for item $index',
              leading: CircleAvatar(
                child: Text(index.toString().padLeft(2, '0')),
              ),
              trailing: const Icon(Icons.chevron_right),
            );
          },
        ),
      ),
    );
  }
}
