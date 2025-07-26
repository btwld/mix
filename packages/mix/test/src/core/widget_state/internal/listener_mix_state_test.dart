import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/widget_state/internal/mix_hoverable_region.dart';
import 'package:mix/src/core/widget_state/widget_state_provider.dart';

import '../../../../helpers/testing_utils.dart';

void main() {
  group('MixHoverableRegion pointer position tracking', () {
    testWidgets('updates pointer position on hover when trackMousePosition is true', (
      WidgetTester tester,
    ) async {
      const key = ValueKey('test_box');

      await tester.pumpMaterialApp(
        MixHoverableRegion(
          trackMousePosition: true,
          child: Builder(
            builder: (context) {
              return const SizedBox(key: key, width: 100, height: 100);
            },
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Get the WidgetStateScope to access the pointer position
      var context = tester.element(find.byKey(key));
      var position = WidgetStateScope.positionOf(context);
      expect(position, isNull);

      // Move mouse to center
      await gesture.moveTo(tester.getCenter(find.byKey(key)));
      await tester.pumpAndSettle();

      context = tester.element(find.byKey(key));
      position = WidgetStateScope.positionOf(context);
      
      expect(position, isNotNull);
      expect(position!.position, equals(const Alignment(0.0, 0.0)));
      expect(position.offset, equals(const Offset(50, 50)));

      addTearDown(gesture.removePointer);
    });

    testWidgets('does not track pointer position when trackMousePosition is false', (
      WidgetTester tester,
    ) async {
      const key = ValueKey('test_box');

      await tester.pumpMaterialApp(
        MixHoverableRegion(
          trackMousePosition: false, // Default
          child: Builder(
            builder: (context) {
              return const SizedBox(key: key, width: 100, height: 100);
            },
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Move mouse to center
      await gesture.moveTo(tester.getCenter(find.byKey(key)));
      await tester.pumpAndSettle();

      final context = tester.element(find.byKey(key));
      final position = WidgetStateScope.positionOf(context);
      
      expect(position, isNull);

      addTearDown(gesture.removePointer);
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