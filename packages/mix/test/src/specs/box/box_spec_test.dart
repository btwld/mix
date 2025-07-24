import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('BoxSpec', () {
    group('Constructor', () {
      test('creates BoxSpec with all properties', () {
        final spec = BoxSpec(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(color: Colors.red),
          foregroundDecoration: BoxDecoration(color: Colors.blue),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
        );

        expect(spec.alignment, Alignment.center);
        expect(spec.padding, const EdgeInsets.all(8.0));
        expect(spec.margin, const EdgeInsets.all(16.0));
        expect(spec.constraints, const BoxConstraints(maxWidth: 200));
        expect(spec.decoration, const BoxDecoration(color: Colors.red));
        expect(
          spec.foregroundDecoration,
          const BoxDecoration(color: Colors.blue),
        );
        expect(spec.transform, Matrix4.identity());
        expect(spec.transformAlignment, Alignment.topLeft);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('creates BoxSpec with default values', () {
        const spec = BoxSpec();

        expect(spec.alignment, isNull);
        expect(spec.padding, isNull);
        expect(spec.margin, isNull);
        expect(spec.constraints, isNull);
        expect(spec.decoration, isNull);
        expect(spec.foregroundDecoration, isNull);
        expect(spec.transform, isNull);
        expect(spec.transformAlignment, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const original = BoxSpec(alignment: Alignment.center);

        final updated = original.copyWith(
          alignment: Alignment.topLeft,
          constraints: const BoxConstraints(minWidth: 150.0, maxWidth: 150.0),
        );

        expect(updated.alignment, Alignment.topLeft);
        expect(updated.constraints?.minWidth, 150.0);
        expect(updated.constraints?.maxWidth, 150.0);
      });

      test('preserves original properties when not specified', () {
        const original = BoxSpec(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(16.0),
          clipBehavior: Clip.antiAlias,
        );

        final updated = original.copyWith(padding: EdgeInsets.all(12.0));

        expect(updated.padding, const EdgeInsets.all(12.0));
        expect(updated.margin, const EdgeInsets.all(16.0)); // unchanged
        expect(updated.clipBehavior, Clip.antiAlias); // unchanged
      });

      test('handles null values correctly', () {
        const original = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );
        final updated = original.copyWith();

        expect(updated.constraints?.minWidth, 100.0);
        expect(updated.constraints?.maxWidth, 100.0);
        expect(updated.constraints?.minHeight, 200.0);
        expect(updated.constraints?.maxHeight, 200.0);
      });
    });

    group('lerp', () {
      test('interpolates between two BoxSpecs correctly', () {
        const spec1 = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
          alignment: Alignment.topLeft,
        );
        const spec2 = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 200.0,
            maxWidth: 200.0,
            minHeight: 400.0,
            maxHeight: 400.0,
          ),
          alignment: Alignment.bottomRight,
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.constraints?.minWidth, 150.0);
        expect(lerped.constraints?.maxWidth, 150.0);
        expect(lerped.constraints?.minHeight, 300.0);
        expect(lerped.constraints?.maxHeight, 300.0);
        expect(lerped.alignment, Alignment.center);
      });

      test('returns original spec when other is null', () {
        const spec = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );
        final lerped = spec.lerp(null, 0.5);

        expect(lerped, spec);
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1 = BoxSpec(
          constraints: BoxConstraints(minWidth: 100.0, maxWidth: 100.0),
        );
        const spec2 = BoxSpec(
          constraints: BoxConstraints(minWidth: 200.0, maxWidth: 200.0),
        );

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        expect(lerpedAt0.constraints?.minWidth, 100.0);
        expect(lerpedAt0.constraints?.maxWidth, 100.0);
        expect(lerpedAt1.constraints?.minWidth, 200.0);
        expect(lerpedAt1.constraints?.maxWidth, 200.0);
      });

      test('interpolates padding and margin correctly', () {
        const spec1 = BoxSpec(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(16.0),
        );
        const spec2 = BoxSpec(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(32.0),
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.padding, const EdgeInsets.all(12.0));
        expect(lerped.margin, const EdgeInsets.all(24.0));
      });

      test('interpolates constraints correctly', () {
        const spec1 = BoxSpec(
          constraints: BoxConstraints(maxWidth: 100, maxHeight: 200),
        );
        const spec2 = BoxSpec(
          constraints: BoxConstraints(maxWidth: 200, maxHeight: 400),
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.constraints?.maxWidth, 150.0);
        expect(lerped.constraints?.maxHeight, 300.0);
      });

      test('uses step function for clipBehavior', () {
        const spec1 = BoxSpec(clipBehavior: Clip.none);
        const spec2 = BoxSpec(clipBehavior: Clip.antiAlias);

        final lerpedBefore = spec1.lerp(spec2, 0.4);
        final lerpedAfter = spec1.lerp(spec2, 0.6);

        expect(lerpedBefore.clipBehavior, Clip.none);
        expect(lerpedAfter.clipBehavior, Clip.antiAlias);
      });

      test('interpolates transform correctly', () {
        final transform1 = Matrix4.identity();
        final transform2 = Matrix4.identity()..scale(2.0);

        final spec1 = BoxSpec(transform: transform1);
        final spec2 = BoxSpec(transform: transform2);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.transform, isNotNull);
        // Matrix4 lerp is handled by MixHelpers.lerpMatrix4
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const spec1 = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
          alignment: Alignment.center,
        );
        const spec2 = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
          alignment: Alignment.center,
        );

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different properties are not equal', () {
        const spec1 = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );
        const spec2 = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 150.0,
            maxWidth: 150.0,
            minHeight: 200.0,
            maxHeight: 200.0,
          ),
        );

        expect(spec1, isNot(spec2));
      });

      test('specs with null vs non-null properties are not equal', () {
        const spec1 = BoxSpec(
          constraints: BoxConstraints(minWidth: 100.0, maxWidth: 100.0),
        );
        const spec2 = BoxSpec();

        expect(spec1, isNot(spec2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        final spec = BoxSpec(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(color: Colors.red),
          foregroundDecoration: BoxDecoration(color: Colors.blue),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'alignment'), isTrue);
        expect(properties.any((p) => p.name == 'padding'), isTrue);
        expect(properties.any((p) => p.name == 'margin'), isTrue);
        expect(properties.any((p) => p.name == 'constraints'), isTrue);
        expect(properties.any((p) => p.name == 'decoration'), isTrue);
        expect(properties.any((p) => p.name == 'foregroundDecoration'), isTrue);
        expect(properties.any((p) => p.name == 'transform'), isTrue);
        expect(properties.any((p) => p.name == 'transformAlignment'), isTrue);
        expect(properties.any((p) => p.name == 'clipBehavior'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        final spec = BoxSpec(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(16.0),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(color: Colors.red),
          foregroundDecoration: BoxDecoration(color: Colors.blue),
          transform: Matrix4.identity(),
          transformAlignment: Alignment.topLeft,
          clipBehavior: Clip.antiAlias,
        );

        expect(spec.props.length, 11);
        expect(spec.props, contains(Alignment.center));
        expect(spec.props, contains(const EdgeInsets.all(8.0)));
        expect(spec.props, contains(const EdgeInsets.all(16.0)));
        expect(spec.props, contains(const BoxConstraints(maxWidth: 200)));
        expect(spec.props, contains(const BoxDecoration(color: Colors.red)));
        expect(spec.props, contains(const BoxDecoration(color: Colors.blue)));
        expect(spec.props, contains(Matrix4.identity()));
        expect(spec.props, contains(Alignment.topLeft));
        expect(spec.props, contains(Clip.antiAlias));
        expect(spec.props, contains(100.0));
        expect(spec.props, contains(200.0));
      });
    });

    group('Real-world scenarios', () {
      test('creates card-like container spec', () {
        final cardSpec = BoxSpec(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
        );

        expect(cardSpec.padding, const EdgeInsets.all(16.0));
        expect(cardSpec.margin, const EdgeInsets.all(8.0));
        expect((cardSpec.decoration as BoxDecoration?)?.color, Colors.white);
        expect(cardSpec.clipBehavior, Clip.antiAlias);
      });

      test('creates responsive container spec', () {
        const responsiveSpec = BoxSpec(
          constraints: BoxConstraints(
            minWidth: 200,
            maxWidth: 800,
            minHeight: 100,
          ),
          alignment: Alignment.center,
        );

        expect(responsiveSpec.constraints?.minWidth, 200);
        expect(responsiveSpec.constraints?.maxWidth, 800);
        expect(responsiveSpec.constraints?.minHeight, 100);
        expect(responsiveSpec.alignment, Alignment.center);
      });

      test('creates transformed container spec', () {
        final transformMatrix = Matrix4.identity()
          ..rotateZ(0.1)
          ..scale(1.2);

        final transformedSpec = BoxSpec(
          transform: transformMatrix,
          transformAlignment: Alignment.center,
          constraints: BoxConstraints.tightFor(width: 150, height: 100),
        );

        expect(transformedSpec.transform, transformMatrix);
        expect(transformedSpec.transformAlignment, Alignment.center);
        expect(transformedSpec.constraints?.maxWidth, 150);
        expect(transformedSpec.constraints?.maxHeight, 100);
        expect(transformedSpec.constraints?.minWidth, 150);
        expect(transformedSpec.constraints?.minHeight, 100);
      });
    });
  });
}
