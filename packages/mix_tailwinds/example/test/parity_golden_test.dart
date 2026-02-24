import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final originalOnError = FlutterError.onError;
  var sawUnexpectedFlutterError = false;

  void drainKnownOverflowExceptions(WidgetTester tester) {
    while (true) {
      final exception = tester.takeException();
      if (exception == null) break;

      final message = exception.toString();
      if (message.contains('RenderFlex overflowed')) {
        continue;
      }

      final isAggregateException =
          message.startsWith('Multiple exceptions (') &&
          message.contains('at least one was unexpected.');
      if (isAggregateException && !sawUnexpectedFlutterError) {
        continue;
      }

      throw TestFailure(
        'Unexpected exception during parity golden capture:\n$message',
      );
    }

    if (sawUnexpectedFlutterError) {
      throw TestFailure(
        'Unexpected non-overflow FlutterError was reported during capture.',
      );
    }

    sawUnexpectedFlutterError = false;
  }

  Future<void> pumpAtWidth(WidgetTester tester, double width) async {
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('RenderFlex overflowed')) {
        // Ignore known flex overflow warnings during golden capture so we can
        // compare visual diffs even when shrink semantics diverge.
        return;
      }
      sawUnexpectedFlutterError = true;
      originalOnError?.call(details);
    };
    addTearDown(() {
      FlutterError.onError = originalOnError;
    });

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 2000);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
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
    drainKnownOverflowExceptions(tester);
    await tester.pumpAndSettle();
    drainKnownOverflowExceptions(tester);
  }

  const widths = [480.0, 768.0, 1024.0];

  for (final width in widths) {
    testWidgets('matches Flutter golden at ${width.toInt()}px', (tester) async {
      await pumpAtWidth(tester, width);
      await expectLater(
        find.byType(TailwindParityPreview),
        matchesGoldenFile('goldens/flutter-plan-card-${width.toInt()}.png'),
      );
      drainKnownOverflowExceptions(tester);
    });
  }
}
