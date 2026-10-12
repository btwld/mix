import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds_example/gradient_debug_preview.dart';

void main() {
  testWidgets('gradient debug functional markup renders without errors', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(480, 600);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TwScope(
          config: TwConfig.standard(),
          child: const GradientDebugPreview(width: 480),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
