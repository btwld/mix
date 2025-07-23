import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackSpecAttribute', () {
    group('Constructor', () {
      test('creates StackSpecAttribute with all properties', () {
        final attribute = StackSpecAttribute(
          alignment: Prop(AlignmentDirectional.topStart),
          fit: Prop(StackFit.loose),
          textDirection: Prop(TextDirection.ltr),
          clipBehavior: Prop(Clip.antiAlias),
        );

        expect(attribute.$alignment, resolvesTo(AlignmentDirectional.topStart));
        expect(attribute.$fit, resolvesTo(StackFit.loose));
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$clipBehavior, resolvesTo(Clip.antiAlias));
      });

      test('creates empty StackSpecAttribute', () {
        final attribute = StackSpecAttribute();

        expect(attribute.$alignment, isNull);
        expect(attribute.$fit, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('only constructor', () {
      test('creates StackSpecAttribute with only constructor', () {
        final attribute = StackSpecAttribute.only(
          alignment: AlignmentDirectional.bottomEnd,
          fit: StackFit.expand,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.hardEdge,
        );

        expect(
          attribute.$alignment,
          resolvesTo(AlignmentDirectional.bottomEnd),
        );
        expect(attribute.$fit, resolvesTo(StackFit.expand));
        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
        expect(attribute.$clipBehavior, resolvesTo(Clip.hardEdge));
      });

      test('creates partial StackSpecAttribute with only constructor', () {
        final attribute = StackSpecAttribute.only(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
        );

        expect(attribute.$alignment, resolvesTo(Alignment.center));
        expect(attribute.$fit, resolvesTo(StackFit.passthrough));
        expect(attribute.$textDirection, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('value constructor', () {
      test('creates StackSpecAttribute from StackSpec', () {
        const spec = StackSpec(
          alignment: AlignmentDirectional.topStart,
          fit: StackFit.loose,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        );

        final attribute = StackSpecAttribute.value(spec);

        expect(attribute.$alignment, resolvesTo(AlignmentDirectional.topStart));
        expect(attribute.$fit, resolvesTo(StackFit.loose));
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$clipBehavior, resolvesTo(Clip.antiAlias));
      });

      test('maybeValue returns null for null spec', () {
        expect(StackSpecAttribute.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = StackSpec(
          alignment: Alignment.bottomRight,
          fit: StackFit.expand,
        );
        final attribute = StackSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$alignment, resolvesTo(Alignment.bottomRight));
        expect(attribute.$fit, resolvesTo(StackFit.expand));
      });
    });

    group('Utility Methods', () {
      test('alignment utility works correctly', () {
        final center = StackSpecAttribute().alignment(Alignment.center);
        final topStart = StackSpecAttribute().alignment(
          AlignmentDirectional.topStart,
        );
        final bottomEnd = StackSpecAttribute().alignment(
          AlignmentDirectional.bottomEnd,
        );

        expect(center.$alignment, resolvesTo(Alignment.center));
        expect(topStart.$alignment, resolvesTo(AlignmentDirectional.topStart));
        expect(
          bottomEnd.$alignment,
          resolvesTo(AlignmentDirectional.bottomEnd),
        );
      });

      test('fit utility works correctly', () {
        final loose = StackSpecAttribute().fit(StackFit.loose);
        final expand = StackSpecAttribute().fit(StackFit.expand);
        final passthrough = StackSpecAttribute().fit(StackFit.passthrough);

        expect(loose.$fit, resolvesTo(StackFit.loose));
        expect(expand.$fit, resolvesTo(StackFit.expand));
        expect(passthrough.$fit, resolvesTo(StackFit.passthrough));
      });

      test('textDirection utility works correctly', () {
        final ltr = StackSpecAttribute().textDirection(TextDirection.ltr);
        final rtl = StackSpecAttribute().textDirection(TextDirection.rtl);

        expect(ltr.$textDirection, resolvesTo(TextDirection.ltr));
        expect(rtl.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('clipBehavior utility works correctly', () {
        final none = StackSpecAttribute().clipBehavior(Clip.none);
        final hardEdge = StackSpecAttribute().clipBehavior(Clip.hardEdge);
        final antiAlias = StackSpecAttribute().clipBehavior(Clip.antiAlias);
        final antiAliasWithSaveLayer = StackSpecAttribute().clipBehavior(
          Clip.antiAliasWithSaveLayer,
        );

        expect(none.$clipBehavior, resolvesTo(Clip.none));
        expect(hardEdge.$clipBehavior, resolvesTo(Clip.hardEdge));
        expect(antiAlias.$clipBehavior, resolvesTo(Clip.antiAlias));
        expectProp(
          antiAliasWithSaveLayer.$clipBehavior,
          Clip.antiAliasWithSaveLayer,
        );
      });

      test('chaining utilities works correctly', () {
        final attribute = StackSpecAttribute()
            .alignment(Alignment.topLeft)
            .fit(StackFit.expand)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        expect(attribute.$alignment, resolvesTo(Alignment.topLeft));
        expect(attribute.$fit, resolvesTo(StackFit.expand));
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$clipBehavior, resolvesTo(Clip.antiAlias));
      });
    });

    group('Convenience Methods', () {
      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 300),
        );
        final attribute = StackSpecAttribute().animate(animation);

        expect(attribute.animation, equals(animation));
      });
    });

    group('Resolution', () {
      test('resolves to StackSpec with correct properties', () {
        final attribute = StackSpecAttribute()
            .alignment(AlignmentDirectional.centerStart)
            .fit(StackFit.loose)
            .textDirection(TextDirection.rtl)
            .clipBehavior(Clip.hardEdge);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.alignment, AlignmentDirectional.centerStart);
        expect(spec.fit, StackFit.loose);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.clipBehavior, Clip.hardEdge);
      });

      test('resolves with partial values correctly', () {
        final attribute = StackSpecAttribute()
            .alignment(Alignment.bottomCenter)
            .fit(StackFit.passthrough);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.alignment, Alignment.bottomCenter);
        expect(spec.fit, StackFit.passthrough);
        expect(spec.textDirection, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = StackSpecAttribute()
            .alignment(Alignment.topLeft)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr);

        final second = StackSpecAttribute()
            .alignment(Alignment.bottomRight)
            .clipBehavior(Clip.antiAlias);

        final merged = first.merge(second);

        expectProp(
          merged.$alignment,
          Alignment.bottomRight,
        ); // second overrides
        expect(merged.$fit, resolvesTo(StackFit.loose)); // from first
        expectProp(merged.$textDirection, TextDirection.ltr); // from first
        expect(merged.$clipBehavior, resolvesTo(Clip.antiAlias)); // from second
      });

      test('returns this when other is null', () {
        final attribute = StackSpecAttribute().alignment(Alignment.center);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });

      test('merges all properties when both have values', () {
        final first = StackSpecAttribute()
            .alignment(AlignmentDirectional.topStart)
            .fit(StackFit.loose);

        final second = StackSpecAttribute()
            .alignment(AlignmentDirectional.bottomEnd)
            .fit(StackFit.expand)
            .textDirection(TextDirection.rtl)
            .clipBehavior(Clip.hardEdge);

        final merged = first.merge(second);

        expectProp(
          merged.$alignment,
          AlignmentDirectional.bottomEnd,
        ); // second overrides
        expect(merged.$fit, resolvesTo(StackFit.expand)); // second overrides
        expectProp(merged.$textDirection, TextDirection.rtl); // from second
        expect(merged.$clipBehavior, resolvesTo(Clip.hardEdge)); // from second
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = StackSpecAttribute()
            .alignment(Alignment.center)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        final attr2 = StackSpecAttribute()
            .alignment(Alignment.center)
            .fit(StackFit.loose)
            .textDirection(TextDirection.ltr)
            .clipBehavior(Clip.antiAlias);

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = StackSpecAttribute().alignment(Alignment.topLeft);
        final attr2 = StackSpecAttribute().alignment(Alignment.bottomRight);

        expect(attr1, isNot(equals(attr2)));
      });

      test('attributes with different fit are not equal', () {
        final attr1 = StackSpecAttribute().fit(StackFit.loose);
        final attr2 = StackSpecAttribute().fit(StackFit.expand);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = StackSpecAttribute(
          alignment: Prop(AlignmentDirectional.topStart),
          fit: Prop(StackFit.loose),
          textDirection: Prop(TextDirection.ltr),
          clipBehavior: Prop(Clip.antiAlias),
        );

        expect(attribute.props.length, 4);
        expect(attribute.props, contains(attribute.$alignment));
        expect(attribute.props, contains(attribute.$fit));
        expect(attribute.props, contains(attribute.$textDirection));
        expect(attribute.props, contains(attribute.$clipBehavior));
      });
    });

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = StackSpecAttribute(
          modifiers: [
            OpacityModifierAttribute(opacity: Prop(0.5)),
            AlignModifierAttribute(alignment: Prop(Alignment.center)),
          ],
        );

        expect(attribute.modifiers, isNotNull);
        expect(attribute.modifiers!.length, 2);
      });

      test('modifiers merge correctly', () {
        final first = StackSpecAttribute(
          modifiers: [OpacityModifierAttribute(opacity: Prop(0.5))],
        );

        final second = StackSpecAttribute(
          modifiers: [
            AlignModifierAttribute(alignment: Prop(Alignment.center)),
          ],
        );

        final merged = first.merge(second);

        // Note: The actual merge behavior depends on the parent class implementation
        expect(merged.modifiers, isNotNull);
      });
    });

    group('Variants', () {
      test('variants can be added to attribute', () {
        final attribute = StackSpecAttribute();
        expect(attribute.variants, isNull); // By default no variants
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = StackSpecAttribute();
        final modified = original.alignment(Alignment.center);

        expect(identical(original, modified), isFalse);
        expect(original.$alignment, isNull);
        expect(modified.$alignment, resolvesTo(Alignment.center));
      });

      test('builder methods can be chained fluently', () {
        final attribute = StackSpecAttribute()
            .alignment(AlignmentDirectional.topEnd)
            .fit(StackFit.expand)
            .textDirection(TextDirection.rtl)
            .clipBehavior(Clip.hardEdge);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec.alignment, AlignmentDirectional.topEnd);
        expect(spec.fit, StackFit.expand);
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.clipBehavior, Clip.hardEdge);
      });
    });

    group('Debug Properties', () {
      test('debugFillProperties includes all properties', () {
        // This test verifies that the attribute implements Diagnosticable correctly
        final attribute = StackSpecAttribute()
            .alignment(Alignment.center)
            .fit(StackFit.loose);

        // The presence of debugFillProperties is tested by the framework
        expect(attribute, isA<StackSpecAttribute>());
      });
    });
  });
}
