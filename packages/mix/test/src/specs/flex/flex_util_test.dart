import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexSpecUtility', () {
    late FlexSpecUtility util;

    setUp(() {
      util = FlexSpecUtility();
    });

    group('individual utility methods', () {
      test('direction utility modifies internal state', () {
        util..direction(Axis.horizontal);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(direction: Axis.horizontal));
      });

      test('mainAxisAlignment utility modifies internal state', () {
        util..mainAxisAlignment(MainAxisAlignment.center);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec,
          const FlexSpec(mainAxisAlignment: MainAxisAlignment.center),
        );
      });

      test('crossAxisAlignment utility modifies internal state', () {
        util..crossAxisAlignment(CrossAxisAlignment.stretch);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec,
          const FlexSpec(crossAxisAlignment: CrossAxisAlignment.stretch),
        );
      });

      test('mainAxisSize utility modifies internal state', () {
        util..mainAxisSize(MainAxisSize.min);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(mainAxisSize: MainAxisSize.min));
      });

      test('verticalDirection utility modifies internal state', () {
        util..verticalDirection(VerticalDirection.up);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(verticalDirection: VerticalDirection.up));
      });

      test('textDirection utility modifies internal state', () {
        util..textDirection(TextDirection.rtl);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(textDirection: TextDirection.rtl));
      });

      test('textBaseline utility modifies internal state', () {
        util..textBaseline(TextBaseline.ideographic);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(textBaseline: TextBaseline.ideographic));
      });

      test('clipBehavior utility modifies internal state', () {
        util..clipBehavior(Clip.antiAlias);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(clipBehavior: Clip.antiAlias));
      });

      test('spacing utility modifies internal state', () {
        util.spacing(16.0);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(spacing: 16.0));
      });
    });

    group('cascade chaining', () {
      test('chains multiple utility calls', () {
        util
          ..direction(Axis.horizontal)
          ..spacing(8.0);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(direction: Axis.horizontal, spacing: 8.0));
      });

      test('chains all properties together', () {
        util
          ..direction(Axis.vertical)
          ..mainAxisAlignment(MainAxisAlignment.center)
          ..crossAxisAlignment(CrossAxisAlignment.stretch)
          ..spacing(12.0);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec,
          const FlexSpec(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12.0,
          ),
        );
      });

      test('later calls override earlier ones', () {
        util
          ..direction(Axis.horizontal)
          ..direction(Axis.vertical);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(direction: Axis.vertical));
      });
    });

    group('convenience methods', () {
      test('row() returns FlexMix with horizontal direction', () {
        final result = util.row();

        expect(result, FlexMix(direction: Axis.horizontal));
      });

      test('column() returns FlexMix with vertical direction', () {
        final result = util.column();

        expect(result, FlexMix(direction: Axis.vertical));
      });
    });

    group('animation', () {
      test('animate() returns FlexMix with animation config', () {
        final animationConfig = AnimationConfig.linear(
          const Duration(seconds: 1),
        );
        final result = util.animate(animationConfig);

        expect(result, FlexMix(animation: animationConfig));
      });
    });

    group('utility construction', () {
      test('creates FlexSpecUtility with initial FlexMix', () {
        final initialMix = FlexMix(direction: Axis.horizontal);
        final utility = FlexSpecUtility(initialMix);

        final spec = utility.resolve(MockBuildContext());
        expect(spec, const FlexSpec(direction: Axis.horizontal));
      });

      test('creates empty FlexSpecUtility', () {
        final utility = FlexSpecUtility();

        final spec = utility.resolve(MockBuildContext());
        expect(spec.direction, isNull);
        expect(spec.spacing, isNull);
      });
    });

    group('merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('merge with another FlexSpecUtility creates new instance', () {
        final other = FlexSpecUtility(FlexMix(direction: Axis.horizontal));
        final result = util.merge(other);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexSpecUtility>());

        final spec = result.resolve(MockBuildContext());
        expect(spec, const FlexSpec(direction: Axis.horizontal));
      });

      test('merge with FlexMix creates new instance', () {
        final otherMix = FlexMix(spacing: 8.0);
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexSpecUtility>());

        final spec = result.resolve(MockBuildContext());
        expect(spec, const FlexSpec(spacing: 8.0));
      });

      test('merge combines properties correctly', () {
        final util1 = FlexSpecUtility(
          FlexMix(direction: Axis.horizontal, spacing: 4.0),
        );
        final util2 = FlexSpecUtility(
          FlexMix(spacing: 8.0, clipBehavior: Clip.hardEdge),
        );

        final result = util1.merge(util2);
        final spec = result.resolve(MockBuildContext());

        expect(
          spec,
          const FlexSpec(
            direction: Axis.horizontal,
            spacing: 8.0,
            clipBehavior: Clip.hardEdge,
          ),
        );
      });

      test('handles multiple merges correctly', () {
        final util1 = FlexSpecUtility(FlexMix(direction: Axis.horizontal));
        final util2 = FlexSpecUtility(FlexMix(spacing: 8.0));
        final util3 = FlexSpecUtility(
          FlexMix(mainAxisAlignment: MainAxisAlignment.center),
        );

        final result = util1.merge(util2).merge(util3);
        final spec = result.resolve(MockBuildContext());

        expect(
          spec,
          const FlexSpec(
            direction: Axis.horizontal,
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
      });
    });

    group('resolution', () {
      test('resolves empty utility to FlexSpec with null properties', () {
        final spec = util.resolve(MockBuildContext());

        expect(spec.direction, isNull);
        expect(spec.mainAxisAlignment, isNull);
        expect(spec.spacing, isNull);
      });

      test('resolves after chaining to correct FlexSpec', () {
        util
          ..direction(Axis.vertical)
          ..mainAxisAlignment(MainAxisAlignment.center)
          ..spacing(12.0);

        final spec = util.resolve(MockBuildContext());

        expect(
          spec,
          const FlexSpec(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12.0,
          ),
        );
      });
    });

    group('resolvesTo matcher integration', () {
      test('utility resolves to correct FlexSpec with matcher', () {
        util
          ..direction(Axis.horizontal)
          ..mainAxisAlignment(MainAxisAlignment.center)
          ..spacing(8.0);

        expect(
          util,
          resolvesTo(
            const FlexSpec(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
            ),
          ),
        );
      });
    });

    group('token support', () {
      test('resolves tokens with context', () {
        const gapToken = MixToken<double>('gap');
        final context = MockBuildContext(
          tokens: {gapToken.defineValue(24.0)},
        );

        final utility = FlexSpecUtility(FlexMix.create(spacing: Prop.token(gapToken)));
        final spec = utility.resolve(context);

        expect(spec.gap, 24.0);
      });
    });

    group('variant utilities', () {
      test('on utility creates VariantAttributeBuilder', () {
        final hoverBuilder = util.on.hover;

        expect(hoverBuilder, isA<VariantAttributeBuilder<FlexSpec>>());
      });
    });

    group('modifier utilities', () {
      test('wrap utility creates modifier FlexMix', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<FlexMix>());
        expect(result.$modifier, isNotNull);
        expect(result.$modifier!.$modifiers!.length, 1);
      });
    });

    group('complex scenarios', () {
      test('combines chaining with merge', () {
        final util1 = FlexSpecUtility()
          ..direction(Axis.horizontal)
          ..spacing(4.0);
        final util2 = FlexSpecUtility()
          ..mainAxisAlignment(MainAxisAlignment.center);

        final result = util1.merge(util2);
        final spec = result.resolve(MockBuildContext());

        expect(
          spec,
          const FlexSpec(
            direction: Axis.horizontal,
            spacing: 4.0,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
      });

      test('chaining after construction with initial mix', () {
        final utility = FlexSpecUtility(FlexMix(direction: Axis.horizontal))
          ..gap(8.0)
          ..mainAxisAlignment(MainAxisAlignment.center);

        final spec = utility.resolve(MockBuildContext());

        expect(
          spec,
          const FlexSpec(
            direction: Axis.horizontal,
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
      });
    });

    group('edge cases', () {
      test('multiple property changes via chaining', () {
        util
          ..direction(Axis.horizontal)
          ..direction(Axis.vertical)
          ..gap(4.0) // deprecated, should be overridden by spacing
          ..spacing(8.0);

        final spec = util.resolve(MockBuildContext());
        expect(spec, const FlexSpec(direction: Axis.vertical, spacing: 8.0));
      });

      test('empty utility after chaining with null values', () {
        // This tests the behavior when properties are explicitly set to null
        final utility = FlexSpecUtility(FlexMix(direction: Axis.horizontal));
        final spec = utility.resolve(MockBuildContext());

        expect(spec.direction, Axis.horizontal);
        expect(spec.spacing, isNull);
      });
    });
  });
}
