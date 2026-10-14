import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Read the painted transform, not the resolved target style: the latter can
// be correct even while the modifier disappears during the return animation.
double _rotation(WidgetTester tester) {
  final transforms = tester.widgetList<Transform>(find.byType(Transform));
  return transforms.fold<double>(0, (angle, widget) {
    final matrix = widget.transform;
    return angle + math.atan2(matrix.entry(1, 0), matrix.entry(0, 0));
  });
}

Future<TestGesture> _mountHoverBox(WidgetTester tester) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Box(
          style: BoxStyler()
              .size(100, 100)
              .color(const Color(0xFF4466FF))
              .animate(.linear(const Duration(milliseconds: 400)))
              .onHovered(.rotate(0.1)),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  return mouse;
}

void main() {
  testWidgets('hover rotation animates in and out without a resting rotate', (
    tester,
  ) async {
    final mouse = await _mountHoverBox(tester);
    expect(_rotation(tester), closeTo(0, 1e-6));

    await mouse.moveTo(tester.getCenter(find.byType(Box)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_rotation(tester), closeTo(0.025, 1e-6));
    await tester.pumpAndSettle();
    expect(_rotation(tester), closeTo(0.1, 1e-6));

    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(_rotation(tester), closeTo(0.1, 1e-6));
    await tester.pump(const Duration(milliseconds: 100));
    expect(_rotation(tester), closeTo(0.075, 1e-6));
    await tester.pumpAndSettle();
    expect(_rotation(tester), closeTo(0, 1e-6));
    expect(tester.takeException(), isNull);
  });

  testWidgets('interrupted hover rotation returns from the painted angle', (
    tester,
  ) async {
    final mouse = await _mountHoverBox(tester);
    final center = tester.getCenter(find.byType(Box));
    await mouse.moveTo(center);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(_rotation(tester), closeTo(0.05, 1e-6));

    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(_rotation(tester), closeTo(0.05, 1e-6));
    await tester.pump(const Duration(milliseconds: 100));
    expect(_rotation(tester), closeTo(0.0375, 1e-6));

    await mouse.moveTo(center);
    await tester.pump();
    expect(_rotation(tester), closeTo(0.0375, 1e-6));
    await tester.pump(const Duration(milliseconds: 100));
    expect(_rotation(tester), closeTo(0.053125, 1e-6));
    await tester.pumpAndSettle();
    expect(_rotation(tester), closeTo(0.1, 1e-6));

    await mouse.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(_rotation(tester), closeTo(0, 1e-6));
    expect(tester.takeException(), isNull);
  });
}
