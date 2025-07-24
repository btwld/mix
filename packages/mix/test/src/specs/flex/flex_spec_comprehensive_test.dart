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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          clipBehavior: Clip.antiAlias,
          gap: 16.0,
        );

        expect(spec.direction, Axis.horizontal);
        expect(spec.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(spec.mainAxisSize, MainAxisSize.max);
        expect(spec.verticalDirection, VerticalDirection.down);
        expect(spec.textDirection, TextDirection.ltr);
        expect(spec.textBaseline, TextBaseline.alphabetic);
        expect(spec.clipBehavior, Clip.antiAlias);
        expect(spec.gap, 16.0);
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
        expect(spec.gap, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const original = FlexSpec(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: 8.0,
        );

        final updated = original.copyWith(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
        );

        expect(updated.direction, Axis.horizontal);
        expect(updated.mainAxisAlignment, MainAxisAlignment.end);
        expect(updated.crossAxisAlignment, CrossAxisAlignment.center); // unchanged
        expect(updated.gap, 8.0); // unchanged
        expect(updated.mainAxisSize, MainAxisSize.min);
      });

      test('preserves original properties when not specified', () {
        const original = FlexSpec(
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.hardEdge,
        );

        final updated = original.copyWith(verticalDirection: VerticalDirection.down);

        expect(updated.verticalDirection, VerticalDirection.down);
        expect(updated.textDirection, TextDirection.rtl); // unchanged
        expect(updated.clipBehavior, Clip.hardEdge); // unchanged
      });

      test('handles null values correctly', () {
        const original = FlexSpec(direction: Axis.horizontal, gap: 12.0);
        final updated = original.copyWith();

        expect(updated.direction, Axis.horizontal);
        expect(updated.gap, 12.0);
      });
    });

    group('lerp', () {
      test('interpolates between two FlexSpecs correctly', () {
        const spec1 = FlexSpec(gap: 8.0);
        const spec2 = FlexSpec(gap: 16.0);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.gap, 12.0); // (8 + 16) / 2
      });

      test('returns original spec when other is null', () {
        const spec = FlexSpec(direction: Axis.horizontal, gap: 8.0);
        final lerped = spec.lerp(null, 0.5);

        expect(lerped, spec);
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1 = FlexSpec(gap: 8.0, direction: Axis.horizontal);
        const spec2 = FlexSpec(gap: 16.0, direction: Axis.vertical);

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        expect(lerpedAt0.gap, 8.0);
        expect(lerpedAt0.direction, Axis.horizontal);
        expect(lerpedAt1.gap, 16.0);
        expect(lerpedAt1.direction, Axis.vertical);
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

      test('interpolates gap correctly', () {
        const spec1 = FlexSpec(gap: 0.0);
        const spec2 = FlexSpec(gap: 20.0);

        final lerped = spec1.lerp(spec2, 0.25);

        expect(lerped.gap, 5.0); // 0 + (20 - 0) * 0.25
      });

      test('handles null gap interpolation', () {
        const spec1 = FlexSpec(gap: 10.0);
        const spec2 = FlexSpec();

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.gap, isA<double>());
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const spec1 = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          gap: 16.0,
        );
        const spec2 = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          gap: 16.0,
        );

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different properties are not equal', () {
        const spec1 = FlexSpec(direction: Axis.horizontal, gap: 8.0);
        const spec2 = FlexSpec(direction: Axis.vertical, gap: 8.0);

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          clipBehavior: Clip.antiAlias,
          gap: 16.0,
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
        expect(properties.any((p) => p.name == 'gap'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const spec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          clipBehavior: Clip.antiAlias,
          gap: 16.0,
        );

        expect(spec.props.length, 9);
        expect(spec.props, contains(Axis.horizontal));
        expect(spec.props, contains(MainAxisAlignment.center));
        expect(spec.props, contains(CrossAxisAlignment.stretch));
        expect(spec.props, contains(MainAxisSize.max));
        expect(spec.props, contains(VerticalDirection.down));
        expect(spec.props, contains(TextDirection.ltr));
        expect(spec.props, contains(TextBaseline.alphabetic));
        expect(spec.props, contains(Clip.antiAlias));
        expect(spec.props, contains(16.0));
      });
    });

    group('Real-world scenarios', () {
      test('creates row layout spec', () {
        const rowSpec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: 8.0,
        );

        expect(rowSpec.direction, Axis.horizontal);
        expect(rowSpec.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expect(rowSpec.crossAxisAlignment, CrossAxisAlignment.center);
        expect(rowSpec.gap, 8.0);
      });

      test('creates column layout spec', () {
        const columnSpec = FlexSpec(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
        );

        expect(columnSpec.direction, Axis.vertical);
        expect(columnSpec.mainAxisAlignment, MainAxisAlignment.start);
        expect(columnSpec.crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(columnSpec.mainAxisSize, MainAxisSize.min);
      });

      test('creates RTL flex spec', () {
        const rtlSpec = FlexSpec(
          direction: Axis.horizontal,
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
        );

        expect(rtlSpec.direction, Axis.horizontal);
        expect(rtlSpec.textDirection, TextDirection.rtl);
        expect(rtlSpec.mainAxisAlignment, MainAxisAlignment.start);
      });

      test('creates baseline-aligned flex spec', () {
        const baselineSpec = FlexSpec(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
        );

        expect(baselineSpec.direction, Axis.horizontal);
        expect(baselineSpec.crossAxisAlignment, CrossAxisAlignment.baseline);
        expect(baselineSpec.textBaseline, TextBaseline.alphabetic);
      });
    });
  });
}
