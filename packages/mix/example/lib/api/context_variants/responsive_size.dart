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


    final style = Style.box(
        .width(100)
        .height(100)
        .color(Colors.blue.shade400 )
        .onBreakpoint(.xs, .color(Colors.green))

        .borderRadius(.circular(16))
        .shadow(
          .color(Colors.black.withValues(alpha: 0.2))
          .blurRadius(20)
        )
        .text( 
          .fontSize(16)
          .fontWeight(.bold)
          .color(Colors.white)
          .wrap(
            .align(alignment: .center)
          )
        )
        .animate(.spring(300.ms))
    );

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