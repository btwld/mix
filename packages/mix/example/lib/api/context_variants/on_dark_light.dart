import 'package:example/helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final kdefaultFlexStyle = Style.flexbox().flex(
  FlexMix.mainAxisSize(MainAxisSize.min).gap(8),
);

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final flexboxStyle = kdefaultFlexStyle.box(
      BoxMix.color(Colors.grey.shade100)
          .padding(EdgeInsetsMix.symmetric(horizontal: 12, vertical: 4))
          .borderRadius(BorderRadiusMix.circular(10)),
    );

    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          platformBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Center(
            child: VBox(
              style: kdefaultFlexStyle,
              children: [
                Example(),
                HBox(
                  style: flexboxStyle,
                  children: [
                    Text('Light'),
                    Switch(
                      value: isDark,
                      onChanged: (value) {
                        setState(() {
                          isDark = value;
                        });
                      },
                    ),
                    Text('Dark'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxMix()
        .height(100)
        .width(100)
        .borderRadius(BorderRadiusMix.circular(10))
        .onDark(BoxMix.color(Colors.white));

    return FlexBox(
      direction: Axis.horizontal,
      style: kdefaultFlexStyle,
      children: [
        Box(
          style: style.color(Colors.black).onDark(BoxMix.color(Colors.white)),
        ),
        Box(
          style: style.color(Colors.white).onLight(BoxMix.color(Colors.black)),
        ),
      ],
    );
  }
}
