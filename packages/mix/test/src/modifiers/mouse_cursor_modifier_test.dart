import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('MouseCursorDecoratorSpec', () {
    testWidgets('uses custom mouseCursor when provided',
        (WidgetTester tester) async {
      const cursor = SystemMouseCursors.resizeUpRight;
      await tester.pumpWidget(
        Box(
          style: Style(
            $box.wrap.cursor(cursor),
          ),
        ),
      );

      final finder = find.byType(MouseRegion);
      expect(finder, findsOneWidget);

      final mouseRegion = tester.widget<MouseRegion>(finder);
      expect(mouseRegion.cursor, equals(cursor));
    });

    testWidgets('uses defer cursor when null provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Box(
          style: Style(
            $box.wrap.cursor(null),
          ),
        ),
      );

      final finder = find.byType(MouseRegion);
      expect(finder, findsOneWidget);

      final mouseRegion = tester.widget<MouseRegion>(finder);
      expect(mouseRegion.cursor, equals(MouseCursor.defer));
    });
  });

  group('MouseCursorModifierSpecUtility', () {
    const utility = MouseCursorModifierSpecUtility(UtilityTestAttribute.new);

    group('basic cursor methods', () {
      test('defer() creates correct attribute', () {
        final result = utility.defer();
        expect(result, isA<UtilityTestAttribute>());
        expect(result.value.mouseCursor, MouseCursor.defer);
      });

      test('uncontrolled() creates correct attribute', () {
        final result = utility.uncontrolled();
        expect(result, isA<UtilityTestAttribute>());
        expect(result.value.mouseCursor, MouseCursor.uncontrolled);
      });

      test('call() with custom cursor creates correct attribute', () {
        const customCursor = SystemMouseCursors.click;
        final result = utility.call(customCursor);
        expect(result, isA<UtilityTestAttribute>());
        expect(result.value.mouseCursor, customCursor);
      });

      test('call() with null creates correct attribute', () {
        final result = utility.call(null);
        expect(result, isA<UtilityTestAttribute>());
        expect(result.value.mouseCursor, isNull);
      });
    });

    group('system cursor methods', () {
      test('none() creates correct attribute', () {
        final result = utility.none();
        expect(result.value.mouseCursor, SystemMouseCursors.none);
      });

      test('basic() creates correct attribute', () {
        final result = utility.basic();
        expect(result.value.mouseCursor, SystemMouseCursors.basic);
      });

      test('click() creates correct attribute', () {
        final result = utility.click();
        expect(result.value.mouseCursor, SystemMouseCursors.click);
      });

      test('forbidden() creates correct attribute', () {
        final result = utility.forbidden();
        expect(result.value.mouseCursor, SystemMouseCursors.forbidden);
      });

      test('wait() creates correct attribute', () {
        final result = utility.wait();
        expect(result.value.mouseCursor, SystemMouseCursors.wait);
      });

      test('progress() creates correct attribute', () {
        final result = utility.progress();
        expect(result.value.mouseCursor, SystemMouseCursors.progress);
      });

      test('contextMenu() creates correct attribute', () {
        final result = utility.contextMenu();
        expect(result.value.mouseCursor, SystemMouseCursors.contextMenu);
      });

      test('help() creates correct attribute', () {
        final result = utility.help();
        expect(result.value.mouseCursor, SystemMouseCursors.help);
      });
    });

    group('text cursor methods', () {
      test('text() creates correct attribute', () {
        final result = utility.text();
        expect(result.value.mouseCursor, SystemMouseCursors.text);
      });

      test('verticalText() creates correct attribute', () {
        final result = utility.verticalText();
        expect(result.value.mouseCursor, SystemMouseCursors.verticalText);
      });

      test('cell() creates correct attribute', () {
        final result = utility.cell();
        expect(result.value.mouseCursor, SystemMouseCursors.cell);
      });

      test('precise() creates correct attribute', () {
        final result = utility.precise();
        expect(result.value.mouseCursor, SystemMouseCursors.precise);
      });
    });

    group('interaction cursor methods', () {
      test('move() creates correct attribute', () {
        final result = utility.move();
        expect(result.value.mouseCursor, SystemMouseCursors.move);
      });

      test('grab() creates correct attribute', () {
        final result = utility.grab();
        expect(result.value.mouseCursor, SystemMouseCursors.grab);
      });

      test('grabbing() creates correct attribute', () {
        final result = utility.grabbing();
        expect(result.value.mouseCursor, SystemMouseCursors.grabbing);
      });

      test('noDrop() creates correct attribute', () {
        final result = utility.noDrop();
        expect(result.value.mouseCursor, SystemMouseCursors.noDrop);
      });

      test('alias() creates correct attribute', () {
        final result = utility.alias();
        expect(result.value.mouseCursor, SystemMouseCursors.alias);
      });

      test('copy() creates correct attribute', () {
        final result = utility.copy();
        expect(result.value.mouseCursor, SystemMouseCursors.copy);
      });

      test('disappearing() creates correct attribute', () {
        final result = utility.disappearing();
        expect(result.value.mouseCursor, SystemMouseCursors.disappearing);
      });
    });

    group('scroll cursor methods', () {
      test('allScroll() creates correct attribute', () {
        final result = utility.allScroll();
        expect(result.value.mouseCursor, SystemMouseCursors.allScroll);
      });
    });

    group('resize cursor methods', () {
      test('resizeLeftRight() creates correct attribute', () {
        final result = utility.resizeLeftRight();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeLeftRight);
      });

      test('resizeUpDown() creates correct attribute', () {
        final result = utility.resizeUpDown();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeUpDown);
      });

      test('resizeUpLeftDownRight() creates correct attribute', () {
        final result = utility.resizeUpLeftDownRight();
        expect(
            result.value.mouseCursor, SystemMouseCursors.resizeUpLeftDownRight);
      });

      test('resizeUpRightDownLeft() creates correct attribute', () {
        final result = utility.resizeUpRightDownLeft();
        expect(
            result.value.mouseCursor, SystemMouseCursors.resizeUpRightDownLeft);
      });

      test('resizeUp() creates correct attribute', () {
        final result = utility.resizeUp();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeUp);
      });

      test('resizeDown() creates correct attribute', () {
        final result = utility.resizeDown();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeDown);
      });

      test('resizeLeft() creates correct attribute', () {
        final result = utility.resizeLeft();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeLeft);
      });

      test('resizeRight() creates correct attribute', () {
        final result = utility.resizeRight();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeRight);
      });

      test('resizeUpLeft() creates correct attribute', () {
        final result = utility.resizeUpLeft();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeUpLeft);
      });

      test('resizeUpRight() creates correct attribute', () {
        final result = utility.resizeUpRight();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeUpRight);
      });

      test('resizeDownLeft() creates correct attribute', () {
        final result = utility.resizeDownLeft();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeDownLeft);
      });

      test('resizeDownRight() creates correct attribute', () {
        final result = utility.resizeDownRight();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeDownRight);
      });

      test('resizeColumn() creates correct attribute', () {
        final result = utility.resizeColumn();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeColumn);
      });

      test('resizeRow() creates correct attribute', () {
        final result = utility.resizeRow();
        expect(result.value.mouseCursor, SystemMouseCursors.resizeRow);
      });
    });

    group('zoom cursor methods', () {
      test('zoomIn() creates correct attribute', () {
        final result = utility.zoomIn();
        expect(result.value.mouseCursor, SystemMouseCursors.zoomIn);
      });

      test('zoomOut() creates correct attribute', () {
        final result = utility.zoomOut();
        expect(result.value.mouseCursor, SystemMouseCursors.zoomOut);
      });
    });
  });
}
