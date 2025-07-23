import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('IconSpecAttribute', () {
    group('Constructor', () {
      test('creates IconSpecAttribute with all properties', () {
        final attribute = IconSpecAttribute(
          color: Prop(Colors.blue),
          size: Prop(24.0),
          weight: Prop(400.0),
          grade: Prop(0.0),
          opticalSize: Prop(24.0),
          shadows: [
            MixProp(
              ShadowMix.only(
                color: Colors.black,
                offset: const Offset(1, 1),
                blurRadius: 2.0,
              ),
            ),
          ],
          textDirection: Prop(TextDirection.ltr),
          applyTextScaling: Prop(true),
          fill: Prop(1.0),
        );

        expect(attribute.$color, resolvesTo(Colors.blue));
        expect(attribute.$size, resolvesTo(24.0));
        expect(attribute.$weight, resolvesTo(400.0));
        expect(attribute.$grade, resolvesTo(0.0));
        expect(attribute.$opticalSize, resolvesTo(24.0));
        expect(attribute.$shadows, isNotNull);
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$applyTextScaling, resolvesTo(true));
        expect(attribute.$fill, resolvesTo(1.0));
      });

      test('creates IconSpecAttribute with default values', () {
        final attribute = IconSpecAttribute();

        expect(attribute.$color, isNull);
        expect(attribute.$size, isNull);
        expect(attribute.$weight, isNull);
        expect(attribute.$grade, isNull);
        expect(attribute.$opticalSize, isNull);
        expect(attribute.$shadows, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$applyTextScaling, isNull);
        expect(attribute.$fill, isNull);
      });
    });

    group('only constructor', () {
      test('creates IconSpecAttribute with only specified properties', () {
        final attribute = IconSpecAttribute.only(
          color: Colors.red,
          size: 32.0,
          weight: 500.0,
        );

        expect(attribute.$color, resolvesTo(Colors.red));
        expect(attribute.$size, resolvesTo(32.0));
        expect(attribute.$weight, resolvesTo(500.0));
        expect(attribute.$grade, isNull);
        expect(attribute.$opticalSize, isNull);
        expect(attribute.$shadows, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$applyTextScaling, isNull);
        expect(attribute.$fill, isNull);
      });
    });

    group('value constructor', () {
      test('creates IconSpecAttribute from IconSpec', () {
        const spec = IconSpec(
          color: Colors.green,
          size: 16.0,
          weight: 300.0,
          grade: -25.0,
          opticalSize: 16.0,
          shadows: [
            Shadow(color: Colors.grey, offset: Offset(2, 2), blurRadius: 4.0),
          ],
          textDirection: TextDirection.rtl,
          applyTextScaling: false,
          fill: 0.5,
        );

        final attribute = IconSpecAttribute.value(spec);

        expect(attribute.$color, resolvesTo(Colors.green));
        expect(attribute.$size, resolvesTo(16.0));
        expect(attribute.$weight, resolvesTo(300.0));
        expect(attribute.$grade, resolvesTo(-25.0));
        expect(attribute.$opticalSize, resolvesTo(16.0));
        expect(attribute.$shadows, isNotNull);
        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
        expect(attribute.$applyTextScaling, resolvesTo(false));
        expect(attribute.$fill, resolvesTo(0.5));
      });
    });

    group('maybeValue constructor', () {
      test('creates IconSpecAttribute from non-null IconSpec', () {
        const spec = IconSpec(color: Colors.purple, size: 20.0);
        final attribute = IconSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$color, resolvesTo(Colors.purple));
        expect(attribute.$size, resolvesTo(20.0));
      });

      test('returns null for null IconSpec', () {
        final attribute = IconSpecAttribute.maybeValue(null);
        expect(attribute, isNull);
      });
    });

    group('Utility methods', () {
      test('color utility creates IconSpecAttribute with color', () {
        final attribute = IconSpecAttribute();
        final colorAttribute = attribute.color(Colors.orange);

        expect(colorAttribute, isA<IconSpecAttribute>());
        expect(colorAttribute.$color, resolvesTo(Colors.orange));
      });

      test('size utility creates IconSpecAttribute with size', () {
        final attribute = IconSpecAttribute();
        final sizeAttribute = attribute.size(28.0);

        expect(sizeAttribute, isA<IconSpecAttribute>());
        expect(sizeAttribute.$size, resolvesTo(28.0));
      });

      test('weight utility creates IconSpecAttribute with weight', () {
        final attribute = IconSpecAttribute();
        final weightAttribute = attribute.weight(600.0);

        expect(weightAttribute, isA<IconSpecAttribute>());
        expect(weightAttribute.$weight, resolvesTo(600.0));
      });

      test('grade utility creates IconSpecAttribute with grade', () {
        final attribute = IconSpecAttribute();
        final gradeAttribute = attribute.grade(25.0);

        expect(gradeAttribute, isA<IconSpecAttribute>());
        expect(gradeAttribute.$grade, resolvesTo(25.0));
      });

      test(
        'opticalSize utility creates IconSpecAttribute with opticalSize',
        () {
          final attribute = IconSpecAttribute();
          final opticalSizeAttribute = attribute.opticalSize(48.0);

          expect(opticalSizeAttribute, isA<IconSpecAttribute>());
          expect(opticalSizeAttribute.$opticalSize, resolvesTo(48.0));
        },
      );

      test('shadow utility creates IconSpecAttribute with shadow', () {
        final attribute = IconSpecAttribute();
        final shadowAttribute = attribute.shadow(
          ShadowMix.only(
            color: Colors.black,
            offset: const Offset(1, 1),
            blurRadius: 2.0,
          ),
        );

        expect(shadowAttribute, isA<IconSpecAttribute>());
        expect(shadowAttribute.$shadows, isNotNull);
        expect(shadowAttribute.$shadows!.length, 1);
      });

      test(
        'textDirection utility creates IconSpecAttribute with textDirection',
        () {
          final attribute = IconSpecAttribute();
          final textDirectionAttribute = attribute.textDirection(
            TextDirection.rtl,
          );

          expect(textDirectionAttribute, isA<IconSpecAttribute>());
          expect(
            textDirectionAttribute.$textDirection,
            resolvesTo(TextDirection.rtl),
          );
        },
      );

      test(
        'applyTextScaling utility creates IconSpecAttribute with applyTextScaling',
        () {
          final attribute = IconSpecAttribute();
          final applyTextScalingAttribute = attribute.applyTextScaling(false);

          expect(applyTextScalingAttribute, isA<IconSpecAttribute>());
          expect(
            applyTextScalingAttribute.$applyTextScaling,
            resolvesTo(false),
          );
        },
      );

      test('fill utility creates IconSpecAttribute with fill', () {
        final attribute = IconSpecAttribute();
        final fillAttribute = attribute.fill(0.8);

        expect(fillAttribute, isA<IconSpecAttribute>());
        expect(fillAttribute.$fill, resolvesTo(0.8));
      });

      test(
        'shadows utility creates IconSpecAttribute with multiple shadows',
        () {
          final attribute = IconSpecAttribute();
          final shadowsAttribute = attribute.shadows([
            ShadowMix.only(
              color: Colors.black,
              offset: const Offset(1, 1),
              blurRadius: 2.0,
            ),
            ShadowMix.only(
              color: Colors.grey,
              offset: const Offset(2, 2),
              blurRadius: 4.0,
            ),
          ]);

          expect(shadowsAttribute, isA<IconSpecAttribute>());
          expect(shadowsAttribute.$shadows, isNotNull);
          expect(shadowsAttribute.$shadows!.length, 2);
        },
      );
    });

    group('resolve', () {
      test('resolves to IconSpec with correct properties', () {
        final attribute = IconSpecAttribute.only(
          color: Colors.cyan,
          size: 36.0,
          weight: 700.0,
          grade: 50.0,
          opticalSize: 36.0,
          textDirection: TextDirection.ltr,
          applyTextScaling: true,
          fill: 1.0,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.color, Colors.cyan);
        expect(spec.size, 36.0);
        expect(spec.weight, 700.0);
        expect(spec.grade, 50.0);
        expect(spec.opticalSize, 36.0);
        expect(spec.textDirection, TextDirection.ltr);
        expect(spec.applyTextScaling, true);
        expect(spec.fill, 1.0);
      });

      test('resolves with partial values correctly', () {
        final attribute = IconSpecAttribute.only(
          color: Colors.yellow,
          size: 18.0,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.color, Colors.yellow);
        expect(spec.size, 18.0);
        expect(spec.weight, isNull);
        expect(spec.grade, isNull);
        expect(spec.opticalSize, isNull);
        expect(spec.shadows, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.applyTextScaling, isNull);
        expect(spec.fill, isNull);
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = IconSpecAttribute.only(
          color: Colors.red,
          size: 24.0,
          weight: 400.0,
        );

        final second = IconSpecAttribute.only(
          color: Colors.blue,
          grade: 25.0,
          opticalSize: 48.0,
        );

        final merged = first.merge(second);

        expect(merged.$color, resolvesTo(Colors.blue)); // second overrides
        expect(merged.$size, resolvesTo(24.0)); // from first
        expect(merged.$weight, resolvesTo(400.0)); // from first
        expect(merged.$grade, resolvesTo(25.0)); // from second
        expect(merged.$opticalSize, resolvesTo(48.0)); // from second
      });

      test('merges all properties when both have values', () {
        final first = IconSpecAttribute.only(
          color: Colors.green,
          size: 20.0,
          weight: 300.0,
          grade: -25.0,
        );

        final second = IconSpecAttribute.only(
          color: Colors.purple,
          size: 32.0,
          opticalSize: 32.0,
          textDirection: TextDirection.rtl,
          applyTextScaling: false,
          fill: 0.7,
        );

        final merged = first.merge(second);

        expect(merged.$color, resolvesTo(Colors.purple)); // second overrides
        expect(merged.$size, resolvesTo(32.0)); // second overrides
        expect(merged.$weight, resolvesTo(300.0)); // from first
        expect(merged.$grade, resolvesTo(-25.0)); // from first
        expect(merged.$opticalSize, resolvesTo(32.0)); // from second
        expect(
          merged.$textDirection,
          resolvesTo(TextDirection.rtl),
        ); // from second
        expect(merged.$applyTextScaling, resolvesTo(false)); // from second
        expect(merged.$fill, resolvesTo(0.7)); // from second
      });

      test('modifiers merge correctly', () {
        final opacityModifier = OpacityModifierAttribute(opacity: Prop(0.5));
        final alignModifier = AlignModifierAttribute(
          alignment: Prop(Alignment.center),
        );

        final first = IconSpecAttribute(modifiers: [opacityModifier]);
        final second = IconSpecAttribute(modifiers: [alignModifier]);

        final merged = first.merge(second);

        // Check that the modifiers list matches exactly the expected list
        final expectedModifiers = [
          OpacityModifierAttribute(opacity: Prop(0.5)),
          AlignModifierAttribute(alignment: Prop(Alignment.center)),
        ];

        expect(merged.modifiers, expectedModifiers);
      });
    });

    group('equality', () {
      test('instances with same properties are equal', () {
        final attribute1 = IconSpecAttribute.only(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
        );

        final attribute2 = IconSpecAttribute.only(
          color: Colors.blue,
          size: 24.0,
          weight: 400.0,
        );

        expect(attribute1, equals(attribute2));
      });

      test('instances with different properties are not equal', () {
        final attribute1 = IconSpecAttribute.only(
          color: Colors.blue,
          size: 24.0,
        );

        final attribute2 = IconSpecAttribute.only(
          color: Colors.red,
          size: 24.0,
        );

        expect(attribute1, isNot(equals(attribute2)));
      });
    });
  });
}
