import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(const PressableExample());

class PressableExample extends StatelessWidget {
  const PressableExample({super.key});

  @override
  Widget build(BuildContext context) {
    final column = FlexBoxStyler().direction(.vertical).spacing(16);
    final heading = TextStyler().fontSize(22).fontWeight(.bold);
    final button = BoxStyler()
        .padding(.symmetric(vertical: 12, horizontal: 20))
        .borderRadius(.circular(12))
        .color(Colors.blue)
        .onPressed(.color(Colors.indigo));
    final label = TextStyler().color(Colors.white).fontWeight(.w600);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: column(
            children: [
              heading('BoxStyler.pressable'),
              button.pressable(onPress: () {}, child: label('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
