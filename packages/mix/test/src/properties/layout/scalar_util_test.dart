import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Scalar Utilities Extensions', () {
    group('FontWeightUtility', () {
      final utility = MixUtility<MockStyle<FontWeight>, FontWeight>(MockStyle.new);

      test('bold() creates FontWeight.bold', () {
        final attr = utility.bold();
        expect(attr.value, FontWeight.bold);
      });

      test('normal() creates FontWeight.normal', () {
        final attr = utility.normal();
        expect(attr.value, FontWeight.normal);
      });

      test('w100() creates FontWeight.w100', () {
        final attr = utility.w100();
        expect(attr.value, FontWeight.w100);
      });

      test('w200() creates FontWeight.w200', () {
        final attr = utility.w200();
        expect(attr.value, FontWeight.w200);
      });

      test('w300() creates FontWeight.w300', () {
        final attr = utility.w300();
        expect(attr.value, FontWeight.w300);
      });

      test('w400() creates FontWeight.w400', () {
        final attr = utility.w400();
        expect(attr.value, FontWeight.w400);
      });

      test('w500() creates FontWeight.w500', () {
        final attr = utility.w500();
        expect(attr.value, FontWeight.w500);
      });

      test('w600() creates FontWeight.w600', () {
        final attr = utility.w600();
        expect(attr.value, FontWeight.w600);
      });

      test('w700() creates FontWeight.w700', () {
        final attr = utility.w700();
        expect(attr.value, FontWeight.w700);
      });

      test('w800() creates FontWeight.w800', () {
        final attr = utility.w800();
        expect(attr.value, FontWeight.w800);
      });

      test('w900() creates FontWeight.w900', () {
        final attr = utility.w900();
        expect(attr.value, FontWeight.w900);
      });
    });

    group('AlignmentUtility', () {
      final utility = MixUtility<MockStyle<AlignmentGeometry>, AlignmentGeometry>(MockStyle.new);

      test('topLeft() creates Alignment.topLeft', () {
        final attr = utility.topLeft();
        expect(attr.value, Alignment.topLeft);
      });

      test('topCenter() creates Alignment.topCenter', () {
        final attr = utility.topCenter();
        expect(attr.value, Alignment.topCenter);
      });

      test('topRight() creates Alignment.topRight', () {
        final attr = utility.topRight();
        expect(attr.value, Alignment.topRight);
      });

      test('centerLeft() creates Alignment.centerLeft', () {
        final attr = utility.centerLeft();
        expect(attr.value, Alignment.centerLeft);
      });

      test('center() creates Alignment.center', () {
        final attr = utility.center();
        expect(attr.value, Alignment.center);
      });

      test('centerRight() creates Alignment.centerRight', () {
        final attr = utility.centerRight();
        expect(attr.value, Alignment.centerRight);
      });

      test('bottomLeft() creates Alignment.bottomLeft', () {
        final attr = utility.bottomLeft();
        expect(attr.value, Alignment.bottomLeft);
      });

      test('bottomCenter() creates Alignment.bottomCenter', () {
        final attr = utility.bottomCenter();
        expect(attr.value, Alignment.bottomCenter);
      });

      test('bottomRight() creates Alignment.bottomRight', () {
        final attr = utility.bottomRight();
        expect(attr.value, Alignment.bottomRight);
      });

      test('only() creates custom Alignment', () {
        final attr = utility.only(x: 0.5, y: -0.5);
        expect(attr.value, const Alignment(0.5, -0.5));
      });

      test('only() creates AlignmentDirectional when start is provided', () {
        final attr = utility.only(start: 0.5, y: -0.5);
        expect(attr.value, const AlignmentDirectional(0.5, -0.5));
      });

      test('only() throws when both x and start are provided', () {
        expect(
          () => utility.only(x: 0.5, start: 0.5, y: -0.5),
          throwsAssertionError,
        );
      });
    });
  });
}
