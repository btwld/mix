import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

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

      expect(result.value.top?.color?.value, Colors.red);
      expect(result.value.top?.width, 10.0);
      expect(result.value.top?.style, BorderStyle.solid);
      expect(result.value.top?.strokeAlign, 0.5);
      expect(result.value.right, null);
      expect(result.value.bottom, null);
      expect(result.value.left, null);

      final resultColor = border.top.color(Colors.yellow);
      final resultWidth = border.top.width(20.0);
      final resultStyle = border.top.style(BorderStyle.solid);
      final resultStrokeAlign = border.top.strokeAlign(0.2);

      expect(resultColor.value.top?.color?.value, Colors.yellow);
      expect(resultWidth.value.top?.width, 20.0);
      expect(resultStyle.value.top?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.top?.strokeAlign, 0.2);
    });

    test('border.bottom()', () {
      final result = border.bottom(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );

      expect(result.value.bottom?.color?.value, Colors.red);
      expect(result.value.bottom?.width, 10.0);
      expect(result.value.bottom?.style, BorderStyle.solid);
      expect(result.value.bottom?.strokeAlign, 0.5);
      expect(result.value.right, null);
      expect(result.value.top, null);
      expect(result.value.left, null);

      final resultColor = border.bottom.color(Colors.yellow);
      final resultWidth = border.bottom.width(20.0);
      final resultStyle = border.bottom.style(BorderStyle.solid);
      final resultStrokeAlign = border.bottom.strokeAlign(0.2);

      expect(resultColor.value.bottom?.color?.value, Colors.yellow);
      expect(resultWidth.value.bottom?.width, 20.0);
      expect(resultStyle.value.bottom?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.bottom?.strokeAlign, 0.2);
    });

    test('border.left()', () {
      final result = border.left(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );
      expect(result.value.left?.color?.value, Colors.red);
      expect(result.value.left?.width, 10.0);
      expect(result.value.left?.style, BorderStyle.solid);
      expect(result.value.left?.strokeAlign, 0.5);
      expect(result.value.right, null);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = border.left.color(Colors.yellow);
      final resultWidth = border.left.width(20.0);
      final resultStyle = border.left.style(BorderStyle.solid);
      final resultStrokeAlign = border.left.strokeAlign(0.2);

      expect(resultColor.value.left?.color?.value, Colors.yellow);
      expect(resultWidth.value.left?.width, 20.0);
      expect(resultStyle.value.left?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.left?.strokeAlign, 0.2);
    });

    test('border.right()', () {
      final result = border.right(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );
      expect(result.value.right?.color?.value, Colors.red);
      expect(result.value.right?.width, 10.0);
      expect(result.value.right?.style, BorderStyle.solid);
      expect(result.value.right?.strokeAlign, 0.5);
      expect(result.value.left, null);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = border.right.color(Colors.yellow);
      final resultWidth = border.right.width(20.0);
      final resultStyle = border.right.style(BorderStyle.solid);
      final resultStrokeAlign = border.right.strokeAlign(0.2);

      expect(resultColor.value.right?.color?.value, Colors.yellow);
      expect(resultWidth.value.right?.width, 20.0);
      expect(resultStyle.value.right?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.right?.strokeAlign, 0.2);
    });

    test('border.horizontal()', () {
      final result = border.horizontal(
        color: Colors.blue,
        strokeAlign: 0.3,
        style: BorderStyle.solid,
        width: 5.0,
      );
      expect(result.value.top?.color?.value, Colors.blue);
      expect(result.value.top?.width, 5.0);
      expect(result.value.top?.style, BorderStyle.solid);
      expect(result.value.top?.strokeAlign, 0.3);
      expect(result.value.bottom?.color?.value, Colors.blue);
      expect(result.value.bottom?.width, 5.0);
      expect(result.value.bottom?.style, BorderStyle.solid);
      expect(result.value.bottom?.strokeAlign, 0.3);
      expect(result.value.left, null);
      expect(result.value.right, null);

      final resultColor = border.horizontal.color(Colors.yellow);
      final resultWidth = border.horizontal.width(20.0);
      final resultStyle = border.horizontal.style(BorderStyle.solid);
      final resultStrokeAlign = border.horizontal.strokeAlign(0.2);

      expect(resultColor.value.top?.color?.value, Colors.yellow);
      expect(resultWidth.value.top?.width, 20.0);
      expect(resultStyle.value.top?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.top?.strokeAlign, 0.2);

      expect(resultColor.value.bottom?.color?.value, Colors.yellow);
      expect(resultWidth.value.bottom?.width, 20.0);
      expect(resultStyle.value.bottom?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.bottom?.strokeAlign, 0.2);
    });

    test('border.vertical()', () {
      final result = border.vertical(
        color: Colors.green,
        strokeAlign: 0.2,
        style: BorderStyle.solid,
        width: 7.0,
      );
      expect(result.value.left?.color?.value, Colors.green);
      expect(result.value.left?.width, 7.0);
      expect(result.value.left?.style, BorderStyle.solid);
      expect(result.value.left?.strokeAlign, 0.2);
      expect(result.value.right?.color?.value, Colors.green);
      expect(result.value.right?.width, 7.0);
      expect(result.value.right?.style, BorderStyle.solid);
      expect(result.value.right?.strokeAlign, 0.2);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = border.vertical.color(Colors.yellow);
      final resultWidth = border.vertical.width(20.0);
      final resultStyle = border.vertical.style(BorderStyle.solid);
      final resultStrokeAlign = border.vertical.strokeAlign(0.2);

      expect(resultColor.value.left?.color?.value, Colors.yellow);
      expect(resultWidth.value.left?.width, 20.0);
      expect(resultStyle.value.left?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.left?.strokeAlign, 0.2);

      expect(resultColor.value.right?.color?.value, Colors.yellow);
      expect(resultWidth.value.right?.width, 20.0);
      expect(resultStyle.value.right?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.right?.strokeAlign, 0.2);
    });

    test('border.all()', () {
      final result = border.all(
        color: Colors.purple,
        strokeAlign: 0.1,
        style: BorderStyle.solid,
        width: 3.0,
      );
      expect(result.value.top?.color?.value, Colors.purple);
      expect(result.value.top?.width, 3.0);
      expect(result.value.top?.style, BorderStyle.solid);
      expect(result.value.top?.strokeAlign, 0.1);
      expect(result.value.bottom?.color?.value, Colors.purple);
      expect(result.value.bottom?.width, 3.0);
      expect(result.value.bottom?.style, BorderStyle.solid);
      expect(result.value.bottom?.strokeAlign, 0.1);
      expect(result.value.left?.color?.value, Colors.purple);
      expect(result.value.left?.width, 3.0);
      expect(result.value.left?.style, BorderStyle.solid);
      expect(result.value.left?.strokeAlign, 0.1);
      expect(result.value.right?.color?.value, Colors.purple);
      expect(result.value.right?.width, 3.0);
      expect(result.value.right?.style, BorderStyle.solid);
      expect(result.value.right?.strokeAlign, 0.1);

      final resultColor = border.all.color(Colors.yellow);
      final resultWidth = border.all.width(20.0);
      final resultStyle = border.all.style(BorderStyle.solid);
      final resultStrokeAlign = border.all.strokeAlign(0.2);

      expect(resultColor.value.top?.color?.value, Colors.yellow);
      expect(resultWidth.value.top?.width, 20.0);
      expect(resultStyle.value.top?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.top?.strokeAlign, 0.2);

      expect(resultColor.value.bottom?.color?.value, Colors.yellow);
      expect(resultWidth.value.bottom?.width, 20.0);
      expect(resultStyle.value.bottom?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.bottom?.strokeAlign, 0.2);

      expect(resultColor.value.left?.color?.value, Colors.yellow);
      expect(resultWidth.value.left?.width, 20.0);
      expect(resultStyle.value.left?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.left?.strokeAlign, 0.2);

      expect(resultColor.value.right?.color?.value, Colors.yellow);
      expect(resultWidth.value.right?.width, 20.0);
      expect(resultStyle.value.right?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.right?.strokeAlign, 0.2);
    });
  });

  // BorderDirectionalUtility

  group('BorderDirectionalUtility', () {
    final borderDirectional =
        BorderDirectionalUtility(UtilityTestAttribute.new);

    test('borderDirectional.top()', () {
      final result = borderDirectional.top(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );

      expect(result.value.top?.color?.value, Colors.red);
      expect(result.value.top?.width, 10.0);
      expect(result.value.top?.style, BorderStyle.solid);
      expect(result.value.top?.strokeAlign, 0.5);
      expect(result.value.end, null);
      expect(result.value.bottom, null);
      expect(result.value.start, null);

      final resultColor = borderDirectional.top.color(Colors.yellow);
      final resultWidth = borderDirectional.top.width(20.0);
      final resultStyle = borderDirectional.top.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.top.strokeAlign(0.2);

      expect(resultColor.value.top?.color?.value, Colors.yellow);
      expect(resultWidth.value.top?.width, 20.0);
      expect(resultStyle.value.top?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.top?.strokeAlign, 0.2);
    });

    test('borderDirectional.bottom()', () {
      final result = borderDirectional.bottom(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );

      expect(result.value.bottom?.color?.value, Colors.red);
      expect(result.value.bottom?.width, 10.0);
      expect(result.value.bottom?.style, BorderStyle.solid);
      expect(result.value.bottom?.strokeAlign, 0.5);
      expect(result.value.end, null);
      expect(result.value.top, null);
      expect(result.value.start, null);

      final resultColor = borderDirectional.bottom.color(Colors.yellow);
      final resultWidth = borderDirectional.bottom.width(20.0);
      final resultStyle = borderDirectional.bottom.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.bottom.strokeAlign(0.2);

      expect(resultColor.value.bottom?.color?.value, Colors.yellow);
      expect(resultWidth.value.bottom?.width, 20.0);
      expect(resultStyle.value.bottom?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.bottom?.strokeAlign, 0.2);
    });

    test('borderDirectional.start()', () {
      final result = borderDirectional.start(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );
      expect(result.value.start?.color?.value, Colors.red);
      expect(result.value.start?.width, 10.0);
      expect(result.value.start?.style, BorderStyle.solid);
      expect(result.value.start?.strokeAlign, 0.5);
      expect(result.value.end, null);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = borderDirectional.start.color(Colors.yellow);
      final resultWidth = borderDirectional.start.width(20.0);
      final resultStyle = borderDirectional.start.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.start.strokeAlign(0.2);

      expect(resultColor.value.start?.color?.value, Colors.yellow);
      expect(resultWidth.value.start?.width, 20.0);
      expect(resultStyle.value.start?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.start?.strokeAlign, 0.2);
    });

    test('borderDirectional.end()', () {
      final result = borderDirectional.end(
        color: Colors.red,
        strokeAlign: 0.5,
        style: BorderStyle.solid,
        width: 10.0,
      );
      expect(result.value.end?.color?.value, Colors.red);
      expect(result.value.end?.width, 10.0);
      expect(result.value.end?.style, BorderStyle.solid);
      expect(result.value.end?.strokeAlign, 0.5);
      expect(result.value.start, null);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = borderDirectional.end.color(Colors.yellow);
      final resultWidth = borderDirectional.end.width(20.0);
      final resultStyle = borderDirectional.end.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.end.strokeAlign(0.2);

      expect(resultColor.value.end?.color?.value, Colors.yellow);
      expect(resultWidth.value.end?.width, 20.0);
      expect(resultStyle.value.end?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.end?.strokeAlign, 0.2);
    });

    test('borderDirectional.horizontal()', () {
      final result = borderDirectional.horizontal(
        color: Colors.blue,
        strokeAlign: 0.3,
        style: BorderStyle.solid,
        width: 5.0,
      );
      expect(result.value.top?.color?.value, Colors.blue);
      expect(result.value.top?.width, 5.0);
      expect(result.value.top?.style, BorderStyle.solid);
      expect(result.value.top?.strokeAlign, 0.3);
      expect(result.value.bottom?.color?.value, Colors.blue);
      expect(result.value.bottom?.width, 5.0);
      expect(result.value.bottom?.style, BorderStyle.solid);
      expect(result.value.bottom?.strokeAlign, 0.3);
      expect(result.value.start, null);
      expect(result.value.end, null);

      final resultColor = borderDirectional.horizontal.color(Colors.yellow);
      final resultWidth = borderDirectional.horizontal.width(20.0);
      final resultStyle = borderDirectional.horizontal.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.horizontal.strokeAlign(0.2);

      expect(resultColor.value.top?.color?.value, Colors.yellow);
      expect(resultWidth.value.top?.width, 20.0);
      expect(resultStyle.value.top?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.top?.strokeAlign, 0.2);

      expect(resultColor.value.bottom?.color?.value, Colors.yellow);
      expect(resultWidth.value.bottom?.width, 20.0);
      expect(resultStyle.value.bottom?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.bottom?.strokeAlign, 0.2);
    });

    test('borderDirectional.vertical()', () {
      final result = borderDirectional.vertical(
        color: Colors.green,
        strokeAlign: 0.2,
        style: BorderStyle.solid,
        width: 7.0,
      );
      expect(result.value.start?.color?.value, Colors.green);
      expect(result.value.start?.width, 7.0);
      expect(result.value.start?.style, BorderStyle.solid);
      expect(result.value.start?.strokeAlign, 0.2);
      expect(result.value.end?.color?.value, Colors.green);
      expect(result.value.end?.width, 7.0);
      expect(result.value.end?.style, BorderStyle.solid);
      expect(result.value.end?.strokeAlign, 0.2);
      expect(result.value.top, null);
      expect(result.value.bottom, null);

      final resultColor = borderDirectional.vertical.color(Colors.yellow);
      final resultWidth = borderDirectional.vertical.width(20.0);
      final resultStyle = borderDirectional.vertical.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.vertical.strokeAlign(0.2);

      expect(resultColor.value.start?.color?.value, Colors.yellow);
      expect(resultWidth.value.start?.width, 20.0);
      expect(resultStyle.value.start?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.start?.strokeAlign, 0.2);

      expect(resultColor.value.end?.color?.value, Colors.yellow);
      expect(resultWidth.value.end?.width, 20.0);
      expect(resultStyle.value.end?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.end?.strokeAlign, 0.2);
    });

    test('borderDirectional.all()', () {
      final result = borderDirectional.all(
        color: Colors.purple,
        strokeAlign: 0.1,
        style: BorderStyle.solid,
        width: 3.0,
      );
      expect(result.value.top?.color?.value, Colors.purple);
      expect(result.value.top?.width, 3.0);
      expect(result.value.top?.style, BorderStyle.solid);
      expect(result.value.top?.strokeAlign, 0.1);
      expect(result.value.bottom?.color?.value, Colors.purple);
      expect(result.value.bottom?.width, 3.0);
      expect(result.value.bottom?.style, BorderStyle.solid);
      expect(result.value.bottom?.strokeAlign, 0.1);
      expect(result.value.start?.color?.value, Colors.purple);
      expect(result.value.start?.width, 3.0);
      expect(result.value.start?.style, BorderStyle.solid);
      expect(result.value.start?.strokeAlign, 0.1);
      expect(result.value.end?.color?.value, Colors.purple);
      expect(result.value.end?.width, 3.0);
      expect(result.value.end?.style, BorderStyle.solid);
      expect(result.value.end?.strokeAlign, 0.1);

      final resultColor = borderDirectional.all.color(Colors.yellow);
      final resultWidth = borderDirectional.all.width(20.0);
      final resultStyle = borderDirectional.all.style(BorderStyle.solid);
      final resultStrokeAlign = borderDirectional.all.strokeAlign(0.2);

      expect(resultColor.value.top?.color?.value, Colors.yellow);
      expect(resultWidth.value.top?.width, 20.0);
      expect(resultStyle.value.top?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.top?.strokeAlign, 0.2);

      expect(resultColor.value.bottom?.color?.value, Colors.yellow);
      expect(resultWidth.value.bottom?.width, 20.0);
      expect(resultStyle.value.bottom?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.bottom?.strokeAlign, 0.2);

      expect(resultColor.value.start?.color?.value, Colors.yellow);
      expect(resultWidth.value.start?.width, 20.0);
      expect(resultStyle.value.start?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.start?.strokeAlign, 0.2);

      expect(resultColor.value.end?.color?.value, Colors.yellow);
      expect(resultWidth.value.end?.width, 20.0);
      expect(resultStyle.value.end?.style, BorderStyle.solid);
      expect(resultStrokeAlign.value.end?.strokeAlign, 0.2);
    });
  });
}
