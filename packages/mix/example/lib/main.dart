import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(const PressableBuilderExample());

class PressableBuilderExample extends StatelessWidget {
  const PressableBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final button = BoxStyler()
        .padding(.symmetric(vertical: 12, horizontal: 20))
        .borderRadius(.circular(12))
        .color(Colors.blue)
        .onPressed(.color(Colors.indigo))
        .pressable();

    final heading = TextStyler().fontSize(22).fontWeight(.bold);
    final textAction = TextStyler().color(Colors.blue).pressable();

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FlexBox(
            style: FlexBoxStyler().direction(.vertical).spacing(16),
            children: [
              heading('Callable pressable builders'),
              textAction('Open settings', onPress: () {}),
              button(
                onPress: () {},
                semanticsLabel: 'Save',
                child: const StyledText('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
