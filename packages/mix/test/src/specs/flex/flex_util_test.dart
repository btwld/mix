import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexMutableStyler', () {
    late FlexMutableStyler util;

    setUp(() {
      util = FlexMutableStyler();
    });

    group('individual utility methods', () {
      test('direction utility modifies internal state', () {
        util.direction(Axis.horizontal);

        final spec = util.resolve(MockBuildContext());
        expect(spec.spec, const FlexSpec(direction: Axis.horizontal));
      });

      test('mainAxisAlignment utility modifies internal state', () {
        util.mainAxisAlignment(MainAxisAlignment.center);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec.spec,
          const FlexSpec(mainAxisAlignment: MainAxisAlignment.center),
        );
      });

      test('crossAxisAlignment utility modifies internal state', () {
        util.crossAxisAlignment(CrossAxisAlignment.stretch);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec.spec,
          const FlexSpec(crossAxisAlignment: CrossAxisAlignment.stretch),
        );
      });

      test('mainAxisSize utility modifies internal state', () {
        util.mainAxisSize(MainAxisSize.min);

        final spec = util.resolve(MockBuildContext());
        expect(spec.spec, const FlexSpec(mainAxisSize: MainAxisSize.min));
      });

      test('verticalDirection utility modifies internal state', () {
        util.verticalDirection(VerticalDirection.up);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec.spec,
          const FlexSpec(verticalDirection: VerticalDirection.up),
        );
      });

      test('textDirection utility modifies internal state', () {
        util.textDirection(TextDirection.rtl);

        final spec = util.resolve(MockBuildContext());
        expect(spec.spec, const FlexSpec(textDirection: TextDirection.rtl));
      });

      test('textBaseline utility modifies internal state', () {
        util.textBaseline(TextBaseline.ideographic);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec.spec,
          const FlexSpec(textBaseline: TextBaseline.ideographic),
        );
      });

      test('clipBehavior utility modifies internal state', () {
        util.clipBehavior(Clip.antiAlias);

        final spec = util.resolve(MockBuildContext());
        expect(spec.spec, const FlexSpec(clipBehavior: Clip.antiAlias));
      });

      test('spacing utility modifies internal state', () {
        util.spacing(16.0);

        final spec = util.resolve(MockBuildContext());
        expect(spec.spec, const FlexSpec(spacing: 16.0));
      });
    });

    group('cascade chaining', () {
      test('chains multiple utility calls', () {
        util
          ..direction(Axis.horizontal)
          ..spacing(8.0);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec.spec,
          const FlexSpec(direction: Axis.horizontal, spacing: 8.0),
        );
      });

      test('chains all properties together', () {
        util
          ..direction(Axis.vertical)
          ..mainAxisAlignment(MainAxisAlignment.center)
          ..crossAxisAlignment(CrossAxisAlignment.stretch)
          ..spacing(12.0);

        final spec = util.resolve(MockBuildContext());
        expect(
          spec.spec,
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
        expect(spec.spec, const FlexSpec(direction: Axis.vertical));
      });
    });

    group('convenience methods', () {
      test('', () {
        final result = util.row();

        expect(result, FlexStyler(direction: Axis.horizontal));
      });

      test('', () {
        final result = util.column();

        expect(result, FlexStyler(direction: Axis.vertical));
      });
    });

    group('animation', () {
      test('', () {
        final animationConfig = AnimationConfig.linear(
          const Duration(seconds: 1),
        );
        final result = util.animate(animationConfig);

        expect(result, FlexStyler(animation: animationConfig));
      });
    });

    group('utility construction', () {
      test('', () {
        final initialMix = FlexStyler(direction: Axis.horizontal);
        final utility = FlexMutableStyler(initialMix);

        final spec = utility.resolve(MockBuildContext());
        expect(spec.spec, const FlexSpec(direction: Axis.horizontal));
      });

      test('', () {
        final utility = FlexMutableStyler();

        final spec = utility.resolve(MockBuildContext());
        expect(spec.spec.direction, isNull);
        expect(spec.spec.spacing, isNull);
      });
    });

    group('merge functionality', () {
      test('merge with null returns same instance', () {
        final result = util.merge(null);
        expect(result, same(util));
      });

      test('', () {
        final other = FlexMutableStyler(FlexStyler(direction: Axis.horizontal));
        final result = util.merge(other);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexMutableStyler>());

        final spec = result.resolve(MockBuildContext());
        expect(spec.spec, const FlexSpec(direction: Axis.horizontal));
      });

      test('', () {
        final otherMix = FlexStyler(spacing: 8.0);
        final result = util.merge(otherMix);

        expect(result, isNot(same(util)));
        expect(result, isA<FlexMutableStyler>());

        final spec = result.resolve(MockBuildContext());
        expect(spec.spec, const FlexSpec(spacing: 8.0));
      });

      test('merge combines properties correctly', () {
        final util1 = FlexMutableStyler(
          FlexStyler(direction: Axis.horizontal, spacing: 4.0),
        );
        final util2 = FlexMutableStyler(
          FlexStyler(spacing: 8.0, clipBehavior: Clip.hardEdge),
        );

        final result = util1.merge(util2);
        final spec = result.resolve(MockBuildContext());

        expect(
          spec.spec,
          const FlexSpec(
            direction: Axis.horizontal,
            spacing: 8.0,
            clipBehavior: Clip.hardEdge,
          ),
        );
      });

      test('handles multiple merges correctly', () {
        final util1 = FlexMutableStyler(FlexStyler(direction: Axis.horizontal));
        final util2 = FlexMutableStyler(FlexStyler(spacing: 8.0));
        final util3 = FlexMutableStyler(
          FlexStyler(mainAxisAlignment: MainAxisAlignment.center),
        );

        final result = util1.merge(util2).merge(util3);
        final spec = result.resolve(MockBuildContext());

        expect(
          spec.spec,
          const FlexSpec(
            direction: Axis.horizontal,
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
      });
    });

    group('resolution', () {
      test('', () {
        final spec = util.resolve(MockBuildContext());

        expect(spec.spec.direction, isNull);
        expect(spec.spec.mainAxisAlignment, isNull);
        expect(spec.spec.spacing, isNull);
      });

      test('', () {
        util
          ..direction(Axis.vertical)
          ..mainAxisAlignment(MainAxisAlignment.center)
          ..spacing(12.0);

        final spec = util.resolve(MockBuildContext());

        expect(
          spec.spec,
          const FlexSpec(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12.0,
          ),
        );
      });
    });

    group('resolvesTo matcher integration', () {
      test('', () {
        util
          ..direction(Axis.horizontal)
          ..mainAxisAlignment(MainAxisAlignment.center)
          ..spacing(8.0);

        expect(
          util,
          resolvesTo(
            isA<StyleSpec<FlexSpec>>().having(
              (w) => w.spec,
              'spec',
              const FlexSpec(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8.0,
              ),
            ),
          ),
        );
      });
    });

    group('token support', () {
      test('resolves tokens with context', () {
        const gapToken = MixToken<double>('gap');
        final context = MockBuildContext(tokens: {gapToken.defineValue(24.0)});

        final utility = FlexMutableStyler(
          FlexStyler.create(spacing: Prop.token(gapToken)),
        );
        final spec = utility.resolve(context);

        expect(spec.spec.gap, 24.0);
      });
    });

    group('variant utilities', () {
      test('on utility creates VariantAttributeBuilder', () {
        final hoverBuilder = util.on.hover;

        expect(hoverBuilder, isA<VariantAttributeBuilder<FlexSpec>>());
      });
    });

    group('modifier utilities', () {
      test('', () {
        final result = util.wrap.opacity(0.5);

        expect(result, isA<FlexStyler>());
        expect(result.$modifier, isNotNull);
        expect(result.$modifier!.$modifiers!.length, 1);
      });
    });

    group('complex scenarios', () {
      test('combines chaining with merge', () {
        final util1 = FlexMutableStyler()
          ..direction(Axis.horizontal)
          ..spacing(4.0);
        final util2 = FlexMutableStyler()
          ..mainAxisAlignment(MainAxisAlignment.center);

        final result = util1.merge(util2);
        final spec = result.resolve(MockBuildContext());

        expect(
          spec.spec,
          const FlexSpec(
            direction: Axis.horizontal,
            spacing: 4.0,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        );
      });

      test('chaining after construction with initial mix', () {
        final utility =
            FlexMutableStyler(FlexStyler(direction: Axis.horizontal))
              ..gap(8.0)
              ..mainAxisAlignment(MainAxisAlignment.center);

        final spec = utility.resolve(MockBuildContext());

        expect(
          spec.spec,
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
        expect(
          spec.spec,
          const FlexSpec(direction: Axis.vertical, spacing: 8.0),
        );
      });

      test('empty utility after chaining with null values', () {
        // This tests the behavior when properties are explicitly set to null
        final utility = FlexMutableStyler(
          FlexStyler(direction: Axis.horizontal),
        );
        final spec = utility.resolve(MockBuildContext());

        expect(spec.spec.direction, Axis.horizontal);
        expect(spec.spec.spacing, isNull);
      });
    });
  });
}
