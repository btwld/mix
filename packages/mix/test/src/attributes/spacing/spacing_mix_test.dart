import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('EdgeInsetsMix', () {
    group('constructor', () {
      test('only factory assigns properties correctly', () {
        final mix = EdgeInsetsMix.only(
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
        final mix = EdgeInsetsMix(
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
        final mix = EdgeInsetsMix.value(edgeInsets);

        expect(mix, resolvesTo(edgeInsets));
      });

      test('.maybeValue handles null correctly', () {
        expect(EdgeInsetsMix.maybeValue(null), isNull);
        expect(EdgeInsetsMix.maybeValue(const EdgeInsets.all(10.0)), isNotNull);
      });

      test('.all creates uniform EdgeInsets', () {
        final mix = EdgeInsetsMix.all(10.0);

        expect(mix, resolvesTo(const EdgeInsets.all(10.0)));
      });

      test('.none creates zero EdgeInsets', () {
        final mix = EdgeInsetsMix.none();

        expect(mix, resolvesTo(EdgeInsets.zero));
      });

      test('only factory with specific values', () {
        final mix = EdgeInsetsMix.only(top: 10.0, left: 20.0);

        expect(mix, resolvesTo(const EdgeInsets.only(top: 10.0, left: 20.0)));
      });
    });

    group('resolve', () {
      test('returns correct EdgeInsets', () {
        final mix = EdgeInsetsMix.only(
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
        final mix = EdgeInsetsMix.only(top: 10.0); // other properties are null

        expect(mix, resolvesTo(const EdgeInsets.only(top: 10.0)));
      });

      test('handles all-null DTO', () {
        final mix = EdgeInsetsMix();

        expect(mix, resolvesTo(EdgeInsets.zero));
      });
    });

    group('merge', () {
      test('correctly combines properties', () {
        final base = EdgeInsetsMix.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );
        final override = EdgeInsetsMix.only(
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
        final mix = EdgeInsetsMix.only(top: 10.0);
        expect(mix.merge(null), same(mix));
      });

      test('preserves unspecified properties', () {
        final base = EdgeInsetsMix.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );
        final override = EdgeInsetsMix.only(top: 5.0);

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
        final mix1 = EdgeInsetsMix.only(top: 10.0, left: 20.0);
        final mix2 = EdgeInsetsMix.only(top: 10.0, left: 20.0);

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equals with different values', () {
        final mix1 = EdgeInsetsMix.only(top: 10.0);
        final mix2 = EdgeInsetsMix.only(top: 20.0);

        expect(mix1, isNot(equals(mix2)));
      });
    });

    group('token resolution', () {
      testWidgets('resolves tokens from context', (tester) async {
        const spaceToken = MixToken<double>('test-space');
        final mix = EdgeInsetsMix(
          top: Prop.token(spaceToken),
          left: Prop(20.0),
        );

        await tester.pumpWithMixScope(
          Container(),
          theme: MixScopeData.static(tokens: {spaceToken: 10.0}),
        );

        expect(mix, resolvesTo(const EdgeInsets.only(top: 10.0, left: 20.0)));
      });

      test('handles missing tokens gracefully', () {
        const token = MixToken<double>('undefined');
        final mix = EdgeInsetsMix(top: Prop.token(token));

        expect(() => mix.resolve(MockBuildContext()), throwsStateError);
      });
    });
  });

  group('EdgeInsetsDirectionalMix', () {
    group('constructor', () {
      test('only factory assigns properties correctly', () {
        final mix = EdgeInsetsDirectionalMix.only(
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
        final mix = EdgeInsetsDirectionalMix(
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
        final mix = EdgeInsetsDirectionalMix.value(edgeInsets);

        expect(mix, resolvesTo(edgeInsets));
      });

      test('.maybeValue handles null correctly', () {
        expect(EdgeInsetsDirectionalMix.maybeValue(null), isNull);
        expect(
          EdgeInsetsDirectionalMix.maybeValue(
            const EdgeInsetsDirectional.all(10.0),
          ),
          isNotNull,
        );
      });

      test('.all creates uniform EdgeInsetsDirectional', () {
        final mix = EdgeInsetsDirectionalMix.all(10.0);

        expect(mix, resolvesTo(const EdgeInsetsDirectional.all(10.0)));
      });

      test('.none creates zero EdgeInsetsDirectional', () {
        final mix = EdgeInsetsDirectionalMix.none();

        expect(mix, resolvesTo(EdgeInsetsDirectional.zero));
      });

      test('only factory with specific values', () {
        final mix = EdgeInsetsDirectionalMix.only(top: 10.0, start: 20.0);

        expect(
          dto,
          resolvesTo(const EdgeInsetsDirectional.only(top: 10.0, start: 20.0)),
        );
      });
    });

    group('resolve', () {
      test('returns correct EdgeInsetsDirectional', () {
        final mix = EdgeInsetsDirectionalMix.only(
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
        final mix = EdgeInsetsDirectionalMix.only(
          top: 10.0,
        ); // other properties are null

        expect(mix, resolvesTo(const EdgeInsetsDirectional.only(top: 10.0)));
      });

      test('handles all-null DTO', () {
        final mix = EdgeInsetsDirectionalMix();

        expect(mix, resolvesTo(EdgeInsetsDirectional.zero));
      });
    });

    group('merge', () {
      test('correctly combines properties', () {
        final base = EdgeInsetsDirectionalMix.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );
        final override = EdgeInsetsDirectionalMix.only(
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
        final mix = EdgeInsetsDirectionalMix.only(top: 10.0);
        expect(mix.merge(null), same(mix));
      });

      test('preserves unspecified properties', () {
        final base = EdgeInsetsDirectionalMix.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );
        final override = EdgeInsetsDirectionalMix.only(top: 5.0);

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
        final mix1 = EdgeInsetsDirectionalMix.only(top: 10.0, start: 20.0);
        final mix2 = EdgeInsetsDirectionalMix.only(top: 10.0, start: 20.0);

        expect(mix1, equals(mix2));
        expect(mix1.hashCode, equals(mix2.hashCode));
      });

      test('not equals with different values', () {
        final mix1 = EdgeInsetsDirectionalMix.only(top: 10.0);
        final mix2 = EdgeInsetsDirectionalMix.only(top: 20.0);

        expect(mix1, isNot(equals(mix2)));
      });
    });

    group('token resolution', () {
      testWidgets('resolves tokens from context', (tester) async {
        const spaceToken = MixToken<double>('test-space');
        final mix = EdgeInsetsDirectionalMix(
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
        final mix = EdgeInsetsDirectionalMix(top: Prop.token(token));

        expect(() => mix.resolve(MockBuildContext()), throwsStateError);
      });
    });
  });

  group('EdgeInsetsGeometryMix', () {
    group('static factories', () {
      test('.value creates appropriate DTO type', () {
        const edgeInsets = EdgeInsets.all(10.0);
        const directional = EdgeInsetsDirectional.all(20.0);

        final mix1 = EdgeInsetsGeometryMix.value(edgeInsets);
        final mix2 = EdgeInsetsGeometryMix.value(directional);

        expect(mix1, isA<EdgeInsetsMix>());
        expect(mix2, isA<EdgeInsetsDirectionalMix>());
        expect(mix1, resolvesTo(edgeInsets));
        expect(mix2, resolvesTo(directional));
      });

      test('.maybeValue handles null correctly', () {
        expect(EdgeInsetsGeometryMix.maybeValue(null), isNull);
        expect(
          EdgeInsetsGeometryMix.maybeValue(const EdgeInsets.all(10.0)),
          isNotNull,
        );
      });

      test('.only creates EdgeInsetsMix for left/right', () {
        final mix = EdgeInsetsGeometryMix.only(
          top: 10.0,
          left: 20.0,
          right: 30.0,
        );

        expect(mix, isA<EdgeInsetsMix>());
        expect(
          dto,
          resolvesTo(const EdgeInsets.only(top: 10.0, left: 20.0, right: 30.0)),
        );
      });

      test('.only creates EdgeInsetsDirectionalMix for start/end', () {
        final mix = EdgeInsetsGeometryMix.only(
          top: 10.0,
          start: 20.0,
          end: 30.0,
        );

        expect(mix, isA<EdgeInsetsDirectionalMix>());
        expect(
          dto,
          resolvesTo(
            const EdgeInsetsDirectional.only(top: 10.0, start: 20.0, end: 30.0),
          ),
        );
      });

      test('.only throws assertion error for mixed directional', () {
        expect(
          () => EdgeInsetsGeometryMix.only(
            left: 10.0,
            start: 20.0, // Cannot mix left/right with start/end
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('cross-type merging', () {
      test('EdgeInsetsMix merges with EdgeInsetsDirectionalMix', () {
        final edgeInsets = EdgeInsetsMix.only(
          top: 10.0,
          bottom: 20.0,
          left: 30.0,
          right: 40.0,
        );
        final directional = EdgeInsetsDirectionalMix.only(
          top: 5.0,
          start: 15.0,
        );

        final merged = EdgeInsetsGeometryMix.tryToMerge(
          edgeInsets,
          directional,
        );

        expect(merged, isA<EdgeInsetsDirectionalMix>());
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

      test('EdgeInsetsDirectionalMix merges with EdgeInsetsMix', () {
        final directional = EdgeInsetsDirectionalMix.only(
          top: 10.0,
          bottom: 20.0,
          start: 30.0,
          end: 40.0,
        );
        final edgeInsets = EdgeInsetsMix.only(top: 5.0, left: 15.0);

        final merged = EdgeInsetsGeometryMix.tryToMerge(
          directional,
          edgeInsets,
        );

        expect(merged, isA<EdgeInsetsMix>());
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
        final mix1 = EdgeInsetsMix.only(top: 10.0, left: 20.0);
        final mix2 = EdgeInsetsMix.only(top: 5.0, right: 30.0);

        final merged = EdgeInsetsGeometryMix.tryToMerge(mix1, mix2);

        expect(merged, isA<EdgeInsetsMix>());
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
        final mix = EdgeInsetsMix.only(top: 10.0);
        final merged = EdgeInsetsGeometryMix.tryToMerge(null, dto);

        expect(merged, same(mix));
      });

      test('returns first when second is null', () {
        final mix = EdgeInsetsMix.only(top: 10.0);
        final merged = EdgeInsetsGeometryMix.tryToMerge(mix, null);

        expect(merged, same(mix));
      });

      test('returns null when both are null', () {
        final merged = EdgeInsetsGeometryMix.tryToMerge(null, null);

        expect(merged, isNull);
      });
    });
  });

  // Legacy test for backward compatibility
  group('SpacingDto (legacy)', () {
    test('resolves to EdgeInsets.only with correct values', () {
      final spacingDto = EdgeInsetsGeometryMix.only(
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
      final spacingDto1 = EdgeInsetsGeometryMix.only(
        top: 10,
        bottom: 20,
        left: 30,
        right: 40,
      );
      final spacingDto2 = EdgeInsetsGeometryMix.only(
        top: 5,
        bottom: 15,
        left: 25,
        right: 35,
      );
      final mergedSpacingDto = spacingDto1.merge(spacingDto2);
      expect(
        mergedSpacingDto,
        EdgeInsetsGeometryMix.only(top: 5, bottom: 15, left: 25, right: 35),
      );
    });
  });
}
