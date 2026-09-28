import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/snacks/examples.dart';

void main() {
  testWidgets('slide cursor reflects working and completed states', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: SlideCommit())),
      ),
    );
    final target = find.byKey(const Key('slide-commit'));
    await tester.drag(target, const Offset(300, 0));
    await tester.pump();
    final mouse = TestGesture(
      dispatcher: tester.sendEventToBinding,
      kind: PointerDeviceKind.mouse,
      device: 42,
    );
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: tester.getCenter(target));
    await tester.pump();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(42),
      SystemMouseCursors.progress,
    );
    await tester.pump(const Duration(milliseconds: 710));
    await tester.pump();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(42),
      SystemMouseCursors.basic,
    );
    await tester.pump(const Duration(milliseconds: 1510));
    await tester.pump();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(42),
      SystemMouseCursors.resizeLeftRight,
    );
  });

  for (final (name, widget) in [
    ('comet-dial', const CometDial()),
    ('wake-slider', const WakeSlider()),
    ('slide-commit', const SlideCommit()),
    ('scrub-field', const ScrubField()),
  ]) {
    testWidgets('$name shows a horizontal cursor through a mouse drag', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Center(child: widget)),
        ),
      );
      final mouse = TestGesture(
        dispatcher: tester.sendEventToBinding,
        kind: PointerDeviceKind.mouse,
        device: 42,
      );
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byKey(Key(name))));
      await tester.pump();

      void expectDragCursor() => expect(
        RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(42),
        SystemMouseCursors.resizeLeftRight,
      );

      expectDragCursor();
      await mouse.down(tester.getCenter(find.byKey(Key(name))));
      await mouse.moveBy(const Offset(30, 0));
      await tester.pump();
      expectDragCursor();
      await mouse.up();
      await tester.pumpAndSettle();
      expectDragCursor();
      await mouse.moveTo(Offset.zero);
      await tester.pump();
      expect(
        RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(42),
        SystemMouseCursors.basic,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
