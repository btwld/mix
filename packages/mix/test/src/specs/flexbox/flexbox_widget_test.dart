import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Default parameters for FlexBox matches Container+Flex', () {
    testWidgets('should have the same default parameters', (tester) async {
      const flexBoxKey = Key('flexbox');
      const containerKey = Key('container');
      const flexKey = Key('flex');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                FlexBox(
                  direction: Axis.horizontal,
                  key: flexBoxKey,
                  style: FlexBoxStyle(box: BoxMix()),
                ),
                Container(
                  key: containerKey,
                  child: Flex(
                    direction: Axis.horizontal,
                    key: flexKey,
                    children: const [],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final flexBoxFinder = find.byKey(flexBoxKey);
      final containerFinder = find.byKey(containerKey);
      final flexFinder = find.byKey(flexKey);

      /// Find the Container and Flex widgets inside the FlexBox widget
      final styledContainer = tester.widget<Container>(
        find.descendant(of: flexBoxFinder, matching: find.byType(Container)),
      );
      final styledFlex = tester.widget<Flex>(
        find.descendant(of: flexBoxFinder, matching: find.byType(Flex)),
      );

      final container = tester.widget<Container>(containerFinder);
      final flex = tester.widget<Flex>(flexFinder);

      /// Compare Container default parameters
      expect(styledContainer.alignment, container.alignment);
      expect(styledContainer.padding, container.padding);
      expect(styledContainer.decoration, container.decoration);
      expect(
        styledContainer.foregroundDecoration,
        container.foregroundDecoration,
      );
      expect(styledContainer.constraints, container.constraints);
      expect(styledContainer.margin, container.margin);
      expect(styledContainer.transform, container.transform);
      expect(styledContainer.transformAlignment, container.transformAlignment);
      expect(styledContainer.clipBehavior, container.clipBehavior);

      /// Compare Flex default parameters
      expect(styledFlex.direction, flex.direction);
      expect(styledFlex.mainAxisAlignment, flex.mainAxisAlignment);
      expect(styledFlex.mainAxisSize, flex.mainAxisSize);
      expect(styledFlex.crossAxisAlignment, flex.crossAxisAlignment);
      expect(styledFlex.textDirection, flex.textDirection);
      expect(styledFlex.verticalDirection, flex.verticalDirection);
      expect(styledFlex.textBaseline, flex.textBaseline);
      expect(styledFlex.clipBehavior, flex.clipBehavior);
    });
  });

  group('Default parameters for HBox matches Row', () {
    testWidgets('should have the same default parameters', (tester) async {
      const hBoxKey = Key('hbox');
      const rowKey = Key('row');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                HBox(key: hBoxKey),
                Row(key: rowKey, children: const []),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final hBoxFinder = find.byKey(hBoxKey);
      final rowFinder = find.byKey(rowKey);

      /// Find the Flex widget inside the HBox widget
      final styledFlex = tester.widget<Flex>(
        find.descendant(of: hBoxFinder, matching: find.byType(Flex)),
      );
      final row = tester.widget<Flex>(rowFinder);

      /// Compare the default parameters
      expect(styledFlex.direction, row.direction);
      expect(styledFlex.mainAxisAlignment, row.mainAxisAlignment);
      expect(styledFlex.mainAxisSize, row.mainAxisSize);
      expect(styledFlex.crossAxisAlignment, row.crossAxisAlignment);
      expect(styledFlex.textDirection, row.textDirection);
      expect(styledFlex.verticalDirection, row.verticalDirection);
      expect(styledFlex.textBaseline, row.textBaseline);
      expect(styledFlex.clipBehavior, row.clipBehavior);
    });
  });

  group('Default parameters for VBox matches Column', () {
    testWidgets('should have the same default parameters', (tester) async {
      const vBoxKey = Key('vbox');
      const columnKey = Key('column');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VBox(key: vBoxKey),
                Column(key: columnKey, children: const []),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final vBoxFinder = find.byKey(vBoxKey);
      final columnFinder = find.byKey(columnKey);

      /// Find the Flex widget inside the VBox widget
      final styledFlex = tester.widget<Flex>(
        find.descendant(of: vBoxFinder, matching: find.byType(Flex)),
      );
      final column = tester.widget<Flex>(columnFinder);

      /// Compare the default parameters
      expect(styledFlex.direction, column.direction);
      expect(styledFlex.mainAxisAlignment, column.mainAxisAlignment);
      expect(styledFlex.mainAxisSize, column.mainAxisSize);
      expect(styledFlex.crossAxisAlignment, column.crossAxisAlignment);
      expect(styledFlex.textDirection, column.textDirection);
      expect(styledFlex.verticalDirection, column.verticalDirection);
      expect(styledFlex.textBaseline, column.textBaseline);
      expect(styledFlex.clipBehavior, column.clipBehavior);
    });

    testWidgets('should verify FlexBox defaults match Flutter Flex defaults', (
      tester,
    ) async {
      const flexBoxKey = Key('flexbox');
      const flexKey = Key('flex');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                FlexBox(direction: Axis.horizontal, key: flexBoxKey),
                Flex(
                  direction: Axis.horizontal,
                  key: flexKey,
                  children: const [],
                ),
              ],
            ),
          ),
        ),
      );

      /// Get widgets by key
      final flexBoxFinder = find.byKey(flexBoxKey);
      final flexFinder = find.byKey(flexKey);

      /// Find the Flex widget inside the FlexBox widget
      final styledFlex = tester.widget<Flex>(
        find.descendant(of: flexBoxFinder, matching: find.byType(Flex)),
      );
      final flex = tester.widget<Flex>(flexFinder);

      /// Verify specific defaults
      expect(
        styledFlex.mainAxisAlignment,
        MainAxisAlignment.start,
        reason: 'FlexBox should default to MainAxisAlignment.start',
      );
      expect(
        flex.mainAxisAlignment,
        MainAxisAlignment.start,
        reason: 'Flutter Flex should default to MainAxisAlignment.start',
      );

      expect(
        styledFlex.mainAxisSize,
        MainAxisSize.max,
        reason: 'FlexBox should default to MainAxisSize.max',
      );
      expect(
        flex.mainAxisSize,
        MainAxisSize.max,
        reason: 'Flutter Flex should default to MainAxisSize.max',
      );

      expect(
        styledFlex.crossAxisAlignment,
        CrossAxisAlignment.center,
        reason: 'FlexBox should default to CrossAxisAlignment.center',
      );
      expect(
        flex.crossAxisAlignment,
        CrossAxisAlignment.center,
        reason: 'Flutter Flex should default to CrossAxisAlignment.center',
      );

      expect(
        styledFlex.verticalDirection,
        VerticalDirection.down,
        reason: 'FlexBox should default to VerticalDirection.down',
      );
      expect(
        flex.verticalDirection,
        VerticalDirection.down,
        reason: 'Flutter Flex should default to VerticalDirection.down',
      );

      expect(
        styledFlex.clipBehavior,
        Clip.none,
        reason: 'FlexBox should default to Clip.none',
      );
      expect(
        flex.clipBehavior,
        Clip.none,
        reason: 'Flutter Flex should default to Clip.none',
      );
    });
  });
}
