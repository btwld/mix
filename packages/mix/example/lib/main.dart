import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const primary = ColorToken('primary');

void main() {
  runApp(
    MixTheme(
      data: MixThemeData(
        colors: {
          primary: Colors.blue,
        },
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool scale = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              scale = !scale;
            });
          },
          child: Box(
            style: Style(
              $box.color.red(),
              $box.width(scale ? 100 : 200),
              $box.height(scale ? 100 : 200),
            ).animate(
              duration: const Duration(milliseconds: 4000),
              curve: Curves.bounceInOut,
            ),
          ),
        ),
      ),
    );
  }
}

Style style() => Style(
      $icon.color.red(),
      $flexbox
        ..flex.direction(Axis.horizontal)
        ..flex.mainAxisSize.min(),
      $on.breakpoint(const Breakpoint(minWidth: 0, maxWidth: 365))(
        $flexbox.flex.direction(Axis.vertical),
      ),
    ).animate(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
