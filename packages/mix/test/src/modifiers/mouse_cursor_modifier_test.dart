import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('MouseCursorDecorator', () {
    group('Constructor', () {
      test('creates with null mouseCursor by default', () {
        const modifier = MouseCursorDecorator();

        expect(modifier.mouseCursor, isNull);
      });

      test('assigns mouseCursor correctly', () {
        const cursor = SystemMouseCursors.click;
        const modifier = MouseCursorDecorator(mouseCursor: cursor);

        expect(modifier.mouseCursor, cursor);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated mouseCursor', () {
        const original = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );

        final updated = original.copyWith(
          mouseCursor: SystemMouseCursors.click,
        );

        expect(updated.mouseCursor, SystemMouseCursors.click);
        expect(updated, isNot(same(original)));
      });

      test('preserves original mouseCursor when parameter is null', () {
        const original = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );

        final updated = original.copyWith();

        expect(updated.mouseCursor, original.mouseCursor);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('returns start cursor when t < 0.5', () {
        const start = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );
        const end = MouseCursorDecorator(mouseCursor: SystemMouseCursors.click);
        final result = start.lerp(end, 0.3);

        expect(result.mouseCursor, SystemMouseCursors.basic);
      });

      test('returns end cursor when t >= 0.5', () {
        const start = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );
        const end = MouseCursorDecorator(mouseCursor: SystemMouseCursors.click);
        final result = start.lerp(end, 0.7);

        expect(result.mouseCursor, SystemMouseCursors.click);
      });

      test('returns start cursor when t = 0.5', () {
        const start = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );
        const end = MouseCursorDecorator(mouseCursor: SystemMouseCursors.click);
        final result = start.lerp(end, 0.5);

        expect(result.mouseCursor, SystemMouseCursors.click);
      });

      test('handles null other parameter', () {
        const start = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });

      test('handles null mouseCursor values', () {
        const start = MouseCursorDecorator();
        const end = MouseCursorDecorator(mouseCursor: SystemMouseCursors.click);

        final result1 = start.lerp(end, 0.3);
        expect(result1.mouseCursor, isNull);

        final result2 = start.lerp(end, 0.7);
        expect(result2.mouseCursor, SystemMouseCursors.click);
      });

      test('handles extreme t values', () {
        const start = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );
        const end = MouseCursorDecorator(mouseCursor: SystemMouseCursors.click);

        final result0 = start.lerp(end, 0.0);
        expect(result0.mouseCursor, SystemMouseCursors.basic);

        final result1 = start.lerp(end, 1.0);
        expect(result1.mouseCursor, SystemMouseCursors.click);
      });
    });

    group('equality and hashCode', () {
      test('equal when mouseCursor matches', () {
        const modifier1 = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );
        const modifier2 = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when mouseCursor differs', () {
        const modifier1 = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );
        const modifier2 = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.click,
        );

        expect(modifier1, isNot(equals(modifier2)));
        expect(modifier1.hashCode, isNot(equals(modifier2.hashCode)));
      });

      test('equal when both have null mouseCursor', () {
        const modifier1 = MouseCursorDecorator();
        const modifier2 = MouseCursorDecorator();

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('not equal when one has null and other has value', () {
        const modifier1 = MouseCursorDecorator();
        const modifier2 = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );

        expect(modifier1, isNot(equals(modifier2)));
        expect(modifier1.hashCode, isNot(equals(modifier2.hashCode)));
      });
    });

    group('props', () {
      test('contains mouseCursor', () {
        const modifier = MouseCursorDecorator(
          mouseCursor: SystemMouseCursors.basic,
        );

        expect(modifier.props, [SystemMouseCursors.basic]);
      });

      test('contains null when mouseCursor is null', () {
        const modifier = MouseCursorDecorator();

        expect(modifier.props, [null]);
      });
    });

    group('build', () {
      testWidgets('creates MouseRegion with defer cursor by default', (
        WidgetTester tester,
      ) async {
        const modifier = MouseCursorDecorator();
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final mouseRegion = tester.widget<MouseRegion>(
          find.byType(MouseRegion),
        );
        expect(mouseRegion.cursor, MouseCursor.defer);
        expect(mouseRegion.child, same(child));
      });

      testWidgets('creates MouseRegion with custom cursor', (
        WidgetTester tester,
      ) async {
        const cursor = SystemMouseCursors.click;
        const modifier = MouseCursorDecorator(mouseCursor: cursor);
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final mouseRegion = tester.widget<MouseRegion>(
          find.byType(MouseRegion),
        );
        expect(mouseRegion.cursor, cursor);
        expect(mouseRegion.child, same(child));
      });

      testWidgets('creates MouseRegion with various system cursors', (
        WidgetTester tester,
      ) async {
        final cursors = [
          SystemMouseCursors.basic,
          SystemMouseCursors.click,
          SystemMouseCursors.forbidden,
          SystemMouseCursors.wait,
          SystemMouseCursors.text,
          SystemMouseCursors.grab,
          SystemMouseCursors.grabbing,
          SystemMouseCursors.resizeLeftRight,
          SystemMouseCursors.resizeUpDown,
        ];

        for (final cursor in cursors) {
          final modifier = MouseCursorDecorator(mouseCursor: cursor);
          const child = SizedBox(width: 50, height: 50);

          await tester.pumpWidget(modifier.build(child));

          final mouseRegion = tester.widget<MouseRegion>(
            find.byType(MouseRegion),
          );
          expect(mouseRegion.cursor, cursor);
          expect(mouseRegion.child, same(child));
        }
      });
    });
  });

  group('MouseCursorDecoratorSpecAttribute', () {
    group('Constructor', () {
      test('creates with null mouseCursor by default', () {
        const attribute = MouseCursorDecoratorSpecAttribute();

        expect(attribute.mouseCursor, isNull);
      });

      test('creates with provided Prop value', () {
        final mouseCursor = Prop<MouseCursor>(SystemMouseCursors.click);
        final attribute = MouseCursorDecoratorSpecAttribute(
          mouseCursor: mouseCursor,
        );

        expect(attribute.mouseCursor, same(mouseCursor));
      });
    });

    group('only constructor', () {
      test('creates Prop value from direct value', () {
        final attribute = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.basic,
        );

        expectProp(attribute.mouseCursor, SystemMouseCursors.basic);
      });

      test('handles null value correctly', () {
        final attribute = MouseCursorDecoratorSpecAttribute.only();

        expect(attribute.mouseCursor, isNull);
      });
    });

    group('resolve', () {
      test('resolves to MouseCursorDecorator with resolved value', () {
        final attribute = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.click,
        );

        expect(
          attribute,
          resolvesTo(
            const MouseCursorDecorator(mouseCursor: SystemMouseCursors.click),
          ),
        );
      });

      test('resolves with null value', () {
        final attribute = MouseCursorDecoratorSpecAttribute();

        expect(attribute, resolvesTo(const MouseCursorDecorator()));
      });
    });

    group('merge', () {
      test('merges with other MouseCursorDecoratorSpecAttribute', () {
        final attribute1 = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.basic,
        );
        final attribute2 = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.click,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.mouseCursor, SystemMouseCursors.click); // overridden
      });

      test('returns original when other is null', () {
        final attribute = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.basic,
        );

        final merged = attribute.merge(null);

        expect(merged, same(attribute));
      });

      test('merges with null values', () {
        final attribute1 = MouseCursorDecoratorSpecAttribute();
        final attribute2 = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.click,
        );

        final merged = attribute1.merge(attribute2);

        expectProp(merged.mouseCursor, SystemMouseCursors.click);
      });
    });

    group('equality and props', () {
      test('equal when Prop values match', () {
        final attribute1 = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.basic,
        );
        final attribute2 = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.basic,
        );

        expect(attribute1, equals(attribute2));
      });

      test('not equal when values differ', () {
        final attribute1 = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.basic,
        );
        final attribute2 = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.click,
        );

        expect(attribute1, isNot(equals(attribute2)));
      });

      test('props contains mouseCursor Prop', () {
        final attribute = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.basic,
        );

        final props = attribute.props;
        expect(props.length, 1);
        expect(props[0], attribute.mouseCursor);
      });

      test('props contains null when mouseCursor is null', () {
        final attribute = MouseCursorDecoratorSpecAttribute();

        final props = attribute.props;
        expect(props.length, 1);
        expect(props[0], isNull);
      });
    });
  });

  group('Integration tests', () {
    testWidgets(
      'MouseCursorDecoratorSpecAttribute resolves and builds correctly',
      (WidgetTester tester) async {
        final attribute = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: SystemMouseCursors.grab,
        );

        expect(
          attribute,
          resolvesTo(
            const MouseCursorDecorator(mouseCursor: SystemMouseCursors.grab),
          ),
        );

        final modifier = attribute.resolve(MockBuildContext());
        const child = SizedBox(width: 100, height: 100);

        await tester.pumpWidget(modifier.build(child));

        final mouseRegion = tester.widget<MouseRegion>(
          find.byType(MouseRegion),
        );
        expect(mouseRegion.cursor, SystemMouseCursors.grab);
        expect(mouseRegion.child, same(child));
      },
    );

    test('Complex merge scenario preserves and overrides correctly', () {
      final base = MouseCursorDecoratorSpecAttribute.only(
        mouseCursor: SystemMouseCursors.basic,
      );

      final override1 = MouseCursorDecoratorSpecAttribute.only(
        mouseCursor: SystemMouseCursors.click,
      );

      final override2 = MouseCursorDecoratorSpecAttribute.only(
        mouseCursor: SystemMouseCursors.grab,
      );

      final result = base.merge(override1).merge(override2);

      expectProp(result.mouseCursor, SystemMouseCursors.grab);
    });

    test('Lerp produces expected step function behavior', () {
      const start = MouseCursorDecorator(mouseCursor: SystemMouseCursors.basic);
      const end = MouseCursorDecorator(mouseCursor: SystemMouseCursors.click);

      final quarter = start.lerp(end, 0.25);
      final half = start.lerp(end, 0.5);
      final threeQuarter = start.lerp(end, 0.75);

      // Step function: < 0.5 uses start, >= 0.5 uses end
      expect(quarter.mouseCursor, SystemMouseCursors.basic);
      expect(half.mouseCursor, SystemMouseCursors.click);
      expect(threeQuarter.mouseCursor, SystemMouseCursors.click);
    });

    testWidgets('Integration with various system cursors', (
      WidgetTester tester,
    ) async {
      final testCases = [
        SystemMouseCursors.none,
        SystemMouseCursors.basic,
        SystemMouseCursors.click,
        SystemMouseCursors.forbidden,
        SystemMouseCursors.wait,
        SystemMouseCursors.progress,
        SystemMouseCursors.contextMenu,
        SystemMouseCursors.help,
        SystemMouseCursors.text,
        SystemMouseCursors.verticalText,
        SystemMouseCursors.cell,
        SystemMouseCursors.precise,
        SystemMouseCursors.move,
        SystemMouseCursors.grab,
        SystemMouseCursors.grabbing,
        SystemMouseCursors.noDrop,
        SystemMouseCursors.alias,
        SystemMouseCursors.copy,
        SystemMouseCursors.disappearing,
        SystemMouseCursors.allScroll,
        SystemMouseCursors.resizeLeftRight,
        SystemMouseCursors.resizeUpDown,
        SystemMouseCursors.resizeUpLeftDownRight,
        SystemMouseCursors.resizeUpRightDownLeft,
        SystemMouseCursors.resizeUp,
        SystemMouseCursors.resizeDown,
        SystemMouseCursors.resizeLeft,
        SystemMouseCursors.resizeRight,
        SystemMouseCursors.resizeUpLeft,
        SystemMouseCursors.resizeUpRight,
        SystemMouseCursors.resizeDownLeft,
        SystemMouseCursors.resizeDownRight,
        SystemMouseCursors.resizeColumn,
        SystemMouseCursors.resizeRow,
        SystemMouseCursors.zoomIn,
        SystemMouseCursors.zoomOut,
      ];

      for (final cursor in testCases) {
        final attribute = MouseCursorDecoratorSpecAttribute.only(
          mouseCursor: cursor,
        );
        expect(
          attribute,
          resolvesTo(MouseCursorDecorator(mouseCursor: cursor)),
        );

        final modifier = attribute.resolve(MockBuildContext());
        const child = SizedBox(width: 50, height: 50);

        await tester.pumpWidget(modifier.build(child));

        final mouseRegion = tester.widget<MouseRegion>(
          find.byType(MouseRegion),
        );
        expect(
          mouseRegion.cursor,
          cursor,
          reason: 'Failed for cursor: $cursor',
        );
        expect(mouseRegion.child, same(child));
      }
    });
  });
}
