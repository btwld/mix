import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Example())),
    );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final flexStyle = Style.flexbox()
        .flex(FlexMix.mainAxisSize(MainAxisSize.min).gap(4))
        .box(
          BoxMix.color(Colors.cyan.shade50)
              .padding(
                EdgeInsetsDirectionalMix.symmetric(horizontal: 10, vertical: 4),
              )
              .borderRadius(BorderRadiusMix.circular(99))
              .border(
                BoxBorderMix.all(
                  BorderSideMix.color(Colors.cyan.shade600).width(2),
                ),
              ),
        );

    final iconStyle = Style.icon().color(Colors.cyan.shade600).size(18);
    final textStyle = Style.text()
        .fontSize(16)
        .fontWeight(FontWeight.w500)
        .color(Colors.cyan.shade700);

    return HBox(
      style: flexStyle,
      children: [
        StyledIcon(Icons.ac_unit_rounded, style: iconStyle),
        StyledText('Snow', style: textStyle),
      ],
    );
  }
}
