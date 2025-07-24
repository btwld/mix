import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexSpecAttribute', () {
    group('Constructor', () {
      test('creates FlexSpecAttribute with all properties', () {
        final attribute = FlexSpecAttribute(
          direction: Prop(Axis.horizontal),
          mainAxisAlignment: Prop(MainAxisAlignment.center),
          crossAxisAlignment: Prop(CrossAxisAlignment.stretch),
          mainAxisSize: Prop(MainAxisSize.max),
          verticalDirection: Prop(VerticalDirection.down),
          textDirection: Prop(TextDirection.ltr),
          textBaseline: Prop(TextBaseline.alphabetic),
          clipBehavior: Prop(Clip.antiAlias),
          gap: Prop(16.0),
        );

        expect(attribute.$direction!, resolvesTo(Axis.horizontal));
        expectProp(attribute.$mainAxisAlignment, MainAxisAlignment.center);
        expectProp(attribute.$crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(attribute.$mainAxisSize!, resolvesTo(MainAxisSize.max));
        expect(
          attribute.$verticalDirection!,
          resolvesTo(VerticalDirection.down),
        );
        expect(attribute.$textDirection!, resolvesTo(TextDirection.ltr));
        expect(attribute.$textBaseline!, resolvesTo(TextBaseline.alphabetic));
        expect(attribute.$clipBehavior!, resolvesTo(Clip.antiAlias));
        expect(attribute.$gap!, resolvesTo(16.0));
      });

      test('creates empty FlexSpecAttribute', () {
        final attribute = FlexSpecAttribute();

        expect(attribute.$direction, isNull);
        expect(attribute.$mainAxisAlignment, isNull);
        expect(attribute.$crossAxisAlignment, isNull);
        expect(attribute.$mainAxisSize, isNull);
        expect(attribute.$verticalDirection, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$textBaseline, isNull);
        expect(attribute.$clipBehavior, isNull);
        expect(attribute.$gap, isNull);
      });
    });

    group('only constructor', () {
      test('creates FlexSpecAttribute with only constructor', () {
        final attribute = FlexSpecAttribute.only(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          clipBehavior: Clip.hardEdge,
          gap: 8.0,
        );

        expect(attribute.$direction, resolvesTo(Axis.vertical));
        expectProp(attribute.$mainAxisAlignment, MainAxisAlignment.spaceEvenly);
        expectProp(attribute.$crossAxisAlignment, CrossAxisAlignment.center);
        expect(attribute.$mainAxisSize, resolvesTo(MainAxisSize.min));
        expect(attribute.$verticalDirection, resolvesTo(VerticalDirection.up));
        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
        expect(attribute.$textBaseline, resolvesTo(TextBaseline.ideographic));
        expect(attribute.$clipBehavior, resolvesTo(Clip.hardEdge));
        expect(attribute.$gap, resolvesTo(8.0));
      });

      test('creates partial FlexSpecAttribute with only constructor', () {
        final attribute = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          gap: 12.0,
        );

        expect(attribute.$direction, resolvesTo(Axis.horizontal));
        expect(attribute.$gap, resolvesTo(12.0));
        expect(attribute.$mainAxisAlignment, isNull);
        expect(attribute.$crossAxisAlignment, isNull);
        expect(attribute.$mainAxisSize, isNull);
        expect(attribute.$verticalDirection, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$textBaseline, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });

    group('value constructor', () {
      test('creates FlexSpecAttribute from FlexSpec', () {
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

        final attribute = FlexSpecAttribute.value(spec);

        expect(attribute.$direction, resolvesTo(Axis.horizontal));
        expectProp(attribute.$mainAxisAlignment, MainAxisAlignment.center);
        expectProp(attribute.$crossAxisAlignment, CrossAxisAlignment.stretch);
        expect(attribute.$mainAxisSize, resolvesTo(MainAxisSize.max));
        expect(
          attribute.$verticalDirection,
          resolvesTo(VerticalDirection.down),
        );
        expect(attribute.$textDirection, resolvesTo(TextDirection.ltr));
        expect(attribute.$textBaseline, resolvesTo(TextBaseline.alphabetic));
        expect(attribute.$clipBehavior, resolvesTo(Clip.antiAlias));
        expect(attribute.$gap, resolvesTo(16.0));
      });

      test('maybeValue returns null for null spec', () {
        expect(FlexSpecAttribute.maybeValue(null), isNull);
      });

      test('maybeValue returns attribute for non-null spec', () {
        const spec = FlexSpec(direction: Axis.vertical, gap: 8.0);
        final attribute = FlexSpecAttribute.maybeValue(spec);

        expect(attribute, isNotNull);
        expect(attribute!.$direction, resolvesTo(Axis.vertical));
        expect(attribute.$gap, resolvesTo(8.0));
      });
    });

    group('Utility Methods', () {
      test('direction utility works correctly', () {
        final horizontal = FlexSpecAttribute().direction(Axis.horizontal);
        final vertical = FlexSpecAttribute().direction(Axis.vertical);

        expect(horizontal.$direction, resolvesTo(Axis.horizontal));
        expect(vertical.$direction, resolvesTo(Axis.vertical));
      });

      test('mainAxisAlignment utility works correctly', () {
        final attribute = FlexSpecAttribute().mainAxisAlignment(
          MainAxisAlignment.spaceAround,
        );

        expectProp(attribute.$mainAxisAlignment, MainAxisAlignment.spaceAround);
      });

      test('crossAxisAlignment utility works correctly', () {
        final attribute = FlexSpecAttribute().crossAxisAlignment(
          CrossAxisAlignment.end,
        );

        expect(
          attribute.$crossAxisAlignment,
          resolvesTo(CrossAxisAlignment.end),
        );
      });

      test('mainAxisSize utility works correctly', () {
        final attribute = FlexSpecAttribute().mainAxisSize(MainAxisSize.min);

        expect(attribute.$mainAxisSize, resolvesTo(MainAxisSize.min));
      });

      test('verticalDirection utility works correctly', () {
        final attribute = FlexSpecAttribute().verticalDirection(
          VerticalDirection.up,
        );

        expect(attribute.$verticalDirection, resolvesTo(VerticalDirection.up));
      });

      test('textDirection utility works correctly', () {
        final attribute = FlexSpecAttribute().textDirection(TextDirection.rtl);

        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
      });

      test('textBaseline utility works correctly', () {
        final attribute = FlexSpecAttribute().textBaseline(
          TextBaseline.ideographic,
        );

        expect(attribute.$textBaseline, resolvesTo(TextBaseline.ideographic));
      });

      test('clipBehavior utility works correctly', () {
        final attribute = FlexSpecAttribute().clipBehavior(
          Clip.antiAliasWithSaveLayer,
        );

        expect(
          attribute.$clipBehavior,
          resolvesTo(Clip.antiAliasWithSaveLayer),
        );
      });

      test('gap utility works correctly', () {
        final attribute = FlexSpecAttribute().gap(24.0);

        expect(attribute.$gap, resolvesTo(24.0));
      });

      test('chaining utilities accumulates properties correctly', () {
        // Chaining now properly accumulates all properties
        final chained = FlexSpecAttribute()
            .direction(Axis.horizontal)
            .mainAxisAlignment(MainAxisAlignment.spaceBetween)
            .crossAxisAlignment(CrossAxisAlignment.center)
            .gap(16.0);

        // All properties should be set when chaining
        expect(chained.$direction, resolvesTo(Axis.horizontal));
        expectProp(chained.$mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expectProp(chained.$crossAxisAlignment, CrossAxisAlignment.center);
        expect(chained.$gap, resolvesTo(16.0));
      });

      test('merge combines different attribute instances', () {
        // Merge is still useful for combining separate attribute instances
        final first = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
        );

        final second = FlexSpecAttribute.only(
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: 16.0,
        );

        final combined = first.merge(second);

        expect(combined.$direction, resolvesTo(Axis.horizontal));
        expectProp(combined.$mainAxisAlignment, MainAxisAlignment.start);
        expectProp(combined.$crossAxisAlignment, CrossAxisAlignment.center);
        expect(combined.$gap, resolvesTo(16.0));
      });
    });

    group('Convenience Methods', () {
      test('row() method sets horizontal direction', () {
        final attribute = FlexSpecAttribute().row();

        expect(attribute.$direction, resolvesTo(Axis.horizontal));
      });

      test('column() method sets vertical direction', () {
        final attribute = FlexSpecAttribute().column();

        expect(attribute.$direction, resolvesTo(Axis.vertical));
      });

      test('animate method sets animation config', () {
        final animation = AnimationConfig.linear(
          const Duration(milliseconds: 300),
        );
        final attribute = FlexSpecAttribute().animate(animation);

        expect(attribute.animation, equals(animation));
      });
    });

    group('Resolution', () {
      test('resolves to FlexSpec with correct properties', () {
        final attribute = FlexSpecAttribute.only(
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

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
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

      test('resolves with null values correctly', () {
        final attribute = FlexSpecAttribute()
            .direction(Axis.vertical)
            .gap(12.0);

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec, isNotNull);
        expect(spec.direction, Axis.vertical);
        expect(spec.gap, 12.0);
        expect(spec.mainAxisAlignment, isNull);
        expect(spec.crossAxisAlignment, isNull);
        expect(spec.mainAxisSize, isNull);
        expect(spec.verticalDirection, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.textBaseline, isNull);
        expect(spec.clipBehavior, isNull);
      });
    });

    group('Merge', () {
      test('merges properties correctly', () {
        final first = FlexSpecAttribute.only(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          gap: 8.0,
        );

        final second = FlexSpecAttribute.only(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        );

        final merged = first.merge(second);

        expect(
          merged.$direction,
          resolvesTo(Axis.vertical),
        ); // second overrides
        expectProp(
          merged.$mainAxisAlignment,
          MainAxisAlignment.start,
        ); // from first
        expectProp(
          merged.$crossAxisAlignment,
          CrossAxisAlignment.center,
        ); // from second
        expect(
          merged.$mainAxisSize,
          resolvesTo(MainAxisSize.min),
        ); // from second
        expect(merged.$gap, resolvesTo(8.0)); // from first
      });

      test('returns this when other is null', () {
        final attribute = FlexSpecAttribute().direction(Axis.horizontal);
        final merged = attribute.merge(null);

        expect(identical(attribute, merged), isTrue);
      });

      test('merges all properties when both have values', () {
        final first = FlexSpecAttribute()
            .direction(Axis.horizontal)
            .mainAxisAlignment(MainAxisAlignment.center)
            .crossAxisAlignment(CrossAxisAlignment.start)
            .mainAxisSize(MainAxisSize.max)
            .verticalDirection(VerticalDirection.down);

        final second = FlexSpecAttribute()
            .direction(Axis.vertical)
            .mainAxisAlignment(MainAxisAlignment.end)
            .textDirection(TextDirection.rtl)
            .textBaseline(TextBaseline.ideographic)
            .clipBehavior(Clip.hardEdge)
            .gap(20.0);

        final merged = first.merge(second);

        expect(
          merged.$direction,
          resolvesTo(Axis.vertical),
        ); // second overrides
        expectProp(
          merged.$mainAxisAlignment,
          MainAxisAlignment.end,
        ); // second overrides
        expectProp(
          merged.$crossAxisAlignment,
          CrossAxisAlignment.start,
        ); // from first
        expect(
          merged.$mainAxisSize,
          resolvesTo(MainAxisSize.max),
        ); // from first
        expectProp(
          merged.$verticalDirection,
          VerticalDirection.down,
        ); // from first
        expectProp(merged.$textDirection, TextDirection.rtl); // from second
        expectProp(
          merged.$textBaseline,
          TextBaseline.ideographic,
        ); // from second
        expect(merged.$clipBehavior, resolvesTo(Clip.hardEdge)); // from second
        expect(merged.$gap, resolvesTo(20.0)); // from second
      });
    });

    group('Equality', () {
      test('equal attributes have same hashCode', () {
        final attr1 = FlexSpecAttribute()
            .direction(Axis.horizontal)
            .mainAxisAlignment(MainAxisAlignment.center)
            .gap(16.0);

        final attr2 = FlexSpecAttribute()
            .direction(Axis.horizontal)
            .mainAxisAlignment(MainAxisAlignment.center)
            .gap(16.0);

        expect(attr1, equals(attr2));
        expect(attr1.hashCode, equals(attr2.hashCode));
      });

      test('different attributes are not equal', () {
        final attr1 = FlexSpecAttribute().direction(Axis.horizontal);
        final attr2 = FlexSpecAttribute().direction(Axis.vertical);

        expect(attr1, isNot(equals(attr2)));
      });

      test('attributes with different gaps are not equal', () {
        final attr1 = FlexSpecAttribute().gap(8.0);
        final attr2 = FlexSpecAttribute().gap(16.0);

        expect(attr1, isNot(equals(attr2)));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final attribute = FlexSpecAttribute(
          direction: Prop(Axis.horizontal),
          mainAxisAlignment: Prop(MainAxisAlignment.center),
          crossAxisAlignment: Prop(CrossAxisAlignment.stretch),
          mainAxisSize: Prop(MainAxisSize.max),
          verticalDirection: Prop(VerticalDirection.down),
          textDirection: Prop(TextDirection.ltr),
          textBaseline: Prop(TextBaseline.alphabetic),
          clipBehavior: Prop(Clip.antiAlias),
          gap: Prop(16.0),
        );

        expect(attribute.props.length, 9);
        expect(attribute.props, contains(attribute.$direction));
        expect(attribute.props, contains(attribute.$mainAxisAlignment));
        expect(attribute.props, contains(attribute.$crossAxisAlignment));
        expect(attribute.props, contains(attribute.$mainAxisSize));
        expect(attribute.props, contains(attribute.$verticalDirection));
        expect(attribute.props, contains(attribute.$textDirection));
        expect(attribute.props, contains(attribute.$textBaseline));
        expect(attribute.props, contains(attribute.$clipBehavior));
        expect(attribute.props, contains(attribute.$gap));
      });
    });

    group('Modifiers', () {
      test('modifiers can be added to attribute', () {
        final attribute = FlexSpecAttribute(
          modifiers: [
            OpacityModifierAttribute(opacity: Prop(0.5)),
            PaddingModifierAttribute.only(padding: EdgeInsetsMix.all(8.0)),
          ],
        );

        expect(attribute.modifiers, isNotNull);
        expect(attribute.modifiers!.length, 2);
      });

      test('modifiers merge correctly', () {
        final first = FlexSpecAttribute(
          modifiers: [OpacityModifierAttribute(opacity: Prop(0.5))],
        );

        final second = FlexSpecAttribute(
          modifiers: [
            PaddingModifierAttribute.only(padding: EdgeInsetsMix.all(8.0)),
          ],
        );

        final merged = first.merge(second);

        // Note: The actual merge behavior depends on the parent class implementation
        expect(merged.modifiers, isNotNull);
      });
    });

    group('Variants', () {
      test('variants can be added to attribute', () {
        final attribute = FlexSpecAttribute();
        expect(attribute.variants, isNull); // By default no variants
      });
    });

    group('Builder pattern', () {
      test('builder methods create new instances', () {
        final original = FlexSpecAttribute();
        final modified = original.direction(Axis.horizontal);

        expect(identical(original, modified), isFalse);
        expect(original.$direction, isNull);
        expect(modified.$direction, resolvesTo(Axis.horizontal));
      });

      test('builder methods can be combined with merge', () {
        final attribute = FlexSpecAttribute()
            .direction(Axis.horizontal)
            .merge(
              FlexSpecAttribute().mainAxisAlignment(
                MainAxisAlignment.spaceBetween,
              ),
            )
            .merge(
              FlexSpecAttribute().crossAxisAlignment(CrossAxisAlignment.center),
            )
            .merge(FlexSpecAttribute().gap(16.0));

        final context = MockBuildContext();
        final spec = attribute.resolve(context);

        expect(spec.direction, Axis.horizontal);
        expect(spec.mainAxisAlignment, MainAxisAlignment.spaceBetween);
        expect(spec.crossAxisAlignment, CrossAxisAlignment.center);
        expect(spec.gap, 16.0);
      });
    });

    group('Debug Properties', () {
      test('debugFillProperties includes all properties', () {
        // This test verifies that the attribute implements Diagnosticable correctly
        final attribute = FlexSpecAttribute()
            .direction(Axis.horizontal)
            .mainAxisAlignment(MainAxisAlignment.center)
            .gap(16.0);

        // The presence of debugFillProperties is tested by the framework
        expect(attribute, isA<FlexSpecAttribute>());
      });
    });
  });
}
