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
    final flexStyle = FlexBoxStyler()
        .mainAxisSize(.min)
        .spacing(4)
        .crossAxisAlignment(.start)
        .mainAxisAlignment(.spaceBetween)
        .color(Colors.grey.shade50)
        .padding(
          .symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        )
        .borderRadius(.circular(10))
        .borderAll(
          color: Colors.blueGrey.shade400,
          width: 1,
        )
        .height(150)
        .width(120)
        .boxShadow(
          blurRadius: 10,
          color: Colors.black12,
        );

    final iconStyle = IconStyler()
        .icon(Icons.piano_outlined)
        .color(Colors.blueGrey.shade600)
        .size(20);

    final textStyle = TextStyler()
        .fontSize(16)
        .fontWeight(FontWeight.w500)
        .color(Colors.blueGrey.shade600);

    return VBox(
      style: flexStyle,
      children: [
        StyledIcon( style: iconStyle),
        StyledText('Musician', style: textStyle),
      ],
    );
  }
}
