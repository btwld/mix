import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

Future<Container> boxContainerFor(
  WidgetTester tester,
  String classNames,
) async {
  await pumpDiv(tester, classNames, child: const SizedBox());
  await tester.pump();

  final containerFinder = find.byType(Container);
  expect(containerFinder, findsOneWidget);

  return tester.widget<Container>(containerFinder);
}

Future<BoxDecoration?> boxDecorationFor(
  WidgetTester tester,
  String classNames,
) async {
  final container = await boxContainerFor(tester, classNames);
  return container.decoration as BoxDecoration?;
}

Future<BoxDecoration?> boxDecorationForWithConfig(
  WidgetTester tester,
  String classNames,
  TwConfig config,
) async {
  await pumpLtr(
    tester,
    TwScope(
      config: config,
      child: Div(classNames: classNames, child: const SizedBox()),
    ),
  );
  await tester.pump();

  final containerFinder = find.byType(Container);
  expect(containerFinder, findsOneWidget);

  final container = tester.widget<Container>(containerFinder);
  return container.decoration as BoxDecoration?;
}

Future<void> expectBoxShadows(
  WidgetTester tester,
  String classNames,
  List<BoxShadow> expected,
) async {
  final decoration = await boxDecorationFor(tester, classNames);
  final actual = decoration?.boxShadow;
  expect(actual ?? const <BoxShadow>[], orderedEquals(expected));
}

CurveAnimationConfig? parseAnimation(String classNames, {TwParser? parser}) {
  final p = parser ?? TwParser();
  return p.parseAnimationFromTokens(p.listTokens(classNames));
}

Future<Text> renderedTextFor(
  WidgetTester tester,
  String classNames, {
  String value = 'sample',
}) async {
  await pumpLtr(
    tester,
    StyledText(value, style: TwParser().parseText(classNames)),
  );
  await tester.pump();

  return tester.widget<Text>(find.text(value));
}

Future<void> pumpSized(
  WidgetTester tester,
  Widget child, {
  double width = 800,
  double height = 600,
}) async {
  await tester.binding.setSurfaceSize(Size(width, height));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> pumpLtr(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

EdgeInsets singlePaddingInsets(WidgetTester tester) {
  expect(find.byType(Padding), findsOneWidget);
  final padding = tester.widget<Padding>(find.byType(Padding));
  return padding.padding as EdgeInsets;
}

TwParser twParserWatching(List<String> sink) =>
    TwParser(onUnsupported: sink.add);

BoxStyler parseBoxWatching(String classNames, List<String> sink) {
  return twParserWatching(sink).parseBox(classNames);
}

Future<void> pumpDiv(
  WidgetTester tester,
  String classNames, {
  Widget child = const SizedBox(width: 40, height: 40),
}) async {
  await pumpLtr(tester, Div(classNames: classNames, child: child));
}

Future<TestGesture> createMouseGesture(
  WidgetTester tester, {
  Offset initialPosition = const Offset(-500, -500),
}) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: initialPosition);
  await tester.pump();
  return gesture;
}

Future<TestGesture> createOffscreenMouseGesture(WidgetTester tester) {
  return createMouseGesture(tester);
}
