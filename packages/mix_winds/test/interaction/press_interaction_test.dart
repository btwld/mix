import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_winds/mix_winds.dart';

const _red500 = Color(0xFFFB2C36);
const _blue500 = Color(0xFF2B7FFF);

Future<void> _pumpAtTopLeft(WidgetTester tester, Widget child) async {
  await tester.binding.setSurfaceSize(const Size(500, 400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(500, 400)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    ),
  );
  await tester.pump();
}

Finder _containerInside(Key key) =>
    find.descendant(of: find.byKey(key), matching: find.byType(Container));

Color? _decorationColor(WidgetTester tester, Key key) {
  final finder = _containerInside(key);
  expect(finder, findsOneWidget);
  final container = tester.widget<Container>(finder);
  return (container.decoration as BoxDecoration?)?.color;
}

void main() {
  testWidgets(
    'B1 active styles a held bare Div without making it a tap control',
    (tester) async {
      const subject = Key('b1-div');
      var ancestorTaps = 0;
      await _pumpAtTopLeft(
        tester,
        GestureDetector(
          onTap: () => ancestorTaps++,
          excludeFromSemantics: true,
          child: const Div(
            key: subject,
            classNames: 'w-20 h-20 bg-red-500 active:bg-blue-500',
          ),
        ),
      );

      expect(_decorationColor(tester, subject), _red500);
      final semantics = tester.getSemantics(find.byKey(subject));
      expect(
        semantics.getSemanticsData().hasAction(SemanticsAction.tap),
        isFalse,
      );

      final gesture = await tester.startGesture(
        tester.getCenter(_containerInside(subject)),
      );
      await tester.pump();
      expect(_decorationColor(tester, subject), _blue500);

      await gesture.up();
      await tester.pump();
      expect(_decorationColor(tester, subject), _red500);
      expect(ancestorTaps, 1);
    },
  );

  testWidgets('B2 Pressable propagates held state to active Div styling', (
    tester,
  ) async {
    const subject = Key('b2-div');
    await _pumpAtTopLeft(
      tester,
      Pressable(
        onPress: () {},
        child: const Div(
          key: subject,
          classNames: 'w-20 h-20 bg-red-500 active:bg-blue-500',
        ),
      ),
    );

    expect(_decorationColor(tester, subject), _red500);
    final gesture = await tester.startGesture(
      tester.getCenter(_containerInside(subject)),
    );
    await tester.pump();
    expect(_decorationColor(tester, subject), _blue500);

    await gesture.up();
    await tester.pump();
    expect(_decorationColor(tester, subject), _red500);
  });

  testWidgets(
    'B3 press state is shared by one Pressable but not independent ones',
    (tester) async {
      const sharedFirst = Key('b3-shared-first');
      const sharedSecond = Key('b3-shared-second');
      await _pumpAtTopLeft(
        tester,
        Pressable(
          onPress: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Div(
                key: sharedFirst,
                classNames: 'w-20 h-20 bg-red-500 active:bg-blue-500',
              ),
              Div(
                key: sharedSecond,
                classNames: 'w-20 h-20 bg-red-500 active:bg-blue-500',
              ),
            ],
          ),
        ),
      );

      final sharedGesture = await tester.startGesture(
        tester.getCenter(_containerInside(sharedFirst)),
      );
      await tester.pump();
      expect(_decorationColor(tester, sharedFirst), _blue500);
      expect(_decorationColor(tester, sharedSecond), _blue500);
      await sharedGesture.up();
      await tester.pump();

      const independentFirst = Key('b3-independent-first');
      const independentSecond = Key('b3-independent-second');
      await _pumpAtTopLeft(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Pressable(
              onPress: () {},
              child: const Div(
                key: independentFirst,
                classNames: 'w-20 h-20 bg-red-500 active:bg-blue-500',
              ),
            ),
            Pressable(
              onPress: () {},
              child: const Div(
                key: independentSecond,
                classNames: 'w-20 h-20 bg-red-500 active:bg-blue-500',
              ),
            ),
          ],
        ),
      );

      final independentGesture = await tester.startGesture(
        tester.getCenter(_containerInside(independentFirst)),
      );
      await tester.pump();
      expect(_decorationColor(tester, independentFirst), _blue500);
      expect(_decorationColor(tester, independentSecond), _red500);
      await independentGesture.up();
    },
  );

  testWidgets('B4 Button excludes margin from press styling and onPressed', (
    tester,
  ) async {
    const subject = Key('b4-div');
    var presses = 0;
    await _pumpAtTopLeft(
      tester,
      Button(
        key: subject,
        classNames: 'm-8 w-20 h-20 bg-red-500 active:bg-blue-500',
        onPressed: () => presses++,
      ),
    );

    final innerRect = tester.getRect(_containerInside(subject));
    final padding = find.descendant(
      of: find.byKey(subject),
      matching: find.byType(Padding),
    );
    final outerRect = tester.getRect(padding.first);
    final marginPoint = Offset(
      (outerRect.left + innerRect.left) / 2,
      innerRect.center.dy,
    );

    final gesture = await tester.startGesture(marginPoint);
    await tester.pump();
    final colorWhileHeld = _decorationColor(tester, subject);
    await gesture.up();
    await tester.pump();

    expect([colorWhileHeld, presses], [_red500, 0]);
  });
}
