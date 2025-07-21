import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('StrutStyleMix', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor creates StrutStyleMix with all properties', () {
        final mix = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          height: 2.0,
          leading: 1.0,
          forceStrutHeight: true,
        );

        expect(mix.fontFamily, resolvesTo('Roboto'));
        // fontFamilyFallback is a list of Prop<String>, so we check the resolved values
        expect(
          mix.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          ['Arial', 'Helvetica'],
        );
        expect(mix.fontSize, resolvesTo(24.0));
        expect(mix.fontWeight, resolvesTo(FontWeight.bold));
        expect(mix.fontStyle, resolvesTo(FontStyle.italic));
        expect(mix.height, resolvesTo(2.0));
        expect(mix.leading, resolvesTo(1.0));
        expect(mix.forceStrutHeight, resolvesTo(true));
      });

      test('main constructor with Prop values', () {
        final mix = StrutStyleMix(
          fontFamily: Prop('Inter'),
          fontFamilyFallback: [Prop('Verdana'), Prop('Georgia')],
          fontSize: Prop(18.0),
          fontWeight: Prop(FontWeight.w600),
          fontStyle: Prop(FontStyle.normal),
          height: Prop(1.5),
          leading: Prop(0.5),
          forceStrutHeight: Prop(false),
        );

        expect(mix.fontFamily, resolvesTo('Inter'));
        expect(
          mix.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          ['Verdana', 'Georgia'],
        );
        expect(mix.fontSize, resolvesTo(18.0));
        expect(mix.fontWeight, resolvesTo(FontWeight.w600));
        expect(mix.fontStyle, resolvesTo(FontStyle.normal));
        expect(mix.height, resolvesTo(1.5));
        expect(mix.leading, resolvesTo(0.5));
        expect(mix.forceStrutHeight, resolvesTo(false));
      });

      test('value constructor from StrutStyle', () {
        const strutStyle = StrutStyle(
          fontFamily: 'Helvetica',
          fontFamilyFallback: ['Arial'],
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          height: 1.8,
          leading: 0.8,
          forceStrutHeight: true,
        );
        final mix = StrutStyleMix.value(strutStyle);

        expect(mix.fontFamily, resolvesTo(strutStyle.fontFamily));
        expect(
          mix.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          strutStyle.fontFamilyFallback,
        );
        expect(mix.fontSize, resolvesTo(strutStyle.fontSize));
        expect(mix.fontWeight, resolvesTo(strutStyle.fontWeight));
        expect(mix.fontStyle, resolvesTo(strutStyle.fontStyle));
        expect(mix.height, resolvesTo(strutStyle.height));
        expect(mix.leading, resolvesTo(strutStyle.leading));
        expect(mix.forceStrutHeight, resolvesTo(strutStyle.forceStrutHeight));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns StrutStyleMix for non-null StrutStyle', () {
        const strutStyle = StrutStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );
        final mix = StrutStyleMix.maybeValue(strutStyle);

        expect(mix, isNotNull);
        expect(mix?.fontSize, resolvesTo(strutStyle.fontSize));
        expect(mix?.fontWeight, resolvesTo(strutStyle.fontWeight));
      });

      test('maybeValue returns null for null StrutStyle', () {
        final mix = StrutStyleMix.maybeValue(null);
        expect(mix, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to StrutStyle with all properties', () {
        final mix = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          height: 2.0,
          leading: 1.0,
          forceStrutHeight: true,
        );

        expect(
          dto,
          resolvesTo(
            const StrutStyle(
              fontFamily: 'Roboto',
              fontFamilyFallback: ['Arial', 'Helvetica'],
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              height: 2.0,
              leading: 1.0,
              forceStrutHeight: true,
            ),
          ),
        );
      });

      test('resolves with default values for null properties', () {
        final mix = StrutStyleMix.only();

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.fontFamily, isNull);
        expect(resolved.fontFamilyFallback, isNull);
        expect(resolved.fontSize, isNull);
        expect(resolved.fontWeight, isNull);
        expect(resolved.fontStyle, isNull);
        expect(resolved.height, isNull);
        expect(resolved.leading, isNull);
        expect(resolved.forceStrutHeight, isNull);
      });

      test('resolves with partial properties', () {
        final mix = StrutStyleMix.only(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          forceStrutHeight: true,
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.fontSize, 20.0);
        expect(resolved.fontWeight, FontWeight.w500);
        expect(resolved.forceStrutHeight, true);
        expect(resolved.fontFamily, isNull);
        expect(resolved.height, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another StrutStyleMix - all properties', () {
        final mix1 = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          height: 1.5,
          leading: 0.5,
          forceStrutHeight: false,
        );
        final mix2 = StrutStyleMix.only(
          fontFamily: 'Inter',
          fontFamilyFallback: const ['Arial'],
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          height: 2.0,
          leading: 1.0,
          forceStrutHeight: true,
        );

        final merged = dto1.merge(mix2);

        expect(merged.fontFamily, resolvesTo('Inter'));
        expect(
          merged.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          ['Arial'],
        );
        expect(merged.fontSize, resolvesTo(28.0));
        expect(merged.fontWeight, resolvesTo(FontWeight.bold));
        expect(merged.fontStyle, resolvesTo(FontStyle.italic));
        expect(merged.height, resolvesTo(2.0));
        expect(merged.leading, resolvesTo(1.0));
        expect(merged.forceStrutHeight, resolvesTo(true));
      });

      test('merge with partial properties', () {
        final mix1 = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        );
        final mix2 = StrutStyleMix.only(
          height: 2.0,
          leading: 1.0,
          forceStrutHeight: true,
        );

        final merged = dto1.merge(mix2);

        expect(merged.fontFamily, resolvesTo('Roboto'));
        expect(merged.fontSize, resolvesTo(24.0));
        expect(merged.fontWeight, resolvesTo(FontWeight.bold));
        expect(merged.height, resolvesTo(2.0));
        expect(merged.leading, resolvesTo(1.0));
        expect(merged.forceStrutHeight, resolvesTo(true));
      });

      test('merge with null returns original', () {
        final mix = StrutStyleMix.only(fontFamily: 'Roboto', fontSize: 24.0);

        final merged = mix.merge(null);
        expect(merged, same(mix));
      });

      test('merge fontFamilyFallback lists', () {
        final mix1 = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );
        final mix2 = StrutStyleMix.only(
          fontFamilyFallback: const ['Verdana', 'Georgia'],
        );

        final merged = dto1.merge(mix2);
        expect(
          merged.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          ['Verdana', 'Georgia'],
        );
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('equal StrutStyleMixs', () {
        final mix1 = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          forceStrutHeight: true,
        );
        final mix2 = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          forceStrutHeight: true,
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equal StrutStyleMixs', () {
        final mix1 = StrutStyleMix.only(fontFamily: 'Roboto', fontSize: 24.0);
        final mix2 = StrutStyleMix.only(fontFamily: 'Lato', fontSize: 24.0);

        expect(mix1, isNot(equals(mix2)));
      });

      test('equality with lists', () {
        final mix1 = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );
        final mix2 = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles empty fontFamilyFallback list', () {
        final mix = StrutStyleMix.only(fontFamilyFallback: const []);

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.fontFamilyFallback, isEmpty);
      });

      test('handles zero and negative values', () {
        final mix = StrutStyleMix.only(
          fontSize: 0.0,
          height: -1.0,
          leading: -0.5,
        );

        expect(mix.fontSize, resolvesTo(0.0));
        expect(mix.height, resolvesTo(-1.0));
        expect(mix.leading, resolvesTo(-0.5));
      });

      test('handles extreme font weights', () {
        final mix1 = StrutStyleMix.only(fontWeight: FontWeight.w100);
        final mix2 = StrutStyleMix.only(fontWeight: FontWeight.w900);

        expect(mix1.fontWeight, resolvesTo(FontWeight.w100));
        expect(mix2.fontWeight, resolvesTo(FontWeight.w900));
      });

      test('handles very large fontSize', () {
        final mix = StrutStyleMix.only(fontSize: 1000.0);

        expect(mix.fontSize, resolvesTo(1000.0));
      });

      test('handles null fontFamily with non-null fontFamilyFallback', () {
        final mix = StrutStyleMix.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.fontFamily, isNull);
        expect(resolved.fontFamilyFallback, ['Arial', 'Helvetica']);
      });

      test('handles forceStrutHeight variations', () {
        final mix1 = StrutStyleMix.only(forceStrutHeight: true);
        final mix2 = StrutStyleMix.only(forceStrutHeight: false);
        final dto3 = StrutStyleMix.only(); // null

        expect(mix1.forceStrutHeight, resolvesTo(true));
        expect(mix2.forceStrutHeight, resolvesTo(false));
        expect(mix3.forceStrutHeight, isNull);
      });
    });

    // Integration Tests
    group('Integration Tests', () {
      test('StrutStyleMix used in Text widget context', () {
        final mix = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          height: 1.5,
          forceStrutHeight: true,
        );

        final context = MockBuildContext();
        final resolved = mix.resolve(context);

        expect(resolved.fontFamily, 'Roboto');
        expect(resolved.fontSize, 16.0);
        expect(resolved.height, 1.5);
        expect(resolved.forceStrutHeight, true);
      });

      test('complex merge scenario', () {
        final baseStyle = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        );

        final headingStyle = StrutStyleMix.only(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          height: 1.2,
        );

        final overrideStyle = StrutStyleMix.only(
          fontFamily: 'Inter',
          forceStrutHeight: true,
        );

        final merged = baseStyle.merge(headingStyle).merge(overrideStyle);

        expect(merged.fontFamily, resolvesTo('Inter'));
        expect(merged.fontSize, resolvesTo(24.0));
        expect(merged.fontWeight, resolvesTo(FontWeight.bold));
        expect(merged.height, resolvesTo(1.2));
        expect(merged.forceStrutHeight, resolvesTo(true));
      });

      test('fontFamilyFallback behavior with merge', () {
        final mix1 = StrutStyleMix.only(
          fontFamily: 'CustomFont',
          fontFamilyFallback: const ['Fallback1'],
        );

        final mix2 = StrutStyleMix.only(
          fontFamilyFallback: const ['Fallback2', 'Fallback3'],
        );

        final merged = dto1.merge(mix2);

        expect(merged.fontFamily, resolvesTo('CustomFont'));
        expect(
          merged.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          ['Fallback2', 'Fallback3'],
        );
      });
    });
  });
}
