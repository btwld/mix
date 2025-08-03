import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('StackMix', () {
    group('Constructor', () {
      test('creates StackMix with all properties', () {
        final attribute = StackMix(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        );

        expect(attribute.$alignment, resolvesTo(Alignment.center));
        expect(attribute.$fit, resolvesTo(StackFit.expand));
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$clipBehavior, resolvesTo(Clip.antiAlias));
      });

      test('creates empty StackMix', () {
        final attribute = StackMix();

        expect(attribute.$alignment, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('Factory Constructors', () {
      test('alignment factory creates StackMix with alignment', () {
        final stackMix = StackMix.alignment(Alignment.topLeft);

        expect(stackMix.$alignment, resolvesTo(Alignment.topLeft));
      });

      test('fit factory creates StackMix with fit', () {
        final stackMix = StackMix.fit(StackFit.loose);

        expect(stackMix.$fit, resolvesTo(StackFit.loose));
      });

      test('textDirection factory creates StackMix with textDirection', () {
        final stackMix = StackMix.textDirection(TextDirection.rtl);

        expect(stackMix.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('clipBehavior factory creates StackMix with clipBehavior', () {
        final stackMix = StackMix.clipBehavior(Clip.hardEdge);

        expect(stackMix.$clipBehavior, resolvesTo(Clip.hardEdge));
      });

      test('animation factory creates StackMix with animation config', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final stackMix = StackMix.animate(animation);

        expect(stackMix.$animation, animation);
      });

      test('variant factory creates StackMix with variant', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = StackMix.alignment(Alignment.center);
        final stackMix = StackMix.variant(variant, style);

        expect(stackMix.$variants, isNotNull);
        expect(stackMix.$variants!.length, 1);
      });
    });

    group('value constructor', () {
      test('creates StackMix from StackSpec', () {
        const spec = StackSpec(
          alignment: Alignment.bottomRight,
          fit: StackFit.passthrough,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.none,
        );

        final attribute = StackMix.value(spec);

        expect(attribute.$alignment, resolvesTo(Alignment.bottomRight));
        expect(attribute.$fit, resolvesTo(StackFit.passthrough));
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$clipBehavior, resolvesTo(Clip.none));
      });

      test('maybeValue returns null for null spec', () {
        expect(StackMix.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = StackSpec(
          alignment: Alignment.topCenter,
          fit: StackFit.expand,
        );
        final attribute = StackMix.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$alignment, resolvesTo(Alignment.topCenter));
        expect(attribute.$fit, resolvesTo(StackFit.expand));
      });
    });

    group('Utility Methods', () {
      test('alignment utility works correctly', () {
        final attribute = StackMix().alignment(Alignment.bottomLeft);

        expect(attribute.$alignment, resolvesTo(Alignment.bottomLeft));
      });

      test('fit utility works correctly', () {
        final attribute = StackMix().fit(StackFit.expand);

        expect(attribute.$fit, resolvesTo(StackFit.expand));
      });

      test('textDirection utility works correctly', () {
        final attribute = StackMix().textDirection(TextDirection.rtl);

        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('clipBehavior utility works correctly', () {
        final attribute = StackMix().clipBehavior(Clip.antiAliasWithSaveLayer);

        expect(
          attribute.$clipBehavior,
          resolvesTo(Clip.antiAliasWithSaveLayer),
        );
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(Duration(milliseconds: 500));
        final attribute = StackMix().animate(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Variant Methods', () {
      test('variant method adds variant to StackMix', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = StackMix.alignment(Alignment.center);
        final stackMix = StackMix().variant(variant, style);

        expect(stackMix.$variants, isNotNull);
        expect(stackMix.$variants!.length, 1);
      });

      test('variants method sets multiple variants', () {
        final variants = [
          VariantStyle(
            ContextVariant.brightness(Brightness.dark),
            StackMix.alignment(Alignment.topLeft),
          ),
          VariantStyle(
            ContextVariant.brightness(Brightness.light),
            StackMix.alignment(Alignment.bottomRight),
          ),
        ];
        final stackMix = StackMix().variants(variants);

        expect(stackMix.$variants, isNotNull);
        expect(stackMix.$variants!.length, 2);
      });
    });

    group('Resolution', () {
      test('resolves to StackSpec with correct properties', () {
        final attribute = StackMix(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.alignment, Alignment.center);
        expect(spec.fit, StackFit.expand);
        expect(spec.textDirection, TextDirection.ltr);
        expect(spec.clipBehavior, Clip.antiAlias);
      });

      test('resolves with null values correctly', () {
        final attribute = StackMix()
            .alignment(Alignment.topLeft)
            .fit(StackFit.loose);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.alignment, Alignment.topLeft);
        expect(spec.fit, StackFit.loose);
        expect(spec.textDirection, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = StackMix(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
        );

        final second = StackMix(
          alignment: Alignment.bottomRight,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.hardEdge,
        );

        final merged = first.merge(second);

        expect(
          merged.$alignment,
          resolvesTo(Alignment.bottomRight),
        ); // second overrides
        expect(merged.$fit, resolvesTo(StackFit.loose)); // from first
        expect(
          merged.$textDirection,
          resolvesTo(TextDirection.rtl),
        ); // from second
        expect(merged.$clipBehavior, resolvesTo(Clip.hardEdge)); // from second
      });

      test('returns this when other is null', () {
        final attribute = StackMix().alignment(Alignment.center);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = StackMix()
            .alignment(Alignment.center)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        final attr2 = StackMix()
            .alignment(Alignment.center)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        expect(attr1, equals(attr2));
      });

      test('different attributes are not equal', () {
        final attr1 = StackMix().alignment(Alignment.topLeft);
        final attr2 = StackMix().alignment(Alignment.bottomRight);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = StackMix(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        );

        expect(attribute.props.length, 7);
        expect(attribute.props, contains(attribute.$alignment));
        expect(attribute.props, contains(attribute.$fit));
        expect(attribute.props, contains(attribute.$textDirection));
        expect(attribute.props, contains(attribute.$clipBehavior));
      });
    });
  });
}
