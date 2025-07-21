import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/widget_state/internal/mouse_region_mix_state.dart';

void main() {
  group('PointerPositionStateWidget', () {
    testWidgets('updates pointer position on hover', (
      WidgetTester tester,
    ) async {
      await tester.pumpMaterialApp(
        const MouseRegionMixStateWidget(
          child: SizedBox(width: 100, height: 100),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      var context = tester.element(find.byType(SizedBox));

      final beforePosition = MouseRegionMixWidgetState.of(
        tester.element(find.byType(SizedBox)),
      )!.pointerPosition;

      await gesture.moveTo(const Offset(50, 50));
      await tester.pumpAndSettle();

      context = tester.element(find.byType(SizedBox));

      final afterPosition = MouseRegionMixWidgetState.of(
        context,
      )!.pointerPosition;
      expect(beforePosition, isNull);

      expect(afterPosition?.offset, equals(const Offset(50, 50)));

      addTearDown(gesture.removePointer);
    });
  });
  group('PointerListenerMixStateController', () {
    test('updates pointer position correctly', () {
      final controller = MouseRegionMixStateController();
      const size = Size(200, 100);

      controller.updateCursorPosition(const Offset(100, 50), size);

      expect(
        controller.pointerPosition?.position,
        equals(const Alignment(0.0, 0.0)),
      );
      expect(controller.pointerPosition?.offset, equals(const Offset(100, 50)));
    });

    test('clamps pointer position to valid range', () {
      final controller = MouseRegionMixStateController();
      const size = Size(200, 100);

      controller.updateCursorPosition(const Offset(250, 150), size);

      expect(
        controller.pointerPosition?.position,
        equals(const Alignment(1.0, 1.0)),
      );
      expect(
        controller.pointerPosition?.offset,
        equals(const Offset(250, 150)),
      );
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
        equals(position.position.hashCode ^ position.offset.hashCode),
      );
    });
  });
}
