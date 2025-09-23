import '../../../helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final flexStyle = FlexBoxStyler()
        .mainAxisSize(.min)
        .spacing(4)
        .color(Colors.cyan.shade50)
        .paddingX(10)
        .paddingY(4)
        .borderRounded(99)
        .borderAll(
          color: Colors.cyan.shade600,
          width: 2,
        );

    final iconStyle = IconStyler()
        .icon(Icons.ac_unit_rounded)
        .color(Colors.cyan.shade600)
        .size(18);
    final textStyle = TextStyler()
        .fontSize(16)
        .fontWeight(FontWeight.w500)
        .color(Colors.cyan.shade700);

    return RowBox(
      style: flexStyle,
      children: [
        StyledIcon(style: iconStyle),
        StyledText('Snow', style: textStyle),
      ],
    );
  }
}
