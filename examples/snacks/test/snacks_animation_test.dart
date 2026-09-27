import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:example_snacks/gallery/examples.dart';
import 'package:example_snacks/gallery/theme.dart';
import 'helpers/snacks_test_harness.dart';

void main() {
  Future<void> press(WidgetTester t, String key) async {
    await t.tap(keyed(key));
    await t.pump();
  }

  Future<TestGesture> dragStart(
    WidgetTester t,
    Finder target,
    Offset delta,
  ) async {
    final g = await t.startGesture(t.getCenter(target));
    await g.moveBy(delta / delta.distance * 24);
    await t.pump();
    await g.moveBy(delta);
    await t.pump(const Duration(milliseconds: 16));
    return g;
  }

  Future<TestGesture> mouse(WidgetTester t, Finder target) async {
    final p = await t.createGesture(kind: PointerDeviceKind.mouse);
    await p.addPointer(location: Offset.zero);
    await p.moveTo(t.getCenter(target));
    await t.pump();
    addTearDown(p.removePointer);
    return p;
  }

  testWidgets('closed inbox has no red fringe and reveal exposes danger', (
    t,
  ) async {
    await pumpBit(t, const SwipeRow());
    Future<int> redPixels() async {
      final data = await pixels(t);
      var count = 0;
      for (var i = 0; i < data.length; i += 4) {
        if (data[i] > data[i + 1] * 1.5 && data[i] > data[i + 2] * 1.2) count++;
      }
      return count;
    }

    expect(await redPixels(), 0);
    await t.drag(find.text('Inbox from Leo'), const Offset(-90, 0));
    await t.pumpAndSettle();
    expect(await redPixels(), greaterThan(100));
  });

  testWidgets(
    'folder hides closed cards and opens three separated in-bounds cards',
    (t) async {
      await pumpBit(t, const FolderFloat());
      double opacity(int i) => t
          .widget<Opacity>(
            find
                .ancestor(
                  of: keyed('folder-note-$i'),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity;
      for (var i = 0; i < 3; i++) {
        expect(opacity(i), 0);
      }
      final pointer = await mouse(t, keyed('folder-float'));
      await t.pump(const Duration(milliseconds: 600));
      final stage = paintedBounds(t, keyed('folder-float'));
      Rect? previous;
      for (var i = 0; i < 3; i++) {
        expect(opacity(i), 1);
        final rect = paintedBounds(t, decoration(keyed('folder-note-$i')));
        expect(
          stage.contains(rect.topLeft),
          isTrue,
          reason: "stage=$stage note=$rect",
        );
        expect(
          stage.contains(rect.bottomRight),
          isTrue,
          reason: "stage=$stage note=$rect",
        );
        if (previous != null) {
          expect(previous.right, lessThan(rect.left));
        }
        previous = rect;
      }
      await pointer.moveTo(Offset.zero);
      await t.pumpAndSettle();
      for (var i = 0; i < 3; i++) {
        expect(opacity(i), 0);
      }
    },
  );

  testWidgets(
    'prompt aligns input and send tile with symmetric vertical inset',
    (t) async {
      await pumpBit(t, const PromptBar());
      final bar = t.getRect(keyed('prompt-bar'));
      final tile = t.getRect(find.byType(PressableBox));
      final field = t.getRect(find.byType(TextField));
      expect(bar.height, 50);
      expect(tile.top - bar.top, 8);
      expect(bar.bottom - tile.bottom, 8);
      expect(bar.right - tile.right, 8);
      expect(field.center.dy, tile.center.dy);
      await t.enterText(
        find.byType(TextField),
        'A longer prompt for stable alignment',
      );
      await t.pump();
      expect(t.getRect(keyed('prompt-bar')), bar);
    },
  );

  testWidgets('switch taps and springs between endpoints', (t) async {
    await pumpBit(t, const SquishSwitch());
    final thumb = find
        .descendant(
          of: keyed('squish-switch'),
          matching: find.byType(DecoratedBox),
        )
        .last;
    final off = paintedBounds(t, thumb).center.dx;
    await press(t, 'squish-switch');
    await t.pump(const Duration(milliseconds: 140));
    expect(paintedBounds(t, thumb).center.dx, greaterThan(off + 5));
    await t.pump(const Duration(seconds: 1));
    expect(paintedBounds(t, thumb).center.dx - off, closeTo(38, 0.2));
    await press(t, 'squish-switch');
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    expect(paintedBounds(t, thumb).center.dx, closeTo(off, 0.2));
    expect(paintedBounds(t, thumb).width, closeTo(30, 0.1));
  });
  testWidgets('rating previews on hover, restores on exit and commits on tap', (
    t,
  ) async {
    await pumpBit(t, const PeekRating());
    final stars = find.byType(PressableBox);
    final p = await mouse(t, stars.last);
    expect(find.text('Peek 5'), findsOneWidget);
    await p.moveTo(Offset.zero);
    await t.pump();
    expect(find.text('3 / 5'), findsOneWidget);
    await t.tap(stars.at(1));
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('2 / 5'), findsOneWidget);
  });
  testWidgets(
    'spring check has 28px geometry, centered tick, spring fill and reversal',
    (t) async {
      await pumpBit(t, const SpringCheck());
      final fill = decoration(keyed('spring-check-fill'));
      expect(t.getSize(keyed('spring-check')).height, 44);
      expect(t.getSize(fill), const Size(28, 28));
      expect(paintedBounds(t, fill).width, closeTo(0.28, 0.1));
      await press(t, 'spring-check');
      await t.pump(const Duration(milliseconds: 140));
      expect(paintedBounds(t, fill).width, inExclusiveRange(2, 34));
      await t.pump(const Duration(seconds: 1));
      expect(paintedBounds(t, fill).width, closeTo(28, 0.1));
      expect(
        (paintedBounds(t, find.byIcon(Icons.check_rounded)).center -
                paintedBounds(t, fill).center)
            .distance,
        lessThan(0.1),
      );
      await press(t, 'spring-check');
      await t.pump(const Duration(milliseconds: 60));
      await press(t, 'spring-check');
      await t.pump(const Duration(seconds: 1));
      expect(paintedBounds(t, fill).width, closeTo(28, 0.1));
    },
  );
  testWidgets('segment stretches in transit and settles without moving slots', (
    t,
  ) async {
    await pumpBit(t, const RubberSegment());
    final before = t.getCenter(find.text('Month'));
    final capsule = find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == snacksColors()[$ink],
    );
    expect(paintedBounds(t, capsule).width, closeTo(80, .1));
    await t.tap(find.text('Month'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 90));
    expect(paintedBounds(t, capsule).width, greaterThan(84));
    await t.pump(const Duration(milliseconds: 500));
    expect(paintedBounds(t, capsule).width, closeTo(80, .1));
    expect(textColor(t, 'Month'), snacksColors()[$page]);
    expect(textColor(t, 'Week'), snacksColors()[$muted]);
    expect(t.getCenter(find.text('Month')), before);
  });
  testWidgets('jelly radio selects and expands chosen chip', (t) async {
    await pumpBit(t, const JellyRadio());
    final before = t.getSize(find.byType(PressableBox).first);
    await t.tap(find.text('Quiet'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 600));
    expect(textColor(t, 'Quiet'), snacksColors()[$page]);
    expect(textColor(t, 'Focus'), snacksColors()[$ink]);
    expect(
      t.getSize(find.byType(PressableBox).first).width,
      greaterThan(before.width),
    );
  });
  testWidgets(
    'select opens and closes through frames without moving its trigger',
    (t) async {
      await pumpBit(t, const GlideSelect());
      final origin = t.getCenter(keyed('glide-select'));
      await press(t, 'glide-select');
      await t.pump();
      double opacity() => t
          .widget<Opacity>(
            find
                .descendant(
                  of: keyed('glide-menu'),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity;
      await t.pump(const Duration(milliseconds: 60));
      expect(opacity(), inExclusiveRange(0, 1));
      expect(t.getCenter(keyed('glide-select')), origin);
      await t.pump(const Duration(milliseconds: 150));
      expect(opacity(), 1);
      final p = await mouse(t, find.text('Grok'));
      await t.pump(const Duration(milliseconds: 250));
      final before = paintedBounds(t, decoration(keyed('glide-highlight'))).top;
      await p.moveTo(t.getCenter(find.text('Claude')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 100));
      final mid = paintedBounds(t, decoration(keyed('glide-highlight'))).top;
      expect(mid, inExclusiveRange(before - 31, before));
      await t.pump(const Duration(milliseconds: 150));
      await t.tap(find.text('Claude'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 60));
      expect(opacity(), inExclusiveRange(0, 1));
      expect(find.text('Grok').hitTestable(), findsNothing);
      await press(
        t,
        'glide-select',
      ); // reverse before the outgoing portal unmounts
      await t.pump(const Duration(milliseconds: 200));
      expect(opacity(), 1);
      await press(t, 'glide-select');
      await t.pump(const Duration(milliseconds: 150));
      expect(keyed('glide-menu'), findsNothing);
      expect(find.text('Claude'), findsOneWidget);
      expect(t.getCenter(keyed('glide-select')), origin);
    },
  );
  testWidgets('scrub field drags and clamps typed input at stable width', (
    t,
  ) async {
    await pumpBit(t, const ScrubField());
    final width = t.getSize(keyed('scrub-field')).width;
    await t.drag(keyed('scrub-field'), const Offset(80, 0));
    await t.pump();
    expect(find.text('24 px'), findsNothing);
    await press(t, 'scrub-field');
    expect(t.getSize(keyed('scrub-field')).width, width);
    await t.enterText(find.byType(TextField), '999');
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pump();
    expect(find.text('100 px'), findsOneWidget);
    expect(t.getSize(keyed('scrub-field')).width, width);
  });
  testWidgets(
    'code slots limit actual input, show success/error and allow correction',
    (t) async {
      await pumpBit(t, const CodeSlots());
      await t.enterText(find.byType(TextField), '12a3b45');
      await t.pump();
      await t.pump(const Duration(milliseconds: 500));
      expect(
        t.widget<EditableText>(find.byType(EditableText)).controller.text,
        '1234',
      );
      final valid = await pixels(t);
      await t.enterText(find.byType(TextField), '9999');
      await t.pump();
      await t.pump(const Duration(milliseconds: 500));
      expect(await pixels(t), isNot(equals(valid)));
      await t.enterText(find.byType(TextField), '123');
      await t.pump();
      expect(find.text('4'), findsNothing);
      expect(find.text('3'), findsOneWidget);
    },
  );
  testWidgets('wake paints live bars and clears wake on cancellation', (
    t,
  ) async {
    await pumpBit(t, const WakeSlider());
    final before = await pixels(t);
    final g = await dragStart(t, keyed('wake-slider'), const Offset(70, 0));
    final live = await pixels(t);
    expect(live, isNot(equals(before)));
    await g.cancel();
    await t.pump();
    await t.pump(const Duration(milliseconds: 160));
    expect(await pixels(t), isNot(equals(live)));
    await t.pump(const Duration(milliseconds: 200));
    expect(await pixels(t), isNot(equals(before)));
  });
  testWidgets('comet updates and clamps number, clears trail on cancellation', (
    t,
  ) async {
    await pumpBit(t, const CometDial());
    expect(find.text('0'), findsOneWidget);
    final g = await dragStart(t, keyed('comet-dial'), const Offset(400, 0));
    expect(find.text('100'), findsOneWidget);
    final moving = await pixels(t);
    await g.cancel();
    await t.pump();
    expect(find.text('100'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 160));
    expect(await pixels(t), isNot(equals(moving)));
    await t.pump(const Duration(milliseconds: 200));
  });
  testWidgets(
    'hold rolls back early release and preserves success until next press',
    (t) async {
      await pumpBit(t, const HoldButton());
      final labelCenter = t.getCenter(find.text('Hold to delete')).dy;
      var g = await t.startGesture(t.getCenter(keyed('hold-button')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      expect(find.text('Hold to delete'), findsOneWidget);
      await g.up();
      await t.pump(const Duration(seconds: 1));
      expect(find.text('Deleted'), findsNothing);
      g = await t.startGesture(t.getCenter(keyed('hold-button')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 950));
      expect(find.text('Deleted'), findsOneWidget);
      expect(t.getCenter(find.text('Deleted')).dy, closeTo(labelCenter, 0.1));
      await g.up();
      await t.pump();
      expect(find.text('Deleted'), findsOneWidget);
      expect(t.getCenter(find.text('Deleted')).dy, closeTo(labelCenter, 0.1));
      await press(t, 'hold-button');
      expect(find.text('Hold to delete'), findsOneWidget);
    },
  );
  testWidgets('heart contracts then settles and toggles count back', (t) async {
    await pumpBit(t, const PulseHeart());
    final initial = paintedBounds(
      t,
      find.byIcon(Icons.favorite_border_rounded),
    ).width;
    await press(t, 'pulse-heart');
    await t.pump(const Duration(milliseconds: 80));
    expect(find.text('129'), findsOneWidget);
    expect(
      paintedBounds(t, find.byIcon(Icons.favorite_rounded)).width,
      lessThan(initial * 0.98),
    );
    await t.pump(const Duration(seconds: 1));
    expect(
      paintedBounds(t, find.byIcon(Icons.favorite_rounded)).width,
      closeTo(initial, 0.1),
    );
    await press(t, 'pulse-heart');
    await t.pump(const Duration(seconds: 1));
    expect(find.text('128'), findsOneWidget);
  });
  testWidgets(
    'slide uses one inset capsule, requires full travel and expands on success',
    (t) async {
      await pumpBit(t, const SlideCommit());
      final capsule = decoration(keyed('slide-capsule'));
      final track = t.getRect(keyed('slide-commit'));
      expect(t.getSize(keyed('slide-commit')), const Size(280, 56));
      expect(paintedBounds(t, capsule).width, closeTo(48, .1));
      expect(paintedBounds(t, capsule).height, closeTo(48, .1));
      expect(paintedBounds(t, capsule).left, closeTo(track.left + 4, .1));
      var g = await dragStart(t, keyed('slide-commit'), const Offset(170, 0));
      await g.up();
      await t.pump();
      expect(keyed('slide-pending'), findsNothing);
      await t.pump(const Duration(seconds: 1));
      expect(paintedBounds(t, capsule).left, closeTo(track.left + 4, .1));
      g = await dragStart(t, keyed('slide-commit'), const Offset(240, 0));
      await g.cancel();
      await t.pump(const Duration(seconds: 1));
      expect(keyed('slide-pending'), findsNothing);
      g = await dragStart(t, keyed('slide-commit'), const Offset(240, 0));
      await g.up();
      await t.pump();
      expect(keyed('slide-pending'), findsOneWidget);
      await t.pump(const Duration(milliseconds: 700));
      expect(find.text('Paid'), findsOneWidget);
      await t.pump(const Duration(milliseconds: 160));
      expect(paintedBounds(t, capsule).width, inExclusiveRange(48, 272));
      await t.pump(const Duration(milliseconds: 600));
      expect(paintedBounds(t, capsule).width, closeTo(272, .1));
      expect(paintedBounds(t, capsule).left, closeTo(track.left + 4, .1));
      await t.pump(const Duration(milliseconds: 740));
      await t.pump(const Duration(seconds: 1));
      expect(find.text('Paid'), findsNothing);
      expect(paintedBounds(t, capsule).width, closeTo(48, .1));
      expect(paintedBounds(t, capsule).height, closeTo(48, .1));
    },
  );
  testWidgets('undo burns an outline for four seconds, cancels and restarts', (
    t,
  ) async {
    await pumpBit(t, const FuseButton());
    Finder face(String label) => find.text(label).hitTestable();
    Future<int> amberPixels() async {
      final data = await pixels(t);
      final color = snacksColors()[$warning]!.toARGB32();
      var count = 0;
      for (var i = 0; i < data.length; i += 4) {
        if (data[i] == (color >> 16 & 255) &&
            data[i + 1] == (color >> 8 & 255) &&
            data[i + 2] == (color & 255)) {
          count++;
        }
      }
      return count;
    }

    expect(t.getSize(keyed('fuse-button')), const Size(148, 44));
    await press(t, 'fuse-button');
    await t.pump(const Duration(milliseconds: 250));
    expect(face('Undo'), findsOneWidget);
    expect(face('Archive'), findsNothing);
    final full = await amberPixels();
    expect(full, greaterThan(20));
    await t.pump(const Duration(milliseconds: 1750));
    expect(await amberPixels(), inExclusiveRange(0, full * .8));
    await press(t, 'fuse-button');
    expect(face('Archive'), findsOneWidget);
    await press(t, 'fuse-button');
    await t.pump(const Duration(milliseconds: 3000));
    expect(face('Undo'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 1100));
    expect(face('Archive'), findsOneWidget);
  });
  testWidgets(
    'undo pauses on hover re-entry but not the initial activating hover',
    (t) async {
      await pumpBit(t, const FuseButton());
      final p = await mouse(t, keyed('fuse-button'));
      await press(t, 'fuse-button');
      await t.pump(const Duration(seconds: 1));
      await p.moveTo(Offset.zero);
      await t.pump();
      await p.moveTo(t.getCenter(keyed('fuse-button')));
      await t.pump();
      await t.pump(const Duration(seconds: 5));
      expect(find.text('Undo').hitTestable(), findsOneWidget);
      await p.moveTo(Offset.zero);
      await t.pump();
      await t.pump(const Duration(milliseconds: 3100));
      expect(find.text('Archive').hitTestable(), findsOneWidget);
    },
  );
  testWidgets('bell rings, settles and toggles label and icon', (t) async {
    await pumpBit(t, const BellToggle());
    await press(t, 'bell-toggle');
    await t.pump(const Duration(milliseconds: 70));
    expect(find.text('Notify me'), findsOneWidget);
    final mid = paintedBounds(
      t,
      find.byIcon(Icons.notifications_active_rounded),
    );
    await t.pump(const Duration(milliseconds: 600));
    expect(
      paintedBounds(t, find.byIcon(Icons.notifications_active_rounded)).size,
      isNot(mid.size),
    );
    await press(t, 'bell-toggle');
    expect(find.text('Muted'), findsOneWidget);
  });
  testWidgets('sling retracts, cancels, sends past threshold and resets', (
    t,
  ) async {
    await pumpBit(t, const SlingButton());
    var g = await dragStart(t, keyed('sling-button'), const Offset(-60, 0));
    await g.moveBy(const Offset(50, 0));
    await g.up();
    await t.pump();
    expect(find.text('Sent'), findsNothing);
    g = await dragStart(t, keyed('sling-button'), const Offset(-60, 0));
    await g.cancel();
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    expect(find.text('Sent'), findsNothing);
    g = await dragStart(t, keyed('sling-button'), const Offset(-60, 0));
    await g.up();
    await t.pump();
    expect(find.text('Sent'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 700));
    expect(find.text('Pull left to send'), findsOneWidget);
  });
  testWidgets('dodge flees three approaches then yields and resets', (t) async {
    await pumpBit(t, const DodgeField());
    final p = await mouse(t, find.text('Catch me'));
    for (var i = 0; i < 3; i++) {
      await p.moveTo(t.getCenter(find.text('Catch me')) + Offset(i + 1.0, 0));
      await t.pump(const Duration(milliseconds: 400));
      if (find.text('Fine, you win').evaluate().isNotEmpty) break;
    }
    expect(find.text('Fine, you win'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 500));
    expect(
      (t.getCenter(find.text('Fine, you win')) -
              t.getCenter(keyed('dodge-field')))
          .distance,
      lessThan(0.1),
    );
    await t.tap(find.text('Fine, you win'));
    await t.pump();
    expect(find.text('Catch me'), findsOneWidget);
  });
  testWidgets(
    'swipe row cancels, reveals actionable Delete, restores and swipes through',
    (t) async {
      await pumpBit(t, const SwipeRow());
      var g = await dragStart(
        t,
        find.text('Inbox from Leo'),
        const Offset(-70, 0),
      );
      await g.cancel();
      await t.pump(const Duration(milliseconds: 600));
      expect(find.text('Inbox from Leo'), findsOneWidget);
      g = await dragStart(t, find.text('Inbox from Leo'), const Offset(-70, 0));
      await g.up();
      await t.pump();
      await t.pump(const Duration(milliseconds: 600));
      await t.tap(find.text('Delete'));
      await t.pump();
      expect(find.text('Restore row').hitTestable(), findsOneWidget);
      await t.tap(find.text('Restore row').hitTestable());
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      expect(find.text('Inbox from Leo'), findsOneWidget);
      await t.drag(find.text('Inbox from Leo'), const Offset(-220, 0));
      await t.pump();
      expect(find.text('Restore row').hitTestable(), findsOneWidget);
    },
  );
  testWidgets(
    'tooltip cold delay, warm sibling and cooldown are deterministic',
    (t) async {
      await pumpBit(t, const WarmTooltip());
      double opacity(String text) => t
          .widget<Opacity>(
            find
                .ancestor(of: find.text(text), matching: find.byType(Opacity))
                .first,
          )
          .opacity;
      final p = await mouse(t, find.byIcon(Icons.cut_rounded));
      await t.pump(const Duration(milliseconds: 200));
      expect(opacity('Cut'), 0);
      await t.pump(const Duration(milliseconds: 80));
      await t.pump(const Duration(milliseconds: 300));
      expect(opacity('Cut'), 1);
      await p.moveTo(t.getCenter(find.byIcon(Icons.content_copy_rounded)));
      await t.pump();
      await t.pump(const Duration(milliseconds: 250));
      expect(opacity('Copy'), 1);
      await p.moveTo(Offset.zero);
      await t.pump(const Duration(milliseconds: 750));
      await p.moveTo(t.getCenter(find.byIcon(Icons.content_paste_rounded)));
      await t.pump(const Duration(milliseconds: 200));
      expect(opacity('Paste'), 0);
      await t.pump(const Duration(milliseconds: 80));
      await t.pump(const Duration(milliseconds: 300));
      expect(opacity('Paste'), 1);
    },
  );
  testWidgets('toast expires, restarts deadline and swipes away', (t) async {
    await pumpBit(t, const SwipeToast());
    await t.tap(find.text('Notify'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 1));
    await t.pump(const Duration(milliseconds: 100));
    final midHeight = t.getSize(keyed('toast-reveal')).height;
    expect(midHeight, greaterThan(0));
    await t.pump(const Duration(milliseconds: 300));
    expect(t.getSize(keyed('toast-reveal')).height, greaterThan(midHeight));
    expect(find.text('Mix saved the draft'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 1200));
    expect(
      t.getSize(decoration(keyed('toast-fuse'))).width,
      inExclusiveRange(30, 180),
    );
    await t.tap(find.text('Notify'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 1));
    await t.pump(const Duration(milliseconds: 1600));
    expect(find.text('Mix saved the draft'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 1100));
    expect(find.text('Mix saved the draft').hitTestable(), findsNothing);
    await t.tap(find.text('Notify'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 450));
    final g = await dragStart(
      t,
      find.text('Mix saved the draft'),
      const Offset(0, 70),
    );
    await g.up();
    await t.pump();
    await t.pump(const Duration(milliseconds: 100));
    expect(t.getSize(keyed('toast-reveal')).height, greaterThan(0));
    await t.pump(const Duration(milliseconds: 250));
    expect(t.getSize(keyed('toast-reveal')).height, 0);
    expect(find.text('Mix saved the draft').hitTestable(), findsNothing);
  });
  testWidgets(
    'folder floats notes on hover, closes on exit and toggles by touch',
    (t) async {
      await pumpBit(t, const FolderFloat());
      final closed = paintedBounds(t, find.text('Tokens')).center;
      final p = await mouse(t, keyed('folder-float'));
      await t.pump(const Duration(milliseconds: 600));
      expect(
        paintedBounds(t, find.text('Tokens')).center.dy,
        lessThan(closed.dy - 40),
      );
      await p.moveTo(Offset.zero);
      await t.pump();
      await t.pump(const Duration(milliseconds: 600));
      expect(
        paintedBounds(t, find.text('Tokens')).center.dy,
        closeTo(closed.dy, 0.2),
      );
      await t.tap(find.text('Files'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 600));
      expect(
        paintedBounds(t, find.text('Tokens')).center.dy,
        lessThan(closed.dy - 40),
      );
    },
  );
  testWidgets('branched menu changes section and highlights chosen child', (
    t,
  ) async {
    await pumpBit(t, const BranchedMenu());
    expect(find.text('Tokens'), findsOneWidget);
    await t.tap(find.text('Motion'));
    await t.pump();
    expect(find.text('Tokens').hitTestable(), findsNothing);
    await t.pump(const Duration(milliseconds: 100));
    final folding = t.getSize(keyed('branch-fold-1')).height;
    expect(folding, greaterThan(0));
    await t.pump(const Duration(milliseconds: 300));
    expect(t.getSize(keyed('branch-fold-1')).height, greaterThan(folding));
    expect(find.text('Spring'), findsOneWidget);
    await t.tap(find.text('Keyframes'));
    await t.pump();
    await t.pump(const Duration(milliseconds: 500));
    expect(textColor(t, 'Keyframes'), snacksColors()[$accent]);
    expect(textColor(t, 'Spring'), snacksColors()[$muted]);
  });
  testWidgets('lattice advances deterministic time, freezes and reruns', (
    t,
  ) async {
    await pumpBit(t, const LatticeLoader());
    await press(t, 'lattice-loader');
    await t.pump(const Duration(milliseconds: 900));
    expect(find.text('0.9s'), findsOneWidget);
    expect(find.text('Thinking'), findsOneWidget);
    await t.pump(const Duration(milliseconds: 810));
    expect(find.text('Shipped'), findsOneWidget);
    expect(find.text('1.7s'), findsOneWidget);
    await t.pump(const Duration(seconds: 2));
    expect(find.text('1.7s'), findsOneWidget);
    await press(t, 'lattice-loader');
    expect(find.text('Thinking'), findsOneWidget);
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 2));
  });
  testWidgets('status mark cycles four states and animates running arc', (
    t,
  ) async {
    await pumpBit(t, const StatusMark());
    await press(t, 'status-mark');
    expect(find.text('Running'), findsOneWidget);
    final first = await pixels(t);
    await t.pump(const Duration(milliseconds: 225));
    expect(await pixels(t), isNot(equals(first)));
    await press(t, 'status-mark');
    expect(find.text('Done'), findsOneWidget);
    await press(t, 'status-mark');
    expect(find.text('Failed'), findsOneWidget);
    await press(t, 'status-mark');
    expect(find.text('Idle'), findsOneWidget);
  });
  testWidgets(
    'call fills to success, repeats to retry and ignores busy presses',
    (t) async {
      await pumpBit(t, const CallChip());
      final width = t.getSize(keyed('call-chip')).width;
      await press(t, 'call-chip');
      await t.pump();
      await t.pump(const Duration(milliseconds: 450));
      expect(
        t.getSize(decoration(keyed('call-fill'))).width,
        inExclusiveRange(30, 150),
      );
      await press(t, 'call-chip');
      await t.pump(const Duration(milliseconds: 500));
      expect(find.text('search_docs  done'), findsOneWidget);
      await press(t, 'call-chip');
      await t.pump();
      await t.pump(const Duration(milliseconds: 950));
      expect(find.text('search_docs  retry'), findsOneWidget);
      expect(t.getSize(keyed('call-chip')).width, width);
    },
  );
  testWidgets(
    'prompt stop cancels stale completion and preserves a subsequent run',
    (t) async {
      await pumpBit(t, const PromptBar());
      await t.enterText(find.byType(TextField), 'First request');
      await t.pump();
      await t.tap(find.byIcon(Icons.arrow_upward_rounded));
      await t.pump();
      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
      await t.pump(const Duration(milliseconds: 400));
      await t.tap(find.byIcon(Icons.stop_rounded));
      await t.enterText(find.byType(TextField), 'New request');
      await t.pump();
      await t.tap(find.byIcon(Icons.arrow_upward_rounded));
      await t.pump();
      await t.pump(const Duration(milliseconds: 500));
      expect(find.text('New request'), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
      await t.pump(const Duration(milliseconds: 400));
      expect(find.text('New request'), findsNothing);
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    },
  );
  testWidgets(
    'voice hold animates waveform and clears on release or cancellation',
    (t) async {
      await pumpBit(t, const VoicePill());
      final idle = await pixels(t);
      var g = await t.startGesture(t.getCenter(keyed('voice-pill')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      final first = await pixels(t);
      expect(first, isNot(equals(idle)));
      await t.pump(const Duration(milliseconds: 175));
      expect(await pixels(t), isNot(equals(first)));
      await g.up();
      await t.pump();
      await t.pump(const Duration(milliseconds: 500));
      expect(pixelDifference(await pixels(t), idle), lessThan(0.001));
      g = await t.startGesture(t.getCenter(keyed('voice-pill')));
      await t.pump();
      await g.cancel();
      await t.pump();
      await t.pump(const Duration(milliseconds: 500));
      expect(pixelDifference(await pixels(t), idle), lessThan(0.001));
    },
  );
  testWidgets(
    'thought line shows all three steps before completing and restarts',
    (t) async {
      await pumpBit(t, const ThoughtLine());
      final heading = t.getTopLeft(find.text('Run thought'));
      await press(t, 'thought-line');
      await t.pump(const Duration(milliseconds: 180));
      expect(find.text('Read the tokens').hitTestable(), findsOneWidget);
      await t.pump(const Duration(milliseconds: 240));
      await t.pump(const Duration(milliseconds: 180));
      expect(find.text('Sketch the motion').hitTestable(), findsOneWidget);
      await t.pump(const Duration(milliseconds: 240));
      await t.pump(const Duration(milliseconds: 180));
      expect(find.text('Commit the style').hitTestable(), findsOneWidget);
      await t.pump(const Duration(milliseconds: 240));
      expect(find.text('Thought for 1.3s'), findsOneWidget);
      expect(t.getTopLeft(find.text('Thought for 1.3s')), heading);
      await press(t, 'thought-line');
      await t.pump(const Duration(milliseconds: 180));
      expect(find.text('Read the tokens').hitTestable(), findsOneWidget);
      await t.pumpWidget(const SizedBox());
      await t.pump(const Duration(seconds: 2));
    },
  );
  testWidgets('refine frame cycles labels and visibly resolves preview', (
    t,
  ) async {
    await pumpBit(t, const RefineFrame());
    final queued = await pixels(t);
    for (final label in ['Generating', 'Refining', 'Complete', 'Queued']) {
      await press(t, 'refine-frame');
      await t.pump(const Duration(milliseconds: 500));
      expect(find.text(label), findsOneWidget);
      if (label == 'Complete') expect(await pixels(t), isNot(equals(queued)));
    }
  });
  testWidgets('slosh tracks live input, clamps and settles after release', (
    t,
  ) async {
    await pumpBit(t, const SloshGauge());
    expect(find.text('42%'), findsOneWidget);
    final vessel = find.descendant(
      of: keyed('slosh-gauge'),
      matching: find.byType(GestureDetector),
    );
    final g = await dragStart(t, vessel, const Offset(0, -160));
    expect(find.text('100%'), findsOneWidget);
    final live = await pixels(t);
    await g.up();
    await t.pump();
    await t.pump(const Duration(milliseconds: 500));
    expect(find.text('100%'), findsOneWidget);
    expect(await pixels(t), isNot(equals(live)));
    await t.drag(vessel, const Offset(0, 200));
    await t.pump();
    expect(find.text('0%'), findsOneWidget);
    // Sample the release, not just its endpoint: height must never undershoot.
    for (var frame = 0; frame < 30; frame++) {
      await t.pump(const Duration(milliseconds: 16));
      expect(t.takeException(), isNull);
    }
  });
}
