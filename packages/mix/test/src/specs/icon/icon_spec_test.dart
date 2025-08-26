import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/specs/icon/icon_spec.dart';

void main() {
  group('FlexWidgetSpecUtility', () {
    group('Constructor', () {
      test('', () {
        const spec = IconSpec(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
          grade: 0.0,
          opticalSize: 24.0,
          shadows: [
            Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2.0),
          ],
          textDirection: TextDirection.ltr,
          applyTextScaling: true,
          fill: 1.0,
        );

        expect(spec.color, Colors.blue);
        expect(spec.size, 24.0);
        expect(spec.weight, 400.0);
        expect(spec.grade, 0.0);
        expect(spec.opticalSize, 24.0);
        expect(spec.shadows, isA<List<Shadow>>());
        expect(spec.shadows!.length, 1);
        expect(spec.textDirection, TextDirection.ltr);
        expect(spec.applyTextScaling, true);
        expect(spec.fill, 1.0);
      });

      test('', () {
        const spec = IconSpec();

        expect(spec.color, isNull);
        expect(spec.size, isNull);
        expect(spec.weight, isNull);
        expect(spec.grade, isNull);
        expect(spec.opticalSize, isNull);
        expect(spec.shadows, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.applyTextScaling, isNull);
        expect(spec.fill, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const original = IconSpec(
          color: Colors.red,
          size: 16.0,
          weight: 300.0,
          textDirection: TextDirection.ltr,
        );

        final updated = original.copyWith(
          color: Colors.blue,
          size: 24.0,
          grade: 100.0,
          applyTextScaling: false,
        );

        expect(updated.color, Colors.blue);
        expect(updated.size, 24.0);
        expect(updated.weight, 300.0);
        expect(updated.grade, 100.0);
        expect(updated.textDirection, TextDirection.ltr);
        expect(updated.applyTextScaling, false);
      });

      test('preserves original properties when not specified', () {
        const original = IconSpec(
          opticalSize: 20.0,
          fill: 0.5,
          shadows: [Shadow(color: Colors.grey, offset: Offset(0, 1))],
        );

        final updated = original.copyWith(opticalSize: 24.0);

        expect(updated.opticalSize, 24.0);
        expect(updated.fill, 0.5);
        expect(updated.shadows, isA<List<Shadow>>());
      });

      test('handles null values correctly', () {
        const original = IconSpec(color: Colors.green, size: 18.0);
        final updated = original.copyWith();

        expect(updated.color, Colors.green);
        expect(updated.size, 18.0);
      });
    });

    group('lerp', () {
      test('', () {
        const spec1 = IconSpec(
          color: Colors.red,
          size: 16.0,
          weight: 300.0,
          grade: 0.0,
          opticalSize: 16.0,
          fill: 0.0,
        );
        const spec2 = IconSpec(
          color: Colors.blue,
          size: 24.0,
          weight: 500.0,
          grade: 200.0,
          opticalSize: 24.0,
          fill: 1.0,
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.color, Color.lerp(Colors.red, Colors.blue, 0.5));
        expect(lerped.size, ui.lerpDouble(16.0, 24.0, 0.5)); // (16 + 24) / 2
        expect(lerped.weight, 400.0); // (300 + 500) / 2
        expect(lerped.grade, 100.0); // (0 + 200) / 2
        expect(lerped.opticalSize, 20.0); // (16 + 24) / 2
        expect(lerped.fill, 0.5); // (0 + 1) / 2
      });

      test('handles null other parameter correctly', () {
        const spec = IconSpec(color: Colors.green, size: 20.0);

        // When t < 0.5, should preserve original values
        final lerped1 = spec.lerp(null, 0.3);
        expect(lerped1.color, Color.lerp(Colors.green, null, 0.3));
        expect(lerped1.size, ui.lerpDouble(20.0, null, 0.3));

        // When t >= 0.5, properties interpolate properly with null
        final lerped2 = spec.lerp(null, 0.7);
        expect(lerped2.color, Color.lerp(Colors.green, null, 0.7)); // color should interpolate properly
        expect(lerped2.size, ui.lerpDouble(20.0, null, 0.7)); // size should interpolate properly
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1 = IconSpec(color: Colors.red, size: 16.0, weight: 300.0);
        const spec2 = IconSpec(color: Colors.blue, size: 24.0, weight: 500.0);

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        expect(lerpedAt0.color, Color.lerp(Colors.red, Colors.blue, 0.0));
        expect(lerpedAt0.size, ui.lerpDouble(16.0, 24.0, 0.0));
        expect(lerpedAt0.weight, 300.0);
        expect(lerpedAt1.color, Color.lerp(Colors.red, Colors.blue, 1.0));
        expect(lerpedAt1.size, ui.lerpDouble(16.0, 24.0, 1.0));
        expect(lerpedAt1.weight, 500.0);
      });

      test('uses step function for discrete properties', () {
        const spec1 = IconSpec(
          textDirection: TextDirection.ltr,
          applyTextScaling: true,
        );
        const spec2 = IconSpec(
          textDirection: TextDirection.rtl,
          applyTextScaling: false,
        );

        final lerpedBefore = spec1.lerp(spec2, 0.4);
        final lerpedAfter = spec1.lerp(spec2, 0.6);

        // t < 0.5 uses spec1
        expect(lerpedBefore.textDirection, TextDirection.ltr);
        expect(lerpedBefore.applyTextScaling, true);

        // t >= 0.5 uses spec2
        expect(lerpedAfter.textDirection, TextDirection.rtl);
        expect(lerpedAfter.applyTextScaling, false);
      });

      test('interpolates shadows correctly', () {
        const spec1 = IconSpec(
          shadows: [
            Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 1.0),
          ],
        );
        const spec2 = IconSpec(
          shadows: [
            Shadow(color: Colors.grey, offset: Offset(2, 3), blurRadius: 5.0),
          ],
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.shadows, isA<List<Shadow>>());
        expect(lerped.shadows!.length, 1);
        // Shadow interpolation is handled by MixOps.lerp
      });

      test('handles null shadow interpolation', () {
        const spec1 = IconSpec(
          shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
        );
        const spec2 = IconSpec();

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.shadows, isA<List<Shadow>?>());
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const spec1 = IconSpec(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
          grade: 0.0,
          textDirection: TextDirection.ltr,
        );
        const spec2 = IconSpec(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
          grade: 0.0,
          textDirection: TextDirection.ltr,
        );

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different properties are not equal', () {
        const spec1 = IconSpec(color: Colors.blue, size: 24.0);
        const spec2 = IconSpec(color: Colors.red, size: 24.0);

        expect(spec1, isNot(spec2));
      });

      test('specs with null vs non-null properties are not equal', () {
        const spec1 = IconSpec(color: Colors.blue);
        const spec2 = IconSpec();

        expect(spec1, isNot(spec2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        const spec = IconSpec(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
          grade: 0.0,
          opticalSize: 24.0,
          shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
          textDirection: TextDirection.ltr,
          applyTextScaling: true,
          fill: 1.0,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'color'), isTrue);
        expect(properties.any((p) => p.name == 'size'), isTrue);
        expect(properties.any((p) => p.name == 'weight'), isTrue);
        expect(properties.any((p) => p.name == 'grade'), isTrue);
        expect(properties.any((p) => p.name == 'opticalSize'), isTrue);
        expect(properties.any((p) => p.name == 'shadows'), isTrue);
        expect(properties.any((p) => p.name == 'textDirection'), isTrue);
        expect(properties.any((p) => p.name == 'applyTextScaling'), isTrue);
        expect(properties.any((p) => p.name == 'fill'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const spec = IconSpec(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
          grade: 0.0,
          opticalSize: 24.0,
          shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
          textDirection: TextDirection.ltr,
          applyTextScaling: true,
          fill: 1.0,
        );

        // 13 IconSpec properties (including opacity)
        expect(spec.props.length, 13);
        expect(spec.props, contains(Colors.blue));
        expect(spec.props, contains(24.0));
        expect(spec.props, contains(400.0));
        expect(spec.props, contains(0.0));
        expect(spec.props, contains(isA<List<Shadow>>()));
        expect(spec.props, contains(TextDirection.ltr));
        expect(spec.props, contains(true));
        expect(spec.props, contains(1.0));
      });
    });

    group('Real-world scenarios', () {
      test('creates material design icon spec', () {
        const materialSpec = IconSpec(
          size: 24.0,
          color: Colors.black87,
          textDirection: TextDirection.ltr,
          applyTextScaling: false,
        );

        expect(materialSpec.size, 24.0);
        expect(materialSpec.color, Colors.black87);
        expect(materialSpec.textDirection, TextDirection.ltr);
        expect(materialSpec.applyTextScaling, false);
      });

      test('creates variable font icon spec', () {
        const variableSpec = IconSpec(
          size: 20.0,
          weight: 300.0,
          grade: 25.0,
          opticalSize: 20.0,
          fill: 0.5,
        );

        expect(variableSpec.size, 20.0);
        expect(variableSpec.weight, 300.0);
        expect(variableSpec.grade, 25.0);
        expect(variableSpec.opticalSize, 20.0);
        expect(variableSpec.fill, 0.5);
      });

      test('creates icon with shadow spec', () {
        const shadowSpec = IconSpec(
          size: 32.0,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4.0,
            ),
            Shadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 2.0,
            ),
          ],
        );

        expect(shadowSpec.size, 32.0);
        expect(shadowSpec.color, Colors.white);
        expect(shadowSpec.shadows!.length, 2);
      });

      test('creates RTL icon spec', () {
        const rtlSpec = IconSpec(
          size: 18.0,
          color: Colors.blue,
          textDirection: TextDirection.rtl,
          applyTextScaling: true,
        );

        expect(rtlSpec.size, 18.0);
        expect(rtlSpec.color, Colors.blue);
        expect(rtlSpec.textDirection, TextDirection.rtl);
        expect(rtlSpec.applyTextScaling, true);
      });
    });
  });
}
