import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexBoxSpec', () {
    group('Constructor', () {
      test('creates FlexBoxSpec with all properties', () {
        const boxSpec = BoxSpec(
          width: 200.0,
          height: 100.0,
          alignment: Alignment.center,
        );
        const flexSpec = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 16.0,
        );

        const spec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

        expect(spec.box, boxSpec);
        expect(spec.flex, flexSpec);
        expect(spec.box.width, 200.0);
        expect(spec.box.height, 100.0);
        expect(spec.box.alignment, Alignment.center);
        expect(spec.flex.direction, Axis.horizontal);
        expect(spec.flex.mainAxisAlignment, MainAxisAlignment.center);
        expect(spec.flex.gap, 16.0);
      });

      test('creates FlexBoxSpec with default values', () {
        const spec = FlexBoxSpec();

        expect(spec.box, const BoxSpec());
        expect(spec.flex, const FlexSpec());
        expect(spec.box.width, isNull);
        expect(spec.box.height, isNull);
        expect(spec.flex.direction, isNull);
        expect(spec.flex.gap, isNull);
      });

      test('creates FlexBoxSpec with partial properties', () {
        const boxSpec = BoxSpec(padding: EdgeInsets.all(8.0));
        const spec = FlexBoxSpec(box: boxSpec);

        expect(spec.box, boxSpec);
        expect(spec.flex, const FlexSpec());
        expect(spec.box.padding, const EdgeInsets.all(8.0));
        expect(spec.flex.direction, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const originalBox = BoxSpec(width: 100.0, height: 50.0);
        const originalFlex = FlexSpec(direction: Axis.vertical, gap: 8.0);
        const original = FlexBoxSpec(box: originalBox, flex: originalFlex);

        const newBox = BoxSpec(width: 200.0, height: 100.0);
        final updated = original.copyWith(box: newBox);

        expect(updated.box, newBox);
        expect(updated.flex, originalFlex); // unchanged
        expect(updated.box.width, 200.0);
        expect(updated.box.height, 100.0);
        expect(updated.flex.direction, Axis.vertical);
        expect(updated.flex.gap, 8.0);
      });

      test('preserves original properties when not specified', () {
        const originalBox = BoxSpec(alignment: Alignment.topLeft);
        const originalFlex = FlexSpec(mainAxisAlignment: MainAxisAlignment.end);
        const original = FlexBoxSpec(box: originalBox, flex: originalFlex);

        const newFlex = FlexSpec(direction: Axis.horizontal);
        final updated = original.copyWith(flex: newFlex);

        expect(updated.box, originalBox); // unchanged
        expect(updated.flex, newFlex);
        expect(updated.box.alignment, Alignment.topLeft);
        expect(updated.flex.direction, Axis.horizontal);
      });

      test('handles null values correctly', () {
        const originalBox = BoxSpec(width: 150.0);
        const originalFlex = FlexSpec(gap: 12.0);
        const original = FlexBoxSpec(box: originalBox, flex: originalFlex);

        final updated = original.copyWith();

        expect(updated.box, originalBox);
        expect(updated.flex, originalFlex);
      });
    });

    group('lerp', () {
      test('interpolates between two FlexBoxSpecs correctly', () {
        const spec1Box = BoxSpec(width: 100.0, height: 50.0);
        const spec1Flex = FlexSpec(gap: 8.0);
        const spec1 = FlexBoxSpec(box: spec1Box, flex: spec1Flex);

        const spec2Box = BoxSpec(width: 200.0, height: 100.0);
        const spec2Flex = FlexSpec(gap: 16.0);
        const spec2 = FlexBoxSpec(box: spec2Box, flex: spec2Flex);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.box.width, 150.0); // (100 + 200) / 2
        expect(lerped.box.height, 75.0); // (50 + 100) / 2
        expect(lerped.flex.gap, 12.0); // (8 + 16) / 2
      });

      test('returns original spec when other is null', () {
        const boxSpec = BoxSpec(width: 100.0);
        const flexSpec = FlexSpec(gap: 8.0);
        const spec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

        final lerped = spec.lerp(null, 0.5);

        expect(lerped, spec);
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1Box = BoxSpec(width: 100.0);
        const spec1Flex = FlexSpec(gap: 8.0);
        const spec1 = FlexBoxSpec(box: spec1Box, flex: spec1Flex);

        const spec2Box = BoxSpec(width: 200.0);
        const spec2Flex = FlexSpec(gap: 16.0);
        const spec2 = FlexBoxSpec(box: spec2Box, flex: spec2Flex);

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        expect(lerpedAt0.box.width, 100.0);
        expect(lerpedAt0.flex.gap, 8.0);
        expect(lerpedAt1.box.width, 200.0);
        expect(lerpedAt1.flex.gap, 16.0);
      });

      test('interpolates complex properties correctly', () {
        const spec1Box = BoxSpec(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(8.0),
        );
        const spec1Flex = FlexSpec(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
        );
        const spec1 = FlexBoxSpec(box: spec1Box, flex: spec1Flex);

        const spec2Box = BoxSpec(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(16.0),
        );
        const spec2Flex = FlexSpec(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
        );
        const spec2 = FlexBoxSpec(box: spec2Box, flex: spec2Flex);

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.box.alignment, Alignment.center);
        expect(lerped.box.padding, const EdgeInsets.all(12.0));
        // Discrete properties use step function
        expect(lerped.flex.direction, Axis.vertical); // t >= 0.5
        expect(
          lerped.flex.mainAxisAlignment,
          MainAxisAlignment.end,
        ); // t >= 0.5
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const boxSpec = BoxSpec(width: 100.0, height: 50.0);
        const flexSpec = FlexSpec(direction: Axis.horizontal, gap: 8.0);
        const spec1 = FlexBoxSpec(box: boxSpec, flex: flexSpec);
        const spec2 = FlexBoxSpec(box: boxSpec, flex: flexSpec);

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different box properties are not equal', () {
        const boxSpec1 = BoxSpec(width: 100.0);
        const boxSpec2 = BoxSpec(width: 200.0);
        const flexSpec = FlexSpec(gap: 8.0);
        const spec1 = FlexBoxSpec(box: boxSpec1, flex: flexSpec);
        const spec2 = FlexBoxSpec(box: boxSpec2, flex: flexSpec);

        expect(spec1, isNot(spec2));
      });

      test('specs with different flex properties are not equal', () {
        const boxSpec = BoxSpec(width: 100.0);
        const flexSpec1 = FlexSpec(direction: Axis.horizontal);
        const flexSpec2 = FlexSpec(direction: Axis.vertical);
        const spec1 = FlexBoxSpec(box: boxSpec, flex: flexSpec1);
        const spec2 = FlexBoxSpec(box: boxSpec, flex: flexSpec2);

        expect(spec1, isNot(spec2));
      });

      test('default specs are equal', () {
        const spec1 = FlexBoxSpec();
        const spec2 = FlexBoxSpec();

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        const boxSpec = BoxSpec(width: 100.0, height: 50.0);
        const flexSpec = FlexSpec(direction: Axis.horizontal, gap: 8.0);
        const spec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'box'), isTrue);
        expect(properties.any((p) => p.name == 'flex'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const boxSpec = BoxSpec(width: 100.0, height: 50.0);
        const flexSpec = FlexSpec(direction: Axis.horizontal, gap: 8.0);
        const spec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

        expect(spec.props.length, 2);
        expect(spec.props, contains(boxSpec));
        expect(spec.props, contains(flexSpec));
      });
    });

    group('Real-world scenarios', () {
      test('creates card layout spec', () {
        final cardSpec = FlexBoxSpec(
          box: BoxSpec(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 4.0,
                ),
              ],
            ),
          ),
          flex: FlexSpec(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            gap: 12.0,
          ),
        );

        expect(cardSpec.box.padding, const EdgeInsets.all(16.0));
        expect(cardSpec.box.decoration, isA<BoxDecoration>());
        expect(cardSpec.flex.direction, Axis.vertical);
        expect(cardSpec.flex.mainAxisAlignment, MainAxisAlignment.start);
        expect(cardSpec.flex.crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(cardSpec.flex.gap, 12.0);
      });

      test('creates button layout spec', () {
        final buttonSpec = FlexBoxSpec(
          box: BoxSpec(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            constraints: BoxConstraints(minHeight: 48.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
          flex: FlexSpec(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: 8.0,
          ),
        );

        expect(
          buttonSpec.box.padding,
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        );
        expect(
          buttonSpec.box.constraints,
          const BoxConstraints(minHeight: 48.0),
        );
        expect(buttonSpec.flex.direction, Axis.horizontal);
        expect(buttonSpec.flex.mainAxisAlignment, MainAxisAlignment.center);
        expect(buttonSpec.flex.crossAxisAlignment, CrossAxisAlignment.center);
        expect(buttonSpec.flex.gap, 8.0);
      });

      test('creates responsive container spec', () {
        const responsiveSpec = FlexBoxSpec(
          box: BoxSpec(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 1200.0),
            margin: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          flex: FlexSpec(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            gap: 24.0,
          ),
        );

        expect(responsiveSpec.box.width, double.infinity);
        expect(
          responsiveSpec.box.constraints,
          const BoxConstraints(maxWidth: 1200.0),
        );
        expect(
          responsiveSpec.box.margin,
          const EdgeInsets.symmetric(horizontal: 16.0),
        );
        expect(responsiveSpec.flex.direction, Axis.vertical);
        expect(responsiveSpec.flex.mainAxisSize, MainAxisSize.min);
        expect(
          responsiveSpec.flex.crossAxisAlignment,
          CrossAxisAlignment.stretch,
        );
        expect(responsiveSpec.flex.gap, 24.0);
      });

      test('creates navigation bar spec', () {
        const navSpec = FlexBoxSpec(
          box: BoxSpec(
            height: 56.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
          ),
          flex: FlexSpec(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        );

        expect(navSpec.box.height, 56.0);
        expect(
          navSpec.box.padding,
          const EdgeInsets.symmetric(horizontal: 16.0),
        );
        expect(navSpec.flex.direction, Axis.horizontal);
        expect(navSpec.flex.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expect(navSpec.flex.crossAxisAlignment, CrossAxisAlignment.center);
      });
    });
  });
}
