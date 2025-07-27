import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/cursor_position.dart';
import 'package:mix/src/core/internal/mix_hoverable_region.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('MixHoverableRegion pointer position tracking', () {
    testWidgets(
      'automatically tracks pointer position when widgets are listening',
      (WidgetTester tester) async {
        const key = ValueKey('test_box');
        PointerPosition? capturedPosition;

        await tester.pumpMaterialApp(
          MixHoverableRegion(
            child: Builder(
              builder: (context) {
                capturedPosition = PointerPosition.of(context);
                return const SizedBox(key: key, width: 100, height: 100);
              },
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);

        // Initially no position
        expect(capturedPosition, isNull);

        // Move mouse to center
        await gesture.moveTo(tester.getCenter(find.byKey(key)));
        await tester.pumpAndSettle();

        // Force rebuild to capture position
        await tester.pumpMaterialApp(
          MixHoverableRegion(
            child: Builder(
              builder: (context) {
                capturedPosition = PointerPosition.of(context);
                return const SizedBox(key: key, width: 100, height: 100);
              },
            ),
          ),
        );

        expect(capturedPosition, isNotNull);
        expect(capturedPosition!.position, equals(const Alignment(0.0, 0.0)));
        expect(capturedPosition!.offset, equals(const Offset(50, 50)));

        addTearDown(gesture.removePointer);
      },
    );

    testWidgets(
      'provides cursor position infrastructure even when not actively used',
      (WidgetTester tester) async {
        const key = ValueKey('test_box');
        late PointerPositionNotifier notifier;

        await tester.pumpMaterialApp(
          MixHoverableRegion(
            child: Builder(
              builder: (context) {
                // Get access to the notifier without creating a dependency
                notifier = PointerPosition.notifierOf(context)!;
                // Not calling PointerPosition.of(context) - no dependency created
                return const SizedBox(key: key, width: 100, height: 100);
              },
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);

        // The provider infrastructure is always present (InheritedNotifier creates a listener)
        expect(notifier.shouldTrack, isTrue);
        expect(notifier.value, isNull);

        // Move mouse to center
        await gesture.moveTo(tester.getCenter(find.byKey(key)));
        await tester.pumpAndSettle();

        // Position is updated because infrastructure is present, but no widgets depend on it
        expect(notifier.shouldTrack, isTrue);
        expect(notifier.value, isNotNull);
        expect(notifier.value!.position, equals(const Alignment(0.0, 0.0)));

        addTearDown(gesture.removePointer);
      },
    );
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

    test('hashCode is generated correctly', () {
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
}
