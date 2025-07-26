import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/widget_state/internal/mix_interactable.dart';
import 'package:mix/src/core/widget_state/widget_state_provider.dart';

import '../../../../helpers/testing_utils.dart';

void main() {
  group('CursorPositionController with MixInteractable', () {
    testWidgets('updates cursor position on hover', (
      WidgetTester tester,
    ) async {
      const key = ValueKey('test_box');

      await tester.pumpMaterialApp(
        MixInteractable(
          child: const SizedBox(key: key, width: 100, height: 100),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      /// Get he WidgetStateProvider to access the cursor position
      var context = tester.element(find.byKey(key));
      final (_, beforePosition) = WidgetStateScope.of(context);

      await gesture.moveTo(const Offset(50, 50));
      await tester.pumpAndSettle();

      context = tester.element(find.byKey(key));

      final (_, afterPosition) = WidgetStateScope.of(context);
      expect(beforePosition, isNull);

      expect(afterPosition?.offset, equals(const Offset(50, 50)));

      addTearDown(gesture.removePointer);
    });
  });
  group('CursorPositionController', () {
    test('updates cursor position correctly', () {
      final controller = CursorPositionController();
      const size = Size(200, 100);

      controller.updatePosition(const Offset(100, 50), size);

      expect(controller.value?.position, equals(const Alignment(0.0, 0.0)));
      expect(controller.value?.offset, equals(const Offset(100, 50)));
    });

    test('clamps cursor position to valid range', () {
      final controller = CursorPositionController();
      const size = Size(200, 100);

      controller.updatePosition(const Offset(250, 150), size);

      expect(controller.value?.position, equals(const Alignment(1.0, 1.0)));
      expect(controller.value?.offset, equals(const Offset(250, 150)));
    });

    test('clears cursor position', () {
      final controller = CursorPositionController();
      const size = Size(200, 100);

      controller.updatePosition(const Offset(100, 50), size);
      expect(controller.value, isNotNull);

      controller.clear();
      expect(controller.value, isNull);
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
