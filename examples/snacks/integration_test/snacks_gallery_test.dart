import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mix/mix.dart';
import 'package:example_snacks/gallery/app.dart';
import 'package:example_snacks/gallery/theme.dart';

// Unlike the deterministic widget suite, these run the complete, scrollable app
// with real timers. Input is injected into Flutter, never the desktop pointer.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;
  const record = bool.fromEnvironment('SNACKS_RECORDING');
  if (record) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  void check(String title, Future<void> Function(_Demo demo) action) {
    testWidgets(title, (tester) async {
      await tester.pumpWidget(
        RepaintBoundary(
          key: const Key('integration-snapshot'),
          child: SnacksGalleryApp(key: UniqueKey()),
        ),
      );
      await tester.pumpAndSettle();
      final demo = _Demo(tester, title);
      await tester.ensureVisible(demo.card);
      await tester.pumpAndSettle();
      expect(demo.key.hitTestable(), findsOneWidget);
      if (record) {
        debugPrint('SNACKS_RECORD_START::$title');
        await tester.pump(const Duration(seconds: 1));
      }
      await action(demo);
      if (record) {
        await tester.pump(const Duration(seconds: 1));
        debugPrint('SNACKS_RECORD_END::$title');
      }
      expect(tester.takeException(), isNull);
      // Dispose any timers/controllers before the next example mounts.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }

  check('Squish Switch', (d) async {
    final thumb = d.inside(find.byType(DecoratedBox)).last;
    final before = d.bounds(thumb).center.dx;
    await d.tap(d.key);
    await d.settle();
    expect(d.bounds(thumb).center.dx, greaterThan(before + 30));
    await d.tap(d.key);
    await d.settle();
    expect(d.bounds(thumb).center.dx, closeTo(before, 1));
  });
  check('Peek Rating', (d) async {
    final stars = find.descendant(
      of: d.key,
      matching: find.byType(PressableBox),
    );
    final mouse = await d.hover(stars.last);
    expect(d.text('Peek 5'), findsOneWidget);
    await mouse.moveTo(Offset.zero);
    await d.tap(stars.at(1));
    expect(d.text('2 / 5'), findsOneWidget);
  });
  check('Spring Check', (d) async {
    final fill = find
        .descendant(
          of: find.byKey(const Key('spring-check-fill')),
          matching: find.byType(DecoratedBox),
        )
        .first;
    await d.tap(d.key);
    await d.settle();
    expect(d.bounds(fill).width, closeTo(28, .2));
    await d.tap(d.key);
    await d.settle();
    expect(d.bounds(fill).width, lessThan(1));
  });
  check('Rubber Segment', (d) async {
    final position = d.t.getCenter(d.text('Month'));
    await d.tap(d.text('Month'));
    await d.settle();
    expect(d.color('Month'), snacksColors()[$page]);
    expect(d.color('Week'), snacksColors()[$muted]);
    expect(d.t.getCenter(d.text('Month')), position);
  });
  check('Jelly Radio', (d) async {
    final first = find
        .descendant(of: d.key, matching: find.byType(PressableBox))
        .first;
    final width = d.t.getSize(first).width;
    await d.tap(d.text('Quiet'));
    await d.settle();
    expect(d.color('Quiet'), snacksColors()[$page]);
    expect(d.t.getSize(first).width, greaterThan(width));
  });
  check('Glide Select', (d) async {
    await d.tap(d.text('Gemini'));
    await d.settle();
    await d.hover(find.text('Grok'));
    await d.tap(find.text('Claude'));
    await d.settle();
    expect(d.text('Claude'), findsOneWidget);
    expect(d.text('Grok'), findsNothing);
  });
  check('Scrub Field', (d) async {
    final width = d.t.getSize(d.key).width;
    await d.t.drag(d.key, const Offset(80, 0));
    await d.t.pump();
    expect(d.text('24 px'), findsNothing);
    await d.tap(d.key);
    await d.t.enterText(d.inside(find.byType(TextField)), '999');
    await d.t.testTextInput.receiveAction(TextInputAction.done);
    await d.t.pump();
    expect(d.text('100 px'), findsOneWidget);
    expect(d.t.getSize(d.key).width, width);
  });
  check('Code Slots', (d) async {
    final input = d.inside(find.byType(TextField));
    await d.t.enterText(input, '9999');
    await d.settle();
    final invalid = await d.pixels();
    await d.t.enterText(input, '1234');
    await d.settle();
    expect(
      d.t
          .widget<EditableText>(d.inside(find.byType(EditableText)))
          .controller
          .text,
      '1234',
    );
    expect(d.text('1'), findsOneWidget);
    expect(d.text('4'), findsOneWidget);
    expect(await d.pixels(), isNot(equals(invalid)));
  });
  check('Wake Slider', (d) async {
    final before = await d.pixels();
    await d.t.drag(d.key, const Offset(90, 0));
    await d.settle();
    expect(await d.pixels(), isNot(equals(before)));
  });
  check('Comet Dial', (d) async {
    expect(d.text('0'), findsOneWidget);
    await d.t.timedDrag(
      d.key,
      const Offset(280, 0),
      const Duration(milliseconds: 800),
    );
    await d.t.pump();
    expect(
      d.text('100'),
      findsOneWidget,
      reason:
          'Rendered labels: ${d.t.widgetList<Text>(d.inside(find.byType(Text))).map((t) => t.data).toList()}',
    );
  });
  check('Hold Button', (d) async {
    var gesture = await d.t.startGesture(d.t.getCenter(d.key));
    await d.t.pump(const Duration(milliseconds: 250));
    await gesture.up();
    await d.settle();
    expect(d.text('Deleted'), findsNothing);
    gesture = await d.t.startGesture(d.t.getCenter(d.key));
    await d.until(d.text('Deleted'));
    await gesture.up();
    await d.t.pump();
    expect(d.text('Deleted'), findsOneWidget);
  });
  check('Pulse Heart', (d) async {
    await d.tap(d.key);
    expect(d.text('129'), findsOneWidget);
    await d.settle();
    await d.tap(d.key);
    expect(d.text('128'), findsOneWidget);
  });
  check('Slide Commit', (d) async {
    await d.t.drag(d.key, const Offset(270, 0));
    await d.t.pump();
    expect(find.byKey(const Key('slide-pending')), findsOneWidget);
    await d.until(d.text('Paid'));
    await d.until(d.text('Paid'), absent: true);
  });
  check('Fuse Button', (d) async {
    await d.tap(d.key);
    expect(d.text('Undo').hitTestable(), findsOneWidget);
    await d.tap(d.key);
    expect(d.text('Archive').hitTestable(), findsOneWidget);
    await d.tap(d.key);
    await d.until(d.text('Archive').hitTestable());
  });
  check('Bell Toggle', (d) async {
    await d.tap(d.key);
    expect(d.text('Notify me'), findsOneWidget);
    await d.settle();
    await d.tap(d.key);
    expect(d.text('Muted'), findsOneWidget);
  });
  check('Sling Button', (d) async {
    await d.t.drag(d.key, const Offset(-100, 0));
    await d.t.pump();
    expect(d.text('Sent'), findsOneWidget);
    await d.until(d.text('Pull left to send'));
  });
  check('Dodge Field', (d) async {
    final mouse = await d.hover(d.text('Catch me'));
    for (var i = 0; i < 4 && d.text('Catch me').evaluate().isNotEmpty; i++) {
      await mouse.moveTo(d.t.getCenter(d.text('Catch me')) + Offset(i + 1, 0));
      await d.t.pump(const Duration(milliseconds: 400));
    }
    expect(d.text('Fine, you win'), findsOneWidget);
    await mouse.moveTo(Offset.zero);
    await d.settle();
    await d.tap(d.text('Fine, you win'));
    expect(d.text('Catch me'), findsOneWidget);
  });
  check('Swipe Row', (d) async {
    await d.t.drag(d.text('Inbox from Leo'), const Offset(-100, 0));
    await d.settle();
    await d.tap(d.text('Delete'));
    expect(d.text('Restore row').hitTestable(), findsOneWidget);
    await d.tap(d.text('Restore row').hitTestable());
    expect(d.text('Inbox from Leo'), findsOneWidget);
  });
  check('Warm Tooltip', (d) async {
    Finder tool(IconData icon) =>
        find.descendant(of: d.key, matching: find.byIcon(icon));
    final mouse = await d.hover(tool(Icons.cut_rounded));
    await d.t.pump(const Duration(milliseconds: 650));
    await d.settle();
    double opacity(String label) => d.t
        .widget<Opacity>(
          find
              .ancestor(of: d.text(label), matching: find.byType(Opacity))
              .first,
        )
        .opacity;
    expect(opacity('Cut'), 1);
    await mouse.moveTo(d.t.getCenter(tool(Icons.content_copy_rounded)));
    await d.t.pump(const Duration(milliseconds: 300));
    await d.settle();
    expect(opacity('Copy'), 1);
  });
  check('Swipe Toast', (d) async {
    await d.tap(d.text('Notify'));
    await d.t.pump(const Duration(milliseconds: 450));
    expect(d.text('Mix saved the draft').hitTestable(), findsOneWidget);
    await d.t.drag(
      d.text('Mix saved the draft').hitTestable(),
      const Offset(0, 80),
    );
    await d.t.pump();
    expect(d.text('Mix saved the draft').hitTestable(), findsNothing);
    await d.tap(d.text('Notify'));
    await d.t.pump(const Duration(milliseconds: 450));
    await d.until(d.text('Mix saved the draft').hitTestable(), absent: true);
  });
  check('Folder Float', (d) async {
    final before = d.bounds(d.text('Tokens')).center.dy;
    final mouse = await d.hover(d.key);
    await d.settle();
    expect(d.bounds(d.text('Tokens')).center.dy, lessThan(before - 40));
    await mouse.moveTo(Offset.zero);
    await d.settle();
    expect(d.bounds(d.text('Tokens')).center.dy, closeTo(before, 1));
  });
  check('Branched Menu', (d) async {
    await d.tap(d.text('Motion'));
    expect(d.text('Tokens').hitTestable(), findsNothing);
    await d.settle();
    expect(d.text('Spring'), findsOneWidget);
    await d.tap(d.text('Keyframes'));
    await d.settle();
    expect(d.color('Keyframes'), snacksColors()[$accent]);
  });
  check('Lattice Loader', (d) async {
    await d.tap(d.key);
    expect(d.text('Thinking'), findsOneWidget);
    await d.until(d.text('Shipped'));
    expect(d.text('1.7s'), findsOneWidget);
    await d.tap(d.key);
    expect(d.text('Thinking'), findsOneWidget);
  });
  check('Status Mark', (d) async {
    for (final label in ['Running', 'Done', 'Failed', 'Idle']) {
      await d.tap(d.key);
      expect(d.text(label), findsOneWidget);
      // The running arc is infinite: never pumpAndSettle while it is active.
      await d.t.pump(const Duration(milliseconds: 250));
    }
  });
  check('Call Chip', (d) async {
    final width = d.t.getSize(d.key).width;
    await d.tap(d.key);
    await d.until(d.text('search_docs  done'));
    await d.tap(d.key);
    await d.until(d.text('search_docs  retry'));
    expect(d.t.getSize(d.key).width, width);
  });
  check('Prompt Bar', (d) async {
    final input = d.inside(find.byType(TextField));
    await d.t.enterText(input, 'First request');
    await d.t.pump();
    await d.tap(d.inside(find.byIcon(Icons.arrow_upward_rounded)));
    expect(d.inside(find.byIcon(Icons.stop_rounded)), findsOneWidget);
    await d.tap(d.inside(find.byIcon(Icons.stop_rounded)));
    await d.t.pump(const Duration(seconds: 1));
    expect(d.text('First request'), findsOneWidget);
    await d.t.enterText(input, 'New request');
    await d.t.pump();
    await d.tap(d.inside(find.byIcon(Icons.arrow_upward_rounded)));
    await d.until(d.text('New request'), absent: true);
  });
  check('Voice Pill', (d) async {
    final width = d.t.getSize(d.key).width;
    final gesture = await d.t.startGesture(d.t.getCenter(d.key));
    await d.t.pump(const Duration(milliseconds: 500));
    expect(d.t.getSize(d.key).width, greaterThan(width));
    final first = await d.pixels();
    await d.t.pump(const Duration(milliseconds: 200));
    expect(await d.pixels(), isNot(equals(first)));
    await gesture.up();
    await d.settle();
    expect(d.t.getSize(d.key).width, closeTo(width, 1));
  });
  check('Thought Line', (d) async {
    await d.tap(d.key);
    await d.until(d.text('Read the tokens').hitTestable());
    await d.until(d.text('Sketch the motion').hitTestable());
    await d.until(d.text('Commit the style').hitTestable());
    await d.until(d.text('Thought for 1.3s'));
  });
  check('Refine Frame', (d) async {
    for (final label in ['Generating', 'Refining', 'Complete', 'Queued']) {
      await d.tap(d.key);
      await d.settle();
      expect(d.text(label), findsOneWidget);
    }
  });
  check('Slosh Gauge', (d) async {
    final vessel = find.descendant(
      of: d.key,
      matching: find.byType(GestureDetector),
    );
    await d.t.drag(vessel, const Offset(0, -200));
    await d.settle();
    expect(d.text('100%'), findsOneWidget);
    await d.t.drag(vessel, const Offset(0, 200));
    await d.settle();
    expect(d.text('0%'), findsOneWidget);
  });
}

class _Demo {
  _Demo(this.t, this.title);
  final WidgetTester t;
  final String title;
  Finder get card => find.byKey(Key('demo-$title'));
  Finder get key => find.byKey(Key(title.toLowerCase().replaceAll(' ', '-')));
  Finder inside(Finder finder) => find.descendant(of: card, matching: finder);
  Finder text(String value) => inside(find.text(value));
  Color? color(String value) => t.widget<Text>(text(value)).style?.color;
  Rect bounds(Finder finder) {
    final box = t.renderObject<RenderBox>(finder);
    return MatrixUtils.transformRect(
      box.getTransformTo(null),
      Offset.zero & box.size,
    );
  }

  Future<void> tap(Finder finder) async {
    await t.tap(finder);
    await t.pump();
  }

  Future<void> settle() => t.pumpAndSettle(
    const Duration(milliseconds: 50),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 5),
  );

  Future<void> until(Finder finder, {bool absent = false}) async {
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (finder.evaluate().isEmpty != absent &&
        DateTime.now().isBefore(deadline)) {
      await t.pump(const Duration(milliseconds: 40));
    }
    expect(finder, absent ? findsNothing : findsOneWidget);
  }

  Future<TestGesture> hover(Finder finder) async {
    final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(t.getCenter(finder));
    await t.pump();
    addTearDown(mouse.removePointer);
    return mouse;
  }

  Future<List<int>> pixels() async {
    final boundary = t.renderObject<RenderRepaintBoundary>(
      find.byKey(const Key('integration-snapshot')),
    );
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    return bytes!.buffer.asUint8List();
  }
}
