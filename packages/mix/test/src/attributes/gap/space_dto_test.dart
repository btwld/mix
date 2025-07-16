import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('SpaceDto', () {
    // Constructor Tests
    group('Constructor Tests', () {
      test('value constructor creates SpaceDto with given value', () {
        const dto = SpaceDto.value(10.0);
        expect(dto, resolvesTo(10.0));
      });

      test('token constructor creates SpaceDto with token', () {
        const token = MixableToken<double>('test.space');
        const dto = SpaceDto.token(token);
        expect(dto, isA<SpaceDto>());
      });

      test('zero constant has value 0', () {
        expect(SpaceDto.zero, resolvesTo(0.0));
      });

      test('infinity constant has value double.infinity', () {
        expect(SpaceDto.infinity, resolvesTo(double.infinity));
      });
    });

    // Factory Tests
    group('Factory Tests', () {
      test('maybeValue returns SpaceDto for non-null value', () {
        final dto = SpaceDto.maybeValue(10.0);
        expect(dto, isNotNull);
        expect(dto, resolvesTo(10.0));
      });

      test('maybeValue returns null for null value', () {
        final dto = SpaceDto.maybeValue(null);
        expect(dto, isNull);
      });

      test('maybeValue with zero returns SpaceDto with 0', () {
        final dto = SpaceDto.maybeValue(0.0);
        expect(dto, isNotNull);
        expect(dto, resolvesTo(0.0));
      });

      test('maybeValue with infinity returns SpaceDto with infinity', () {
        final dto = SpaceDto.maybeValue(double.infinity);
        expect(dto, isNotNull);
        expect(dto, resolvesTo(double.infinity));
      });

      test('maybeValue with negative value returns SpaceDto', () {
        final dto = SpaceDto.maybeValue(-10.0);
        expect(dto, isNotNull);
        expect(dto, resolvesTo(-10.0));
      });
    });

    // Resolution Tests
    group('Resolution Tests', () {
      test('value SpaceDto resolves to its value', () {
        const dto = SpaceDto.value(25.5);
        final context = createEmptyMixData();
        expect(dto.resolve(context), 25.5);
      });

      testWidgets('token SpaceDto resolves correctly', (tester) async {
        const testToken = MixableToken<double>('spacing.large');

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(
            tokens: {
              testToken: 32.0,
            },
          ),
        );

        final buildContext = tester.element(find.byType(Container));
        final mixContext = MixContext.create(buildContext, Style());

        const dto = SpaceDto.token(testToken);
        expect(dto.resolve(mixContext), 32.0);
      });

      test('SpaceDto.zero resolves to 0.0', () {
        final context = createEmptyMixData();
        expect(SpaceDto.zero.resolve(context), 0.0);
      });

      test('SpaceDto.infinity resolves to double.infinity', () {
        final context = createEmptyMixData();
        expect(SpaceDto.infinity.resolve(context), double.infinity);
      });
    });

    // Merge Tests
    group('Merge Tests', () {
      test('value merges with value - second value wins', () {
        const dto1 = SpaceDto.value(10.0);
        const dto2 = SpaceDto.value(20.0);
        final merged = dto1.merge(dto2);
        
        expect(merged, resolvesTo(20.0));
      });

      test('value merges with token - token wins', () {
        const dto1 = SpaceDto.value(10.0);
        const token = MixableToken<double>('spacing.medium');
        const dto2 = SpaceDto.token(token);
        final merged = dto1.merge(dto2);
        
        expect(merged, same(dto2));
      });

      test('token merges with value - value wins', () {
        const token = MixableToken<double>('spacing.small');
        const dto1 = SpaceDto.token(token);
        const dto2 = SpaceDto.value(30.0);
        final merged = dto1.merge(dto2);
        
        expect(merged, resolvesTo(30.0));
      });

      test('token merges with token - second token wins', () {
        const token1 = MixableToken<double>('spacing.small');
        const token2 = MixableToken<double>('spacing.large');
        const dto1 = SpaceDto.token(token1);
        const dto2 = SpaceDto.token(token2);
        final merged = dto1.merge(dto2);
        
        expect(merged, same(dto2));
      });

      test('merge with null returns original', () {
        const dto = SpaceDto.value(15.0);
        final merged = dto.merge(null);
        
        expect(merged, same(dto));
      });

      test('merge with zero', () {
        const dto1 = SpaceDto.value(10.0);
        const dto2 = SpaceDto.zero;
        final merged = dto1.merge(dto2);
        
        expect(merged, resolvesTo(0.0));
      });

      test('merge with infinity', () {
        const dto1 = SpaceDto.value(10.0);
        const dto2 = SpaceDto.infinity;
        final merged = dto1.merge(dto2);
        
        expect(merged, resolvesTo(double.infinity));
      });
    });

    // Equality and HashCode Tests
    group('Equality and HashCode Tests', () {
      test('value SpaceDto equality', () {
        const dto1 = SpaceDto.value(10.0);
        const dto2 = SpaceDto.value(10.0);
        const dto3 = SpaceDto.value(20.0);
        
        expect(dto1, equals(dto2));
        expect(dto1, isNot(equals(dto3)));
      });

      test('token SpaceDto equality', () {
        const token1 = MixableToken<double>('spacing.medium');
        const token2 = MixableToken<double>('spacing.medium');
        const token3 = MixableToken<double>('spacing.large');
        const dto1 = SpaceDto.token(token1);
        const dto2 = SpaceDto.token(token2);
        const dto3 = SpaceDto.token(token3);
        
        expect(dto1, equals(dto2));
        expect(dto1, isNot(equals(dto3)));
      });

      test('value and token SpaceDto inequality', () {
        const dto1 = SpaceDto.value(16.0);
        const token = MixableToken<double>('spacing.medium');
        const dto2 = SpaceDto.token(token);
        
        expect(dto1, isNot(equals(dto2)));
      });

      test('hashCode consistency for value DTOs', () {
        const dto1 = SpaceDto.value(10.0);
        const dto2 = SpaceDto.value(10.0);
        
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('hashCode consistency for token DTOs', () {
        const token = MixableToken<double>('spacing.medium');
        const dto1 = SpaceDto.token(token);
        const dto2 = SpaceDto.token(token);
        
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('zero equality with value(0.0)', () {
        const dto1 = SpaceDto.zero;
        const dto2 = SpaceDto.value(0.0);
        
        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('infinity equality with value(double.infinity)', () {
        const dto1 = SpaceDto.infinity;
        const dto2 = SpaceDto.value(double.infinity);
        
        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });
    });

    // Edge Cases
    group('Edge Cases', () {
      test('negative values work correctly', () {
        const dto = SpaceDto.value(-10.0);
        expect(dto, resolvesTo(-10.0));
      });

      test('very large values work correctly', () {
        const dto = SpaceDto.value(999999.0);
        expect(dto, resolvesTo(999999.0));
      });

      test('very small values work correctly', () {
        const dto = SpaceDto.value(0.0001);
        expect(dto, resolvesTo(0.0001));
      });

      test('NaN values work correctly', () {
        const dto = SpaceDto.value(double.nan);
        final context = createEmptyMixData();
        expect(dto.resolve(context), isNaN);
      });

      test('negative infinity works correctly', () {
        const dto = SpaceDto.value(double.negativeInfinity);
        expect(dto, resolvesTo(double.negativeInfinity));
      });
    });

    // Integration Tests
    group('Integration Tests', () {
      test('SpaceDto used in Gap widget context', () {
        const dto = SpaceDto.value(16.0);
        final context = createEmptyMixData();
        final resolved = dto.resolve(context);
        
        expect(resolved, 16.0);
        // This value would be used by Gap widget
      });

      testWidgets('SpaceDto with theme token integration', (tester) async {
        const smallToken = MixableToken<double>('spacing.small');
        const mediumToken = MixableToken<double>('spacing.medium');
        const largeToken = MixableToken<double>('spacing.large');

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(
            tokens: {
              smallToken: 8.0,
              mediumToken: 16.0,
              largeToken: 24.0,
            },
          ),
        );

        final buildContext = tester.element(find.byType(Container));
        final mixContext = MixContext.create(buildContext, Style());
        
        expect(SpaceDto.token(smallToken).resolve(mixContext), 8.0);
        expect(SpaceDto.token(mediumToken).resolve(mixContext), 16.0);
        expect(SpaceDto.token(largeToken).resolve(mixContext), 24.0);
      });

      test('SpaceDto chain merging', () {
        const dto1 = SpaceDto.value(10.0);
        const dto2 = SpaceDto.value(20.0);
        const dto3 = SpaceDto.value(30.0);
        
        final merged = dto1.merge(dto2).merge(dto3);
        expect(merged, resolvesTo(30.0));
      });

      test('SpaceDto with null chain merging', () {
        const dto = SpaceDto.value(10.0);
        final merged = dto.merge(null).merge(null);
        
        expect(merged, same(dto));
        expect(merged, resolvesTo(10.0));
      });
    });
  });
}
