import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('GradientUtility', () {
    final utility = GradientUtility(UtilityTestDtoAttribute.new);
    test('GradientUtility.from for RadialGradient', () {
      const gradient = RadialGradient(colors: []);
      final attribute = utility.as(gradient);

      expect(attribute.value, isA<RadialGradientDto>());
      expect(attribute, resolvesTo(gradient));
    });

    test('GradientUtility.from for LinearGradient', () {
      const gradient = LinearGradient(colors: []);
      final attribute = utility.as(gradient);

      expect(attribute.value, isA<LinearGradientDto>());
      expect(attribute, resolvesTo(gradient));
    });

    test('GradientUtility.from for SweepGradient', () {
      const gradient = SweepGradient(colors: []);
      final attribute = utility.as(gradient);

      expect(attribute.value, isA<SweepGradientDto>());
      expect(attribute, resolvesTo(gradient));
    });
  });

  group('RadialGradientUtility', () {
    final radialUtility = RadialGradientUtility(UtilityTestDtoAttribute.new);

    test('.from for RadialGradient', () {
      const gradient = RadialGradient(colors: []);
      final attribute = radialUtility.as(gradient);

      expect(attribute, resolvesTo(gradient));
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
        center: center,
        colors: colors,
        focal: focal,
        focalRadius: focalRadius,
        radius: radius,
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );

      expect(attribute.value, isA<RadialGradientDto>());
      expect(attribute, resolvesTo(isA<RadialGradient>()));
    });

    // colors
    test('.colors', () {
      final colors = [Colors.red, Colors.blue];

      final attribute = radialUtility(colors: colors);
      final dto = attribute.value;

      expect(dto.colors, resolvesTo(colors));
      expect(attribute, resolvesTo(RadialGradient(colors: colors)));
    });

    // stops
    test('.stops', () {
      final stops = [0.0, 0.5];
      final attribute = radialUtility(stops: stops);
      final dto = attribute.value;

      expect(dto.stops, resolvesTo(stops));
      expect(
        attribute,
        resolvesTo(RadialGradient(colors: const [], stops: stops)),
      );
    });

    // center
    test('.center', () {
      const center = Alignment.center;
      final attribute = radialUtility(center: center);
      final attributeFn = radialUtility.center.center();
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.center, resolvesTo(center));
      expect(
        attribute,
        resolvesTo(RadialGradient(colors: const [], center: center)),
      );
    });

    // radius
    test('.radius', () {
      const radius = 20.0;
      final attribute = radialUtility(radius: radius);
      final dto = attribute.value;

      expect(dto.radius, resolvesTo(radius));
      expect(
        attribute,
        resolvesTo(RadialGradient(colors: const [], radius: radius)),
      );
    });

    // focal
    test('.focal', () {
      const focal = Alignment.center;
      final attribute = radialUtility.focal(focal);
      final attributeFn = radialUtility.focal.center();
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.focal, resolvesTo(focal));
      expect(
        attribute,
        resolvesTo(RadialGradient(colors: const [], focal: focal)),
      );
    });

    // focalRadius
    test('.focalRadius', () {
      const focalRadius = 10.0;
      final attribute = radialUtility(focalRadius: focalRadius);
      final dto = attribute.value;

      expect(dto.focalRadius, resolvesTo(focalRadius));
      expect(
        attribute,
        resolvesTo(RadialGradient(colors: const [], focalRadius: focalRadius)),
      );
    });

    // tileMode

    test('.tileMode', () {
      const tileMode = TileMode.clamp;
      final attribute = radialUtility(tileMode: tileMode);
      final attributeFn = radialUtility.tileMode.clamp();

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(attribute, attributeFn);
      expect(dto.tileMode, resolvesTo(tileMode));
      expect(resolvedGradient.tileMode, tileMode);
    });

    // transform
    test('.transform', () {
      const transform = GradientRotation(0.0);
      final attribute = radialUtility(transform: transform);

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(dto.transform, resolvesTo(transform));
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
        center: center,
        colors: colors,
        focal: focal,
        focalRadius: focalRadius,
        radius: radius,
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );

      final resolvedGradient = attribute.resolve(EmptyMixData);
      final dto = attribute.value;

      expect(dto.colors, resolvesTo(colors));
      expect(dto.stops, resolvesTo(stops));
      expect(dto.center, resolvesTo(center));
      expect(dto.radius, resolvesTo(radius));
      expect(dto.focal, resolvesTo(focal));
      expect(dto.focalRadius, resolvesTo(focalRadius));
      expect(dto.tileMode, resolvesTo(tileMode));
      expect(dto.transform, resolvesTo(transform));

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
    final linearUtility = LinearGradientUtility(UtilityTestDtoAttribute.new);

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
        begin: begin,
        colors: colors,
        end: end,
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );

      expect(attribute.value, isA<LinearGradientDto>());
      expect(attribute, resolvesTo(isA<LinearGradient>()));
    });

    // colors
    test('.colors', () {
      final colors = [Colors.red, Colors.blue];

      final attribute = linearUtility(colors: colors);

      expect(attribute.value.colors, resolvesTo(colors));
      expect(attribute, resolvesTo(LinearGradient(colors: colors)));
    });

    // stops
    test('.stops', () {
      final stops = [0.0, 0.5];
      final attribute = linearUtility(stops: stops);

      expect(attribute.value.stops, resolvesTo(stops));
      expect(
        attribute,
        resolvesTo(LinearGradient(colors: const [], stops: stops)),
      );
    });

    // begin
    test('.begin', () {
      const begin = Alignment.centerLeft;
      final attribute = linearUtility(begin: begin);
      final attributeFn = linearUtility.begin.centerLeft();

      expect(attribute, attributeFn);
      expect(attribute.value.begin, resolvesTo(begin));
      expect(
        attribute,
        resolvesTo(LinearGradient(colors: const [], begin: begin)),
      );
    });

    // end
    test('.end', () {
      const end = Alignment.centerRight;
      final attribute = linearUtility(end: end);
      final attributeFn = linearUtility.end.centerRight();

      expect(attribute, attributeFn);
      expect(attribute.value.end, resolvesTo(end));
      expect(attribute, resolvesTo(LinearGradient(colors: const [], end: end)));
    });

    // tileMode
    test('.tileMode', () {
      const tileMode = TileMode.clamp;
      final attribute = linearUtility(tileMode: tileMode);
      final attributeFn = linearUtility.tileMode.clamp();

      expect(attribute, attributeFn);
      expect(attribute.value.tileMode, resolvesTo(tileMode));
      expect(
        attribute,
        resolvesTo(LinearGradient(colors: const [], tileMode: tileMode)),
      );
    });

    // transform
    test('.transform', () {
      const transform = GradientRotation(0.0);
      final attribute = linearUtility(transform: transform);

      expect(attribute.value.transform, resolvesTo(transform));
      expect(
        attribute,
        resolvesTo(LinearGradient(colors: const [], transform: transform)),
      );
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
        begin: begin,
        colors: colors,
        end: end,
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );

      expect(attribute.value.colors, resolvesTo(colors));
      expect(attribute.value.stops, resolvesTo(stops));
      expect(attribute.value.begin, resolvesTo(begin));
      expect(attribute.value.end, resolvesTo(end));
      expect(attribute.value.tileMode, resolvesTo(tileMode));
      expect(attribute.value.transform, resolvesTo(transform));

      expect(
        attribute,
        resolvesTo(
          LinearGradient(
            colors: colors,
            stops: stops,
            begin: begin,
            end: end,
            tileMode: tileMode,
            transform: transform,
          ),
        ),
      );
    });
  });

  // SweepGradientUtility
  group('SweepGradientUtility', () {
    final sweepUtility = SweepGradientUtility(UtilityTestDtoAttribute.new);

    test('.from for SweepGradient', () {
      const gradient = SweepGradient(colors: []);
      final attribute = sweepUtility.as(gradient);

      expect(attribute.value, isA<SweepGradientDto>());
      expect(attribute, resolvesTo(isA<SweepGradient>()));
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
        center: center,
        colors: colors,
        endAngle: endAngle,
        startAngle: startAngle,
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );

      expect(attribute.value, isA<SweepGradientDto>());
      expect(attribute, resolvesTo(isA<SweepGradient>()));
    });

    // colors
    test('.colors', () {
      final colors = [Colors.red, Colors.blue];

      final attribute = sweepUtility(colors: colors);

      expect(attribute.value.colors, resolvesTo(colors));
      expect(attribute, resolvesTo(SweepGradient(colors: colors)));
    });

    // stops
    test('.stops', () {
      final stops = [0.0, 0.5];
      final attribute = sweepUtility(stops: stops);

      expect(attribute.value.stops, resolvesTo(stops));
      expect(
        attribute,
        resolvesTo(SweepGradient(colors: const [], stops: stops)),
      );
    });

    // center
    test('.center', () {
      const center = Alignment.center;
      final attribute = sweepUtility(center: center);
      final attributeFn = sweepUtility.center.center();

      expect(attribute, attributeFn);
      expect(attribute.value.center, resolvesTo(center));
      expect(
        attribute,
        resolvesTo(SweepGradient(colors: const [], center: center)),
      );
    });

    // startAngle
    test('.startAngle', () {
      const startAngle = 0.0;
      final attribute = sweepUtility(startAngle: startAngle);

      expect(attribute.value.startAngle, resolvesTo(startAngle));
      expect(
        attribute,
        resolvesTo(SweepGradient(colors: const [], startAngle: startAngle)),
      );
    });

    // endAngle
    test('.endAngle', () {
      const endAngle = 0.5;
      final attribute = sweepUtility(endAngle: endAngle);

      expect(attribute.value.endAngle, resolvesTo(endAngle));
      expect(
        attribute,
        resolvesTo(SweepGradient(colors: const [], endAngle: endAngle)),
      );
    });

    // tileMode
    test('.tileMode', () {
      const tileMode = TileMode.clamp;
      final attribute = sweepUtility(tileMode: tileMode);
      final attributeFn = sweepUtility.tileMode.clamp();

      expect(attribute, attributeFn);
      expect(attribute.value.tileMode, resolvesTo(tileMode));
      expect(
        attribute,
        resolvesTo(SweepGradient(colors: const [], tileMode: tileMode)),
      );
    });

    // transform
    test('.transform', () {
      const transform = GradientRotation(0.0);
      final attribute = sweepUtility(transform: transform);

      expect(attribute.value.transform, resolvesTo(transform));
      expect(
        attribute,
        resolvesTo(SweepGradient(colors: const [], transform: transform)),
      );
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
        center: center,
        colors: colors,
        endAngle: endAngle,
        startAngle: startAngle,
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );

      expect(attribute.value.colors, resolvesTo(colors));
      expect(attribute.value.stops, resolvesTo(stops));
      expect(attribute.value.center, resolvesTo(center));
      expect(attribute.value.startAngle, resolvesTo(startAngle));
      expect(attribute.value.endAngle, resolvesTo(endAngle));
      expect(attribute.value.tileMode, resolvesTo(tileMode));
      expect(attribute.value.transform, resolvesTo(transform));

      expect(
        attribute,
        resolvesTo(
          SweepGradient(
            colors: colors,
            stops: stops,
            center: center,
            startAngle: startAngle,
            endAngle: endAngle,
            tileMode: tileMode,
            transform: transform,
          ),
        ),
      );
    });
  });
}
