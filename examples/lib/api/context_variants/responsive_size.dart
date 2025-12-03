import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .width(100)
        .height(100)
        .color(Colors.blue.shade400)
        .onBreakpoint(Breakpoint.maxWidth(575), BoxStyler().color(Colors.green))
        .borderRounded(16)
        .shadowOnly(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20)
        .wrap(
          WidgetModifierConfig.defaultText(
            TextStyler() //
                .fontSize(16)
                .fontWeight(.bold)
                .color(Colors.white),
          ).align(alignment: .center),
        )
        .animate(AnimationConfig.spring(300.ms));

    return Center(
      child: Box(
        style: style,
        child: Center(child: Text('Resize window!')),
      ),
    );
  }
}
