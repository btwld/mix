import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexSpec', () {
    group('Constructor', () {
      test('creates FlexSpec with all properties', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          clipBehavior: Clip.antiAlias,
          spacing: 16.0,
        );

        expect(spec.direction, Axis.horizontal);
        expect(spec.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.crossAxisAlignment, CrossAxisAlignment.start);
        expect(spec.mainAxisSize, MainAxisSize.min);
        expect(spec.verticalDirection, VerticalDirection.up);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.textBaseline, TextBaseline.ideographic);
        expect(spec.clipBehavior, Clip.antiAlias);
        expect(spec.spacing, 16.0);
      });

      test('creates FlexSpec with default values', () {
        const spec = FlexSpec();

        expect(spec.direction, isNull);
        expect(spec.mainAxisAlignment, isNull);
        expect(spec.crossAxisAlignment, isNull);
        expect(spec.mainAxisSize, isNull);
        expect(spec.verticalDirection, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.textBaseline, isNull);
        expect(spec.clipBehavior, isNull);
        expect(spec.spacing, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const original = FlexSpec(
          direction: Axis.horizontal,
          spacing: 8.0,
        );

        final updated = original.copyWith(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
        );

        expect(updated.direction, Axis.vertical);
        expect(updated.mainAxisAlignment, MainAxisAlignment.center);
        expect(updated.spacing, 8.0);
      });

      test('preserves original properties when not specified', () {
        const original = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
        );

        final updated = original.copyWith(spacing: 16.0);

        expect(updated.direction, Axis.horizontal);
        expect(updated.mainAxisAlignment, MainAxisAlignment.start);
        expect(updated.crossAxisAlignment, CrossAxisAlignment.center);
        expect(updated.spacing, 16.0);
      });

      test('handles null values correctly', () {
        const original = FlexSpec(
          direction: Axis.horizontal,
          spacing: 8.0,
        );
        final updated = original.copyWith();

        expect(updated.direction, Axis.horizontal);
        expect(updated.spacing, 8.0);
      });
    });

    group('lerp', () {
      test('interpolates spacing correctly', () {
        const spec1 = FlexSpec(spacing: 8.0);
        const spec2 = FlexSpec(spacing: 16.0);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.spacing, ui.lerpDouble(8.0, 16.0, 0.5));
      });

      test('handles null other parameter correctly', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          spacing: 10.0,
        );

        final lerped1 = spec.lerp(null, 0.3);
        expect(lerped1.direction, Axis.horizontal);
        expect(lerped1.spacing, ui.lerpDouble(10.0, null, 0.3));

        final lerped2 = spec.lerp(null, 0.7);
        expect(lerped2.direction, isNull);
        expect(lerped2.spacing, ui.lerpDouble(10.0, null, 0.7));
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1 = FlexSpec(
          direction: Axis.horizontal,
          spacing: 8.0,
        );
        const spec2 = FlexSpec(
          direction: Axis.vertical,
          spacing: 16.0,
        );

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        expect(lerpedAt0.direction, Axis.horizontal);
        expect(lerpedAt0.spacing, ui.lerpDouble(8.0, 16.0, 0.0));
        expect(lerpedAt1.direction, Axis.vertical);
        expect(lerpedAt1.spacing, ui.lerpDouble(8.0, 16.0, 1.0));
      });

      test('uses step function for discrete properties', () {
        const spec1 = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          clipBehavior: Clip.none,
        );
        const spec2 = FlexSpec(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          clipBehavior: Clip.antiAlias,
        );

        final lerpedBefore = spec1.lerp(spec2, 0.4);
        final lerpedAfter = spec1.lerp(spec2, 0.6);

        // t < 0.5 uses spec1
        expect(lerpedBefore.direction, Axis.horizontal);
        expect(lerpedBefore.mainAxisAlignment, MainAxisAlignment.start);
        expect(lerpedBefore.crossAxisAlignment, CrossAxisAlignment.start);
        expect(lerpedBefore.mainAxisSize, MainAxisSize.min);
        expect(lerpedBefore.verticalDirection, VerticalDirection.down);
        expect(lerpedBefore.textDirection, TextDirection.ltr);
        expect(lerpedBefore.textBaseline, TextBaseline.alphabetic);
        expect(lerpedBefore.clipBehavior, Clip.none);

        // t >= 0.5 uses spec2
        expect(lerpedAfter.direction, Axis.vertical);
        expect(lerpedAfter.mainAxisAlignment, MainAxisAlignment.end);
        expect(lerpedAfter.crossAxisAlignment, CrossAxisAlignment.end);
        expect(lerpedAfter.mainAxisSize, MainAxisSize.max);
        expect(lerpedAfter.verticalDirection, VerticalDirection.up);
        expect(lerpedAfter.textDirection, TextDirection.rtl);
        expect(lerpedAfter.textBaseline, TextBaseline.ideographic);
        expect(lerpedAfter.clipBehavior, Clip.antiAlias);
      });

      test('interpolates between two FlexSpecs correctly', () {
        const spec1 = FlexSpec(
          direction: Axis.horizontal,
          spacing: 8.0,
        );
        const spec2 = FlexSpec(
          direction: Axis.vertical,
          spacing: 24.0,
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.direction, Axis.vertical);
        expect(lerped.spacing, 16.0);
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const spec1 = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
        );
        const spec2 = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
        );

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different properties are not equal', () {
        const spec1 = FlexSpec(direction: Axis.horizontal, spacing: 8.0);
        const spec2 = FlexSpec(direction: Axis.vertical, spacing: 8.0);

        expect(spec1, isNot(spec2));
      });

      test('specs with null vs non-null properties are not equal', () {
        const spec1 = FlexSpec(direction: Axis.horizontal);
        const spec2 = FlexSpec();

        expect(spec1, isNot(spec2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          clipBehavior: Clip.antiAlias,
          spacing: 16.0,
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'direction'), isTrue);
        expect(properties.any((p) => p.name == 'mainAxisAlignment'), isTrue);
        expect(properties.any((p) => p.name == 'crossAxisAlignment'), isTrue);
        expect(properties.any((p) => p.name == 'mainAxisSize'), isTrue);
        expect(properties.any((p) => p.name == 'verticalDirection'), isTrue);
        expect(properties.any((p) => p.name == 'textDirection'), isTrue);
        expect(properties.any((p) => p.name == 'textBaseline'), isTrue);
        expect(properties.any((p) => p.name == 'clipBehavior'), isTrue);
        expect(properties.any((p) => p.name == 'spacing'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          clipBehavior: Clip.antiAlias,
          spacing: 16.0,
        );

        expect(spec.props.length, 9);
        expect(spec.props, contains(Axis.horizontal));
        expect(spec.props, contains(MainAxisAlignment.center));
        expect(spec.props, contains(CrossAxisAlignment.start));
        expect(spec.props, contains(MainAxisSize.min));
        expect(spec.props, contains(VerticalDirection.up));
        expect(spec.props, contains(TextDirection.rtl));
        expect(spec.props, contains(TextBaseline.ideographic));
        expect(spec.props, contains(Clip.antiAlias));
        expect(spec.props, contains(16.0));
      });
    });

    group('Real-world scenarios', () {
      test('creates row spec', () {
        const rowSpec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          spacing: 8.0,
        );

        expect(rowSpec.direction, Axis.horizontal);
        expect(rowSpec.mainAxisAlignment, MainAxisAlignment.start);
        expect(rowSpec.crossAxisAlignment, CrossAxisAlignment.center);
        expect(rowSpec.mainAxisSize, MainAxisSize.max);
        expect(rowSpec.spacing, 8.0);
      });

      test('creates column spec', () {
        const columnSpec = FlexSpec(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
        );

        expect(columnSpec.direction, Axis.vertical);
        expect(columnSpec.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expect(columnSpec.crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(columnSpec.mainAxisSize, MainAxisSize.min);
        expect(columnSpec.spacing, 16.0);
      });

      test('creates centered flex spec', () {
        const centeredSpec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
        );

        expect(centeredSpec.direction, Axis.horizontal);
        expect(centeredSpec.mainAxisAlignment, MainAxisAlignment.center);
        expect(centeredSpec.crossAxisAlignment, CrossAxisAlignment.center);
        expect(centeredSpec.mainAxisSize, MainAxisSize.max);
      });

      test('creates RTL flex spec', () {
        const rtlSpec = FlexSpec(
          direction: Axis.horizontal,
          textDirection: TextDirection.rtl,
          verticalDirection: VerticalDirection.down,
        );

        expect(rtlSpec.direction, Axis.horizontal);
        expect(rtlSpec.textDirection, TextDirection.rtl);
        expect(rtlSpec.verticalDirection, VerticalDirection.down);
      });
    });
  });
}
