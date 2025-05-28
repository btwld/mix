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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: FlexBox(
          style: style(),
          direction: Axis.horizontal,
          children: const [
            StyledIcon(Icons.image),
            StyledText('Hello World'),
          ],
        ),
      ),
    );
  }
}

Style style() => Style(
      $icon.color.red(),
      $flexbox.chain
        ..flex.direction(Axis.horizontal)
        ..flex.mainAxisSize.min(),
      $on.breakpoint(const Breakpoint(minWidth: 0, maxWidth: 365))(
        $flexbox.chain.flex.direction(Axis.vertical),
      ),
      Style.builder((context) {
        final isSmall = MediaQuery.of(context).size.width < 365;

        return Style(
          isSmall ? $icon.color.blue() : $icon.color.green(),
        );
      })(),
    ).animate(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
