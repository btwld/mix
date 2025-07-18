import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const primary = MixToken<Color>('primary');

void main() {
  runApp(
    MixScope(
      data: MixScopeData.static(tokens: {primary: Colors.blue}),
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
          style: style() as Style<FlexBoxSpec>,
          direction: Axis.horizontal,
          children: [
            StyledIcon(
              Icons.image,
              style: Style($icon.color.red()) as Style<IconSpec>,
            ),
            StyledText(
              'Hello World',
              style: Style($text.style.color.blue()) as Style<TextSpec>,
            ),
          ],
        ),
      ),
    );
  }
}

Style style() => Style(
  $icon.color.red(),
  $flexbox.flex.direction(Axis.horizontal),
  $flexbox.flex.mainAxisSize.min(),
  $on.breakpoint(const Breakpoint(minWidth: 0, maxWidth: 365))(
    $flexbox.flex.direction(Axis.vertical),
  ),
);
