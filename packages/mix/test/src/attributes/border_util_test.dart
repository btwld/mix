import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('BorderUtility', () {
    final border = BorderUtility(UtilityTestAttribute.new);

    test('border.top()', () {
      final result = border.top(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );

      expect(result.value.top?.mixValue?.color, resolvesTo(Colors.red));
      expect(result.value.top?.mixValue?.width, resolvesTo(10.0));
      expect(result.value.top?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.top?.mixValue?.strokeAlign, resolvesTo(0.5));
      expect(result.value.right, null);
      expect(result.value.bottom, null);
      expect(result.value.left, null);

      final resultColor = border.top.color(Colors.yellow);
      final resultWidth = border.top.width(20.0);
      final resultStyle = border.top.style(BorderStyle.solid);
      final resultStrokeAlign = border.top.strokeAlign(0.2);

      expect(resultColor.value.top?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.top?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.top?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.top?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('border.bottom()', () {
      final result = border.bottom(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );

      expect(result.value.bottom?.mixValue?.color, resolvesTo(Colors.red));
      expect(result.value.bottom?.mixValue?.width, resolvesTo(10.0));
      expect(
        result.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.bottom?.mixValue?.strokeAlign, resolvesTo(0.5));
      expect(result.value.right, null);
      expect(result.value.top, null);
      expect(result.value.left, null);

      final resultColor = border.bottom.color(Colors.yellow);
      final resultWidth = border.bottom.width(20.0);
      final resultStyle = border.bottom.style(BorderStyle.solid);
      final resultStrokeAlign = border.bottom.strokeAlign(0.2);

      expect(
        resultColor.value.bottom?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.bottom?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.bottom?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('border.left()', () {
      final result = border.left(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );
      expect(result.value.left?.mixValue?.color, resolvesTo(Colors.red));
      expect(result.value.left?.mixValue?.width, resolvesTo(10.0));
      expect(result.value.left?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.left?.mixValue?.strokeAlign, resolvesTo(0.5));
      expect(result.value.right, null);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = border.left.color(Colors.yellow);
      final resultWidth = border.left.width(20.0);
      final resultStyle = border.left.style(BorderStyle.solid);
      final resultStrokeAlign = border.left.strokeAlign(0.2);

      expect(
        resultColor.value.left?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.left?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.left?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.left?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('border.right()', () {
      final result = border.right(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );
      expect(result.value.right?.mixValue?.color, resolvesTo(Colors.red));
      expect(result.value.right?.mixValue?.width, resolvesTo(10.0));
      expect(
        result.value.right?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.right?.mixValue?.strokeAlign, resolvesTo(0.5));
      expect(result.value.left, null);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = border.right.color(Colors.yellow);
      final resultWidth = border.right.width(20.0);
      final resultStyle = border.right.style(BorderStyle.solid);
      final resultStrokeAlign = border.right.strokeAlign(0.2);

      expect(
        resultColor.value.right?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.right?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.right?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.right?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('border.horizontal()', () {
      final result = border.horizontal(
        color: Colors.blue,
        strokeAlign: 0.3,
        style: BorderStyle.solid,
        width: 5.0,
      );
      expect(result.value.top?.mixValue?.color, resolvesTo(Colors.blue));
      expect(result.value.top?.mixValue?.width, resolvesTo(5.0));
      expect(result.value.top?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.top?.mixValue?.strokeAlign, resolvesTo(0.3));
      expect(result.value.bottom?.mixValue?.color, resolvesTo(Colors.blue));
      expect(result.value.bottom?.mixValue?.width, resolvesTo(5.0));
      expect(
        result.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.bottom?.mixValue?.strokeAlign, resolvesTo(0.3));
      expect(result.value.left, null);
      expect(result.value.right, null);

      final resultColor = border.horizontal.color(Colors.yellow);
      final resultWidth = border.horizontal.width(20.0);
      final resultStyle = border.horizontal.style(BorderStyle.solid);
      final resultStrokeAlign = border.horizontal.strokeAlign(0.2);

      expect(resultColor.value.top?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.top?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.top?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.top?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(
        resultColor.value.bottom?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.bottom?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.bottom?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('border.vertical()', () {
      final result = border.vertical(
        color: Colors.green,
        strokeAlign: 0.2,
        style: BorderStyle.solid,
        width: 7.0,
      );
      expect(result.value.left?.mixValue?.color, resolvesTo(Colors.green));
      expect(result.value.left?.mixValue?.width, resolvesTo(7.0));
      expect(result.value.left?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.left?.mixValue?.strokeAlign, resolvesTo(0.2));
      expect(result.value.right?.mixValue?.color, resolvesTo(Colors.green));
      expect(result.value.right?.mixValue?.width, resolvesTo(7.0));
      expect(
        result.value.right?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.right?.mixValue?.strokeAlign, resolvesTo(0.2));
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = border.vertical.color(Colors.yellow);
      final resultWidth = border.vertical.width(20.0);
      final resultStyle = border.vertical.style(BorderStyle.solid);
      final resultStrokeAlign = border.vertical.strokeAlign(0.2);

      expect(
        resultColor.value.left?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.left?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.left?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.left?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(
        resultColor.value.right?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.right?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.right?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.right?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('border.all()', () {
      final result = border.all(
        color: Colors.purple,
        strokeAlign: 0.1,
        style: BorderStyle.solid,
        width: 3.0,
      );
      expect(result.value.top?.mixValue?.color, resolvesTo(Colors.purple));
      expect(result.value.top?.mixValue?.width, resolvesTo(3.0));
      expect(result.value.top?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.top?.mixValue?.strokeAlign, resolvesTo(0.1));
      expect(result.value.bottom?.mixValue?.color, resolvesTo(Colors.purple));
      expect(result.value.bottom?.mixValue?.width, resolvesTo(3.0));
      expect(
        result.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.bottom?.mixValue?.strokeAlign, resolvesTo(0.1));
      expect(result.value.left?.mixValue?.color, resolvesTo(Colors.purple));
      expect(result.value.left?.mixValue?.width, resolvesTo(3.0));
      expect(result.value.left?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.left?.mixValue?.strokeAlign, resolvesTo(0.1));
      expect(result.value.right?.mixValue?.color, resolvesTo(Colors.purple));
      expect(result.value.right?.mixValue?.width, resolvesTo(3.0));
      expect(
        result.value.right?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.right?.mixValue?.strokeAlign, resolvesTo(0.1));

      final resultColor = border.all.color(Colors.yellow);
      final resultWidth = border.all.width(20.0);
      final resultStyle = border.all.style(BorderStyle.solid);
      final resultStrokeAlign = border.all.strokeAlign(0.2);

      expect(resultColor.value.top?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.top?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.top?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.top?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(
        resultColor.value.bottom?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.bottom?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.bottom?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(
        resultColor.value.left?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.left?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.left?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.left?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(
        resultColor.value.right?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.right?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.right?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.right?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });
  });

  // BorderDirectionalUtility

  group('BorderDirectionalUtility', () {
    final borderDirectional = BorderDirectionalUtility(
      UtilityTestAttribute.new,
    );

    test('borderDirectional.top()', () {
      final result = borderDirectional.top(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );

      expect(result.value.top?.mixValue?.color, resolvesTo(Colors.red));
      expect(result.value.top?.mixValue?.width, resolvesTo(10.0));
      expect(result.value.top?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.top?.mixValue?.strokeAlign, resolvesTo(0.5));
      expect(result.value.end, null);
      expect(result.value.bottom, null);
      expect(result.value.start, null);

      final resultColor = borderDirectional.top.color(Colors.yellow);
      final resultWidth = borderDirectional.top.width(20.0);
      final resultStyle = borderDirectional.top.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.top.strokeAlign(0.2);

      expect(resultColor.value.top?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.top?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.top?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.top?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('borderDirectional.bottom()', () {
      final result = borderDirectional.bottom(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );

      expect(result.value.bottom?.mixValue?.color, resolvesTo(Colors.red));
      expect(result.value.bottom?.mixValue?.width, resolvesTo(10.0));
      expect(
        result.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.bottom?.mixValue?.strokeAlign, resolvesTo(0.5));
      expect(result.value.end, null);
      expect(result.value.top, null);
      expect(result.value.start, null);

      final resultColor = borderDirectional.bottom.color(Colors.yellow);
      final resultWidth = borderDirectional.bottom.width(20.0);
      final resultStyle = borderDirectional.bottom.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.bottom.strokeAlign(0.2);

      expect(
        resultColor.value.bottom?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.bottom?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.bottom?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('borderDirectional.start()', () {
      final result = borderDirectional.start(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );
      expect(result.value.start?.mixValue?.color, resolvesTo(Colors.red));
      expect(result.value.start?.mixValue?.width, resolvesTo(10.0));
      expect(
        result.value.start?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.start?.mixValue?.strokeAlign, resolvesTo(0.5));
      expect(result.value.end, null);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = borderDirectional.start.color(Colors.yellow);
      final resultWidth = borderDirectional.start.width(20.0);
      final resultStyle = borderDirectional.start.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.start.strokeAlign(0.2);

      expect(
        resultColor.value.start?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.start?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.start?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.start?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('borderDirectional.end()', () {
      final result = borderDirectional.end(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );
      expect(result.value.end?.mixValue?.color, resolvesTo(Colors.red));
      expect(result.value.end?.mixValue?.width, resolvesTo(10.0));
      expect(result.value.end?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.end?.mixValue?.strokeAlign, resolvesTo(0.5));
      expect(result.value.start, null);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = borderDirectional.end.color(Colors.yellow);
      final resultWidth = borderDirectional.end.width(20.0);
      final resultStyle = borderDirectional.end.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.end.strokeAlign(0.2);

      expect(resultColor.value.end?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.end?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.end?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.end?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('borderDirectional.horizontal()', () {
      final result = borderDirectional.horizontal(
        color: Colors.blue,
        strokeAlign: 0.3,
        style: BorderStyle.solid,
        width: 5.0,
      );
      expect(result.value.top?.mixValue?.color, resolvesTo(Colors.blue));
      expect(result.value.top?.mixValue?.width, resolvesTo(5.0));
      expect(result.value.top?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.top?.mixValue?.strokeAlign, resolvesTo(0.3));
      expect(result.value.bottom?.mixValue?.color, resolvesTo(Colors.blue));
      expect(result.value.bottom?.mixValue?.width, resolvesTo(5.0));
      expect(
        result.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.bottom?.mixValue?.strokeAlign, resolvesTo(0.3));
      expect(result.value.start, null);
      expect(result.value.end, null);

      final resultColor = borderDirectional.horizontal.color(Colors.yellow);
      final resultWidth = borderDirectional.horizontal.width(20.0);
      final resultStyle = borderDirectional.horizontal.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.horizontal.strokeAlign(0.2);

      expect(resultColor.value.top?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.top?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.top?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.top?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(
        resultColor.value.bottom?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.bottom?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.bottom?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('borderDirectional.vertical()', () {
      final result = borderDirectional.vertical(
        color: Colors.green,
        strokeAlign: 0.2,
        style: BorderStyle.solid,
        width: 7.0,
      );
      expect(result.value.start?.mixValue?.color, resolvesTo(Colors.green));
      expect(result.value.start?.mixValue?.width, resolvesTo(7.0));
      expect(
        result.value.start?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.start?.mixValue?.strokeAlign, resolvesTo(0.2));
      expect(result.value.end?.mixValue?.color, resolvesTo(Colors.green));
      expect(result.value.end?.mixValue?.width, resolvesTo(7.0));
      expect(result.value.end?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.end?.mixValue?.strokeAlign, resolvesTo(0.2));
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = borderDirectional.vertical.color(Colors.yellow);
      final resultWidth = borderDirectional.vertical.width(20.0);
      final resultStyle = borderDirectional.vertical.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.vertical.strokeAlign(0.2);

      expect(
        resultColor.value.start?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.start?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.start?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.start?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(resultColor.value.end?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.end?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.end?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.end?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });

    test('borderDirectional.all()', () {
      final result = borderDirectional.all(
        color: Colors.purple,
        strokeAlign: 0.1,
        style: BorderStyle.solid,
        width: 3.0,
      );
      expect(result.value.top?.mixValue?.color, resolvesTo(Colors.purple));
      expect(result.value.top?.mixValue?.width, resolvesTo(3.0));
      expect(result.value.top?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.top?.mixValue?.strokeAlign, resolvesTo(0.1));
      expect(result.value.bottom?.mixValue?.color, resolvesTo(Colors.purple));
      expect(result.value.bottom?.mixValue?.width, resolvesTo(3.0));
      expect(
        result.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.bottom?.mixValue?.strokeAlign, resolvesTo(0.1));
      expect(result.value.start?.mixValue?.color, resolvesTo(Colors.purple));
      expect(result.value.start?.mixValue?.width, resolvesTo(3.0));
      expect(
        result.value.start?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(result.value.start?.mixValue?.strokeAlign, resolvesTo(0.1));
      expect(result.value.end?.mixValue?.color, resolvesTo(Colors.purple));
      expect(result.value.end?.mixValue?.width, resolvesTo(3.0));
      expect(result.value.end?.mixValue?.style, resolvesTo(BorderStyle.solid));
      expect(result.value.end?.mixValue?.strokeAlign, resolvesTo(0.1));

      final resultColor = borderDirectional.all.color(Colors.yellow);
      final resultWidth = borderDirectional.all.width(20.0);
      final resultStyle = borderDirectional.all.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.all.strokeAlign(0.2);

      expect(resultColor.value.top?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.top?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.top?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.top?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(
        resultColor.value.bottom?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.bottom?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.bottom?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.bottom?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(
        resultColor.value.start?.mixValue?.color,
        resolvesTo(Colors.yellow),
      );
      expect(resultWidth.value.start?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.start?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.start?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );

      expect(resultColor.value.end?.mixValue?.color, resolvesTo(Colors.yellow));
      expect(resultWidth.value.end?.mixValue?.width, resolvesTo(20.0));
      expect(
        resultStyle.value.end?.mixValue?.style,
        resolvesTo(BorderStyle.solid),
      );
      expect(
        resultStrokeAlign.value.end?.mixValue?.strokeAlign,
        resolvesTo(0.2),
      );
    });
  });
}
