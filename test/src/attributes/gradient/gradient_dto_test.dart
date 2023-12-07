import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  // GradientDto
  group('GradientDto', () {
    test('from method correctly converts Gradient to GradientDto', () {
      const linearGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );

      const radialGradient = RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );

      const sweepGradient = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );

      final linearGradientDto = GradientDto.from(linearGradient);
      final radialGradientDto = GradientDto.from(radialGradient);
      final sweepGradientDto = GradientDto.from(sweepGradient);

      expect(linearGradientDto, isA<LinearGradientDto>());
      expect(radialGradientDto, isA<RadialGradientDto>());
      expect(sweepGradientDto, isA<SweepGradientDto>());

      final resolvedLinearGradient = linearGradientDto.resolve(EmptyMixData);
      final resolvedRadialGradient = radialGradientDto.resolve(EmptyMixData);
      final resolvedSweepGradient = sweepGradientDto.resolve(EmptyMixData);

      expect(resolvedLinearGradient, isA<LinearGradient>());
      expect(resolvedLinearGradient, linearGradient);
      expect(resolvedRadialGradient, isA<RadialGradient>());
      expect(resolvedRadialGradient, radialGradient);
      expect(resolvedSweepGradient, isA<SweepGradient>());
      expect(resolvedSweepGradient, sweepGradient);
    });
  });

  group('LinearGradientDto', () {
    test('Constructor assigns correct properties', () {
      const gradientDto = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      );

      expect(gradientDto.begin, Alignment.topLeft);
      expect(gradientDto.end, Alignment.bottomRight);
      expect(gradientDto.colors?.length, 2);
      expect(gradientDto.stops, [0.0, 1.0]);
      expect(gradientDto.tileMode, TileMode.clamp);
    });

    test('from method correctly converts LinearGradient to LinearGradientDto',
        () {
      const linearGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );
      final gradientDto = LinearGradientDto.from(linearGradient);

      expect(gradientDto.begin, linearGradient.begin);
      expect(gradientDto.end, linearGradient.end);
      expect(gradientDto.colors?.length, linearGradient.colors.length);
      expect(gradientDto.stops, linearGradient.stops);
    });

    test('resolve method returns correct LinearGradient', () {
      const gradientDto = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      final resolvedGradient = gradientDto.resolve(EmptyMixData);

      expect(resolvedGradient, isA<LinearGradient>());
      expect(resolvedGradient.colors.length, 2);
    });

    test('merge method correctly merges two LinearGradientDtos', () {
      const gradientDto1 = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );
      const gradientDto2 = LinearGradientDto(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [ColorDto(Colors.green), ColorDto(Colors.yellow)],
        stops: [0.25, 0.75],
      );

      final mergedGradient = gradientDto1.merge(gradientDto2);

      expect(mergedGradient.begin, gradientDto2.begin);
      expect(mergedGradient.end, gradientDto2.end);
      expect(mergedGradient.colors, isNotNull);
      expect(mergedGradient.colors?.length, 2);
      expect(mergedGradient.stops, [0.25, 0.75]);
    });

    test('== operator returns true for equal objects', () {
      const gradientDto1 = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );
      const gradientDto2 = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      expect(gradientDto1 == gradientDto2, true);
    });

    test('== operator returns false for different objects', () {
      const gradientDto1 = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );
      const gradientDto2 = LinearGradientDto(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [ColorDto(Colors.green), ColorDto(Colors.yellow)],
        stops: [0.25, 0.75],
      );

      expect(gradientDto1 == gradientDto2, false);
    });
  });

  // RadialGradientDto
  group('RadialGradientDto', () {
    test('Constructor assigns correct properties', () {
      const gradientDto = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      );

      expect(gradientDto.center, Alignment.center);
      expect(gradientDto.radius, 0.5);
      expect(gradientDto.colors?.length, 2);
      expect(gradientDto.stops, [0.0, 1.0]);
      expect(gradientDto.tileMode, TileMode.clamp);
    });

    test('from method correctly converts RadialGradient to RadialGradientDto',
        () {
      const radialGradient = RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );
      final gradientDto = RadialGradientDto.from(radialGradient);

      expect(gradientDto.center, radialGradient.center);
      expect(gradientDto.radius, radialGradient.radius);
      expect(gradientDto.colors?.length, radialGradient.colors.length);
      expect(gradientDto.stops, radialGradient.stops);
    });

    test('resolve method returns correct RadialGradient', () {
      const gradientDto = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      final resolvedGradient = gradientDto.resolve(EmptyMixData);

      expect(resolvedGradient, isA<RadialGradient>());
      expect(resolvedGradient.colors.length, 2);
    });

    test('merge method correctly merges two RadialGradientDtos', () {
      const gradientDto1 = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );
      const gradientDto2 = RadialGradientDto(
        center: Alignment.centerLeft,
        radius: 0.75,
        colors: [ColorDto(Colors.green), ColorDto(Colors.yellow)],
        stops: [0.25, 0.75],
      );

      final mergedGradient = gradientDto1.merge(gradientDto2);

      expect(mergedGradient.center, gradientDto2.center);
      expect(mergedGradient.radius, gradientDto2.radius);
      expect(mergedGradient.colors, isNotNull);
      expect(mergedGradient.colors?.length, 2);
      expect(mergedGradient.stops, [0.25, 0.75]);
    });

    test('== operator returns true for equal objects', () {
      const gradientDto1 = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );
      const gradientDto2 = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      expect(gradientDto1 == gradientDto2, true);
    });

    test('== operator returns false for different objects', () {
      const gradientDto1 = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );
      const gradientDto2 = RadialGradientDto(
        center: Alignment.centerLeft,
        radius: 0.75,
        colors: [ColorDto(Colors.green), ColorDto(Colors.yellow)],
        stops: [0.25, 0.75],
      );

      expect(gradientDto1 == gradientDto2, false);
    });
  });

  // SweepGradientDto
  group('SweepGradientDto', () {
    test('Constructor assigns correct properties', () {
      const gradientDto = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp,
      );
      expect(gradientDto.center, Alignment.center);
      expect(gradientDto.startAngle, 0.0);
      expect(gradientDto.endAngle, 1.0);
      expect(gradientDto.colors?.length, 2);
      expect(gradientDto.stops, [0.0, 1.0]);
      expect(gradientDto.tileMode, TileMode.clamp);
    });

    test('from method correctly converts SweepGradient to SweepGradientDto',
        () {
      const sweepGradient = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );
      final gradientDto = SweepGradientDto.from(sweepGradient);

      expect(gradientDto.center, sweepGradient.center);
      expect(gradientDto.startAngle, sweepGradient.startAngle);
      expect(gradientDto.endAngle, sweepGradient.endAngle);
      expect(gradientDto.colors?.length, sweepGradient.colors.length);
      expect(gradientDto.stops, sweepGradient.stops);
    });

    test('resolve method returns correct SweepGradient', () {
      const gradientDto = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      final resolvedGradient = gradientDto.resolve(EmptyMixData);

      expect(resolvedGradient, isA<SweepGradient>());
      expect(resolvedGradient.colors.length, 2);
    });

    test('merge method correctly merges two SweepGradientDtos', () {
      const gradientDto1 = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      const gradientDto2 = SweepGradientDto(
        center: Alignment.centerLeft,
        startAngle: 0.25,
        endAngle: 0.75,
        colors: [ColorDto(Colors.green), ColorDto(Colors.yellow)],
        stops: [0.25, 0.75],
      );

      final mergedGradient = gradientDto1.merge(gradientDto2);

      expect(mergedGradient.center, gradientDto2.center);
      expect(mergedGradient.startAngle, gradientDto2.startAngle);
      expect(mergedGradient.endAngle, gradientDto2.endAngle);
      expect(mergedGradient.colors, isNotNull);
      expect(mergedGradient.colors?.length, 2);
      expect(mergedGradient.stops, [0.25, 0.75]);
    });

    test('== operator returns true for equal objects', () {
      const gradientDto1 = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      const gradientDto2 = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      expect(gradientDto1 == gradientDto2, true);
    });

    test('== operator returns false for different objects', () {
      const gradientDto1 = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [ColorDto(Colors.red), ColorDto(Colors.blue)],
        stops: [0.0, 1.0],
      );

      const gradientDto2 = SweepGradientDto(
        center: Alignment.centerLeft,
        startAngle: 0.25,
        endAngle: 0.75,
        colors: [ColorDto(Colors.green), ColorDto(Colors.yellow)],
        stops: [0.25, 0.75],
      );

      expect(gradientDto1 == gradientDto2, false);
    });
  });
}
