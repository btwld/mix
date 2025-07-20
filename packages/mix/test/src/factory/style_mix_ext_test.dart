import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  final keyOne = UniqueKey();
  final keyTwo = UniqueKey();
  final keyThree = UniqueKey();
  testWidgets('Style.container matches StyledContainer(style:Style)', (
    tester,
  ) async {
    final style = Style($box.decoration(border: Border.all(color: Colors.red)));

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            style.container(key: keyOne, child: const SizedBox()),
            Box(style: style, key: keyTwo, child: const SizedBox()),
            Box(
              style: const Style.empty(),
              key: keyThree,
              child: const SizedBox(),
            ),
          ],
        ),
      ),
    );

    final containerOne = tester.widget<Box>(find.byKey(keyOne));
    final containerTwo = tester.widget<Box>(find.byKey(keyTwo));
    final containerThree = tester.widget<Box>(find.byKey(keyThree));

    expect(containerOne.style, style);
    expect(containerTwo.style, style);
    expect(containerThree.style, isNot(style));
  });

  testWidgets('Style.box matches StyledContainer(style:Style)', (tester) async {
    final style = Style($box.decoration(border: Border.all(color: Colors.red)));

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            style.box(key: keyOne, child: const SizedBox()),
            Box(style: style, key: keyTwo, child: const SizedBox()),
            Box(
              style: const Style.empty(),
              key: keyThree,
              child: const SizedBox(),
            ),
          ],
        ),
      ),
    );

    final containerOne = tester.widget<Box>(find.byKey(keyOne));
    final containerTwo = tester.widget<Box>(find.byKey(keyTwo));
    final containerThree = tester.widget<Box>(find.byKey(keyThree));

    expect(containerOne.style, style, reason: 'containerOne.style');
    expect(containerTwo.style, style, reason: 'containerTwo.style');
    expect(containerThree.style, isNot(style), reason: 'containerThree.style');
  });

  testWidgets('Style.hbox matches HBox(style:Style)', (tester) async {
    final style = Style($box.decoration(border: Border.all(color: Colors.red)));

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            style.hbox(key: keyOne, children: [const SizedBox()]),
            HBox(style: style, key: keyTwo, children: const [SizedBox()]),
            HBox(
              style: const Style.empty(),
              key: keyThree,
              children: const [SizedBox()],
            ),
          ],
        ),
      ),
    );

    final containerOne = tester.widget<HBox>(find.byKey(keyOne));
    final containerTwo = tester.widget<HBox>(find.byKey(keyTwo));
    final containerThree = tester.widget<HBox>(find.byKey(keyThree));

    expect(containerOne.style, style);
    expect(containerTwo.style, style);
    expect(containerThree.style, isNot(style));
  });

  testWidgets('Style.row matches HBox(style:Style)', (tester) async {
    final style = Style($box.decoration(border: Border.all(color: Colors.red)));

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            style.hbox(key: keyOne, children: [const SizedBox()]),
            HBox(style: style, key: keyTwo, children: const [SizedBox()]),
            HBox(
              style: const Style.empty(),
              key: keyThree,
              children: const [SizedBox()],
            ),
          ],
        ),
      ),
    );

    final containerOne = tester.widget<HBox>(find.byKey(keyOne));
    final containerTwo = tester.widget<HBox>(find.byKey(keyTwo));
    final containerThree = tester.widget<HBox>(find.byKey(keyThree));

    expect(containerOne.style, style);
    expect(containerTwo.style, style);
    expect(containerThree.style, isNot(style));
  });

  testWidgets('Style.text matches StyledText(style:Style)', (tester) async {
    final style = Style($text.style(color: Colors.red));

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            style.text('text', key: keyOne),
            StyledText('text', style: style, key: keyTwo),
            StyledText('text', style: const Style.empty(), key: keyThree),
          ],
        ),
      ),
    );

    final containerOne = tester.widget<StyledText>(find.byKey(keyOne));
    final containerTwo = tester.widget<StyledText>(find.byKey(keyTwo));
    final containerThree = tester.widget<StyledText>(find.byKey(keyThree));

    expect(containerOne.style, style);
    expect(containerTwo.style, style);
    expect(containerThree.style, isNot(style));
  });

  testWidgets('Style.vbox matches VBox(style:Style)', (tester) async {
    final style = Style($box.decoration(border: Border.all(color: Colors.red)));

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            style.vbox(key: keyOne, children: [const SizedBox()]),
            VBox(style: style, key: keyTwo, children: const [SizedBox()]),
            VBox(
              style: const Style.empty(),
              key: keyThree,
              children: const [SizedBox()],
            ),
          ],
        ),
      ),
    );

    final containerOne = tester.widget<VBox>(find.byKey(keyOne));
    final containerTwo = tester.widget<VBox>(find.byKey(keyTwo));
    final containerThree = tester.widget<VBox>(find.byKey(keyThree));

    expect(containerOne.style, style);
    expect(containerTwo.style, style);
    expect(containerThree.style, isNot(style));
  });

  testWidgets('Style.column matches VBox(style:Style)', (tester) async {
    final style = Style($box.decoration(border: Border.all(color: Colors.red)));

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            style.vbox(key: keyOne, children: [const SizedBox()]),
            VBox(style: style, key: keyTwo, children: const [SizedBox()]),
            VBox(
              style: const Style.empty(),
              key: keyThree,
              children: const [SizedBox()],
            ),
          ],
        ),
      ),
    );

    final containerOne = tester.widget<VBox>(find.byKey(keyOne));
    final containerTwo = tester.widget<VBox>(find.byKey(keyTwo));
    final containerThree = tester.widget<VBox>(find.byKey(keyThree));

    expect(containerOne.style, style);
    expect(containerTwo.style, style);
    expect(containerThree.style, isNot(style));
  });

  testWidgets('Style.icon matches StyledIcon(style:Style)', (tester) async {
    final style = Style($icon.color.red());

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            style.icon(Icons.ac_unit, key: keyOne),
            StyledIcon(Icons.ac_unit, style: style, key: keyTwo),
            StyledIcon(
              Icons.ac_unit,
              style: const Style.empty(),
              key: keyThree,
            ),
          ],
        ),
      ),
    );

    final containerOne = tester.widget<StyledIcon>(find.byKey(keyOne));
    final containerTwo = tester.widget<StyledIcon>(find.byKey(keyTwo));
    final containerThree = tester.widget<StyledIcon>(find.byKey(keyThree));

    expect(containerOne.style, style);
    expect(containerTwo.style, style);
    expect(containerThree.style, isNot(style));
  });
}
