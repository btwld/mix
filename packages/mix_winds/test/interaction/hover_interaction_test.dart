import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

const _red500 = Color(0xFFFB2C36);
const _blue500 = Color(0xFF2B7FFF);

Future<void> _pumpAtTopLeft(WidgetTester tester, Widget child) async {
  await tester.binding.setSurfaceSize(const Size(400, 400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(400, 400)),
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

double _effectiveOpacity(WidgetTester tester, Key key) {
  final finder = find.descendant(
    of: find.byKey(key),
    matching: find.byType(Opacity),
  );
  if (finder.evaluate().isEmpty) return 1;
  expect(finder, findsOneWidget);
  return tester.widget<Opacity>(finder).opacity;
}

Color? _textColor(WidgetTester tester, Key key) {
  final finder = find.descendant(
    of: find.byKey(key),
    matching: find.byType(Text),
  );
  expect(finder, findsOneWidget);
  return tester.widget<Text>(finder).style?.color;
}

Future<TestGesture> _mouse(WidgetTester tester) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: const Offset(-100, -100));
  await tester.pump();
  return gesture;
}

void main() {
  testWidgets('A1 hover changes a bare Div decoration and reverts on exit', (
    tester,
  ) async {
    const subject = Key('a1-div');
    await _pumpAtTopLeft(
      tester,
      const Div(
        key: subject,
        classNames: 'w-20 h-20 bg-red-500 hover:bg-blue-500',
      ),
    );

    expect(_decorationColor(tester, subject), _red500);

    final gesture = await _mouse(tester);
    await gesture.moveTo(tester.getCenter(_containerInside(subject)));
    await tester.pump();
    expect(_decorationColor(tester, subject), _blue500);

    await gesture.moveTo(const Offset(-100, -100));
    await tester.pump();
    expect(_decorationColor(tester, subject), _red500);
    await gesture.removePointer();
  });

  testWidgets('A2 margin stays outside the hover hit-test boundary', (
    tester,
  ) async {
    const subject = Key('a2-div');
    await _pumpAtTopLeft(
      tester,
      const Div(
        key: subject,
        classNames: 'm-8 w-20 h-20 bg-red-500 hover:bg-blue-500',
      ),
    );

    final container = _containerInside(subject);
    final innerRect = tester.getRect(container);
    final padding = find.descendant(
      of: find.byKey(subject),
      matching: find.byType(Padding),
    );
    expect(padding, findsWidgets);
    final outerRect = tester.getRect(padding.first);
    expect(innerRect.left - outerRect.left, 32);

    final gesture = await _mouse(tester);
    final leftMarginPoint = Offset(
      (outerRect.left + innerRect.left) / 2,
      innerRect.center.dy,
    );
    await gesture.moveTo(leftMarginPoint);
    await tester.pump();
    expect(_decorationColor(tester, subject), _red500);

    await gesture.moveTo(innerRect.center);
    await tester.pump();
    expect(_decorationColor(tester, subject), _blue500);
    await gesture.removePointer();
  });

  testWidgets('A3 not-hover opacity is removed while hovered', (tester) async {
    const subject = Key('a3-div');
    await _pumpAtTopLeft(
      tester,
      const Div(
        key: subject,
        classNames: 'not-hover:opacity-50 w-20 h-20 bg-red-500',
      ),
    );

    expect(_effectiveOpacity(tester, subject), 0.5);

    final gesture = await _mouse(tester);
    await gesture.moveTo(tester.getCenter(_containerInside(subject)));
    await tester.pump();
    expect(_effectiveOpacity(tester, subject), 1);
    await gesture.removePointer();
  });

  testWidgets('A4 hover changes decoration on the flex rendering path', (
    tester,
  ) async {
    const subject = Key('a4-div');
    await _pumpAtTopLeft(
      tester,
      const Div(
        key: subject,
        classNames: 'flex w-40 h-20 gap-2 bg-red-500 hover:bg-blue-500',
        children: [
          SizedBox(width: 10, height: 10),
          SizedBox(width: 10, height: 10),
        ],
      ),
    );

    expect(
      find.descendant(of: find.byKey(subject), matching: find.byType(Flex)),
      findsOneWidget,
    );
    expect(_decorationColor(tester, subject), _red500);

    final gesture = await _mouse(tester);
    await gesture.moveTo(tester.getCenter(_containerInside(subject)));
    await tester.pump();
    expect(_decorationColor(tester, subject), _blue500);
    await gesture.removePointer();
  });

  testWidgets('A5 hover changes rendered Span text color', (tester) async {
    const subject = Key('a5-span');
    await _pumpAtTopLeft(
      tester,
      const Div(
        classNames: 'w-40 h-20',
        child: Span(
          key: subject,
          text: 'hover target',
          classNames: 'text-red-500 hover:text-blue-500',
        ),
      ),
    );

    expect(_textColor(tester, subject), _red500);

    final text = find.descendant(
      of: find.byKey(subject),
      matching: find.byType(Text),
    );
    final gesture = await _mouse(tester);
    await gesture.moveTo(tester.getCenter(text));
    await tester.pump();
    expect(_textColor(tester, subject), _blue500);

    await gesture.moveTo(const Offset(-100, -100));
    await tester.pump();
    expect(_textColor(tester, subject), _red500);
    await gesture.removePointer();
  });
}
