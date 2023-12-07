import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('GradientUtility', () {
    const utility = GradientUtility(UtilityTestDtoAttribute.new);
    test('GradientUtility.from for RadialGradient', () {
      const gradient = RadialGradient(colors: []);
      final attribute = utility.as(gradient);

      expect(attribute.value, isA<RadialGradientDto>());
      expect(attribute.resolve(EmptyMixData), isA<RadialGradient>());
    });

    test('GradientUtility.from for LinearGradient', () {
      const gradient = LinearGradient(colors: []);
      final attribute = utility.as(gradient);

      expect(attribute.value, isA<LinearGradientDto>());
      expect(attribute.resolve(EmptyMixData), isA<LinearGradient>());
    });

    test('GradientUtility.from for SweepGradient', () {
      const gradient = SweepGradient(colors: []);
      final attribute = utility.as(gradient);

      expect(attribute.value, isA<SweepGradientDto>());
      expect(attribute.resolve(EmptyMixData), isA<SweepGradient>());
    });
  });

  group('RadialGradientUtility', () {
    const radialUtility = RadialGradientUtility(UtilityTestDtoAttribute.new);

    test('.from for RadialGradient', () {
      const gradient = RadialGradient(colors: []);
      final attribute = radialUtility.as(gradient);

      final resolvedGradient = attribute.resolve(EmptyMixData);

      expect(resolvedGradient, isA<RadialGradient>());
      expect(attribute.value, isA<RadialGradientDto>());
    });

    test('.call', () {
      final colors = [Colors.red, Colors.blue];
      final stops = [0.0, 0.5];
      const center = Alignment.center;
      const radius = 20.0;
      const focal = Alignment.center;
      const focalRadius = 10.0;
      const tileMode = TileMode.clamp;
      const transform = GradientRotation(0.0);

      final attribute = radialUtility(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
        transform: transform,
      );

      expect(attribute.value, isA<RadialGradientDto>());
      expect(attribute.resolve(EmptyMixData), isA<RadialGradient>());
    });

    // colors
    test('.colors', () {
      final colors = [Colors.red, Colors.blue];
      final colorsDto = colors.map(ColorDto.new).toList();

      final attribute = radialUtility(colors: colors);

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(dto.colors, colorsDto);
      expect(resolvedGradient.colors, colors);
    });

    // stops
    test('.stops', () {
      final stops = [0.0, 0.5];
      final attribute = radialUtility(stops: stops);

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(dto.stops, stops);
      expect(resolvedGradient.stops, stops);
    });

    // center
    test('.center', () {
      const center = Alignment.center;
      final attribute = radialUtility(center: center);
      final attributeFn = radialUtility.center.center();

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as RadialGradient;
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.center, center);
      expect(resolvedGradient.center, center);
    });

    // radius
    test('.radius', () {
      const radius = 20.0;
      final attribute = radialUtility(radius: radius);

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as RadialGradient;
      final dto = attribute.value;

      expect(dto.radius, radius);
      expect(resolvedGradient.radius, radius);
    });

    // focal
    test('.focal', () {
      const focal = Alignment.center;
      final attribute = radialUtility.focal.builder(focal);
      final attributeFn = radialUtility.focal.center();

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as RadialGradient;
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.focal, focal);
      expect(resolvedGradient.focal, focal);
    });

    // focalRadius
    test('.focalRadius', () {
      const focalRadius = 10.0;
      final attribute = radialUtility(focalRadius: focalRadius);

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as RadialGradient;
      final dto = attribute.value;

      expect(dto.focalRadius, focalRadius);
      expect(resolvedGradient.focalRadius, focalRadius);
    });

    // tileMode

    test('.tileMode', () {
      const tileMode = TileMode.clamp;
      final attribute = radialUtility(tileMode: tileMode);
      final attributeFn = radialUtility.tileMode.clamp();

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as RadialGradient;
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.tileMode, tileMode);
      expect(resolvedGradient.tileMode, tileMode);
    });

    // transform
    test('.transform', () {
      const transform = GradientRotation(0.0);
      final attribute = radialUtility(transform: transform);

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as RadialGradient;
      final dto = attribute.value;

      expect(dto.transform, transform);
      expect(resolvedGradient.transform, transform);
    });

    // resolve
    test('.resolve', () {
      final colors = [Colors.red, Colors.blue];
      final stops = [0.0, 0.5];
      const center = Alignment.center;
      const radius = 20.0;
      const focal = Alignment.center;
      const focalRadius = 10.0;
      const tileMode = TileMode.clamp;
      const transform = GradientRotation(0.0);

      final attribute = radialUtility(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
        transform: transform,
      );

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as RadialGradient;
      final dto = attribute.value;

      expect(dto.colors, colors.map(ColorDto.new).toList());
      expect(dto.stops, stops);
      expect(dto.center, center);
      expect(dto.radius, radius);
      expect(dto.focal, focal);
      expect(dto.focalRadius, focalRadius);
      expect(dto.tileMode, tileMode);
      expect(dto.transform, transform);

      expect(resolvedGradient, isA<RadialGradient>());
      expect(resolvedGradient.colors, colors);
      expect(resolvedGradient.stops, stops);
      expect(resolvedGradient.center, center);
      expect(resolvedGradient.radius, radius);
      expect(resolvedGradient.focal, focal);
      expect(resolvedGradient.focalRadius, focalRadius);
      expect(resolvedGradient.tileMode, tileMode);
      expect(resolvedGradient.transform, transform);
    });
  });

  // LinearGradientUtility
  group('LinearGradientUtility', () {
    const linearUtility = LinearGradientUtility(UtilityTestDtoAttribute.new);

    test('.from for LinearGradient', () {
      const gradient = LinearGradient(colors: []);
      final attribute = linearUtility.as(gradient);

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(resolvedGradient, isA<LinearGradient>());
      expect(dto, isA<LinearGradientDto>());
    });

    test('.call', () {
      final colors = [Colors.red, Colors.blue];
      final stops = [0.0, 0.5];
      const begin = Alignment.centerLeft;
      const end = Alignment.centerRight;
      const tileMode = TileMode.clamp;
      const transform = GradientRotation(0.0);

      final attribute = linearUtility(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      );

      expect(attribute.value, isA<LinearGradientDto>());
      expect(attribute.resolve(EmptyMixData), isA<LinearGradient>());
    });

    // colors
    test('.colors', () {
      final colors = [Colors.red, Colors.blue];
      final colorsDto = colors.map(ColorDto.new).toList();

      final attribute = linearUtility(colors: colors);

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(dto.colors, colorsDto);
      expect(resolvedGradient.colors, colors);
    });

    // stops
    test('.stops', () {
      final stops = [0.0, 0.5];
      final attribute = linearUtility(stops: stops);

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(dto.stops, stops);
      expect(resolvedGradient.stops, stops);
    });

    // begin
    test('.begin', () {
      const begin = Alignment.centerLeft;
      final attribute = linearUtility(begin: begin);
      final attributeFn = linearUtility.begin.centerLeft();

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as LinearGradient;
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.begin, begin);
      expect(resolvedGradient.begin, begin);
    });

    // end
    test('.end', () {
      const end = Alignment.centerRight;
      final attribute = linearUtility(end: end);
      final attributeFn = linearUtility.end.centerRight();

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as LinearGradient;

      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.end, end);
      expect(resolvedGradient.end, end);
    });

    // tileMode
    test('.tileMode', () {
      const tileMode = TileMode.clamp;
      final attribute = linearUtility(tileMode: tileMode);
      final attributeFn = linearUtility.tileMode.clamp();

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as LinearGradient;
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.tileMode, tileMode);
      expect(resolvedGradient.tileMode, tileMode);
    });

    // transform
    test('.transform', () {
      const transform = GradientRotation(0.0);
      final attribute = linearUtility(transform: transform);

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as LinearGradient;
      final dto = attribute.value;

      expect(dto.transform, transform);
      expect(resolvedGradient.transform, transform);
    });

    // resolve
    test('.resolve', () {
      final colors = [Colors.red, Colors.blue];
      final stops = [0.0, 0.5];
      const begin = Alignment.centerLeft;
      const end = Alignment.centerRight;
      const tileMode = TileMode.clamp;
      const transform = GradientRotation(0.0);

      final attribute = linearUtility(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      );

      final resolvedGradient =
          attribute.resolve(EmptyMixData) as LinearGradient;
      final dto = attribute.value;

      expect(dto.colors, colors.map(ColorDto.new).toList());
      expect(dto.stops, stops);
      expect(dto.begin, begin);
      expect(dto.end, end);
      expect(dto.tileMode, tileMode);
      expect(dto.transform, transform);

      expect(resolvedGradient, isA<LinearGradient>());
      expect(resolvedGradient.colors, colors);
      expect(resolvedGradient.stops, stops);
      expect(resolvedGradient.begin, begin);
      expect(resolvedGradient.end, end);
      expect(resolvedGradient.tileMode, tileMode);
      expect(resolvedGradient.transform, transform);
    });
  });

  // SweepGradientUtility
  group('SweepGradientUtility', () {
    const sweepUtility = SweepGradientUtility(UtilityTestDtoAttribute.new);

    test('.from for SweepGradient', () {
      const gradient = SweepGradient(colors: []);
      final attribute = sweepUtility.as(gradient);

      expect(attribute.value, isA<SweepGradientDto>());
      expect(attribute.resolve(EmptyMixData), isA<SweepGradient>());
    });

    test('.call', () {
      final colors = [Colors.red, Colors.blue];
      final stops = [0.0, 0.5];
      const center = Alignment.center;
      const startAngle = 0.0;
      const endAngle = 0.5;
      const tileMode = TileMode.clamp;
      const transform = GradientRotation(0.0);

      final attribute = sweepUtility(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
        transform: transform,
      );

      expect(attribute.value, isA<SweepGradientDto>());
      expect(attribute.resolve(EmptyMixData), isA<SweepGradient>());
    });

    // colors
    test('.colors', () {
      final colors = [Colors.red, Colors.blue];
      final colorsDto = colors.map(ColorDto.new).toList();

      final attribute = sweepUtility(colors: colors);

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(dto.colors, colorsDto);
      expect(resolvedGradient.colors, colors);
    });

    // stops
    test('.stops', () {
      final stops = [0.0, 0.5];
      final attribute = sweepUtility(stops: stops);

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(dto.stops, stops);
      expect(resolvedGradient.stops, stops);
    });

    // center
    test('.center', () {
      const center = Alignment.center;
      final attribute = sweepUtility(center: center);
      final attributeFn = sweepUtility.center.center();

      final resolvedGradient = attribute.resolve(EmptyMixData) as SweepGradient;
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.center, center);
      expect(resolvedGradient.center, center);
    });

    // startAngle
    test('.startAngle', () {
      const startAngle = 0.0;
      final attribute = sweepUtility(startAngle: startAngle);

      final resolvedGradient = attribute.resolve(EmptyMixData) as SweepGradient;
      final dto = attribute.value;

      expect(dto.startAngle, startAngle);
      expect(resolvedGradient.startAngle, startAngle);
    });

    // endAngle
    test('.endAngle', () {
      const endAngle = 0.5;
      final attribute = sweepUtility(endAngle: endAngle);

      final resolvedGradient = attribute.resolve(EmptyMixData) as SweepGradient;
      final dto = attribute.value;

      expect(dto.endAngle, endAngle);
      expect(resolvedGradient.endAngle, endAngle);
    });

    // tileMode
    test('.tileMode', () {
      const tileMode = TileMode.clamp;
      final attribute = sweepUtility(tileMode: tileMode);
      final attributeFn = sweepUtility.tileMode.clamp();

      final resolvedGradient = attribute.resolve(EmptyMixData) as SweepGradient;
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.tileMode, tileMode);
      expect(resolvedGradient.tileMode, tileMode);
    });

    // transform
    test('.transform', () {
      const transform = GradientRotation(0.0);
      final attribute = sweepUtility(transform: transform);

      final resolvedGradient = attribute.resolve(EmptyMixData) as SweepGradient;
      final dto = attribute.value;

      expect(dto.transform, transform);
      expect(resolvedGradient.transform, transform);
    });

    // resolve
    test('.resolve', () {
      final colors = [Colors.red, Colors.blue];
      final stops = [0.0, 0.5];
      const center = Alignment.center;
      const startAngle = 0.0;
      const endAngle = 0.5;
      const tileMode = TileMode.clamp;
      const transform = GradientRotation(0.0);

      final attribute = sweepUtility(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
        transform: transform,
      );

      final resolvedGradient = attribute.resolve(EmptyMixData) as SweepGradient;
      final dto = attribute.value;

      expect(dto.colors, colors.map(ColorDto.new).toList());
      expect(dto.stops, stops);
      expect(dto.center, center);
      expect(dto.startAngle, startAngle);
      expect(dto.endAngle, endAngle);
      expect(dto.tileMode, tileMode);
      expect(dto.transform, transform);

      expect(resolvedGradient, isA<SweepGradient>());
      expect(resolvedGradient.colors, colors);
      expect(resolvedGradient.stops, stops);
      expect(resolvedGradient.center, center);
      expect(resolvedGradient.startAngle, startAngle);
      expect(resolvedGradient.endAngle, endAngle);
      expect(resolvedGradient.tileMode, tileMode);
      expect(resolvedGradient.transform, transform);
    });
  });
}
