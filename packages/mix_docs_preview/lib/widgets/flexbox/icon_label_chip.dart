import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'package:mix_docs_preview/helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final flexStyle = FlexBoxStyler.mainAxisSize(.min)
        .spacing(4)
        .color(Colors.cyan.shade50)
        .padding(.symmetric(horizontal: 10, vertical: 4))
        .borderRadius(.circular(99))
        .border(.color(Colors.cyan.shade600).width(2));

    final iconStyle = IconStyler.icon(
      Icons.ac_unit_rounded,
    ).color(Colors.cyan.shade600).size(18);
    final textStyle = TextStyler.fontSize(
      16,
    ).fontWeight(.w500).color(Colors.cyan.shade700);

    return RowBox(
      style: flexStyle,
      children: [
        StyledIcon(style: iconStyle),
        StyledText('Snow', style: textStyle),
      ],
    );
  }
}
