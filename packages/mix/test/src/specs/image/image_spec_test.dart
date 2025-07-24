import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('ImageSpec', () {
    group('Constructor', () {
      test('creates ImageSpec with all properties', () {
        const spec = ImageSpec(
          width: 200.0,
          height: 150.0,
          color: Colors.blue,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        expect(spec.width, 200.0);
        expect(spec.height, 150.0);
        expect(spec.color, Colors.blue);
        expect(spec.repeat, ImageRepeat.repeat);
        expect(spec.fit, BoxFit.cover);
        expect(spec.alignment, Alignment.center);
        expect(spec.centerSlice, const Rect.fromLTWH(10, 10, 20, 20));
        expect(spec.filterQuality, FilterQuality.high);
        expect(spec.colorBlendMode, BlendMode.multiply);
      });

      test('creates ImageSpec with default values', () {
        const spec = ImageSpec();

        expect(spec.width, isNull);
        expect(spec.height, isNull);
        expect(spec.color, isNull);
        expect(spec.repeat, isNull);
        expect(spec.fit, isNull);
        expect(spec.alignment, isNull);
        expect(spec.centerSlice, isNull);
        expect(spec.filterQuality, isNull);
        expect(spec.colorBlendMode, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const original = ImageSpec(
          width: 100.0,
          height: 100.0,
          fit: BoxFit.contain,
          color: Colors.red,
        );

        final updated = original.copyWith(
          width: 200.0,
          fit: BoxFit.cover,
          alignment: Alignment.topLeft,
        );

        expect(updated.width, 200.0);
        expect(updated.height, 100.0); // unchanged
        expect(updated.fit, BoxFit.cover);
        expect(updated.color, Colors.red); // unchanged
        expect(updated.alignment, Alignment.topLeft);
      });

      test('preserves original properties when not specified', () {
        const original = ImageSpec(
          repeat: ImageRepeat.repeatX,
          filterQuality: FilterQuality.low,
          colorBlendMode: BlendMode.overlay,
        );

        final updated = original.copyWith(repeat: ImageRepeat.repeatY);

        expect(updated.repeat, ImageRepeat.repeatY);
        expect(updated.filterQuality, FilterQuality.low); // unchanged
        expect(updated.colorBlendMode, BlendMode.overlay); // unchanged
      });

      test('handles null values correctly', () {
        const original = ImageSpec(width: 100.0, height: 200.0);
        final updated = original.copyWith();

        expect(updated.width, 100.0);
        expect(updated.height, 200.0);
      });
    });

    group('lerp', () {
      test('interpolates between two ImageSpecs correctly', () {
        const spec1 = ImageSpec(
          width: 100.0,
          height: 200.0,
          color: Colors.red, // Pure red
          alignment: Alignment.topLeft,
        );
        const spec2 = ImageSpec(
          width: 200.0,
          height: 400.0,
          color: Colors.blue, // Pure blue
          alignment: Alignment.bottomRight,
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.width, 150.0);
        expect(lerped.height, 300.0);
        // The color should match exactly what Color.lerp produces
        final expectedColor = Color.lerp(Colors.red, Colors.blue, 0.5);
        expect(lerped.color, expectedColor);
        expect(lerped.alignment, Alignment.center);
      });

      test('returns original spec when other is null', () {
        const spec = ImageSpec(width: 100.0, height: 200.0);
        final lerped = spec.lerp(null, 0.5);

        expect(lerped, spec);
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1 = ImageSpec(width: 100.0, color: Colors.red);
        const spec2 = ImageSpec(width: 200.0, color: Colors.blue);

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        expect(lerpedAt0.width, 100.0);
        expect(lerpedAt0.color, Color.lerp(Colors.red, Colors.blue, 0.0));
        expect(lerpedAt1.width, 200.0);
        expect(lerpedAt1.color, Color.lerp(Colors.red, Colors.blue, 1.0));
      });

      test('uses step function for discrete properties', () {
        const spec1 = ImageSpec(
          repeat: ImageRepeat.noRepeat,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.low,
          colorBlendMode: BlendMode.srcOver,
        );
        const spec2 = ImageSpec(
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        final lerpedBefore = spec1.lerp(spec2, 0.4);
        final lerpedAfter = spec1.lerp(spec2, 0.6);

        // t < 0.5 uses spec1
        expect(lerpedBefore.repeat, ImageRepeat.noRepeat);
        expect(lerpedBefore.fit, BoxFit.contain);
        expect(lerpedBefore.filterQuality, FilterQuality.low);
        expect(lerpedBefore.colorBlendMode, BlendMode.srcOver);

        // t >= 0.5 uses spec2
        expect(lerpedAfter.repeat, ImageRepeat.repeat);
        expect(lerpedAfter.fit, BoxFit.cover);
        expect(lerpedAfter.filterQuality, FilterQuality.high);
        expect(lerpedAfter.colorBlendMode, BlendMode.multiply);
      });

      test('interpolates Rect centerSlice correctly', () {
        const spec1 = ImageSpec(centerSlice: Rect.fromLTWH(0, 0, 10, 10));
        const spec2 = ImageSpec(centerSlice: Rect.fromLTWH(10, 10, 30, 30));

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.centerSlice, const Rect.fromLTWH(5, 5, 20, 20));
      });

      test('interpolates AlignmentGeometry correctly', () {
        const spec1 = ImageSpec(alignment: Alignment.topLeft);
        const spec2 = ImageSpec(alignment: Alignment.bottomRight);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.alignment, Alignment.center);
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const spec1 = ImageSpec(
          width: 100.0,
          height: 200.0,
          color: Colors.blue,
          fit: BoxFit.cover,
        );
        const spec2 = ImageSpec(
          width: 100.0,
          height: 200.0,
          color: Colors.blue,
          fit: BoxFit.cover,
        );

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different properties are not equal', () {
        const spec1 = ImageSpec(width: 100.0, height: 200.0);
        const spec2 = ImageSpec(width: 150.0, height: 200.0);

        expect(spec1, isNot(spec2));
      });

      test('specs with null vs non-null properties are not equal', () {
        const spec1 = ImageSpec(width: 100.0);
        const spec2 = ImageSpec();

        expect(spec1, isNot(spec2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        const spec = ImageSpec(
          width: 200.0,
          height: 150.0,
          color: Colors.blue,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'width'), isTrue);
        expect(properties.any((p) => p.name == 'height'), isTrue);
        expect(properties.any((p) => p.name == 'color'), isTrue);
        expect(properties.any((p) => p.name == 'repeat'), isTrue);
        expect(properties.any((p) => p.name == 'fit'), isTrue);
        expect(properties.any((p) => p.name == 'alignment'), isTrue);
        expect(properties.any((p) => p.name == 'centerSlice'), isTrue);
        expect(properties.any((p) => p.name == 'filterQuality'), isTrue);
        expect(properties.any((p) => p.name == 'colorBlendMode'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const spec = ImageSpec(
          width: 200.0,
          height: 150.0,
          color: Colors.blue,
          repeat: ImageRepeat.repeat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          centerSlice: Rect.fromLTWH(10, 10, 20, 20),
          filterQuality: FilterQuality.high,
          colorBlendMode: BlendMode.multiply,
        );

        expect(spec.props.length, 9);
        expect(spec.props, contains(200.0));
        expect(spec.props, contains(150.0));
        expect(spec.props, contains(Colors.blue));
        expect(spec.props, contains(ImageRepeat.repeat));
        expect(spec.props, contains(BoxFit.cover));
        expect(spec.props, contains(Alignment.center));
        expect(spec.props, contains(const Rect.fromLTWH(10, 10, 20, 20)));
        expect(spec.props, contains(FilterQuality.high));
        expect(spec.props, contains(BlendMode.multiply));
      });
    });

    group('Real-world scenarios', () {
      test('creates responsive image spec', () {
        const responsiveSpec = ImageSpec(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.medium,
        );

        expect(responsiveSpec.fit, BoxFit.cover);
        expect(responsiveSpec.alignment, Alignment.center);
        expect(responsiveSpec.filterQuality, FilterQuality.medium);
      });

      test('creates tinted image spec', () {
        const tintedSpec = ImageSpec(
          color: Colors.blue,
          colorBlendMode: BlendMode.overlay,
          fit: BoxFit.contain,
        );

        expect(tintedSpec.color, Colors.blue);
        expect(tintedSpec.colorBlendMode, BlendMode.overlay);
        expect(tintedSpec.fit, BoxFit.contain);
      });

      test('creates nine-patch image spec', () {
        const ninePatchSpec = ImageSpec(
          centerSlice: Rect.fromLTWH(16, 16, 32, 32),
          repeat: ImageRepeat.noRepeat,
          fit: BoxFit.fill,
        );

        expect(ninePatchSpec.centerSlice, const Rect.fromLTWH(16, 16, 32, 32));
        expect(ninePatchSpec.repeat, ImageRepeat.noRepeat);
        expect(ninePatchSpec.fit, BoxFit.fill);
      });

      test('creates fixed size image spec', () {
        const fixedSizeSpec = ImageSpec(
          width: 64.0,
          height: 64.0,
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
        );

        expect(fixedSizeSpec.width, 64.0);
        expect(fixedSizeSpec.height, 64.0);
        expect(fixedSizeSpec.fit, BoxFit.scaleDown);
        expect(fixedSizeSpec.alignment, Alignment.topCenter);
      });
    });
  });
}
