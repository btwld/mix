import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('EdgeInsetsDto', () {
    group('constructor', () {
      test('only factory assigns properties correctly', () {
        final dto = EdgeInsetsDto.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );

        expect(
          dto,
          resolvesTo(
            const EdgeInsets.only(
              top: 10.0,
              bottom: 20.0,
              left: 30.0,
              right: 40.0,
            ),
          ),
        );
      });

      test('main constructor assigns properties correctly', () {
        final dto = EdgeInsetsDto(
          top: Prop(10.0),
          bottom: Prop(20.0),
          left: Prop(30.0),
          right: Prop(40.0),
        );

        expect(
          dto,
          resolvesTo(
            const EdgeInsets.only(
              top: 10.0,
              bottom: 20.0,
              left: 30.0,
              right: 40.0,
            ),
          ),
        );
      });

      test('.value factory creates from Flutter type', () {
        const edgeInsets = EdgeInsets.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );
        final dto = EdgeInsetsDto.value(edgeInsets);

        expect(dto, resolvesTo(edgeInsets));
      });

      test('.maybeValue handles null correctly', () {
        expect(EdgeInsetsDto.maybeValue(null), isNull);
        expect(EdgeInsetsDto.maybeValue(const EdgeInsets.all(10.0)), isNotNull);
      });

      test('.all creates uniform EdgeInsets', () {
        final dto = EdgeInsetsDto.all(10.0);

        expect(dto, resolvesTo(const EdgeInsets.all(10.0)));
      });

      test('.none creates zero EdgeInsets', () {
        final dto = EdgeInsetsDto.none();

        expect(dto, resolvesTo(EdgeInsets.zero));
      });

      test('only factory with specific values', () {
        final dto = EdgeInsetsDto.only(top: 10.0, left: 20.0);

        expect(dto, resolvesTo(const EdgeInsets.only(top: 10.0, left: 20.0)));
      });
    });

    group('resolve', () {
      test('returns correct EdgeInsets', () {
        final dto = EdgeInsetsDto.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );

        expect(
          dto,
          resolvesTo(
            const EdgeInsets.only(
              top: 10.0,
              bottom: 20.0,
              left: 30.0,
              right: 40.0,
            ),
          ),
        );
      });

      test('uses default values for null properties', () {
        final dto = EdgeInsetsDto.only(top: 10.0); // other properties are null

        expect(dto, resolvesTo(const EdgeInsets.only(top: 10.0)));
      });

      test('handles all-null DTO', () {
        final dto = EdgeInsetsDto();

        expect(dto, resolvesTo(EdgeInsets.zero));
      });
    });

    group('merge', () {
      test('correctly combines properties', () {
        final base = EdgeInsetsDto.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );
        final override = EdgeInsetsDto.only(
          top: 5.0,
          left: 15.0,
        ); // bottom and right not specified

        final merged = base.merge(override);

        expect(
          merged,
          resolvesTo(
            const EdgeInsets.only(
              top: 5.0, // From override
              bottom: 20.0, // Preserved from base
              left: 15.0, // From override
              right: 40.0, // Preserved from base
            ),
          ),
        );
      });

      test('returns self when merging with null', () {
        final dto = EdgeInsetsDto.only(top: 10.0);
        expect(dto.merge(null), same(dto));
      });

      test('preserves unspecified properties', () {
        final base = EdgeInsetsDto.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );
        final override = EdgeInsetsDto.only(top: 5.0);

        final merged = base.merge(override);

        expect(
          merged,
          resolvesTo(
            const EdgeInsets.only(
              top: 5.0, // Overridden
              bottom: 20.0, // Preserved
              left: 30.0, // Preserved
              right: 40.0, // Preserved
            ),
          ),
        );
      });
    });

    group('equality', () {
      test('equals with same values', () {
        final dto1 = EdgeInsetsDto.only(top: 10.0, left: 20.0);
        final dto2 = EdgeInsetsDto.only(top: 10.0, left: 20.0);

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equals with different values', () {
        final dto1 = EdgeInsetsDto.only(top: 10.0);
        final dto2 = EdgeInsetsDto.only(top: 20.0);

        expect(dto1, isNot(equals(dto2)));
      });
    });

    group('token resolution', () {
      testWidgets('resolves tokens from context', (tester) async {
        const spaceToken = MixToken<double>('test-space');
        final dto = EdgeInsetsDto(
          top: Prop.token(spaceToken),
          left: Prop(20.0),
        );

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(tokens: {spaceToken: 10.0}),
        );

        expect(dto, resolvesTo(const EdgeInsets.only(top: 10.0, left: 20.0)));
      });

      test('handles missing tokens gracefully', () {
        const token = MixToken<double>('undefined');
        final dto = EdgeInsetsDto(top: Prop.token(token));

        expect(() => dto.resolve(MockBuildContext()), throwsStateError);
      });
    });
  });

  group('EdgeInsetsDirectionalDto', () {
    group('constructor', () {
      test('only factory assigns properties correctly', () {
        final dto = EdgeInsetsDirectionalDto.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );

        expect(
          dto,
          resolvesTo(
            const EdgeInsetsDirectional.only(
              top: 10.0,
              bottom: 20.0,
              start: 30.0,
              end: 40.0,
            ),
          ),
        );
      });

      test('main constructor assigns properties correctly', () {
        final dto = EdgeInsetsDirectionalDto(
          top: Prop(10.0),
          bottom: Prop(20.0),
          start: Prop(30.0),
          end: Prop(40.0),
        );

        expect(
          dto,
          resolvesTo(
            const EdgeInsetsDirectional.only(
              top: 10.0,
              bottom: 20.0,
              start: 30.0,
              end: 40.0,
            ),
          ),
        );
      });

      test('.value factory creates from Flutter type', () {
        const edgeInsets = EdgeInsetsDirectional.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );
        final dto = EdgeInsetsDirectionalDto.value(edgeInsets);

        expect(dto, resolvesTo(edgeInsets));
      });

      test('.maybeValue handles null correctly', () {
        expect(EdgeInsetsDirectionalDto.maybeValue(null), isNull);
        expect(
          EdgeInsetsDirectionalDto.maybeValue(
            const EdgeInsetsDirectional.all(10.0),
          ),
          isNotNull,
        );
      });

      test('.all creates uniform EdgeInsetsDirectional', () {
        final dto = EdgeInsetsDirectionalDto.all(10.0);

        expect(dto, resolvesTo(const EdgeInsetsDirectional.all(10.0)));
      });

      test('.none creates zero EdgeInsetsDirectional', () {
        final dto = EdgeInsetsDirectionalDto.none();

        expect(dto, resolvesTo(EdgeInsetsDirectional.zero));
      });

      test('only factory with specific values', () {
        final dto = EdgeInsetsDirectionalDto.only(top: 10.0, start: 20.0);

        expect(
          dto,
          resolvesTo(const EdgeInsetsDirectional.only(top: 10.0, start: 20.0)),
        );
      });
    });

    group('resolve', () {
      test('returns correct EdgeInsetsDirectional', () {
        final dto = EdgeInsetsDirectionalDto.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );

        expect(
          dto,
          resolvesTo(
            const EdgeInsetsDirectional.only(
              top: 10.0,
              bottom: 20.0,
              start: 30.0,
              end: 40.0,
            ),
          ),
        );
      });

      test('uses default values for null properties', () {
        final dto = EdgeInsetsDirectionalDto.only(
          top: 10.0,
        ); // other properties are null

        expect(dto, resolvesTo(const EdgeInsetsDirectional.only(top: 10.0)));
      });

      test('handles all-null DTO', () {
        final dto = EdgeInsetsDirectionalDto();

        expect(dto, resolvesTo(EdgeInsetsDirectional.zero));
      });
    });

    group('merge', () {
      test('correctly combines properties', () {
        final base = EdgeInsetsDirectionalDto.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );
        final override = EdgeInsetsDirectionalDto.only(
          top: 5.0,
          start: 15.0,
        ); // bottom and end not specified

        final merged = base.merge(override);

        expect(
          merged,
          resolvesTo(
            const EdgeInsetsDirectional.only(
              top: 5.0, // From override
              bottom: 20.0, // Preserved from base
              start: 15.0, // From override
              end: 40.0, // Preserved from base
            ),
          ),
        );
      });

      test('returns self when merging with null', () {
        final dto = EdgeInsetsDirectionalDto.only(top: 10.0);
        expect(dto.merge(null), same(dto));
      });

      test('preserves unspecified properties', () {
        final base = EdgeInsetsDirectionalDto.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );
        final override = EdgeInsetsDirectionalDto.only(top: 5.0);

        final merged = base.merge(override);

        expect(
          merged,
          resolvesTo(
            const EdgeInsetsDirectional.only(
              top: 5.0, // Overridden
              bottom: 20.0, // Preserved
              start: 30.0, // Preserved
              end: 40.0, // Preserved
            ),
          ),
        );
      });
    });

    group('equality', () {
      test('equals with same values', () {
        final dto1 = EdgeInsetsDirectionalDto.only(top: 10.0, start: 20.0);
        final dto2 = EdgeInsetsDirectionalDto.only(top: 10.0, start: 20.0);

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('not equals with different values', () {
        final dto1 = EdgeInsetsDirectionalDto.only(top: 10.0);
        final dto2 = EdgeInsetsDirectionalDto.only(top: 20.0);

        expect(dto1, isNot(equals(dto2)));
      });
    });

    group('token resolution', () {
      testWidgets('resolves tokens from context', (tester) async {
        const spaceToken = MixToken<double>('test-space');
        final dto = EdgeInsetsDirectionalDto(
          top: Prop.token(spaceToken),
          start: Prop(20.0),
        );

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(tokens: {spaceToken: 10.0}),
        );

        expect(
          dto,
          resolvesTo(const EdgeInsetsDirectional.only(top: 10.0, start: 20.0)),
        );
      });

      test('handles missing tokens gracefully', () {
        const token = MixToken<double>('undefined');
        final dto = EdgeInsetsDirectionalDto(top: Prop.token(token));

        expect(() => dto.resolve(MockBuildContext()), throwsStateError);
      });
    });
  });

  group('EdgeInsetsGeometryDto', () {
    group('static factories', () {
      test('.value creates appropriate DTO type', () {
        const edgeInsets = EdgeInsets.all(10.0);
        const directional = EdgeInsetsDirectional.all(20.0);

        final dto1 = EdgeInsetsGeometryDto.value(edgeInsets);
        final dto2 = EdgeInsetsGeometryDto.value(directional);

        expect(dto1, isA<EdgeInsetsDto>());
        expect(dto2, isA<EdgeInsetsDirectionalDto>());
        expect(dto1, resolvesTo(edgeInsets));
        expect(dto2, resolvesTo(directional));
      });

      test('.maybeValue handles null correctly', () {
        expect(EdgeInsetsGeometryDto.maybeValue(null), isNull);
        expect(
          EdgeInsetsGeometryDto.maybeValue(const EdgeInsets.all(10.0)),
          isNotNull,
        );
      });

      test('.only creates EdgeInsetsDto for left/right', () {
        final dto = EdgeInsetsGeometryDto.only(
          top: 10.0,
          left: 20.0,
          right: 30.0,
        );

        expect(dto, isA<EdgeInsetsDto>());
        expect(
          dto,
          resolvesTo(const EdgeInsets.only(top: 10.0, left: 20.0, right: 30.0)),
        );
      });

      test('.only creates EdgeInsetsDirectionalDto for start/end', () {
        final dto = EdgeInsetsGeometryDto.only(
          top: 10.0,
          start: 20.0,
          end: 30.0,
        );

        expect(dto, isA<EdgeInsetsDirectionalDto>());
        expect(
          dto,
          resolvesTo(
            const EdgeInsetsDirectional.only(top: 10.0, start: 20.0, end: 30.0),
          ),
        );
      });

      test('.only throws assertion error for mixed directional', () {
        expect(
          () => EdgeInsetsGeometryDto.only(
            left: 10.0,
            start: 20.0, // Cannot mix left/right with start/end
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('cross-type merging', () {
      test('EdgeInsetsDto merges with EdgeInsetsDirectionalDto', () {
        final edgeInsets = EdgeInsetsDto.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );
        final directional = EdgeInsetsDirectionalDto.only(
          top: 5.0,
          start: 15.0,
        );

        final merged = EdgeInsetsGeometryDto.tryToMerge(
          edgeInsets,
          directional,
        );

        expect(merged, isA<EdgeInsetsDirectionalDto>());
        expect(
          merged,
          resolvesTo(
            const EdgeInsetsDirectional.only(
              top: 5.0, // From directional (overrides)
              bottom: 20.0, // From edgeInsets (preserved)
              start: 15.0, // From directional
              end: 0.0, // Default (edgeInsets.right not converted)
            ),
          ),
        );
      });

      test('EdgeInsetsDirectionalDto merges with EdgeInsetsDto', () {
        final directional = EdgeInsetsDirectionalDto.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );
        final edgeInsets = EdgeInsetsDto.only(top: 5.0, left: 15.0);

        final merged = EdgeInsetsGeometryDto.tryToMerge(
          directional,
          edgeInsets,
        );

        expect(merged, isA<EdgeInsetsDto>());
        expect(
          merged,
          resolvesTo(
            const EdgeInsets.only(
              top: 5.0, // From edgeInsets (overrides)
              bottom: 20.0, // From directional (preserved)
              left: 15.0, // From edgeInsets
              right: 0.0, // Default (directional.end not converted)
            ),
          ),
        );
      });

      test('same type merging works normally', () {
        final dto1 = EdgeInsetsDto.only(top: 10.0, left: 20.0);
        final dto2 = EdgeInsetsDto.only(top: 5.0, right: 30.0);

        final merged = EdgeInsetsGeometryDto.tryToMerge(dto1, dto2);

        expect(merged, isA<EdgeInsetsDto>());
        expect(
          merged,
          resolvesTo(
            const EdgeInsets.only(
              top: 5.0, // From dto2
              left: 20.0, // From dto1 (preserved)
              right: 30.0, // From dto2
            ),
          ),
        );
      });

      test('returns second when first is null', () {
        final dto = EdgeInsetsDto.only(top: 10.0);
        final merged = EdgeInsetsGeometryDto.tryToMerge(null, dto);

        expect(merged, same(dto));
      });

      test('returns first when second is null', () {
        final dto = EdgeInsetsDto.only(top: 10.0);
        final merged = EdgeInsetsGeometryDto.tryToMerge(dto, null);

        expect(merged, same(dto));
      });

      test('returns null when both are null', () {
        final merged = EdgeInsetsGeometryDto.tryToMerge(null, null);

        expect(merged, isNull);
      });
    });
  });

  // Legacy test for backward compatibility
  group('SpacingDto (legacy)', () {
    test('resolves to EdgeInsets.only with correct values', () {
      final spacingDto = EdgeInsetsGeometryDto.only(
        top: 10,
        bottom: 20,
        left: 30,
        right: 40,
      );

      expect(
        spacingDto,
        resolvesTo(
          const EdgeInsets.only(left: 30, top: 10, right: 40, bottom: 20),
        ),
      );
    });

    test('merges correctly with another SpacingDto', () {
      final spacingDto1 = EdgeInsetsGeometryDto.only(
        top: 10,
        bottom: 20,
        left: 30,
        right: 40,
      );
      final spacingDto2 = EdgeInsetsGeometryDto.only(
        top: 5,
        bottom: 15,
        left: 25,
        right: 35,
      );
      final mergedSpacingDto = spacingDto1.merge(spacingDto2);
      expect(
        mergedSpacingDto,
        EdgeInsetsGeometryDto.only(top: 5, bottom: 15, left: 25, right: 35),
      );
    });
  });
}
