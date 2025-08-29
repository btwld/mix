import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('StackStyle', () {
    group('Constructor', () {
      test('', () {
        final attribute = StackStyler(
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

      test('', () {
        final attribute = StackStyler();

        expect(attribute.$alignment, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('Factory Constructors', () {
      test('', () {
        final stackMix = StackStyler().alignment(Alignment.topLeft);

        expect(stackMix.$alignment, resolvesTo(Alignment.topLeft));
      });

      test('', () {
        final stackMix = StackStyler().fit(StackFit.loose);

        expect(stackMix.$fit, resolvesTo(StackFit.loose));
      });

      test('', () {
        final stackMix = StackStyler().textDirection(TextDirection.rtl);

        expect(stackMix.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('', () {
        final stackMix = StackStyler().clipBehavior(Clip.hardEdge);

        expect(stackMix.$clipBehavior, resolvesTo(Clip.hardEdge));
      });

      test('', () {
        final animation = AnimationConfig.linear(Duration(seconds: 1));
        final stackMix = StackStyler().animate(animation);

        expect(stackMix.$animation, animation);
      });

      test('', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = StackStyler().alignment(Alignment.center);
        final stackMix = StackStyler().variant(variant, style);

        expect(stackMix.$variants, isNotNull);
        expect(stackMix.$variants!.length, 1);
      });
    });

    group('Utility Methods', () {
      test('alignment utility works correctly', () {
        final attribute = StackStyler().alignment(Alignment.bottomLeft);

        expect(attribute.$alignment, resolvesTo(Alignment.bottomLeft));
      });

      test('fit utility works correctly', () {
        final attribute = StackStyler().fit(StackFit.expand);

        expect(attribute.$fit, resolvesTo(StackFit.expand));
      });

      test('textDirection utility works correctly', () {
        final attribute = StackStyler().textDirection(TextDirection.rtl);

        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('clipBehavior utility works correctly', () {
        final attribute = StackStyler().clipBehavior(
          Clip.antiAliasWithSaveLayer,
        );

        expect(
          attribute.$clipBehavior,
          resolvesTo(Clip.antiAliasWithSaveLayer),
        );
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(Duration(milliseconds: 500));
        final attribute = StackStyler().animate(animation);

        expect(attribute.$animation, equals(animation));
      });
    });

    group('Variant Methods', () {
      test('', () {
        final variant = ContextVariant.brightness(Brightness.dark);
        final style = StackStyler().alignment(Alignment.center);
        final stackMix = StackStyler().variant(variant, style);

        expect(stackMix.$variants, isNotNull);
        expect(stackMix.$variants!.length, 1);
      });

      test('variants method sets multiple variants', () {
        final variants = [
          VariantStyle(
            ContextVariant.brightness(Brightness.dark),
            StackStyler().alignment(Alignment.topLeft),
          ),
          VariantStyle(
            ContextVariant.brightness(Brightness.light),
            StackStyler().alignment(Alignment.bottomRight),
          ),
        ];
        final stackMix = StackStyler().variants(variants);

        expect(stackMix.$variants, isNotNull);
        expect(stackMix.$variants!.length, 2);
      });
    });

    group('Resolution', () {
      test('', () {
        final attribute = StackStyler(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        );

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.spec.alignment, Alignment.center);
        expect(spec.spec.fit, StackFit.expand);
        expect(spec.spec.textDirection, TextDirection.ltr);
        expect(spec.spec.clipBehavior, Clip.antiAlias);
      });

      test('resolves with null values correctly', () {
        final attribute = StackStyler()
            .alignment(Alignment.topLeft)
            .fit(StackFit.loose);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.spec.alignment, Alignment.topLeft);
        expect(spec.spec.fit, StackFit.loose);
        expect(spec.spec.textDirection, isNull);
        expect(spec.spec.clipBehavior, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = StackStyler(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
        );

        final second = StackStyler(
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
        final attribute = StackStyler().alignment(Alignment.center);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = StackStyler()
            .alignment(Alignment.center)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        final attr2 = StackStyler()
            .alignment(Alignment.center)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        expect(attr1, equals(attr2));
      });

      test('different attributes are not equal', () {
        final attr1 = StackStyler().alignment(Alignment.topLeft);
        final attr2 = StackStyler().alignment(Alignment.bottomRight);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = StackStyler(
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
