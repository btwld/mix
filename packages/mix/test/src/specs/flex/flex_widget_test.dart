import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/override_modifiers_order.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  testWidgets('FlexSpec properties should match Flex properties',
      (WidgetTester tester) async {
    const flexSpec = FlexSpec(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      verticalDirection: VerticalDirection.down,
      textDirection: TextDirection.ltr,
      textBaseline: TextBaseline.alphabetic,
      clipBehavior: Clip.antiAlias,
      gap: 16,
    );

    const flexKey = Key('flex');
    const flexWidget = FlexSpecWidget(
      key: flexKey,
      spec: flexSpec,
      direction: Axis.horizontal,
      children: [Text('test')],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: flexWidget,
        ),
      ),
    );

    final flexFinder = find.byKey(flexKey);
    expect(flexFinder, findsOneWidget);

    final flex = tester.widget<Flex>(find.descendant(
      of: flexFinder,
      matching: find.byType(Flex),
    ));

    expect(flex.direction, flexSpec.direction);
    expect(flex.mainAxisAlignment, flexSpec.mainAxisAlignment);
    expect(flex.crossAxisAlignment, flexSpec.crossAxisAlignment);
    expect(flex.mainAxisSize, flexSpec.mainAxisSize);
    expect(flex.verticalDirection, flexSpec.verticalDirection);
    expect(flex.textDirection, flexSpec.textDirection);
    expect(flex.textBaseline, flexSpec.textBaseline);
  });

  group('FlexSpecWidget', () {
    testWidgets('prioritizes the direction in spec', (tester) async {
      await tester.pumpMaterialApp(
        const Center(
          child: FlexSpecWidget(
            direction: Axis.horizontal,
            spec: FlexSpec(
              direction: Axis.vertical,
            ),
            children: [
              StyledText('test'),
              StyledText('case'),
            ],
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.vertical);
    });

    testWidgets('changes its gap direction when direction is modified',
        (tester) async {
      await tester.pumpMaterialApp(
        const Center(
          child: FlexSpecWidget(
            direction: Axis.horizontal,
            spec: FlexSpec(direction: Axis.vertical, gap: 16),
            children: [
              StyledText('test'),
              StyledText('case'),
            ],
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.spacing, 16);
    });
  });

  testWidgets(
    'HBox with gap() rendered correctly in complex widget tree',
    (tester) async {
      await tester.pumpMaterialApp(
        Center(
          child: Column(
            children: [
              Row(
                children: [
                  HBox(
                    style: Style($flex.gap(10)),
                    children: const [StyledText('test'), StyledText('case')],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  testWidgets(
    'VBox with gap() rendered correctly in complex widget tree',
    (tester) async {
      await tester.pumpMaterialApp(
        Center(
          child: Row(
            children: [
              Column(
                children: [
                  VBox(
                    style: Style($flex.gap(10)),
                    children: const [StyledText('test'), StyledText('case')],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  testWidgets('should render correctly when Hbox has as its child a Spacer',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 100));

    await tester.pumpMaterialApp(
      HBox(
        style: Style(
          $flex.gap(10),
        ),
        children: const [
          SizedBox(
            key: Key('box1'),
            height: 100.0,
            width: 100.0,
          ),
          Spacer(),
          SizedBox(
            key: Key('box2'),
            height: 100.0,
            width: 100.0,
          ),
        ],
      ),
    );

    final Finder container1Finder = find.byKey(const Key('box1'));
    final Offset container1Offset = tester.getTopLeft(container1Finder);

    expect(container1Offset.dx, 0);
    expect(container1Offset.dy, 0);

    final Finder containerFinder = find.byKey(const Key('box2'));
    final Offset containerOffset = tester.getTopLeft(containerFinder);

    expect(containerOffset.dx, 300);
    expect(containerOffset.dy, 0);
  });

  testWidgets('Does not render Gap with no children', (tester) async {
    await tester.pumpMaterialApp(
      HBox(
        style: Style($flex.gap(10)),
        children: const [],
      ),
    );

    expect(find.byType(SizedBox), findsNothing);
  });

  testWidgets('Does not render Gap with one child', (tester) async {
    await tester.pumpMaterialApp(
      HBox(
        style: Style($flex.gap(10)),
        children: const [
          Text('test'),
        ],
      ),
    );

    expect(find.byType(SizedBox), findsNothing);
  });

  testWidgets(
    'should render correctly when gap is applied to Hbox with any MainAxisAlignment',
    (WidgetTester tester) async {
      const spacing = 10.0;
      await tester.binding.setSurfaceSize(const Size(400, 100));

      for (final e in MainAxisAlignment.values) {
        await tester.pumpMaterialApp(
          Column(
            children: [
              HBox(
                style: Style(
                  $flex.gap(spacing),
                  $flex.mainAxisAlignment(e),
                ),
                children: const [
                  SizedBox(height: 30, width: 30, key: Key('0')),
                  SizedBox(height: 30, width: 30, key: Key('1')),
                  SizedBox(height: 30, width: 30, key: Key('2')),
                ],
              ),
              Row(
                mainAxisAlignment: e,
                spacing: spacing,
                children: const [
                  SizedBox(height: 30, width: 30, key: Key('3')),
                  SizedBox(height: 30, width: 30, key: Key('4')),
                  SizedBox(height: 30, width: 30, key: Key('5')),
                ],
              )
            ],
          ),
        );

        for (var i = 0; i < 3; i++) {
          final Finder expectedWidget = find.byKey(Key('${i + 3}'));
          final Offset expectedOffset = tester.getTopLeft(expectedWidget);

          final Finder actualWidget = find.byKey(Key('$i'));
          final Offset actualOffset = tester.getTopLeft(actualWidget);

          expect(actualOffset.dx, expectedOffset.dx);
        }
      }
    },
  );

  testWidgets(
    'VBox should apply modifiers only once',
    (tester) async {
      await tester.pumpMaterialApp(
        VBox(
          style: Style(
            $flex.gap(10),
            $with.align(),
          ),
          children: const [
            SizedBox(
              height: 10,
              width: 20,
            ),
          ],
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    },
  );

  testWidgets(
    'HBox should apply modifiers only once',
    (tester) async {
      await tester.pumpMaterialApp(
        HBox(
          style: Style(
            $flex.gap(10),
            $with.align(),
          ),
          children: const [
            SizedBox(
              height: 10,
              width: 20,
            ),
          ],
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    },
  );

  testWidgets(
    'StyledRow should apply modifiers only once',
    (tester) async {
      await tester.pumpMaterialApp(
        VBox(
          style: Style(
            $flex.gap(10),
            $with.align(),
          ),
          children: const [
            SizedBox(
              height: 10,
              width: 20,
            ),
          ],
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    },
  );

  testWidgets(
    'StyledColumn should apply modifiers only once',
    (tester) async {
      await tester.pumpMaterialApp(
        StyledColumn(
          style: Style(
            $flex.gap(10),
            $with.align(),
          ),
          children: const [
            SizedBox(
              height: 10,
              width: 20,
            ),
          ],
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    },
  );

  testWidgets(
    'StyledFlex should apply modifiers only once',
    (tester) async {
      await tester.pumpMaterialApp(
        StyledFlex(
          direction: Axis.horizontal,
          style: Style(
            $flex.gap(10),
            $with.align(),
          ),
          children: const [
            SizedBox(
              height: 10,
              width: 20,
            ),
          ],
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    },
  );

  testWidgets(
    'FlexBox should apply modifiers only once',
    (tester) async {
      await tester.pumpMaterialApp(
        FlexBox(
          direction: Axis.horizontal,
          style: Style(
            $flex.gap(10),
            $with.align(),
          ),
          children: const [
            SizedBox(
              height: 10,
              width: 20,
            ),
          ],
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    },
  );

  testWidgets(
    'Renders modifiers in the correct order with many overrides',
    (tester) async {
      testOverrideModifiersOrder(
        tester,
        widgetBuilder: (style, orderOfModifiers) {
          return FlexBox(
            style: style,
            orderOfModifiers: orderOfModifiers,
            direction: Axis.horizontal,
            children: const [],
          );
        },
      );
    },
  );
}
