import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_example/snacks/theme.dart';

Future<void> pumpBit(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: snacksMaterialTheme(),
      home: MixScope(
        colors: snacksColors(),
        radii: snacksRadii(),
        child: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: const Key('snacks-test-boundary'),
              child: ColoredBox(
                color: const Color(0xFF0C0C12),
                child: SizedBox(
                  width: 320,
                  height: 240,
                  child: Center(child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Finder keyed(String key) => find.byKey(Key(key));

/// Painted geometry independent of generated Transform nesting.
Rect paintedBounds(WidgetTester tester, Finder finder) {
  final box = tester.renderObject<RenderBox>(finder);
  return MatrixUtils.transformRect(
    box.getTransformTo(null),
    Offset.zero & box.size,
  );
}

Finder decoration(Finder parent) =>
    find.descendant(of: parent, matching: find.byType(DecoratedBox)).first;
Color? textColor(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style?.color;
Future<Uint8List> pixels(WidgetTester tester) async {
  return (await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      keyed('snacks-test-boundary'),
    );
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    return data!.buffer.asUint8List();
  }))!;
}

/// Fractional channel error tolerates subpixel rasterization at spring rest.
double pixelDifference(Uint8List a, Uint8List b) {
  if (a.length != b.length) return 1;
  var difference = 0;
  for (var i = 0; i < a.length; i++) {
    difference += (a[i] - b[i]).abs();
  }
  return difference / (a.length * 255);
}

Future<void> loadSnacksFonts() async {
  final bytes = await File(
    '../../mix_winds/example/assets/fonts/roboto/Roboto[wdth,wght].ttf',
  ).readAsBytes();
  await (FontLoader(
    'Roboto',
  )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
}
