import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Extensions', () {
    test('StrutStyle', () {
      const value = StrutStyle(
        fontFamily: 'Roboto',
        fontFamilyFallback: ['Arial', 'Helvetica'],
        fontSize: 14.0,
        height: 1.2,
        leading: 5.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        forceStrutHeight: true,
      );

      final dto = StrutStyleDto.value(value);

      // Resolves correctly
      expect(dto.resolve(EmptyMixData), value);
    });

    test('ShapeDecoration', () {
      const value = ShapeDecoration(
        gradient: RadialGradient(colors: [Colors.red, Colors.blue]),
        shadows: [BoxShadow(blurRadius: 5.0)],
        shape: CircleBorder(),
      );

      final dto = ShapeDecorationDto(
        gradient: value.gradient != null
            ? RadialGradientDto.maybeValue(value.gradient! as RadialGradient)
            : null,
        shadows: value.shadows?.map((e) => BoxShadowDto.value(e)).toList(),
        shape: CircleBorderDto(),
      );

      expect(dto, isA<ShapeDecorationDto>());
      expect(dto.resolve(EmptyMixData), value);
    });

    test('BoxConstraints toAttribute', () {
      const value = BoxConstraints(
        minWidth: 100.0,
        maxWidth: 200.0,
        minHeight: 150.0,
        maxHeight: 250.0,
      );

      final dto = BoxConstraintsDto.value(value);

      expect(dto, isA<BoxConstraintsDto>());
      expect(dto.resolve(EmptyMixData), value);
    });

    test('BoxDecoration toAttribute', () {
      final value = BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(blurRadius: 5.0)],
        gradient: const LinearGradient(colors: [Colors.red, Colors.blue]),
      );

      final dto = BoxDecorationDto(
        color: value.color,
        border: value.border != null
            ? BorderDto.value(value.border! as Border)
            : null,
        borderRadius: value.borderRadius != null
            ? BorderRadiusGeometryDto.value(value.borderRadius!)
            : null,
        boxShadow: value.boxShadow?.map((e) => BoxShadowDto.value(e)).toList(),
        gradient: value.gradient != null
            ? LinearGradientDto.maybeValue(value.gradient! as LinearGradient)
            : null,
      );

      expect(dto, isA<BoxDecorationDto>());
      expect(dto.resolve(EmptyMixData), value);
    });

    test('BorderRadiusGeometry', () {
      final value = BorderRadius.circular(10.0);

      final dto = BorderRadiusGeometryDto.value(value);

      expect(dto, isA<BorderRadiusGeometryDto>());
      expect(dto.resolve(EmptyMixData), value);
    });

    test('BorderSide', () {
      const value = BorderSide(
        color: Colors.blue,
        width: 2.0,
        style: BorderStyle.solid,
      );

      final dto = BorderSideDto.value(value);

      expect(dto, isA<BorderSideDto>());
      expect(dto.color, Mix.value(Colors.blue));
      expect(dto.width, 2.0);
      expect(dto.style, BorderStyle.solid);

      // Resolves correctly
      expect(dto.resolve(EmptyMixData), value);
    });

    test('BoxBorder', () {
      //  Border
      const value = Border(
        top: BorderSide(color: Colors.red),
        bottom: BorderSide(color: Colors.blue),
      );

      expect(BorderDto.value(value), isA<BoxBorderDto>());

      // BorderDirectional
      const value2 = BorderDirectional(
        top: BorderSide(color: Colors.red),
        bottom: BorderSide(color: Colors.blue),
      );

      expect(BorderDirectionalDto.value(value2), isA<BoxBorderDto>());
    });

    test('Shadow', () {
      const value = BoxShadow(color: Colors.black, blurRadius: 10.0);

      final dto = BoxShadowDto.value(value);

      expect(dto, isA<BoxShadowDto>());
      expect(dto.blurRadius, 10.0);
      expect(dto.color, Mix.value(Colors.black));

      // Resolves correctly
      expect(dto.resolve(EmptyMixData), value);
    });

    test('BoxShadow', () {
      const value = BoxShadow(color: Colors.grey, blurRadius: 5.0);

      final dto = BoxShadowDto.value(value);

      expect(dto, isA<BoxShadowDto>());
      expect(dto.blurRadius, 5.0);
      expect(dto.color, Mix.value(Colors.grey));

      // Resolves correctly
      expect(dto.resolve(EmptyMixData), value);
    });

    test('TextStyle ', () {
      const value = TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      );

      final dto = TextStyleDto.value(value);

      expect(dto, isA<TextStyleDto>());

      // Resolve and compare individual properties to avoid Flutter beta bug
      final resolved = dto.resolve(EmptyMixData);
      expect(resolved.color, value.color);
      expect(resolved.fontSize, value.fontSize);
      expect(resolved.fontWeight, value.fontWeight);
    });
  });

  test('EdgeInsetsGeometry toDto', () {
    const value = EdgeInsets.all(10.0);
    final dto = EdgeInsetsGeometryDto.value(value);

    expect(dto, isA<EdgeInsetsGeometryDto>());
    expect(dto.resolve(EmptyMixData), value);
  });

  test('Gradient toDto', () {
    const linearGradient = LinearGradient(colors: [Colors.red, Colors.blue]);
    final linearGradientDto = LinearGradientDto.maybeValue(linearGradient)!;
    expect(linearGradientDto, isA<LinearGradientDto>());
    expect(linearGradientDto.resolve(EmptyMixData), linearGradient);

    const radialGradient = RadialGradient(colors: [Colors.red, Colors.blue]);
    final radialGradientDto = RadialGradientDto.maybeValue(radialGradient)!;
    expect(radialGradientDto, isA<RadialGradientDto>());
    expect(radialGradientDto.resolve(EmptyMixData), radialGradient);

    const sweepGradient = SweepGradient(colors: [Colors.red, Colors.blue]);
    final sweepGradientDto = SweepGradientDto.maybeValue(sweepGradient)!;
    expect(sweepGradientDto, isA<SweepGradientDto>());
    expect(sweepGradientDto.resolve(EmptyMixData), sweepGradient);
  });

  test('Matrix4 merge', () {
    final matrix1 = Matrix4.identity();
    final matrix2 = Matrix4.rotationZ(0.5);

    final mergedMatrix = matrix1.merge(matrix2);

    expect(mergedMatrix, isNot(equals(matrix1)));
    expect(mergedMatrix, equals(matrix2));
  });

  test('List<Shadow> toDto', () {
    const shadows = [
      Shadow(color: Colors.black, blurRadius: 10.0),
      Shadow(color: Colors.grey, blurRadius: 5.0),
    ];

    final dtos = shadows.map((e) => ShadowDto.value(e)).toList();

    expect(dtos, isA<List<ShadowDto>>());
    expect(dtos.length, equals(shadows.length));
    expect(dtos.map((e) => e.resolve(EmptyMixData)), equals(shadows));
  });

  test('List<BoxShadow> toDto', () {
    const boxShadows = [
      BoxShadow(color: Colors.black, blurRadius: 10.0),
      BoxShadow(color: Colors.grey, blurRadius: 5.0),
    ];

    final dtos = boxShadows.map((e) => BoxShadowDto.value(e)).toList();

    expect(dtos, isA<List<BoxShadowDto>>());
    expect(dtos.length, equals(boxShadows.length));
    expect(dtos.map((e) => e.resolve(EmptyMixData)), equals(boxShadows));
  });

  test('double toRadius', () {
    const value = 10.0;
    final radius = value.toRadius();

    expect(radius, isA<Radius>());
    expect(radius, equals(const Radius.circular(10.0)));
  });

  test('BorderRadiusGeometry toDto', () {
    final value = BorderRadius.circular(10.0);
    final dto = BorderRadiusGeometryDto.value(value);

    expect(dto, isA<BorderRadiusGeometryDto>());
    expect(dto.resolve(EmptyMixData), value);
  });
}
