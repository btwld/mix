import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('StrutStyleDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('only constructor creates StrutStyleDto with all properties', () {
        final dto = StrutStyleDto.only(
          fontFamily: 'Roboto',
          fontFamilyFallback: const ['Arial', 'Helvetica'],
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          height: 2.0,
          leading: 1.0,
          forceStrutHeight: true,
        );

        expect(dto.fontFamily, resolvesTo('Roboto'));
        // fontFamilyFallback is a list of Prop<String>, so we check the resolved values
        expect(
          dto.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          ['Arial', 'Helvetica'],
        );
        expect(dto.fontSize, resolvesTo(24.0));
        expect(dto.fontWeight, resolvesTo(FontWeight.bold));
        expect(dto.fontStyle, resolvesTo(FontStyle.italic));
        expect(dto.height, resolvesTo(2.0));
        expect(dto.leading, resolvesTo(1.0));
        expect(dto.forceStrutHeight, resolvesTo(true));
      });

      test('main constructor with Prop values', () {
        final dto = StrutStyleDto(
          fontFamily: Prop('Inter'),
          fontFamilyFallback: [Prop('Verdana'), Prop('Georgia')],
          fontSize: Prop(18.0),
          fontWeight: Prop(FontWeight.w600),
          fontStyle: Prop(FontStyle.normal),
          height: Prop(1.5),
          leading: Prop(0.5),
          forceStrutHeight: Prop(false),
        );

        expect(dto.fontFamily, resolvesTo('Inter'));
        expect(
          dto.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          ['Verdana', 'Georgia'],
        );
        expect(dto.fontSize, resolvesTo(18.0));
        expect(dto.fontWeight, resolvesTo(FontWeight.w600));
        expect(dto.fontStyle, resolvesTo(FontStyle.normal));
        expect(dto.height, resolvesTo(1.5));
        expect(dto.leading, resolvesTo(0.5));
        expect(dto.forceStrutHeight, resolvesTo(false));
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
        final dto = StrutStyleDto.value(strutStyle);

        expect(dto.fontFamily, resolvesTo(strutStyle.fontFamily));
        expect(
          dto.fontFamilyFallback
              ?.map((p) => p.resolve(MockBuildContext()))
              .toList(),
          strutStyle.fontFamilyFallback,
        );
        expect(dto.fontSize, resolvesTo(strutStyle.fontSize));
        expect(dto.fontWeight, resolvesTo(strutStyle.fontWeight));
        expect(dto.fontStyle, resolvesTo(strutStyle.fontStyle));
        expect(dto.height, resolvesTo(strutStyle.height));
        expect(dto.leading, resolvesTo(strutStyle.leading));
        expect(dto.forceStrutHeight, resolvesTo(strutStyle.forceStrutHeight));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns StrutStyleDto for non-null StrutStyle', () {
        const strutStyle = StrutStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        );
        final dto = StrutStyleDto.maybeValue(strutStyle);

        expect(dto, isNotNull);
        expect(dto?.fontSize, resolvesTo(strutStyle.fontSize));
        expect(dto?.fontWeight, resolvesTo(strutStyle.fontWeight));
      });

      test('maybeValue returns null for null StrutStyle', () {
        final dto = StrutStyleDto.maybeValue(null);
        expect(dto, isNull);
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('resolves to StrutStyle with all properties', () {
        final dto = StrutStyleDto.only(
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
        final dto = StrutStyleDto.only();

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

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
        final dto = StrutStyleDto.only(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          forceStrutHeight: true,
        );

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.fontSize, 20.0);
        expect(resolved.fontWeight, FontWeight.w500);
        expect(resolved.forceStrutHeight, true);
        expect(resolved.fontFamily, isNull);
        expect(resolved.height, isNull);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('merge with another StrutStyleDto - all properties', () {
        final dto1 = StrutStyleDto.only(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          height: 1.5,
          leading: 0.5,
          forceStrutHeight: false,
        );
        final dto2 = StrutStyleDto.only(
          fontFamily: 'Inter',
          fontFamilyFallback: const ['Arial'],
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          height: 2.0,
          leading: 1.0,
          forceStrutHeight: true,
        );

        final merged = dto1.merge(dto2);

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
        final dto1 = StrutStyleDto.only(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        );
        final dto2 = StrutStyleDto.only(
          height: 2.0,
          leading: 1.0,
          forceStrutHeight: true,
        );

        final merged = dto1.merge(dto2);

        expect(merged.fontFamily, resolvesTo('Roboto'));
        expect(merged.fontSize, resolvesTo(24.0));
        expect(merged.fontWeight, resolvesTo(FontWeight.bold));
        expect(merged.height, resolvesTo(2.0));
        expect(merged.leading, resolvesTo(1.0));
        expect(merged.forceStrutHeight, resolvesTo(true));
      });

      test('merge with null returns original', () {
        final dto = StrutStyleDto.only(fontFamily: 'Roboto', fontSize: 24.0);

        final merged = dto.merge(null);
        expect(merged, same(dto));
      });

      test('merge fontFamilyFallback lists', () {
        final dto1 = StrutStyleDto.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );
        final dto2 = StrutStyleDto.only(
          fontFamilyFallback: const ['Verdana', 'Georgia'],
        );

        final merged = dto1.merge(dto2);
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
      test('equal StrutStyleDtos', () {
        final dto1 = StrutStyleDto.only(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          forceStrutHeight: true,
        );
        final dto2 = StrutStyleDto.only(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          forceStrutHeight: true,
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equal StrutStyleDtos', () {
        final dto1 = StrutStyleDto.only(fontFamily: 'Roboto', fontSize: 24.0);
        final dto2 = StrutStyleDto.only(fontFamily: 'Lato', fontSize: 24.0);

        expect(dto1, isNot(equals(dto2)));
      });

      test('equality with lists', () {
        final dto1 = StrutStyleDto.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );
        final dto2 = StrutStyleDto.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('handles empty fontFamilyFallback list', () {
        final dto = StrutStyleDto.only(fontFamilyFallback: const []);

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.fontFamilyFallback, isEmpty);
      });

      test('handles zero and negative values', () {
        final dto = StrutStyleDto.only(
          fontSize: 0.0,
          height: -1.0,
          leading: -0.5,
        );

        expect(dto.fontSize, resolvesTo(0.0));
        expect(dto.height, resolvesTo(-1.0));
        expect(dto.leading, resolvesTo(-0.5));
      });

      test('handles extreme font weights', () {
        final dto1 = StrutStyleDto.only(fontWeight: FontWeight.w100);
        final dto2 = StrutStyleDto.only(fontWeight: FontWeight.w900);

        expect(dto1.fontWeight, resolvesTo(FontWeight.w100));
        expect(dto2.fontWeight, resolvesTo(FontWeight.w900));
      });

      test('handles very large fontSize', () {
        final dto = StrutStyleDto.only(fontSize: 1000.0);

        expect(dto.fontSize, resolvesTo(1000.0));
      });

      test('handles null fontFamily with non-null fontFamilyFallback', () {
        final dto = StrutStyleDto.only(
          fontFamilyFallback: const ['Arial', 'Helvetica'],
        );

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.fontFamily, isNull);
        expect(resolved.fontFamilyFallback, ['Arial', 'Helvetica']);
      });

      test('handles forceStrutHeight variations', () {
        final dto1 = StrutStyleDto.only(forceStrutHeight: true);
        final dto2 = StrutStyleDto.only(forceStrutHeight: false);
        final dto3 = StrutStyleDto.only(); // null

        expect(dto1.forceStrutHeight, resolvesTo(true));
        expect(dto2.forceStrutHeight, resolvesTo(false));
        expect(dto3.forceStrutHeight, isNull);
      });
    });

    // Integration Tests
    group('Integration Tests', () {
      test('StrutStyleDto used in Text widget context', () {
        final dto = StrutStyleDto.only(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          height: 1.5,
          forceStrutHeight: true,
        );

        final context = MockBuildContext();
        final resolved = dto.resolve(context);

        expect(resolved.fontFamily, 'Roboto');
        expect(resolved.fontSize, 16.0);
        expect(resolved.height, 1.5);
        expect(resolved.forceStrutHeight, true);
      });

      test('complex merge scenario', () {
        final baseStyle = StrutStyleDto.only(
          fontFamily: 'Roboto',
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        );

        final headingStyle = StrutStyleDto.only(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          height: 1.2,
        );

        final overrideStyle = StrutStyleDto.only(
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
        final dto1 = StrutStyleDto.only(
          fontFamily: 'CustomFont',
          fontFamilyFallback: const ['Fallback1'],
        );

        final dto2 = StrutStyleDto.only(
          fontFamilyFallback: const ['Fallback2', 'Fallback3'],
        );

        final merged = dto1.merge(dto2);

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
