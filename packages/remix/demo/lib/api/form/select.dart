import 'package:demo/helpers/string.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const MyApp());
}

enum Options {
  banana,
  apple,
  orange,
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Options? _value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Row(
            children: [
              RxSelect<Options>(
                items: const [
                  RxSelectItem<Options>.raw(
                    value: Options.apple,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Custom Apple'),
                      ],
                    ),
                  ),
                ],
                child: RxSelectTrigger(label: 'Select an item'),
              ),
              RxSelect(
                selectedValue: _value,
                onSelectedValueChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
                items: Options.values
                    .map((e) =>
                        RxSelectItem(value: e, label: e.name.capitalize()))
                    .toList(),
                style: RxSelectStyle()
                  ..trigger.container.width(200)
                  ..trigger.container.flex.mainAxisAlignment.spaceBetween(),
                child: RxSelectTrigger(
                  label: _value?.name.capitalize() ?? 'Select an item',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
