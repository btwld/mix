import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(const PressableBuilderExample());

class PressableBuilderExample extends StatelessWidget {
  const PressableBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final column = FlexBoxStyler().direction(.vertical).spacing(16);
    final heading = TextStyler().fontSize(22).fontWeight(.bold);
    final textAction = TextStyler().color(Colors.blue).pressable();
    final button = BoxStyler()
        .padding(.symmetric(vertical: 12, horizontal: 20))
        .borderRadius(.circular(12))
        .color(Colors.blue)
        .onPressed(.color(Colors.indigo))
        .pressable();
    final buttonLabel = TextStyler().color(Colors.white).fontWeight(.w600);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: column(
            children: [
              heading('Callable pressable builders'),
              textAction('Open settings', onPress: () {}),
              button(onPress: () {}, child: buttonLabel('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
