import 'dart:math';

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
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: 300,
            child: RxAccordion(
              defaultTrailingIcon: Icons.keyboard_arrow_down_rounded,
              style: RxAccordionStyle()
                ..itemContainer.animated.ease(200.ms)
                ..trailingIcon.wrap.transform(Matrix4.identity())
                ..trailingIcon.animated.ease(200.ms)
                ..on.selected(
                  RxAccordionStyle()
                    ..itemContainer.color.grey.shade50()
                    ..trailingIcon.wrap.transform(Matrix4.rotationZ(pi)),
                ),
              children: [
                RxAccordionItem(
                  title: 'Section 1',
                  value: 'section1',
                  child: const Text('Content for section 1'),
                ),
                RxAccordionItem(
                  title: 'Section 2',
                  value: 'section2',
                  child: const Text('Content for section 2'),
                ),
                RxAccordionItem(
                  title: 'Section 3',
                  value: 'section3',
                  child: const Text('Content for section 3'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
