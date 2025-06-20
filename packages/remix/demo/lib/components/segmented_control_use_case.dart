import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'SegmentedControl Component',
  type: SegmentedControl,
)
Widget buildAccordionUseCase(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: _WidgetDemo(),
    ),
  );
}

class _WidgetDemo extends StatefulWidget {
  const _WidgetDemo();
  @override
  State<_WidgetDemo> createState() => _WidgetDemoState();
}

class _WidgetDemoState extends State<_WidgetDemo> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SegmentedControl(
      index: index,
      buttons: const [
        SegmentButton(
          text: 'Apple',
        ),
        SegmentButton(
          text: 'Pear',
        ),
        SegmentButton(
          text: 'Banana',
        ),
      ],
      onIndexChanged: (i) {
        setState(() {
          index = i;
        });
      },
    );
  }
}
