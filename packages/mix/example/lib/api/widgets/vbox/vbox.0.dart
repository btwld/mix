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
    final flexStyle = Style.flexbox()
        .flex(
          FlexMix.mainAxisSize(MainAxisSize.min)
              .gap(4)
              .crossAxisAlignment(CrossAxisAlignment.start)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween),
        )
        .box(
          BoxMix.color(Colors.grey.shade50)
              .padding(
                EdgeInsetsDirectionalMix.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              )
              .borderRadius(BorderRadiusMix.circular(10))
              .border(
                BoxBorderMix.all(
                  BorderSideMix.color(Colors.blueGrey.shade400).width(1),
                ),
              )
              .height(150)
              .width(120)
              .shadow(BoxShadowMix.blurRadius(10).color(Colors.black12)),
        );

    final iconStyle = Style.icon().color(Colors.blueGrey.shade600).size(20);
    final textStyle = Style.text()
        .fontSize(16)
        .fontWeight(FontWeight.w500)
        .color(Colors.blueGrey.shade600);

    return VBox(
      style: flexStyle,
      children: [
        StyledIcon(Icons.piano_outlined, style: iconStyle),
        StyledText('Musician', style: textStyle),
      ],
    );
  }
}
