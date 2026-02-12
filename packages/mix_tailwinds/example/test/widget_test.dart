import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mix_tailwinds_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final originalOnError = FlutterError.onError;
  var sawUnexpectedFlutterError = false;
  var sawOverflowFlutterError = false;

  void drainKnownOverflowExceptions(WidgetTester tester) {
    while (true) {
      final exception = tester.takeException();
      if (exception == null) break;

      final message = exception.toString();
      if (message.contains('RenderFlex overflowed')) {
        continue;
      }

      final isAggregateException = message.startsWith('Multiple exceptions (');
      if (isAggregateException &&
          sawOverflowFlutterError &&
          !sawUnexpectedFlutterError) {
        continue;
      }

      throw TestFailure('Unexpected exception in smoke test:\n$message');
    }

    if (sawUnexpectedFlutterError) {
      throw TestFailure('Unexpected non-overflow FlutterError in smoke test.');
    }

    sawUnexpectedFlutterError = false;
    sawOverflowFlutterError = false;
  }

  testWidgets('TailwindParityApp smoke test', (WidgetTester tester) async {
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      if (message.contains('RenderFlex overflowed')) {
        sawOverflowFlutterError = true;
        return;
      }
      sawUnexpectedFlutterError = true;
      originalOnError?.call(details);
    };
    addTearDown(() {
      FlutterError.onError = originalOnError;
    });

    const width = 768.0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(width, 2000);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(width, 2000)),
          child: MaterialApp(home: TailwindParityScreen(initialWidth: width)),
        ),
      ),
    );
    drainKnownOverflowExceptions(tester);
    await tester.pumpAndSettle();
    drainKnownOverflowExceptions(tester);

    // Verify the app renders with expected text
    expect(find.text('mix_tailwinds parity samples'), findsOneWidget);
    drainKnownOverflowExceptions(tester);
  });
}
