import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpMaterialWidget(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: widget,
      ),
    );
  }

  Future<void> simulateHover(Key key, {required VoidCallback? onHover}) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await pump();

    await gesture.moveTo(getCenter(find.byKey(key)));
    await pump();

    onHover?.call();

    await gesture.moveTo(Offset.zero);
    await pump();
  }

  Future<void> simulatePress(
    Key key, {
    required VoidCallback? onPressed,
  }) async {
    final pressGesture = await press(find.byKey(key));
    await pump();

    onPressed?.call();

    await pressGesture.up();
    await pump();
  }

  void expectCursor(SystemMouseCursor cursor, {required Key on}) async {
    final region = widget<MouseRegion>(find
        .descendant(of: find.byKey(on), matching: find.byType(MouseRegion))
        .first);

    expect(region.cursor, cursor);
  }
}
