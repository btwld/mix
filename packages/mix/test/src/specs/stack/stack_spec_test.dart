import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('StackSpec', () {
    group('Constructor', () {
      test('creates StackSpec with all properties', () {
        const spec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
        );

        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('creates StackSpec with default values', () {
        const spec = StackSpec();

        expect(spec.alignment, isNull);
        expect(spec.fit, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const original = StackSpec(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
          textDirection: TextDirection.ltr,
        );

        final updated = original.copyWith(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.hardEdge,
        );

        expect(updated.alignment, Alignment.bottomRight);
        expect(updated.fit, StackFit.loose); // unchanged
        expect(updated.textDirection, TextDirection.ltr); // unchanged
        expect(updated.clipBehavior, Clip.hardEdge);
      });

      test('preserves original properties when not specified', () {
        const original = StackSpec(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
        );

        final updated = original.copyWith(fit: StackFit.passthrough);

        expect(updated.fit, StackFit.passthrough);
        expect(updated.clipBehavior, Clip.none); // unchanged
      });

      test('handles null values correctly', () {
        const original = StackSpec(alignment: Alignment.center, fit: StackFit.loose);
        final updated = original.copyWith();

        expect(updated.alignment, Alignment.center);
        expect(updated.fit, StackFit.loose);
      });
    });

    group('lerp', () {
      test('interpolates between two StackSpecs correctly', () {
        const spec1 = StackSpec(
          alignment: Alignment.topLeft,
        );
        const spec2 = StackSpec(
          alignment: Alignment.bottomRight,
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.alignment, Alignment.center);
      });

      test('returns original spec when other is null', () {
        const spec = StackSpec(alignment: Alignment.center, fit: StackFit.expand);
        final lerped = spec.lerp(null, 0.5);

        expect(lerped, spec);
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1 = StackSpec(alignment: Alignment.topLeft, fit: StackFit.loose);
        const spec2 = StackSpec(alignment: Alignment.bottomRight, fit: StackFit.expand);

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        expect(lerpedAt0.alignment, Alignment.topLeft);
        expect(lerpedAt0.fit, StackFit.loose);
        expect(lerpedAt1.alignment, Alignment.bottomRight);
        expect(lerpedAt1.fit, StackFit.expand);
      });

      test('uses step function for discrete properties', () {
        const spec1 = StackSpec(
          fit: StackFit.loose,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.none,
        );
        const spec2 = StackSpec(
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
        );

        final lerpedBefore = spec1.lerp(spec2, 0.4);
        final lerpedAfter = spec1.lerp(spec2, 0.6);

        // t < 0.5 uses spec1
        expect(lerpedBefore.fit, StackFit.loose);
        expect(lerpedBefore.textDirection, TextDirection.ltr);
        expect(lerpedBefore.clipBehavior, Clip.none);

        // t >= 0.5 uses spec2
        expect(lerpedAfter.fit, StackFit.expand);
        expect(lerpedAfter.textDirection, TextDirection.rtl);
        expect(lerpedAfter.clipBehavior, Clip.antiAlias);
      });

      test('interpolates AlignmentGeometry correctly', () {
        const spec1 = StackSpec(alignment: Alignment.topLeft);
        const spec2 = StackSpec(alignment: Alignment.bottomRight);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.alignment, Alignment.center);
      });

      test('handles null alignment interpolation', () {
        const spec1 = StackSpec(alignment: Alignment.topLeft);
        const spec2 = StackSpec();

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.alignment, isA<AlignmentGeometry>());
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const spec1 = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.hardEdge,
        );
        const spec2 = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.hardEdge,
        );

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different properties are not equal', () {
        const spec1 = StackSpec(alignment: Alignment.center, fit: StackFit.expand);
        const spec2 = StackSpec(alignment: Alignment.topLeft, fit: StackFit.expand);

        expect(spec1, isNot(spec2));
      });

      test('specs with null vs non-null properties are not equal', () {
        const spec1 = StackSpec(alignment: Alignment.center);
        const spec2 = StackSpec();

        expect(spec1, isNot(spec2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        const spec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'alignment'), isTrue);
        expect(properties.any((p) => p.name == 'fit'), isTrue);
        expect(properties.any((p) => p.name == 'textDirection'), isTrue);
        expect(properties.any((p) => p.name == 'clipBehavior'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const spec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.antiAlias,
        );

        expect(spec.props.length, 4);
        expect(spec.props, contains(Alignment.center));
        expect(spec.props, contains(StackFit.expand));
        expect(spec.props, contains(TextDirection.rtl));
        expect(spec.props, contains(Clip.antiAlias));
      });
    });

    group('Real-world scenarios', () {
      test('creates overlay stack spec', () {
        const overlaySpec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          clipBehavior: Clip.none,
        );

        expect(overlaySpec.alignment, Alignment.center);
        expect(overlaySpec.fit, StackFit.expand);
        expect(overlaySpec.clipBehavior, Clip.none);
      });

      test('creates positioned stack spec', () {
        const positionedSpec = StackSpec(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
          textDirection: TextDirection.ltr,
        );

        expect(positionedSpec.alignment, Alignment.topLeft);
        expect(positionedSpec.fit, StackFit.loose);
        expect(positionedSpec.textDirection, TextDirection.ltr);
      });

      test('creates clipped stack spec', () {
        const clippedSpec = StackSpec(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
          clipBehavior: Clip.antiAlias,
        );

        expect(clippedSpec.alignment, Alignment.center);
        expect(clippedSpec.fit, StackFit.passthrough);
        expect(clippedSpec.clipBehavior, Clip.antiAlias);
      });

      test('creates RTL stack spec', () {
        const rtlSpec = StackSpec(
          alignment: AlignmentDirectional.topStart,
          textDirection: TextDirection.rtl,
          fit: StackFit.expand,
        );

        expect(rtlSpec.alignment, AlignmentDirectional.topStart);
        expect(rtlSpec.textDirection, TextDirection.rtl);
        expect(rtlSpec.fit, StackFit.expand);
      });
    });
  });
}
