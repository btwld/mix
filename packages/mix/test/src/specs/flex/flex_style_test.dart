import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexStyle', () {
    group('Constructors', () {
      test('default constructor creates FlexStyle with null properties', () {
        final flexMix = FlexStyler();

        expect(flexMix.$direction, isNull);
        expect(flexMix.$mainAxisAlignment, isNull);
        expect(flexMix.$crossAxisAlignment, isNull);
        expect(flexMix.$mainAxisSize, isNull);
        expect(flexMix.$verticalDirection, isNull);
        expect(flexMix.$textDirection, isNull);
        expect(flexMix.$textBaseline, isNull);
        expect(flexMix.$clipBehavior, isNull);
      });

      test(
        'constructor with parameters creates FlexStyle with correct properties',
        () {
          final flexMix = FlexStyler(
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

          expect(flexMix.$direction, resolvesTo(Axis.horizontal));
          expect(
            flexMix.$mainAxisAlignment,
            resolvesTo(MainAxisAlignment.center),
          );
          expect(
            flexMix.$crossAxisAlignment,
            resolvesTo(CrossAxisAlignment.start),
          );
          expect(flexMix.$mainAxisSize, resolvesTo(MainAxisSize.min));
          expect(flexMix.$verticalDirection, resolvesTo(VerticalDirection.up));
          expect(flexMix.$textDirection, resolvesTo(TextDirection.rtl));
          expect(flexMix.$textBaseline, resolvesTo(TextBaseline.ideographic));
          expect(flexMix.$clipBehavior, resolvesTo(Clip.antiAlias));
          expect(flexMix.$spacing, resolvesTo(16.0));
        },
      );

      test('direction factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().direction(Axis.vertical);
        expect(flexMix.$direction, resolvesTo(Axis.vertical));
      });

      test('mainAxisAlignment factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().mainAxisAlignment(
          MainAxisAlignment.spaceEvenly,
        );
        expect(
          flexMix.$mainAxisAlignment,
          resolvesTo(MainAxisAlignment.spaceEvenly),
        );
      });

      test('crossAxisAlignment factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().crossAxisAlignment(
          CrossAxisAlignment.stretch,
        );
        expect(
          flexMix.$crossAxisAlignment,
          resolvesTo(CrossAxisAlignment.stretch),
        );
      });

      test('mainAxisSize factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().mainAxisSize(MainAxisSize.max);
        expect(flexMix.$mainAxisSize, resolvesTo(MainAxisSize.max));
      });

      test('verticalDirection factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().verticalDirection(VerticalDirection.down);
        expect(flexMix.$verticalDirection, resolvesTo(VerticalDirection.down));
      });

      test('textDirection factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().textDirection(TextDirection.ltr);
        expect(flexMix.$textDirection, resolvesTo(TextDirection.ltr));
      });

      test('textBaseline factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().textBaseline(TextBaseline.alphabetic);
        expect(flexMix.$textBaseline, resolvesTo(TextBaseline.alphabetic));
      });

      test('clipBehavior factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().clipBehavior(Clip.hardEdge);
        expect(flexMix.$clipBehavior, resolvesTo(Clip.hardEdge));
      });

      test('spacing factory creates correct FlexStyle', () {
        final flexMix = FlexStyler().spacing(12.0);
        expect(flexMix.$spacing, resolvesTo(12.0));
      });
    });

    group('Builder methods', () {
      test('direction method creates new instance with updated value', () {
        final original = FlexStyler();
        final modified = original.direction(Axis.horizontal);

        expect(identical(original, modified), isFalse);
        expect(original.$direction, isNull);
        expect(modified.$direction, resolvesTo(Axis.horizontal));
      });

      test('mainAxisAlignment method creates new instance', () {
        final original = FlexStyler();
        final modified = original.mainAxisAlignment(MainAxisAlignment.center);

        expect(identical(original, modified), isFalse);
        expect(
          modified.$mainAxisAlignment,
          resolvesTo(MainAxisAlignment.center),
        );
      });

      test('crossAxisAlignment method creates new instance', () {
        final original = FlexStyler();
        final modified = original.crossAxisAlignment(CrossAxisAlignment.end);

        expect(identical(original, modified), isFalse);
        expect(
          modified.$crossAxisAlignment,
          resolvesTo(CrossAxisAlignment.end),
        );
      });

      test('spacing method creates new instance', () {
        final original = FlexStyler();
        final modified = original.spacing(20.0);

        expect(identical(original, modified), isFalse);
        expect(modified.$spacing, resolvesTo(20.0));
      });

      test('row convenience method sets horizontal direction', () {
        final flexMix = FlexStyler().row();
        expect(flexMix.$direction, resolvesTo(Axis.horizontal));
      });

      test('column convenience method sets vertical direction', () {
        final flexMix = FlexStyler().column();
        expect(flexMix.$direction, resolvesTo(Axis.vertical));
      });
    });

    group('Merge functionality', () {
      test('merge with null returns original', () {
        final original = FlexStyler(direction: Axis.horizontal);
        final result = original.merge(null);

        expect(identical(original, result), isFalse);
        expect(result, equals(original));
      });

      test('merge combines properties correctly', () {
        final first = FlexStyler(direction: Axis.horizontal, spacing: 8.0);
        final second = FlexStyler(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
        );

        final merged = first.merge(second);

        expect(merged.$direction, resolvesTo(Axis.horizontal));
        expect(merged.$mainAxisAlignment, resolvesTo(MainAxisAlignment.center));
        expect(merged.$spacing, resolvesTo(16.0)); // second takes precedence
      });

      test('merge preserves null properties', () {
        final first = FlexStyler(direction: Axis.horizontal);
        final second = FlexStyler(spacing: 8.0);

        final merged = first.merge(second);

        expect(merged.$direction, resolvesTo(Axis.horizontal));
        expect(merged.$spacing, resolvesTo(8.0));
        expect(merged.$mainAxisAlignment, isNull);
      });
    });

    group('Resolve functionality', () {
      test('resolve creates FlexStyleSpec with resolved properties', () {
        final flexMix = FlexStyler(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 12.0,
        );

        final spec = flexMix.resolve(MockBuildContext());

        expect(spec.spec.direction, Axis.vertical);
        expect(spec.spec.mainAxisAlignment, MainAxisAlignment.spaceAround);
        expect(spec.spec.spacing, 12.0);
      });

      test('resolve handles null properties', () {
        final flexMix = FlexStyler();
        final spec = flexMix.resolve(MockBuildContext());

        expect(spec.spec.direction, isNull);
        expect(spec.spec.mainAxisAlignment, isNull);
        expect(spec.spec.spacing, isNull);
      });
    });

    group('Equality and props', () {
      test('equal instances have same props', () {
        final flexMix1 = FlexStyler(direction: Axis.horizontal, spacing: 8.0);
        final flexMix2 = FlexStyler(direction: Axis.horizontal, spacing: 8.0);

        expect(flexMix1, equals(flexMix2));
        expect(flexMix1.props, equals(flexMix2.props));
      });

      test('different instances have different props', () {
        final flexMix1 = FlexStyler(direction: Axis.horizontal);
        final flexMix2 = FlexStyler(direction: Axis.vertical);

        expect(flexMix1, isNot(equals(flexMix2)));
        expect(flexMix1.props, isNot(equals(flexMix2.props)));
      });

      test('props contains all properties', () {
        final flexMix = FlexStyler(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
        );

        final props = flexMix.props;
        expect(props.length, 12); // All properties including inherited ones
        expect(props, contains(flexMix.$direction));
        expect(props, contains(flexMix.$mainAxisAlignment));
        expect(props, contains(flexMix.$spacing));
      });
    });

    group('Diagnostics', () {
      test('debugFillProperties includes all properties', () {
        final flexMix = FlexStyler(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
        );

        final builder = DiagnosticPropertiesBuilder();
        flexMix.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.any((p) => p.name == 'direction'), isTrue);
        expect(properties.any((p) => p.name == 'mainAxisAlignment'), isTrue);
        expect(properties.any((p) => p.name == 'spacing'), isTrue);
      });
    });
  });
}
