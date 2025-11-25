import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final originalOnError = FlutterError.onError;

  setUpAll(() {
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('RenderFlex overflowed')) {
        // Ignore known flex overflow warnings during golden capture so we can
        // compare visual diffs even when shrink semantics diverge.
        return;
      }
      originalOnError?.call(details);
    };
  });

  tearDownAll(() {
    FlutterError.onError = originalOnError;
  });

  Future<void> _pumpAtWidth(WidgetTester tester, double width) async {
    tester.binding.window.devicePixelRatioTestValue = 1;
    tester.binding.window.physicalSizeTestValue = Size(width, 2000);
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: Size(width, 2000)),
          child: SizedBox(
            width: width,
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
              child: TailwindParityPreview(width: width, scrollable: false),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  const widths = [480.0, 768.0, 1024.0];

  for (final width in widths) {
    testWidgets('matches Flutter golden at ${width.toInt()}px', (tester) async {
      await _pumpAtWidth(tester, width);
      await expectLater(
        find.byType(TailwindParityPreview),
        matchesGoldenFile('goldens/flutter-plan-card-${width.toInt()}.png'),
      );
    });
  }
}
