import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
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

      final linearGradientDto = LinearGradientDto.maybeValue(linearGradient)!;
      final radialGradientDto = RadialGradientDto.maybeValue(radialGradient)!;
      final sweepGradientDto = SweepGradientDto.maybeValue(sweepGradient)!;

      expect(linearGradientDto, isA<LinearGradientDto>());
      expect(radialGradientDto, isA<RadialGradientDto>());
      expect(sweepGradientDto, isA<SweepGradientDto>());

      // MIGRATED: Clean assertions using custom matchers
      expect(linearGradientDto, resolvesTo(linearGradient));
      expect(radialGradientDto, resolvesTo(radialGradient));
      expect(sweepGradientDto, resolvesTo(sweepGradient));
    });
  });

  group('LinearGradientDto', () {
    test('Constructor assigns correct properties', () {
      final gradientDto = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.clamp,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      expect(gradientDto.begin, Alignment.topLeft);
      expect(gradientDto.end, Alignment.bottomRight);
      expect(gradientDto.stops, [0.0, 1.0]);
      expect(gradientDto.tileMode, TileMode.clamp);
    });

    test(
      'from method correctly converts LinearGradient to LinearGradientDto',
      () {
        const linearGradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
        );
        final gradientDto = LinearGradientDto.maybeValue(linearGradient)!;

        expect(gradientDto.begin, linearGradient.begin);
        expect(gradientDto.end, linearGradient.end);
        expect(gradientDto.stops, linearGradient.stops);
      },
    );

    test('resolve method returns correct LinearGradient', () {
      final gradientDto = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      final resolvedGradient = gradientDto.resolve(EmptyMixData);

      expect(resolvedGradient, isA<LinearGradient>());
      expect(resolvedGradient.colors.length, 2);
    });

    test('merge method correctly merges two LinearGradientDtos', () {
      final gradientDto1 = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );
      final gradientDto2 = LinearGradientDto(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [Colors.green, Colors.yellow],
        stops: const [0.25, 0.75],
      );

      final mergedGradient = gradientDto1.merge(gradientDto2);

      expect(mergedGradient.begin, gradientDto2.begin);
      expect(mergedGradient.end, gradientDto2.end);
      expect(mergedGradient.colors, isNotNull);
      expect(mergedGradient.stops, [0.25, 0.75]);
    });

    test('== operator returns true for equal objects', () {
      final gradientDto1 = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );
      final gradientDto2 = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      expect(gradientDto1 == gradientDto2, true);
    });

    test('== operator returns false for different objects', () {
      final gradientDto1 = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );
      final gradientDto2 = LinearGradientDto(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: const [Colors.green, Colors.yellow],
        stops: const [0.25, 0.75],
      );

      expect(gradientDto1 == gradientDto2, false);
    });
  });

  // RadialGradientDto
  group('RadialGradientDto', () {
    test('Constructor assigns correct properties', () {
      final gradientDto = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        tileMode: TileMode.clamp,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      expect(gradientDto.center, Alignment.center);
      expect(gradientDto.radius, 0.5);
      expect(gradientDto.stops, [0.0, 1.0]);
      expect(gradientDto.tileMode, TileMode.clamp);
    });

    test(
      'from method correctly converts RadialGradient to RadialGradientDto',
      () {
        const radialGradient = RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
        );
        final gradientDto = RadialGradientDto.maybeValue(radialGradient)!;

        expect(gradientDto.center, radialGradient.center);
        expect(gradientDto.radius, radialGradient.radius);
        expect(gradientDto.stops, radialGradient.stops);
      },
    );

    test('resolve method returns correct RadialGradient', () {
      final gradientDto = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      final resolvedGradient = gradientDto.resolve(EmptyMixData);

      expect(resolvedGradient, isA<RadialGradient>());
      expect(resolvedGradient.colors.length, 2);
    });

    test('merge method correctly merges two RadialGradientDtos', () {
      final gradientDto1 = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );
      final gradientDto2 = RadialGradientDto(
        center: Alignment.centerLeft,
        radius: 0.75,
        colors: const [Colors.green, Colors.yellow],
        stops: const [0.25, 0.75],
      );

      final mergedGradient = gradientDto1.merge(gradientDto2);

      expect(mergedGradient.center, gradientDto2.center);
      expect(mergedGradient.radius, gradientDto2.radius);
      expect(mergedGradient.colors, isNotNull);
      expect(mergedGradient.stops, [0.25, 0.75]);
    });

    test('== operator returns true for equal objects', () {
      final gradientDto1 = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );
      final gradientDto2 = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      expect(gradientDto1 == gradientDto2, true);
    });

    test('== operator returns false for different objects', () {
      final gradientDto1 = RadialGradientDto(
        center: Alignment.center,
        radius: 0.5,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );
      final gradientDto2 = RadialGradientDto(
        center: Alignment.centerLeft,
        radius: 0.75,
        colors: const [Colors.green, Colors.yellow],
        stops: const [0.25, 0.75],
      );

      expect(gradientDto1 == gradientDto2, false);
    });
  });

  // SweepGradientDto
  group('SweepGradientDto', () {
    test('Constructor assigns correct properties', () {
      final gradientDto = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        tileMode: TileMode.clamp,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );
      expect(gradientDto.center, Alignment.center);
      expect(gradientDto.startAngle, 0.0);
      expect(gradientDto.endAngle, 1.0);
      expect(gradientDto.stops, [0.0, 1.0]);
      expect(gradientDto.tileMode, TileMode.clamp);
    });

    test(
      'from method correctly converts SweepGradient to SweepGradientDto',
      () {
        const sweepGradient = SweepGradient(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 1.0,
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
        );
        final gradientDto = SweepGradientDto.maybeValue(sweepGradient)!;

        expect(gradientDto.center, sweepGradient.center);
        expect(gradientDto.startAngle, sweepGradient.startAngle);
        expect(gradientDto.endAngle, sweepGradient.endAngle);
        expect(gradientDto.stops, sweepGradient.stops);
      },
    );

    test('resolve method returns correct SweepGradient', () {
      final gradientDto = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      final resolvedGradient = gradientDto.resolve(EmptyMixData);

      expect(resolvedGradient, isA<SweepGradient>());
      expect(resolvedGradient.colors.length, 2);
    });

    test('merge method correctly merges two SweepGradientDtos', () {
      final gradientDto1 = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      final gradientDto2 = SweepGradientDto(
        center: Alignment.centerLeft,
        startAngle: 0.25,
        endAngle: 0.75,
        colors: const [Colors.green, Colors.yellow],
        stops: const [0.25, 0.75],
      );

      final mergedGradient = gradientDto1.merge(gradientDto2);

      expect(mergedGradient.center, gradientDto2.center);
      expect(mergedGradient.startAngle, gradientDto2.startAngle);
      expect(mergedGradient.endAngle, gradientDto2.endAngle);
      expect(mergedGradient.colors, isNotNull);
      expect(mergedGradient.stops, [0.25, 0.75]);
    });

    test('== operator returns true for equal objects', () {
      final gradientDto1 = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      final gradientDto2 = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      expect(gradientDto1 == gradientDto2, true);
    });

    test('== operator returns false for different objects', () {
      final gradientDto1 = SweepGradientDto(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );

      final gradientDto2 = SweepGradientDto(
        center: Alignment.centerLeft,
        startAngle: 0.25,
        endAngle: 0.75,
        colors: const [Colors.green, Colors.yellow],
        stops: const [0.25, 0.75],
      );

      expect(gradientDto1 == gradientDto2, false);
    });
  });
}
