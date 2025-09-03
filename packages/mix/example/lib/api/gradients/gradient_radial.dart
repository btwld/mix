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
        .height(150)
        .width(150)
        .borderRadius(.circular(75))
        .boxShadow(
          color: Colors.orange.shade400,
          blurRadius: 30,
          spreadRadius: 5,
        )
        .gradient(
          .radial(
            .center(Alignment(-0.3, -0.3))
            .focal(Alignment(-0.1, -0.1))
            .focalRadius(0.1)
            .radius(1.2)
            .colors([
              Colors.orange.shade300,
              Colors.deepOrange.shade600
            ])
          ),
    );

    return Box(style: style);
  }
}