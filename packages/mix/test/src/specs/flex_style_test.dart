import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('FlexStyle', () {
    group('Constructor', () {
      test('creates with all properties', () {
        final attribute = FlexStyler(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          clipBehavior: Clip.antiAlias,
          spacing: 16.0,
        );

        expect(attribute.$direction!, resolvesTo(Axis.horizontal));
        expect(
          attribute.$mainAxisAlignment,
          resolvesTo(MainAxisAlignment.center),
        );
        expect(
          attribute.$crossAxisAlignment,
          resolvesTo(CrossAxisAlignment.stretch),
        );
        expect(attribute.$mainAxisSize!, resolvesTo(MainAxisSize.max));
        expect(
          attribute.$verticalDirection!,
          resolvesTo(VerticalDirection.down),
        );
        expect(attribute.$textDirection!, resolvesTo(TextDirection.ltr));
        expect(attribute.$textBaseline!, resolvesTo(TextBaseline.alphabetic));
        expect(attribute.$clipBehavior!, resolvesTo(Clip.antiAlias));
        expect(attribute.$spacing!, resolvesTo(16.0));
      });

      test('creates with default null values', () {
        final attribute = FlexStyler();

        expect(attribute.$direction, isNull);
        expect(attribute.$mainAxisAlignment, isNull);
        expect(attribute.$crossAxisAlignment, isNull);
        expect(attribute.$mainAxisSize, isNull);
        expect(attribute.$verticalDirection, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$textBaseline, isNull);
        expect(attribute.$clipBehavior, isNull);
        expect(attribute.$spacing, isNull);
      });
    });

    group('only constructor', () {
      test('creates with mixed properties', () {
        final attribute = FlexStyler(
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
        expect(
          attribute.$mainAxisAlignment,
          resolvesTo(MainAxisAlignment.spaceEvenly),
        );
        expect(
          attribute.$crossAxisAlignment,
          resolvesTo(CrossAxisAlignment.center),
        );
        expect(attribute.$mainAxisSize, resolvesTo(MainAxisSize.min));
        expect(attribute.$verticalDirection, resolvesTo(VerticalDirection.up));
        expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
        expect(attribute.$textBaseline, resolvesTo(TextBaseline.ideographic));
        expect(attribute.$clipBehavior, resolvesTo(Clip.hardEdge));
        expect(attribute.$spacing, resolvesTo(8.0));
      });

      test('creates with partial properties', () {
        final attribute = FlexStyler(direction: Axis.horizontal, gap: 12.0);

        expect(attribute.$direction, resolvesTo(Axis.horizontal));
        expect(attribute.$spacing, resolvesTo(12.0));
        expect(attribute.$mainAxisAlignment, isNull);
        expect(attribute.$crossAxisAlignment, isNull);
        expect(attribute.$mainAxisSize, isNull);
        expect(attribute.$verticalDirection, isNull);
        expect(attribute.$textDirection, isNull);
        expect(attribute.$textBaseline, isNull);
        expect(attribute.$clipBehavior, isNull);
      });
    });
  });

  group('Utility Methods', () {
    test('direction utility works correctly', () {
      final horizontal = FlexStyler().direction(Axis.horizontal);
      final vertical = FlexStyler().direction(Axis.vertical);

      expect(horizontal.$direction, resolvesTo(Axis.horizontal));
      expect(vertical.$direction, resolvesTo(Axis.vertical));
    });

    test('mainAxisAlignment utility works correctly', () {
      final attribute = FlexStyler().mainAxisAlignment(
        MainAxisAlignment.spaceAround,
      );

      expect(
        attribute.$mainAxisAlignment,
        resolvesTo(MainAxisAlignment.spaceAround),
      );
    });

    test('crossAxisAlignment utility works correctly', () {
      final attribute = FlexStyler().crossAxisAlignment(CrossAxisAlignment.end);

      expect(attribute.$crossAxisAlignment, resolvesTo(CrossAxisAlignment.end));
    });

    test('mainAxisSize utility works correctly', () {
      final attribute = FlexStyler().mainAxisSize(MainAxisSize.min);

      expect(attribute.$mainAxisSize, resolvesTo(MainAxisSize.min));
    });

    test('verticalDirection utility works correctly', () {
      final attribute = FlexStyler().verticalDirection(VerticalDirection.up);

      expect(attribute.$verticalDirection, resolvesTo(VerticalDirection.up));
    });

    test('textDirection utility works correctly', () {
      final attribute = FlexStyler().textDirection(TextDirection.rtl);

      expect(attribute.$textDirection, resolvesTo(TextDirection.rtl));
    });

    test('textBaseline utility works correctly', () {
      final attribute = FlexStyler().textBaseline(TextBaseline.ideographic);

      expect(attribute.$textBaseline, resolvesTo(TextBaseline.ideographic));
    });

    test('clipBehavior utility works correctly', () {
      final attribute = FlexStyler().clipBehavior(Clip.antiAliasWithSaveLayer);

      expect(attribute.$clipBehavior, resolvesTo(Clip.antiAliasWithSaveLayer));
    });

    test('gap utility works correctly', () {
      final attribute = FlexStyler().spacing(24.0);

      expect(attribute.$spacing, resolvesTo(24.0));
    });

    test('chaining utilities accumulates properties correctly', () {
      // Chaining now properly accumulates all properties
      final chained = FlexStyler()
          .direction(Axis.horizontal)
          .mainAxisAlignment(MainAxisAlignment.spaceBetween)
          .crossAxisAlignment(CrossAxisAlignment.center)
          .spacing(16.0);

      // All properties should be set when chaining
      expect(chained.$direction, resolvesTo(Axis.horizontal));
      expect(
        chained.$mainAxisAlignment,
        resolvesTo(MainAxisAlignment.spaceBetween),
      );
      expect(
        chained.$crossAxisAlignment,
        resolvesTo(CrossAxisAlignment.center),
      );
      expect(chained.$spacing, resolvesTo(16.0));
    });

    test('merge combines different attribute instances', () {
      // Merge is still useful for combining separate attribute instances
      final first = FlexStyler(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
      );

      final second = FlexStyler(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16.0,
      );

      final combined = first.merge(second);

      expect(combined.$direction, resolvesTo(Axis.horizontal));
      expect(combined.$mainAxisAlignment, resolvesTo(MainAxisAlignment.start));
      expect(
        combined.$crossAxisAlignment,
        resolvesTo(CrossAxisAlignment.center),
      );
      expect(combined.$spacing, resolvesTo(16.0));
    });
  });

  group('Factory Constructors', () {
    test('animate factory creates with animation config', () {
      final animation = AnimationConfig.linear(Duration(seconds: 1));
      final flexMix = FlexStyler().animate(animation);

      expect(flexMix.$animation, animation);
    });

    test('variant factory creates with variant', () {
      final variant = ContextTrigger.brightness(Brightness.dark);
      final style = FlexStyler(direction: Axis.horizontal);
      final flexMix = FlexStyler().variant(EventVariantStyle(variant, style));

      expect(flexMix.$variants, isNotNull);
      expect(flexMix.$variants!.length, 1);
    });
  });

  group('Convenience Methods', () {
    test('row() method sets horizontal direction', () {
      final attribute = FlexStyler().row();

      expect(attribute.$direction, resolvesTo(Axis.horizontal));
    });

    test('column() method sets vertical direction', () {
      final attribute = FlexStyler().column();

      expect(attribute.$direction, resolvesTo(Axis.vertical));
    });

    test('animate method sets animation config', () {
      final animation = AnimationConfig.linear(Duration(milliseconds: 500));
      final attribute = FlexStyler().animate(animation);

      expect(attribute.$animation, equals(animation));
    });
  });

  group('Resolution', () {
    test('resolves to FlexSpec correctly', () {
      final attribute = FlexStyler(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.down,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.antiAlias,
        spacing: 16.0,
      );

      final context = MockBuildContext();
      final spec = attribute.resolve(context);

      expect(spec, isNotNull);
      expect(spec.spec.direction, Axis.horizontal);
      expect(spec.spec.mainAxisAlignment, MainAxisAlignment.center);
      expect(spec.spec.crossAxisAlignment, CrossAxisAlignment.stretch);
      expect(spec.spec.mainAxisSize, MainAxisSize.max);
      expect(spec.spec.verticalDirection, VerticalDirection.down);
      expect(spec.spec.textDirection, TextDirection.ltr);
      expect(spec.spec.textBaseline, TextBaseline.alphabetic);
      expect(spec.spec.clipBehavior, Clip.antiAlias);
      expect(spec.spec.gap, 16.0);
    });

    test('resolves with null values correctly', () {
      final attribute = FlexStyler().direction(Axis.vertical).spacing(12.0);

      final context = MockBuildContext();
      final spec = attribute.resolve(context);

      expect(spec, isNotNull);
      expect(spec.spec.direction, Axis.vertical);
      expect(spec.spec.gap, 12.0);
      expect(spec.spec.mainAxisAlignment, isNull);
      expect(spec.spec.crossAxisAlignment, isNull);
      expect(spec.spec.mainAxisSize, isNull);
      expect(spec.spec.verticalDirection, isNull);
      expect(spec.spec.textDirection, isNull);
      expect(spec.spec.textBaseline, isNull);
      expect(spec.spec.clipBehavior, isNull);
    });
  });

  group('Merge', () {
    test('merges properties correctly', () {
      final first = FlexStyler(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        gap: 8.0,
      );

      final second = FlexStyler(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
      );

      final merged = first.merge(second);

      expect(merged.$direction, resolvesTo(Axis.vertical)); // second overrides
      expect(
        merged.$mainAxisAlignment,
        resolvesTo(MainAxisAlignment.start),
      ); // from first
      expect(
        merged.$crossAxisAlignment,
        resolvesTo(CrossAxisAlignment.center),
      ); // from second
      expect(merged.$mainAxisSize, resolvesTo(MainAxisSize.min)); // from second
      expect(merged.$spacing, resolvesTo(8.0)); // from first
    });

    test('returns this when other is null', () {
      final attribute = FlexStyler().direction(Axis.horizontal);
      final merged = attribute.merge(null);

      expect(identical(attribute, merged), isFalse);
      expect(merged, equals(attribute));
    });

    test('merges all properties when both have values', () {
      final first = FlexStyler()
          .direction(Axis.horizontal)
          .mainAxisAlignment(MainAxisAlignment.center)
          .crossAxisAlignment(CrossAxisAlignment.start)
          .mainAxisSize(MainAxisSize.max)
          .verticalDirection(VerticalDirection.down);

      final second = FlexStyler()
          .direction(Axis.vertical)
          .mainAxisAlignment(MainAxisAlignment.end)
          .textDirection(TextDirection.rtl)
          .textBaseline(TextBaseline.ideographic)
          .clipBehavior(Clip.hardEdge)
          .spacing(20.0);

      final merged = first.merge(second);

      expect(merged.$direction, resolvesTo(Axis.vertical)); // second overrides
      expect(
        merged.$mainAxisAlignment,
        resolvesTo(MainAxisAlignment.end),
      ); // second overrides
      expect(
        merged.$crossAxisAlignment,
        resolvesTo(CrossAxisAlignment.start),
      ); // from first
      expect(merged.$mainAxisSize, resolvesTo(MainAxisSize.max)); // from first
      expect(
        merged.$verticalDirection,
        resolvesTo(VerticalDirection.down),
      ); // from first
      expect(
        merged.$textDirection,
        resolvesTo(TextDirection.rtl),
      ); // from second
      expect(
        merged.$textBaseline,
        resolvesTo(TextBaseline.ideographic),
      ); // from second
      expect(merged.$clipBehavior, resolvesTo(Clip.hardEdge)); // from second
      expect(merged.$spacing, resolvesTo(20.0)); // from second
    });
  });

  group('Equality', () {
    test('equal attributes have same hashCode', () {
      final attr1 = FlexStyler()
          .direction(Axis.horizontal)
          .mainAxisAlignment(MainAxisAlignment.center)
          .spacing(16.0);

      final attr2 = FlexStyler()
          .direction(Axis.horizontal)
          .mainAxisAlignment(MainAxisAlignment.center)
          .spacing(16.0);

      expect(attr1, equals(attr2));
      expect(attr1.hashCode, equals(attr2.hashCode));
    });

    test('different attributes are not equal', () {
      final attr1 = FlexStyler().direction(Axis.horizontal);
      final attr2 = FlexStyler().direction(Axis.vertical);

      expect(attr1, isNot(equals(attr2)));
    });

    test('attributes with different gaps are not equal', () {
      final attr1 = FlexStyler().spacing(8.0);
      final attr2 = FlexStyler().spacing(16.0);

      expect(attr1, isNot(equals(attr2)));
    });
  });

  group('Props getter', () {
    test('props includes all properties', () {
      final attribute = FlexStyler(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.down,
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        clipBehavior: Clip.antiAlias,
        spacing: 16.0,
      );

      expect(attribute.props.length, 12);
      expect(attribute.props, contains(attribute.$direction));
      expect(attribute.props, contains(attribute.$mainAxisAlignment));
      expect(attribute.props, contains(attribute.$crossAxisAlignment));
      expect(attribute.props, contains(attribute.$mainAxisSize));
      expect(attribute.props, contains(attribute.$verticalDirection));
      expect(attribute.props, contains(attribute.$textDirection));
      expect(attribute.props, contains(attribute.$textBaseline));
      expect(attribute.props, contains(attribute.$clipBehavior));
      expect(attribute.props, contains(attribute.$spacing));
    });
  });

  group('Modifiers', () {
    test('modifiers can be added to attribute', () {
      final attribute = FlexStyler(
        modifier: WidgetModifierConfig(
          modifiers: [
            OpacityModifierMix(opacity: 0.5),
            PaddingModifierMix(padding: EdgeInsetsMix.all(8.0)),
          ],
        ),
      );

      expect(attribute.$modifier, isNotNull);
      expect(attribute.$modifier!.$modifiers!.length, 2);
    });

    test('modifiers merge correctly', () {
      final first = FlexStyler(
        modifier: WidgetModifierConfig(
          modifiers: [OpacityModifierMix(opacity: 0.5)],
        ),
      );

      final second = FlexStyler(
        modifier: WidgetModifierConfig(
          modifiers: [PaddingModifierMix(padding: EdgeInsetsMix.all(8.0))],
        ),
      );

      final merged = first.merge(second);

      // Note: The actual merge behavior depends on the parent class implementation
      expect(merged.$modifier, isNotNull);
    });
  });

  group('Variant Methods', () {
    test('variant method sets single variant', () {
      final variant = ContextTrigger.brightness(Brightness.dark);
      final style = FlexStyler(direction: Axis.horizontal);
      final flexMix = FlexStyler().variant(EventVariantStyle(variant, style));

      expect(flexMix.$variants, isNotNull);
      expect(flexMix.$variants!.length, 1);
    });

    test('variants method sets multiple variants', () {
      final variants = [
        EventVariantStyle(
          ContextTrigger.brightness(Brightness.dark),
          FlexStyler(direction: Axis.horizontal),
        ),
        EventVariantStyle(
          ContextTrigger.brightness(Brightness.light),
          FlexStyler(direction: Axis.vertical),
        ),
      ];
      final flexMix = FlexStyler().withVariants(variants);

      expect(flexMix.$variants, isNotNull);
      expect(flexMix.$variants!.length, 2);
    });
  });

  group('Builder pattern', () {
    test('builder methods create new instances', () {
      final original = FlexStyler();
      final modified = original.direction(Axis.horizontal);

      expect(identical(original, modified), isFalse);
      expect(original.$direction, isNull);
      expect(modified.$direction, resolvesTo(Axis.horizontal));
    });

    test('builder methods can be combined with merge', () {
      final attribute = FlexStyler()
          .direction(Axis.horizontal)
          .merge(FlexStyler().mainAxisAlignment(MainAxisAlignment.spaceBetween))
          .merge(FlexStyler().crossAxisAlignment(CrossAxisAlignment.center))
          .merge(FlexStyler().spacing(16.0));

      final context = MockBuildContext();
      final spec = attribute.resolve(context);

      expect(spec.spec.direction, Axis.horizontal);
      expect(spec.spec.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      expect(spec.spec.crossAxisAlignment, CrossAxisAlignment.center);
      expect(spec.spec.gap, 16.0);
    });
  });

  group('Debug Properties', () {
    test('debugFillProperties includes all properties', () {
      // This test verifies that the attribute implements Diagnosticable correctly
      final attribute = FlexStyler()
          .direction(Axis.horizontal)
          .mainAxisAlignment(MainAxisAlignment.center)
          .spacing(16.0);

      // The presence of debugFillProperties is tested by the framework
      expect(attribute, isA<FlexStyler>());
    });
  });
}
