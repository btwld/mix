import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final flexStyle = FlexBoxStyle()
        .mainAxisSize(.min)
        .spacing(4)
        .color(Colors.cyan.shade50)
        .padding(
          .horizontal(10)
          .vertical(4),
        )
        .borderRadius(.circular(99))
        .border(
          .all(
            .color(Colors.cyan.shade600)
            .width(2),
          ),
        );

    final iconStyle = IconStyle()
        .icon(Icons.ac_unit_rounded)
        .color(Colors.cyan.shade600)
        .size(18);
    final textStyle = TextStyling()
        .fontSize(16)
        .fontWeight(FontWeight.w500)
        .color(Colors.cyan.shade700);

    return HBox(
      style: flexStyle,
      children: [
        StyledIcon(style: iconStyle),
        StyledText('Snow', style: textStyle),
      ],
    );
  }
}
