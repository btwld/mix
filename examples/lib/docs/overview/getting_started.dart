import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cardStyle = BoxStyler()
        .height(100)
        .width(240)
        .color(Colors.blue)
        .borderRounded(12)
        .borderAll(color: Colors.black, width: 1, style: .solid);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Box(
            style: cardStyle,
            child: StyledText(
              'Hello Mix',
              style: TextStyler().color(Colors.white).fontSize(18),
            ),
          ),
        ),
      ),
    );
  }
}

final primaryCard = BoxStyler().color(Colors.blue).borderRounded(12);

final box = Box(style: primaryCard, child: StyledText('Primary'));
final box2 = Box(
  style: primaryCard.color(Colors.green),
  child: StyledText('Success'),
);
