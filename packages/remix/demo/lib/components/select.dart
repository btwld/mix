import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Select Component',
  type: RxSelect,
)
Widget buildSelect(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: SelectDemo(),
    ),
  );
}

class SelectDemo extends StatefulWidget {
  const SelectDemo({
    super.key,
  });

  @override
  State<SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<SelectDemo> {
  String selectedValue = 'Apple';

  final List<String> items = ['Apple Fiji', 'Banana', 'Orange'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: RxSelect<String>(
              selectedValue: selectedValue,
              onSelectedValueChanged: (value) =>
                  setState(() => selectedValue = value ?? ''),
              items: List.generate(
                items.length,
                (index) => RxSelectItem<String>(
                  value: items[index],
                  label: items[index],
                ),
              ),
              child: Text(selectedValue),
            ),
          ),
        ],
      ),
    );
  }
}
