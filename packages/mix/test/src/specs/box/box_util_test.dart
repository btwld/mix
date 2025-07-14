import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

const $testvariant = Variant('test');
void main() {
  group('BoxUtility', () {
    final boxUtility = BoxSpecUtility(MixUtility.selfBuilder);
    test('call() returns correct instance', () {
      final constraints = BoxConstraintsDto(
        minWidth: 50,
        maxWidth: 200,
        minHeight: 40,
        maxHeight: 100,
      );

      final spacing = EdgeInsetsGeometryDto.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      );

      final container = boxUtility.only(
        alignment: Alignment.center,
        padding: spacing,
        margin: spacing,
        constraints: constraints,
        width: 10,
        height: 10,
        transform: Matrix4.identity(),
        clipBehavior: Clip.antiAlias,
      );

      expect(container.alignment, Alignment.center);
      expect(container.clipBehavior, Clip.antiAlias);

      expect(container.constraints, constraints);

      expect(container.height, 10);
      expect(container.margin, spacing);
      expect(container.padding, spacing);
      expect(container.transform, Matrix4.identity());
      expect(container.width, 10);
    });

    test('alignment() returns correct instance', () {
      final container = boxUtility.alignment(Alignment.center);

      expect(container.alignment, Alignment.center);
    });

    test('clipBehavior() returns correct instance', () {
      final container = boxUtility.clipBehavior(Clip.antiAlias);

      expect(container.clipBehavior, Clip.antiAlias);
    });

    test('color() returns correct instance', () {
      final container = boxUtility.color(Colors.blue);

      expect(
        (container.decoration as BoxDecorationDto).color,
        isA<Prop<Color>>(),
      );
    });

    test('constraints() returns correct instance', () {
      expect($box.constraints, isA<BoxConstraintsUtility>());
    });

    test('shape() returns correct instance', () {
      expect(boxUtility.shapeDecoration, isA<ShapeDecorationUtility>());
    });

    test('height() returns correct instance', () {
      final container = boxUtility.height(10);

      expect(container.height, 10);
    });

    test('margin() returns correct instance', () {
      expect(boxUtility.margin, isA<EdgeInsetsGeometryUtility>());
    });

    test('padding() returns correct instance', () {
      expect(boxUtility.padding, isA<EdgeInsetsGeometryUtility>());
    });

    test('transform() returns correct instance', () {
      final container = boxUtility.transform(Matrix4.identity());

      expect(container.transform, Matrix4.identity());
    });

    test('width() returns correct instance', () {
      final container = boxUtility.width(10);

      expect(container.width, 10);
    });

    test('decoration() returns correct instance', () {
      final container = boxUtility.decoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.amber,
      );

      expect(container.decoration!.color, isA<Prop<Color>>());

      final decorationDTO = container.decoration as BoxDecorationDto;
      expect(
        decorationDTO.borderRadius?.value,
        BorderRadiusDto.value(BorderRadius.circular(10)),
      );
    });

    test('foregroundDecoration() returns correct instance', () {
      final container = boxUtility.foregroundDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.amber,
      );

      expect(
        container.foregroundDecoration!.color,
        isA<Prop<Color>>(),
        reason: 'The color is not correct',
      );

      final foregroundDecorationDTO =
          container.foregroundDecoration as BoxDecorationDto;
      expect(
        foregroundDecorationDTO.borderRadius?.value,
        BorderRadiusDto.value(BorderRadius.circular(10)),
        reason: 'The BorderRadius is not correct',
      );
    });
  });
}
