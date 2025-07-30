import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexMix', () {
    group('Constructors', () {
      test('default constructor creates FlexMix with null properties', () {
        final flexMix = FlexMix();

        expect(flexMix.$direction, isNull);
        expect(flexMix.$mainAxisAlignment, isNull);
        expect(flexMix.$crossAxisAlignment, isNull);
        expect(flexMix.$mainAxisSize, isNull);
        expect(flexMix.$verticalDirection, isNull);
        expect(flexMix.$textDirection, isNull);
        expect(flexMix.$textBaseline, isNull);
        expect(flexMix.$clipBehavior, isNull);
        expect(flexMix.$gap, isNull);
      });

      test(
        'constructor with parameters creates FlexMix with correct properties',
        () {
          final flexMix = FlexMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.up,
            textDirection: TextDirection.rtl,
            textBaseline: TextBaseline.ideographic,
            clipBehavior: Clip.antiAlias,
            gap: 16.0,
          );

          expectProp(flexMix.$direction, Axis.horizontal);
          expectProp(flexMix.$mainAxisAlignment, MainAxisAlignment.center);
          expectProp(flexMix.$crossAxisAlignment, CrossAxisAlignment.start);
          expectProp(flexMix.$mainAxisSize, MainAxisSize.min);
          expectProp(flexMix.$verticalDirection, VerticalDirection.up);
          expectProp(flexMix.$textDirection, TextDirection.rtl);
          expectProp(flexMix.$textBaseline, TextBaseline.ideographic);
          expectProp(flexMix.$clipBehavior, Clip.antiAlias);
          expectProp(flexMix.$gap, 16.0);
        },
      );

      test('value constructor creates FlexMix from FlexSpec', () {
        const spec = FlexSpec(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          gap: 8.0,
        );

        final flexMix = FlexMix.value(spec);

        expectProp(flexMix.$direction, Axis.vertical);
        expectProp(flexMix.$mainAxisAlignment, MainAxisAlignment.end);
        expectProp(flexMix.$gap, 8.0);
      });

      test('maybeValue returns null for null input', () {
        final result = FlexMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns FlexMix for non-null input', () {
        const spec = FlexSpec(direction: Axis.horizontal);
        final result = FlexMix.maybeValue(spec);

        expect(result, isNotNull);
        expectProp(result!.$direction, Axis.horizontal);
      });
    });

    group('Factory constructors', () {
      test('direction factory creates correct FlexMix', () {
        final flexMix = FlexMix.direction(Axis.vertical);
        expectProp(flexMix.$direction, Axis.vertical);
      });

      test('mainAxisAlignment factory creates correct FlexMix', () {
        final flexMix = FlexMix.mainAxisAlignment(
          MainAxisAlignment.spaceEvenly,
        );
        expectProp(flexMix.$mainAxisAlignment, MainAxisAlignment.spaceEvenly);
      });

      test('crossAxisAlignment factory creates correct FlexMix', () {
        final flexMix = FlexMix.crossAxisAlignment(CrossAxisAlignment.stretch);
        expectProp(flexMix.$crossAxisAlignment, CrossAxisAlignment.stretch);
      });

      test('mainAxisSize factory creates correct FlexMix', () {
        final flexMix = FlexMix.mainAxisSize(MainAxisSize.max);
        expectProp(flexMix.$mainAxisSize, MainAxisSize.max);
      });

      test('verticalDirection factory creates correct FlexMix', () {
        final flexMix = FlexMix.verticalDirection(VerticalDirection.down);
        expectProp(flexMix.$verticalDirection, VerticalDirection.down);
      });

      test('textDirection factory creates correct FlexMix', () {
        final flexMix = FlexMix.textDirection(TextDirection.ltr);
        expectProp(flexMix.$textDirection, TextDirection.ltr);
      });

      test('textBaseline factory creates correct FlexMix', () {
        final flexMix = FlexMix.textBaseline(TextBaseline.alphabetic);
        expectProp(flexMix.$textBaseline, TextBaseline.alphabetic);
      });

      test('clipBehavior factory creates correct FlexMix', () {
        final flexMix = FlexMix.clipBehavior(Clip.hardEdge);
        expectProp(flexMix.$clipBehavior, Clip.hardEdge);
      });

      test('gap factory creates correct FlexMix', () {
        final flexMix = FlexMix.gap(12.0);
        expectProp(flexMix.$gap, 12.0);
      });
    });

    group('Builder methods', () {
      test('direction method creates new FlexMix with direction', () {
        final original = FlexMix();
        final modified = original.direction(Axis.horizontal);

        expect(identical(original, modified), isFalse);
        expect(original.$direction, isNull);
        expectProp(modified.$direction, Axis.horizontal);
      });

      test('mainAxisAlignment method creates new FlexMix', () {
        final original = FlexMix();
        final modified = original.mainAxisAlignment(MainAxisAlignment.center);

        expect(identical(original, modified), isFalse);
        expectProp(modified.$mainAxisAlignment, MainAxisAlignment.center);
      });

      test('crossAxisAlignment method creates new FlexMix', () {
        final original = FlexMix();
        final modified = original.crossAxisAlignment(CrossAxisAlignment.end);

        expect(identical(original, modified), isFalse);
        expectProp(modified.$crossAxisAlignment, CrossAxisAlignment.end);
      });

      test('gap method creates new FlexMix with gap', () {
        final original = FlexMix();
        final modified = original.gap(20.0);

        expect(identical(original, modified), isFalse);
        expectProp(modified.$gap, 20.0);
      });

      test('row convenience method sets horizontal direction', () {
        final flexMix = FlexMix().row();
        expectProp(flexMix.$direction, Axis.horizontal);
      });

      test('column convenience method sets vertical direction', () {
        final flexMix = FlexMix().column();
        expectProp(flexMix.$direction, Axis.vertical);
      });
    });

    group('Merge functionality', () {
      test('merge with null returns original', () {
        final original = FlexMix(direction: Axis.horizontal);
        final result = original.merge(null);

        expect(identical(original, result), isTrue);
      });

      test('merge combines properties correctly', () {
        final first = FlexMix(direction: Axis.horizontal, gap: 8.0);
        final second = FlexMix(
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 16.0,
        );

        final merged = first.merge(second);

        expectProp(merged.$direction, Axis.horizontal);
        expectProp(merged.$mainAxisAlignment, MainAxisAlignment.center);
        expectProp(merged.$gap, 16.0); // second takes precedence
      });

      test('merge preserves null properties', () {
        final first = FlexMix(direction: Axis.horizontal);
        final second = FlexMix(gap: 8.0);

        final merged = first.merge(second);

        expectProp(merged.$direction, Axis.horizontal);
        expectProp(merged.$gap, 8.0);
        expect(merged.$mainAxisAlignment, isNull);
      });
    });

    group('Resolve functionality', () {
      test('resolve creates FlexSpec with resolved properties', () {
        final flexMix = FlexMix(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          gap: 12.0,
        );

        final spec = flexMix.resolve(MockBuildContext());

        expect(spec.direction, Axis.vertical);
        expect(spec.mainAxisAlignment, MainAxisAlignment.spaceAround);
        expect(spec.gap, 12.0);
      });

      test('resolve handles null properties', () {
        final flexMix = FlexMix();
        final spec = flexMix.resolve(MockBuildContext());

        expect(spec.direction, isNull);
        expect(spec.mainAxisAlignment, isNull);
        expect(spec.gap, isNull);
      });
    });

    group('Equality and props', () {
      test('equal FlexMix instances have same props', () {
        final flexMix1 = FlexMix(direction: Axis.horizontal, gap: 8.0);
        final flexMix2 = FlexMix(direction: Axis.horizontal, gap: 8.0);

        expect(flexMix1, equals(flexMix2));
        expect(flexMix1.props, equals(flexMix2.props));
      });

      test('different FlexMix instances have different props', () {
        final flexMix1 = FlexMix(direction: Axis.horizontal);
        final flexMix2 = FlexMix(direction: Axis.vertical);

        expect(flexMix1, isNot(equals(flexMix2)));
        expect(flexMix1.props, isNot(equals(flexMix2.props)));
      });

      test('props contains all properties', () {
        final flexMix = FlexMix(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 8.0,
        );

        final props = flexMix.props;
        expect(props.length, 12); // All properties including inherited ones
        expect(props, contains(flexMix.$direction));
        expect(props, contains(flexMix.$mainAxisAlignment));
        expect(props, contains(flexMix.$gap));
      });
    });

    group('Diagnostics', () {
      test('debugFillProperties includes all properties', () {
        final flexMix = FlexMix(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          gap: 8.0,
        );

        final builder = DiagnosticPropertiesBuilder();
        flexMix.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.any((p) => p.name == 'direction'), isTrue);
        expect(properties.any((p) => p.name == 'mainAxisAlignment'), isTrue);
        expect(properties.any((p) => p.name == 'gap'), isTrue);
      });
    });
  });
}
