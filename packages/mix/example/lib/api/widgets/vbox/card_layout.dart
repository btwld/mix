import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final flexStyle = FlexBoxStyler()
        .mainAxisSize(MainAxisSize.min)
        .spacing(4)
        .crossAxisAlignment(CrossAxisAlignment.start)
        .mainAxisAlignment(MainAxisAlignment.spaceBetween)
        .color(Colors.grey.shade50)
        .paddingX(12)
        .paddingY(10)
        .borderRounded(10)
        .borderAll(color: Colors.blueGrey.shade400, width: 1)
        .height(150)
        .width(120)
        .shadowOnly(color: Colors.black12, blurRadius: 10);

    final iconStyle = IconStyler()
        .icon(Icons.piano_outlined)
        .color(Colors.blueGrey.shade600)
        .size(20);

    final textStyle = TextStyler()
        .fontSize(16)
        .fontWeight(FontWeight.w500)
        .color(Colors.blueGrey.shade600);

    return ColumnBox(
      style: flexStyle,
      children: [
        StyledIcon(style: iconStyle),
        StyledText('Musician', style: textStyle),
      ],
    );
  }
}
