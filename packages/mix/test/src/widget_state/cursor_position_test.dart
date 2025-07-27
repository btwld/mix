import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/widget_state/cursor_position.dart';

void main() {
  group('CursorPositionNotifier', () {
    test('shouldTrack returns hasListeners', () {
      final notifier = PointerPositionNotifier();

      expect(notifier.shouldTrack, isFalse);

      void listener() {}
      notifier.addListener(listener);
      expect(notifier.shouldTrack, isTrue);

      notifier.removeListener(listener);
      expect(notifier.shouldTrack, isFalse);

      notifier.dispose();
    });

    test('updatePosition only updates when hasListeners', () {
      final notifier = PointerPositionNotifier();

      // No listeners - should not update
      notifier.updatePosition(Alignment.center, const Offset(50, 50));
      expect(notifier.value, isNull);

      // Add listener - should update
      void listener() {}
      notifier.addListener(listener);
      notifier.updatePosition(Alignment.center, const Offset(50, 50));
      expect(notifier.value, isNotNull);
      expect(notifier.value!.position, equals(Alignment.center));

      notifier.removeListener(listener);
      notifier.dispose();
    });

    test('clearPosition sets value to null', () {
      final notifier = PointerPositionNotifier();

      void listener() {}
      notifier.addListener(listener);
      notifier.updatePosition(Alignment.center, const Offset(50, 50));
      expect(notifier.value, isNotNull);

      notifier.clearPosition();
      expect(notifier.value, isNull);

      notifier.removeListener(listener);
      notifier.dispose();
    });
  });

  group('PointerPosition', () {
    test('equality works correctly', () {
      const position1 = PointerPosition(
        position: Alignment(0.5, 0.5),
        offset: Offset(100, 50),
      );
      const position2 = PointerPosition(
        position: Alignment(0.5, 0.5),
        offset: Offset(100, 50),
      );
      const position3 = PointerPosition(
        position: Alignment(0.0, 0.0),
        offset: Offset(50, 25),
      );

      expect(position1, equals(position2));
      expect(position1, isNot(equals(position3)));
    });

    test('hashCode is consistent with equality', () {
      const position = PointerPosition(
        position: Alignment(0.5, 0.5),
        offset: Offset(100, 50),
      );

      expect(
        position.hashCode,
        equals(Object.hash(position.position, position.offset)),
      );
    });
  });

  testWidgets('PointerPosition static methods work with provider', (
    WidgetTester tester,
  ) async {
    final notifier = PointerPositionNotifier();
    PointerPosition? capturedPosition;
    PointerPositionNotifier? capturedNotifier;

    await tester.pumpWidget(
      PointerPositionProvider(
        notifier: notifier,
        child: Builder(
          builder: (context) {
            capturedPosition = PointerPosition.of(context);
            capturedNotifier = PointerPosition.notifierOf(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(capturedPosition, isNull);
    expect(capturedNotifier, equals(notifier));

    notifier.dispose();
  });
}
