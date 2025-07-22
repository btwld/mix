import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';
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

      final mix = StrutStyleMix.value(value);

      // Resolves correctly
      expect(mix, resolvesTo(value));
    });

    test('ShapeDecoration', () {
      const value = ShapeDecoration(
        gradient: RadialGradient(colors: [Colors.red, Colors.blue]),
        shadows: [BoxShadow(blurRadius: 5.0)],
        shape: CircleBorder(),
      );

      final mix = ShapeDecorationMix(
        gradient: value.gradient != null
            ? RadialGradientMix.maybeValue(value.gradient! as RadialGradient)
            : null,
        shadows: value.shadows?.map((e) => BoxShadowMix.value(e)).toList(),
        shape: CircleBorderMix(),
      );

      expect(mix, isA<ShapeDecorationMix>());
      expect(mix, resolvesTo(value));
    });

    test('BoxConstraints toAttribute', () {
      const value = BoxConstraints(
        minWidth: 100.0,
        maxWidth: 200.0,
        minHeight: 150.0,
        maxHeight: 250.0,
      );

      final mix = BoxConstraintsMix.value(value);

      expect(mix, isA<BoxConstraintsMix>());
      expect(mix, resolvesTo(value));
    });

    test('BoxDecoration toAttribute', () {
      final value = BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(blurRadius: 5.0)],
        gradient: const LinearGradient(colors: [Colors.red, Colors.blue]),
      );

      final mix = BoxDecorationMix(
        color: value.color,
        border: value.border != null
            ? BorderMix.value(value.border! as Border)
            : null,
        borderRadius: value.borderRadius != null
            ? BorderRadiusGeometryMix.value(value.borderRadius!)
            : null,
        boxShadow: value.boxShadow?.map((e) => BoxShadowMix.value(e)).toList(),
        gradient: value.gradient != null
            ? LinearGradientMix.maybeValue(value.gradient! as LinearGradient)
            : null,
      );

      expect(mix, isA<BoxDecorationMix>());
      expect(mix, resolvesTo(value));
    });

    test('BorderRadiusGeometry', () {
      final value = BorderRadius.circular(10.0);

      final mix = BorderRadiusGeometryMix.value(value);

      expect(mix, isA<BorderRadiusGeometryMix>());
      expect(mix, resolvesTo(value));
    });

    test('BorderSide', () {
      const value = BorderSide(
        color: Colors.blue,
        width: 2.0,
        style: BorderStyle.solid,
      );

      final mix = BorderSideMix.value(value);

      expect(mix, isA<BorderSideMix>());
      expect(mix.color, resolvesTo(Colors.blue));
      expect(mix.width, resolvesTo(2.0));
      expect(mix.style, resolvesTo(BorderStyle.solid));

      // Resolves correctly
      expect(mix, resolvesTo(value));
    });

    test('BoxBorder', () {
      //  Border
      const value = Border(
        top: BorderSide(color: Colors.red),
        bottom: BorderSide(color: Colors.blue),
      );

      expect(BorderMix.value(value), isA<BoxBorderMix>());

      // BorderDirectional
      const value2 = BorderDirectional(
        top: BorderSide(color: Colors.red),
        bottom: BorderSide(color: Colors.blue),
      );

      expect(BorderDirectionalMix.value(value2), isA<BoxBorderMix>());
    });

    test('Shadow', () {
      const value = BoxShadow(color: Colors.black, blurRadius: 10.0);

      final mix = BoxShadowMix.value(value);

      expect(mix, isA<BoxShadowMix>());
      expect(mix.blurRadius, resolvesTo(10.0));
      expect(mix.color, resolvesTo(Colors.black));

      // Resolves correctly
      expect(mix, resolvesTo(value));
    });

    test('BoxShadow', () {
      const value = BoxShadow(color: Colors.grey, blurRadius: 5.0);

      final mix = BoxShadowMix.value(value);

      expect(mix, isA<BoxShadowMix>());
      expect(mix.blurRadius, resolvesTo(5.0));
      expect(mix.color, resolvesTo(Colors.grey));

      // Resolves correctly
      expect(mix, resolvesTo(value));
    });

    test('TextStyle ', () {
      const value = TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      );

      final mix = TextStyleMix.value(value);

      expect(mix, isA<TextStyleMix>());

      expect(mix, resolvesTo(value));
    });
  });

  test('EdgeInsetsGeometry toMix', () {
    const value = EdgeInsets.all(10.0);
    final mix = EdgeInsetsGeometryMix.value(value);

    expect(mix, isA<EdgeInsetsGeometryMix>());
    expect(mix, resolvesTo(value));
  });

  test('Gradient toMix', () {
    const linearGradient = LinearGradient(colors: [Colors.red, Colors.blue]);
    final linearGradientMix = LinearGradientMix.maybeValue(linearGradient)!;
    expect(linearGradientMix, isA<LinearGradientMix>());
    expect(linearGradientMix, resolvesTo(linearGradient));

    const radialGradient = RadialGradient(colors: [Colors.red, Colors.blue]);
    final radialGradientMix = RadialGradientMix.maybeValue(radialGradient)!;
    expect(radialGradientMix, isA<RadialGradientMix>());
    expect(radialGradientMix, resolvesTo(radialGradient));

    const sweepGradient = SweepGradient(colors: [Colors.red, Colors.blue]);
    final sweepGradientMix = SweepGradientMix.maybeValue(sweepGradient)!;
    expect(sweepGradientMix, isA<SweepGradientMix>());
    expect(sweepGradientMix, resolvesTo(sweepGradient));
  });

  test('Matrix4 merge', () {
    final matrix1 = Matrix4.identity();
    final matrix2 = Matrix4.rotationZ(0.5);

    final mergedMatrix = matrix1.merge(matrix2);

    expect(mergedMatrix, isNot(equals(matrix1)));
    expect(mergedMatrix, equals(matrix2));
  });

  test('List<Shadow> toMix', () {
    const shadows = [
      Shadow(color: Colors.black, blurRadius: 10.0),
      Shadow(color: Colors.grey, blurRadius: 5.0),
    ];

    final mixList = shadows.map((e) => ShadowMix.value(e)).toList();

    expect(mixs, isA<List<ShadowMix>>());
    expect(mixs.length, equals(shadows.length));
    for (int i = 0; i < mixList.length; i++) {
      expect(mixs[i], resolvesTo(shadows[i]));
    }
  });

  test('List<BoxShadow> toMix', () {
    const boxShadows = [
      BoxShadow(color: Colors.black, blurRadius: 10.0),
      BoxShadow(color: Colors.grey, blurRadius: 5.0),
    ];

    final mixList = boxShadows.map((e) => BoxShadowMix.value(e)).toList();

    expect(mixs, isA<List<BoxShadowMix>>());
    expect(mixs.length, equals(boxShadows.length));
    for (int i = 0; i < mixList.length; i++) {
      expect(mixs[i], resolvesTo(boxShadows[i]));
    }
  });

  test('double toRadius', () {
    const value = 10.0;
    final radius = value.toRadius();

    expect(radius, isA<Radius>());
    expect(radius, equals(const Radius.circular(10.0)));
  });

  test('BorderRadiusGeometry toMix', () {
    final value = BorderRadius.circular(10.0);
    final mix = BorderRadiusGeometryMix.value(value);

    expect(mix, isA<BorderRadiusGeometryMix>());
    expect(mix, resolvesTo(value));
  });
}
