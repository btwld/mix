import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('BoxConstraintsDto', () {
    group('constructor', () {
      test('main factory assigns properties correctly', () {
        final dto = BoxConstraintsDto(
          minWidth: 50,
          maxWidth: 150,
          minHeight: 100,
          maxHeight: 200,
        );

        expect(
          dto,
          resolvesTo(
            const BoxConstraints(
              minWidth: 50,
              maxWidth: 150,
              minHeight: 100,
              maxHeight: 200,
            ),
          ),
        );
      });

      test('.value factory creates from Flutter type', () {
        const constraints = BoxConstraints(
          minWidth: 50,
          maxWidth: 150,
          minHeight: 100,
          maxHeight: 200,
        );
        final dto = BoxConstraintsDto.value(constraints);

        expect(dto, resolvesTo(constraints));
      });

      test('.maybeValue handles null correctly', () {
        expect(BoxConstraintsDto.maybeValue(null), isNull);

        const constraints = BoxConstraints(minWidth: 10);
        expect(BoxConstraintsDto.maybeValue(constraints), isNotNull);
        expect(
          BoxConstraintsDto.maybeValue(constraints),
          resolvesTo(constraints),
        );
      });

      test('.props constructor accepts Prop instances', () {
        final dto = BoxConstraintsDto.props(
          minWidth: Prop(50),
          maxWidth: Prop(150),
          minHeight: Prop(100),
          maxHeight: Prop(200),
        );

        expect(
          dto,
          resolvesTo(
            const BoxConstraints(
              minWidth: 50,
              maxWidth: 150,
              minHeight: 100,
              maxHeight: 200,
            ),
          ),
        );
      });
    });

    group('resolve', () {
      test('returns correct BoxConstraints with specific values', () {
        final dto = BoxConstraintsDto(
          minWidth: 50,
          maxWidth: 150,
          minHeight: 100,
          maxHeight: 200,
        );

        expect(
          dto,
          resolvesTo(
            const BoxConstraints(
              minWidth: 50,
              maxWidth: 150,
              minHeight: 100,
              maxHeight: 200,
            ),
          ),
        );
      });

      test('uses default values for null properties', () {
        final dto = BoxConstraintsDto(
          minWidth: 50,
          minHeight: 100,
          // maxWidth and maxHeight are null
        );

        expect(
          dto,
          resolvesTo(
            const BoxConstraints(
              minWidth: 50,
              maxWidth: double.infinity,
              minHeight: 100,
              maxHeight: double.infinity,
            ),
          ),
        );
      });

      test('handles all-null DTO', () {
        final dto = BoxConstraintsDto();

        expect(() => dto.resolve(EmptyMixData), returnsNormally);
        expect(dto, resolvesTo(const BoxConstraints()));
      });
    });

    group('merge', () {
      test('combines properties correctly', () {
        final base = BoxConstraintsDto(
          minWidth: 50,
          maxWidth: 150,
          minHeight: 100,
          maxHeight: 200,
        );
        final override = BoxConstraintsDto(
          minWidth: 60,
          maxWidth: 160,
          // minHeight and maxHeight not specified
        );

        final merged = base.merge(override);

        expect(
          merged,
          resolvesTo(
            const BoxConstraints(
              minWidth: 60, // From override
              maxWidth: 160, // From override
              minHeight: 100, // Preserved from base
              maxHeight: 200, // Preserved from base
            ),
          ),
        );
      });

      test('preserves unspecified properties', () {
        final base = BoxConstraintsDto(
          minWidth: 50,
          maxWidth: 150,
          minHeight: 100,
          maxHeight: 200,
        );
        final override = BoxConstraintsDto(
          minWidth: 60, // Only minWidth
        );

        final merged = base.merge(override);

        expect(
          merged,
          resolvesTo(
            const BoxConstraints(
              minWidth: 60, // Overridden
              maxWidth: 150, // Preserved
              minHeight: 100, // Preserved
              maxHeight: 200, // Preserved
            ),
          ),
        );
      });

      test('returns self when merging with null', () {
        final dto = BoxConstraintsDto(minWidth: 50, minHeight: 100);
        final merged = dto.merge(null);

        expect(merged, same(dto));
      });
    });

    group('equality', () {
      test('equals with same values', () {
        final dto1 = BoxConstraintsDto(minWidth: 50, minHeight: 100);
        final dto2 = BoxConstraintsDto(minWidth: 50, minHeight: 100);

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equals with different values', () {
        final dto1 = BoxConstraintsDto(minWidth: 50, minHeight: 100);
        final dto2 = BoxConstraintsDto(minWidth: 60, minHeight: 100);

        expect(dto1, isNot(equals(dto2)));
      });

      test('handles null values in equality', () {
        final dto1 = BoxConstraintsDto(minWidth: 50); // maxWidth is null
        final dto2 = BoxConstraintsDto(minWidth: 50); // maxWidth is null
        final dto3 = BoxConstraintsDto(minWidth: 50, maxWidth: 100);

        expect(dto1, equals(dto2));
        expect(dto1, isNot(equals(dto3)));
      });
    });

    group('token resolution', () {
      testWidgets('resolves tokens from context', (tester) async {
        const minToken = MixToken<double>('constraints.min');
        const maxToken = MixToken<double>('constraints.max');

        final dto = BoxConstraintsDto.props(
          minWidth: Prop.token(minToken),
          maxWidth: Prop.token(maxToken),
          minHeight: Prop(100),
          maxHeight: Prop(200),
        );

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(tokens: {minToken: 50.0, maxToken: 150.0}),
        );

        final context = tester.element(find.byType(Container));

        expect(
          dto.resolve(context),
          const BoxConstraints(
            minWidth: 50,
            maxWidth: 150,
            minHeight: 100,
            maxHeight: 200,
          ),
        );
      });

      test('handles missing tokens gracefully', () {
        const token = MixToken<double>('undefined.size');
        final dto = BoxConstraintsDto.props(minWidth: Prop.token(token));

        // The resolve should throw when token is not found
        expect(() => dto.resolve(EmptyMixData), throwsA(isA<StateError>()));
      });

      testWidgets('mixes tokens and values', (tester) async {
        const sizeToken = MixToken<double>('size.large');

        final dto = BoxConstraintsDto.props(
          minWidth: Prop(10),
          maxWidth: Prop.token(sizeToken),
          minHeight: Prop(20),
          maxHeight: Prop.token(sizeToken),
        );

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(tokens: {sizeToken: 100.0}),
        );

        final context = tester.element(find.byType(Container));

        expect(
          dto.resolve(context),
          const BoxConstraints(
            minWidth: 10,
            maxWidth: 100,
            minHeight: 20,
            maxHeight: 100,
          ),
        );
      });
    });

    group('edge cases', () {
      test('handles extreme values', () {
        final dto = BoxConstraintsDto(
          minWidth: 0,
          maxWidth: double.infinity,
          minHeight: 0,
          maxHeight: double.infinity,
        );

        expect(() => dto.resolve(EmptyMixData), returnsNormally);
      });

      test('merge maintains property types', () {
        final dto1 = BoxConstraintsDto.props(
          minWidth: Prop(50),
          maxWidth: Prop.token(const MixToken<double>('size')),
        );
        final dto2 = BoxConstraintsDto(minWidth: 60);

        final merged = dto1.merge(dto2);

        // The merge should preserve the token in maxWidth
        expect(merged.maxWidth?.hasToken, isTrue);
        expect(merged.minWidth?.hasValue, isTrue);
      });
    });
  });
}
