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


    final style = BoxStyler()
        .width(100)
        .height(100)
        .color(Colors.blue.shade400)
        .onBreakpoint(Breakpoint.xs, BoxStyler().color(Colors.green))
        .borderRounded(16)
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
        )
        .wrapDefaultTextStyle(
          TextStyleMix()
            .fontSize(16)
            .fontWeight(FontWeight.bold)
            .color(Colors.white)
        )
        .wrap(
          ModifierConfig.align(alignment: Alignment.center)
        )
        .animate(AnimationConfig.spring(const Duration(milliseconds: 300)));

    return Center(
      child: Box(
        style: style,
        child: Center(
          child: Text(
            'Resize window!',
           
          ),
        ),
      ),
    );
  }
}
