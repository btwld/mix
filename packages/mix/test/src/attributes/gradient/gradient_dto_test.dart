import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  // Base GradientDto factory tests
  group('GradientDto factory tests', () {
    test('value factory with LinearGradient', () {
      const gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );
      
      final dto = GradientDto.value(gradient);
      
      expect(dto, isA<LinearGradientDto>());
      expect(dto, resolvesTo(gradient));
    });

    test('value factory with RadialGradient', () {
      const gradient = RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );
      
      final dto = GradientDto.value(gradient);
      
      expect(dto, isA<RadialGradientDto>());
      expect(dto, resolvesTo(gradient));
    });

    test('value factory with SweepGradient', () {
      const gradient = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 1.0,
        colors: [Colors.red, Colors.blue],
        stops: [0.0, 1.0],
      );
      
      final dto = GradientDto.value(gradient);
      
      expect(dto, isA<SweepGradientDto>());
      expect(dto, resolvesTo(gradient));
    });

    test('maybeValue factory with null', () {
      final dto = GradientDto.maybeValue(null);
      expect(dto, isNull);
    });

    test('maybeValue factory with non-null gradient', () {
      const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
      final dto = GradientDto.maybeValue(gradient);
      
      expect(dto, isNotNull);
      expect(dto, isA<LinearGradientDto>());
    });
  });

  // Cross-type merge tests
  group('GradientDto cross-type merge tests', () {
    test('tryToMerge with same types', () {
      final dto1 = LinearGradientDto(colors: const [Colors.red]);
      final dto2 = LinearGradientDto(colors: const [Colors.blue]);
      
      final merged = GradientDto.tryToMerge(dto1, dto2) as LinearGradientDto?;
      
      expect(merged, isNotNull);
      expect(merged!.colors?.value, [Colors.blue]);
    });

    test('tryToMerge LinearGradient with RadialGradient', () {
      final linear = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.red, Colors.green],
      );
      final radial = RadialGradientDto(
        center: Alignment.center,
        radius: 0.8,
        colors: const [Colors.blue, Colors.yellow],
      );
      
      final merged = GradientDto.tryToMerge(linear, radial) as RadialGradientDto?;
      
      expect(merged, isNotNull);
      expect(merged!.colors?.value, [Colors.blue, Colors.yellow]);
      expect(merged.center, resolvesTo(Alignment.center));
      expect(merged.radius, resolvesTo(0.8));
    });

    test('tryToMerge with null values', () {
      final dto = LinearGradientDto(colors: const [Colors.red]);
      
      expect(GradientDto.tryToMerge(dto, null), same(dto));
      expect(GradientDto.tryToMerge(null, dto), same(dto));
      expect(GradientDto.tryToMerge(null, null), isNull);
    });
  });

  group('LinearGradientDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates LinearGradientDto with all properties', () {
        const transform = GradientRotation(1.5);
        final dto = LinearGradientDto(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
          transform: transform,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
        );

        expect(dto.begin, resolvesTo(Alignment.topLeft));
        expect(dto.end, resolvesTo(Alignment.bottomRight));
        expect(dto.tileMode, resolvesTo(TileMode.clamp));
        expect(dto.transform, resolvesTo(transform));
        expect(dto.colors?.value, [Colors.red, Colors.blue]);
        expect(dto.stops?.value, [0.0, 1.0]);
      });

      test('props constructor with Prop values', () {
        const dto = LinearGradientDto.props(
          begin: Prop.value(Alignment.topCenter),
          end: Prop.value(Alignment.bottomCenter),
          tileMode: Prop.value(TileMode.mirror),
          transform: null,
          colors: Prop.value([Colors.green, Colors.yellow]),
          stops: Prop.value([0.25, 0.75]),
        );

        expect(dto.begin, resolvesTo(Alignment.topCenter));
        expect(dto.end, resolvesTo(Alignment.bottomCenter));
        expect(dto.tileMode, resolvesTo(TileMode.mirror));
        expect(dto.colors?.value, [Colors.green, Colors.yellow]);
        expect(dto.stops?.value, [0.25, 0.75]);
      });

      test('value constructor from LinearGradient', () {
        const gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red, Colors.blue],
          stops: [0.0, 1.0],
          tileMode: TileMode.repeated,
        );
        final dto = LinearGradientDto.value(gradient);

        expect(dto.begin, resolvesTo(gradient.begin));
        expect(dto.end, resolvesTo(gradient.end));
        expect(dto.colors?.value, gradient.colors);
        expect(dto.stops?.value, gradient.stops);
        expect(dto.tileMode, resolvesTo(gradient.tileMode));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns LinearGradientDto for non-null gradient', () {
        const gradient = LinearGradient(
          colors: [Colors.red, Colors.blue],
        );
        final dto = LinearGradientDto.maybeValue(gradient);
        
        expect(dto, isNotNull);
        expect(dto?.colors?.value, gradient.colors);
      });

      test('maybeValue returns null for null gradient', () {
        final dto = LinearGradientDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to LinearGradient with all properties', () {
        const transform = GradientRotation(2.0);
        final dto = LinearGradientDto(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(
          dto,
          resolvesTo(
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red, Colors.blue],
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
              transform: transform,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = LinearGradientDto.props(
          begin: null,
          end: null,
          tileMode: null,
          transform: null,
          colors: Prop.value([Colors.purple]),
          stops: null,
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.begin, Alignment.centerLeft);
        expect(resolved.end, Alignment.centerRight);
        expect(resolved.tileMode, TileMode.clamp);
        expect(resolved.transform, isNull);
        expect(resolved.colors, [Colors.purple]);
        expect(resolved.stops, isNull);
      });

    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another LinearGradientDto - all properties', () {
        const transform1 = GradientRotation(1.0);
        const transform2 = GradientRotation(2.0);
        
        final dto1 = LinearGradientDto(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
          transform: transform1,
        );
        final dto2 = LinearGradientDto(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
          tileMode: TileMode.mirror,
          transform: transform2,
        );

        final merged = dto1.merge(dto2);

        expect(merged.begin, resolvesTo(Alignment.centerLeft));
        expect(merged.end, resolvesTo(Alignment.centerRight));
        expect(merged.colors?.value, [Colors.green, Colors.yellow]);
        expect(merged.stops?.value, [0.25, 0.75]);
        expect(merged.tileMode, resolvesTo(TileMode.mirror));
        expect(merged.transform, resolvesTo(transform2));
      });

      test('merge with partial properties', () {
        final dto1 = LinearGradientDto(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
          tileMode: TileMode.repeated,
        );
        final dto2 = LinearGradientDto(
          end: Alignment.bottomCenter,
          stops: const [0.3, 0.7],
        );

        final merged = dto1.merge(dto2);

        expect(merged.begin, resolvesTo(Alignment.topLeft));
        expect(merged.end, resolvesTo(Alignment.bottomCenter));
        expect(merged.colors?.value, [Colors.red, Colors.blue]);
        expect(merged.stops?.value, [0.3, 0.7]);
        expect(merged.tileMode, resolvesTo(TileMode.repeated));
      });

      test('merge with null returns original', () {
        final dto = LinearGradientDto(
          colors: const [Colors.purple, Colors.orange],
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal LinearGradientDtos', () {
        const transform = GradientRotation(1.5);
        final dto1 = LinearGradientDto(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );
        final dto2 = LinearGradientDto(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal LinearGradientDtos', () {
        final dto1 = LinearGradientDto(
          begin: Alignment.topLeft,
          colors: const [Colors.red, Colors.blue],
        );
        final dto2 = LinearGradientDto(
          begin: Alignment.centerLeft,
          colors: const [Colors.red, Colors.blue],
        );

        expect(dto1, isNot(equals(dto2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles empty colors list', () {
        final dto = LinearGradientDto(
          colors: const [],
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.colors, isEmpty);
      });

      test('handles single color', () {
        final dto = LinearGradientDto(
          colors: const [Colors.red],
        );
        
        expect(dto, resolvesTo(const LinearGradient(
          colors: [Colors.red],
        )));
      });

      test('handles many colors without stops', () {
        final dto = LinearGradientDto(
          colors: const [Colors.red, Colors.green, Colors.blue, Colors.yellow],
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.colors.length, 4);
        expect(resolved.stops, isNull);
      });

      test('handles mismatched colors and stops lengths', () {
        final dto = LinearGradientDto(
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 0.5, 1.0], // 3 stops for 2 colors
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.colors, [Colors.red, Colors.blue]);
        expect(resolved.stops, [0.0, 0.5, 1.0]);
      });
    });
  });

  group('RadialGradientDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates RadialGradientDto with all properties', () {
        const transform = GradientRotation(1.5);
        final dto = RadialGradientDto(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.bottomRight,
          focalRadius: 0.2,
          tileMode: TileMode.clamp,
          transform: transform,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
        );

        expect(dto.center, resolvesTo(Alignment.center));
        expect(dto.radius, resolvesTo(0.5));
        expect(dto.focal, resolvesTo(Alignment.bottomRight));
        expect(dto.focalRadius, resolvesTo(0.2));
        expect(dto.tileMode, resolvesTo(TileMode.clamp));
        expect(dto.transform, resolvesTo(transform));
        expect(dto.colors?.value, [Colors.red, Colors.blue]);
        expect(dto.stops?.value, [0.0, 1.0]);
      });

      test('props constructor with Prop values', () {
        const dto = RadialGradientDto.props(
          center: Prop.value(Alignment.topCenter),
          radius: Prop.value(0.8),
          focal: null,
          focalRadius: null,
          tileMode: Prop.value(TileMode.mirror),
          transform: null,
          colors: Prop.value([Colors.green, Colors.yellow]),
          stops: Prop.value([0.25, 0.75]),
        );

        expect(dto.center, resolvesTo(Alignment.topCenter));
        expect(dto.radius, resolvesTo(0.8));
        expect(dto.tileMode, resolvesTo(TileMode.mirror));
        expect(dto.colors?.value, [Colors.green, Colors.yellow]);
        expect(dto.stops?.value, [0.25, 0.75]);
      });

      test('value constructor from RadialGradient', () {
        const gradient = RadialGradient(
          center: Alignment.bottomCenter,
          radius: 0.7,
          colors: [Colors.purple, Colors.orange],
          stops: [0.2, 0.8],
          tileMode: TileMode.repeated,
          focal: Alignment.center,
          focalRadius: 0.1,
        );
        final dto = RadialGradientDto.value(gradient);

        expect(dto.center, resolvesTo(gradient.center));
        expect(dto.radius, resolvesTo(gradient.radius));
        expect(dto.focal, resolvesTo(gradient.focal));
        expect(dto.focalRadius, resolvesTo(gradient.focalRadius));
        expect(dto.colors?.value, gradient.colors);
        expect(dto.stops?.value, gradient.stops);
        expect(dto.tileMode, resolvesTo(gradient.tileMode));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns RadialGradientDto for non-null gradient', () {
        const gradient = RadialGradient(
          colors: [Colors.red, Colors.blue],
        );
        final dto = RadialGradientDto.maybeValue(gradient);
        
        expect(dto, isNotNull);
        expect(dto?.colors?.value, gradient.colors);
      });

      test('maybeValue returns null for null gradient', () {
        final dto = RadialGradientDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to RadialGradient with all properties', () {
        const transform = GradientRotation(2.0);
        final dto = RadialGradientDto(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.topRight,
          focalRadius: 0.3,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(
          dto,
          resolvesTo(
            const RadialGradient(
              center: Alignment.center,
              radius: 0.5,
              focal: Alignment.topRight,
              focalRadius: 0.3,
              colors: [Colors.red, Colors.blue],
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
              transform: transform,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = RadialGradientDto.props(
          center: null,
          radius: null,
          focal: null,
          focalRadius: null,
          tileMode: null,
          transform: null,
          colors: Prop.value([Colors.purple]),
          stops: null,
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.center, Alignment.center);
        expect(resolved.radius, 0.5);
        expect(resolved.focal, isNull);
        expect(resolved.focalRadius, 0.0);
        expect(resolved.tileMode, TileMode.clamp);
        expect(resolved.transform, isNull);
        expect(resolved.colors, [Colors.purple]);
        expect(resolved.stops, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another RadialGradientDto - all properties', () {
        const transform1 = GradientRotation(1.0);
        const transform2 = GradientRotation(2.0);
        
        final dto1 = RadialGradientDto(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.bottomLeft,
          focalRadius: 0.1,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
          transform: transform1,
        );
        final dto2 = RadialGradientDto(
          center: Alignment.centerLeft,
          radius: 0.75,
          focal: Alignment.topRight,
          focalRadius: 0.2,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
          tileMode: TileMode.mirror,
          transform: transform2,
        );

        final merged = dto1.merge(dto2);

        expect(merged.center, resolvesTo(Alignment.centerLeft));
        expect(merged.radius, resolvesTo(0.75));
        expect(merged.focal, resolvesTo(Alignment.topRight));
        expect(merged.focalRadius, resolvesTo(0.2));
        expect(merged.colors?.value, [Colors.green, Colors.yellow]);
        expect(merged.stops?.value, [0.25, 0.75]);
        expect(merged.tileMode, resolvesTo(TileMode.mirror));
        expect(merged.transform, resolvesTo(transform2));
      });

      test('merge with partial properties', () {
        final dto1 = RadialGradientDto(
          center: Alignment.topCenter,
          radius: 0.6,
          colors: const [Colors.red, Colors.blue],
        );
        final dto2 = RadialGradientDto(
          focal: Alignment.center,
          focalRadius: 0.15,
          stops: const [0.3, 0.7],
        );

        final merged = dto1.merge(dto2);

        expect(merged.center, resolvesTo(Alignment.topCenter));
        expect(merged.radius, resolvesTo(0.6));
        expect(merged.focal, resolvesTo(Alignment.center));
        expect(merged.focalRadius, resolvesTo(0.15));
        expect(merged.colors?.value, [Colors.red, Colors.blue]);
        expect(merged.stops?.value, [0.3, 0.7]);
      });

      test('merge with null returns original', () {
        final dto = RadialGradientDto(
          colors: const [Colors.purple, Colors.orange],
          radius: 0.8,
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal RadialGradientDtos', () {
        const transform = GradientRotation(1.5);
        final dto1 = RadialGradientDto(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.topLeft,
          focalRadius: 0.1,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );
        final dto2 = RadialGradientDto(
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.topLeft,
          focalRadius: 0.1,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal RadialGradientDtos', () {
        final dto1 = RadialGradientDto(
          center: Alignment.center,
          radius: 0.5,
          colors: const [Colors.red, Colors.blue],
        );
        final dto2 = RadialGradientDto(
          center: Alignment.center,
          radius: 0.6,
          colors: const [Colors.red, Colors.blue],
        );

        expect(dto1, isNot(equals(dto2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles radius at boundaries', () {
        final dto1 = RadialGradientDto(
          radius: 0.0,
          colors: const [Colors.red, Colors.blue],
        );
        final dto2 = RadialGradientDto(
          radius: 1.0,
          colors: const [Colors.red, Colors.blue],
        );
        
        expect(dto1.radius, resolvesTo(0.0));
        expect(dto2.radius, resolvesTo(1.0));
      });

      test('handles focal and focalRadius relationships', () {
        final dto = RadialGradientDto(
          focal: Alignment.topRight,
          focalRadius: 0.5,
          colors: const [Colors.red, Colors.blue],
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.focal, Alignment.topRight);
        expect(resolved.focalRadius, 0.5);
      });

      test('handles focal without focalRadius', () {
        final dto = RadialGradientDto(
          focal: Alignment.bottomLeft,
          colors: const [Colors.red, Colors.blue],
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.focal, Alignment.bottomLeft);
        expect(resolved.focalRadius, 0.0);
      });
    });
  });

  group('SweepGradientDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('main constructor creates SweepGradientDto with all properties', () {
        const transform = GradientRotation(1.5);
        final dto = SweepGradientDto(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28, // 2π
          tileMode: TileMode.clamp,
          transform: transform,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
        );

        expect(dto.center, resolvesTo(Alignment.center));
        expect(dto.startAngle, resolvesTo(0.0));
        expect(dto.endAngle, resolvesTo(6.28));
        expect(dto.tileMode, resolvesTo(TileMode.clamp));
        expect(dto.transform, resolvesTo(transform));
        expect(dto.colors?.value, [Colors.red, Colors.blue]);
        expect(dto.stops?.value, [0.0, 1.0]);
      });

      test('props constructor with Prop values', () {
        const dto = SweepGradientDto.props(
          center: Prop.value(Alignment.topCenter),
          startAngle: Prop.value(1.57), // π/2
          endAngle: Prop.value(4.71), // 3π/2
          tileMode: Prop.value(TileMode.mirror),
          transform: null,
          colors: Prop.value([Colors.green, Colors.yellow]),
          stops: Prop.value([0.25, 0.75]),
        );

        expect(dto.center, resolvesTo(Alignment.topCenter));
        expect(dto.startAngle, resolvesTo(1.57));
        expect(dto.endAngle, resolvesTo(4.71));
        expect(dto.tileMode, resolvesTo(TileMode.mirror));
        expect(dto.colors?.value, [Colors.green, Colors.yellow]);
        expect(dto.stops?.value, [0.25, 0.75]);
      });

      test('value constructor from SweepGradient', () {
        const gradient = SweepGradient(
          center: Alignment.bottomCenter,
          startAngle: 0.5,
          endAngle: 5.5,
          colors: [Colors.purple, Colors.orange],
          stops: [0.2, 0.8],
          tileMode: TileMode.repeated,
        );
        final dto = SweepGradientDto.value(gradient);

        expect(dto.center, resolvesTo(gradient.center));
        expect(dto.startAngle, resolvesTo(gradient.startAngle));
        expect(dto.endAngle, resolvesTo(gradient.endAngle));
        expect(dto.colors?.value, gradient.colors);
        expect(dto.stops?.value, gradient.stops);
        expect(dto.tileMode, resolvesTo(gradient.tileMode));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns SweepGradientDto for non-null gradient', () {
        const gradient = SweepGradient(
          colors: [Colors.red, Colors.blue],
        );
        final dto = SweepGradientDto.maybeValue(gradient);
        
        expect(dto, isNotNull);
        expect(dto?.colors?.value, gradient.colors);
      });

      test('maybeValue returns null for null gradient', () {
        final dto = SweepGradientDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to SweepGradient with all properties', () {
        const transform = GradientRotation(2.0);
        final dto = SweepGradientDto(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(
          dto,
          resolvesTo(
            const SweepGradient(
              center: Alignment.center,
              startAngle: 0.0,
              endAngle: 6.28,
              colors: [Colors.red, Colors.blue],
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror,
              transform: transform,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        const dto = SweepGradientDto.props(
          center: null,
          startAngle: null,
          endAngle: null,
          tileMode: null,
          transform: null,
          colors: Prop.value([Colors.purple]),
          stops: null,
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.center, Alignment.center);
        expect(resolved.startAngle, 0.0);
        expect(resolved.endAngle, 6.283185307179586); // 2π
        expect(resolved.tileMode, TileMode.clamp);
        expect(resolved.transform, isNull);
        expect(resolved.colors, [Colors.purple]);
        expect(resolved.stops, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another SweepGradientDto - all properties', () {
        const transform1 = GradientRotation(1.0);
        const transform2 = GradientRotation(2.0);
        
        final dto1 = SweepGradientDto(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 3.14,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
          transform: transform1,
        );
        final dto2 = SweepGradientDto(
          center: Alignment.centerLeft,
          startAngle: 1.57,
          endAngle: 4.71,
          colors: const [Colors.green, Colors.yellow],
          stops: const [0.25, 0.75],
          tileMode: TileMode.mirror,
          transform: transform2,
        );

        final merged = dto1.merge(dto2);

        expect(merged.center, resolvesTo(Alignment.centerLeft));
        expect(merged.startAngle, resolvesTo(1.57));
        expect(merged.endAngle, resolvesTo(4.71));
        expect(merged.colors?.value, [Colors.green, Colors.yellow]);
        expect(merged.stops?.value, [0.25, 0.75]);
        expect(merged.tileMode, resolvesTo(TileMode.mirror));
        expect(merged.transform, resolvesTo(transform2));
      });

      test('merge with partial properties', () {
        final dto1 = SweepGradientDto(
          center: Alignment.topCenter,
          startAngle: 0.5,
          colors: const [Colors.red, Colors.blue],
        );
        final dto2 = SweepGradientDto(
          endAngle: 5.5,
          stops: const [0.3, 0.7],
          tileMode: TileMode.repeated,
        );

        final merged = dto1.merge(dto2);

        expect(merged.center, resolvesTo(Alignment.topCenter));
        expect(merged.startAngle, resolvesTo(0.5));
        expect(merged.endAngle, resolvesTo(5.5));
        expect(merged.colors?.value, [Colors.red, Colors.blue]);
        expect(merged.stops?.value, [0.3, 0.7]);
        expect(merged.tileMode, resolvesTo(TileMode.repeated));
      });

      test('merge with null returns original', () {
        final dto = SweepGradientDto(
          colors: const [Colors.purple, Colors.orange],
          startAngle: 0.0,
          endAngle: 6.28,
        );

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal SweepGradientDtos', () {
        const transform = GradientRotation(1.5);
        final dto1 = SweepGradientDto(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );
        final dto2 = SweepGradientDto(
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28,
          colors: const [Colors.red, Colors.blue],
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
          transform: transform,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal SweepGradientDtos', () {
        final dto1 = SweepGradientDto(
          center: Alignment.center,
          startAngle: 0.0,
          colors: const [Colors.red, Colors.blue],
        );
        final dto2 = SweepGradientDto(
          center: Alignment.center,
          startAngle: 0.5,
          colors: const [Colors.red, Colors.blue],
        );

        expect(dto1, isNot(equals(dto2)));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles angle wrapping', () {
        final dto = SweepGradientDto(
          startAngle: -1.0,
          endAngle: 7.28, // > 2π
          colors: const [Colors.red, Colors.blue],
        );
        
        expect(dto.startAngle, resolvesTo(-1.0));
        expect(dto.endAngle, resolvesTo(7.28));
      });

      test('handles startAngle equal to endAngle', () {
        final dto = SweepGradientDto(
          startAngle: 3.14,
          endAngle: 3.14,
          colors: const [Colors.red, Colors.blue],
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.startAngle, 3.14);
        expect(resolved.endAngle, 3.14);
      });

      test('handles colors in circular pattern', () {
        final dto = SweepGradientDto(
          colors: const [Colors.red, Colors.green, Colors.blue, Colors.red],
          stops: const [0.0, 0.33, 0.67, 1.0],
        );
        
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved.colors.first, resolved.colors.last);
        expect(resolved.stops?.first, 0.0);
        expect(resolved.stops?.last, 1.0);
      });
    });
  });

  // Integration Tests
  group('Integration Tests', () {
    test('GradientDto in BoxDecoration context', () {
      final gradientDto = LinearGradientDto(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Colors.purple, Colors.orange],
      );
      
      final decorationDto = BoxDecorationDto(
        gradient: gradientDto,
        borderRadius: BorderRadiusDto.value(BorderRadius.circular(12)),
      );
      
      final context = createEmptyMixData();
      final resolved = decorationDto.resolve(context);
      
      expect(resolved.gradient, isA<LinearGradient>());
      expect((resolved.gradient as LinearGradient).colors, [Colors.purple, Colors.orange]);
    });

    test('complex gradient merging scenario', () {
      final baseGradient = LinearGradientDto(
        colors: const [Colors.red, Colors.blue],
        stops: const [0.0, 1.0],
      );
      
      final overrideGradient = LinearGradientDto(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.mirror,
      );
      
      final finalGradient = LinearGradientDto(
        transform: const GradientRotation(1.57),
      );
      
      final merged = baseGradient.merge(overrideGradient).merge(finalGradient);
      
      expect(merged.colors?.value, [Colors.red, Colors.blue]);
      expect(merged.stops?.value, [0.0, 1.0]);
      expect(merged.begin, resolvesTo(Alignment.topCenter));
      expect(merged.end, resolvesTo(Alignment.bottomCenter));
      expect(merged.tileMode, resolvesTo(TileMode.mirror));
      expect(merged.transform, resolvesTo(const GradientRotation(1.57)));
    });

  });
}
