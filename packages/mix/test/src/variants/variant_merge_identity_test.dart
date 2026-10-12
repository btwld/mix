import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

enum _TestVariant with EnumVariant { primary }

void main() {
  group('VariantStyle merge identity', () {
    test(
      'keeps different variant kinds with the same display key separate',
      () {
        final cases = <(Variant, Variant)>[
          (const NamedVariant('web'), ContextVariant.web()),
          (const NamedVariant('custom'), ContextVariant('custom', (_) => true)),
          (
            const NamedVariant('widget_state_hovered'),
            WidgetStateVariant(WidgetState.hovered),
          ),
        ];

        for (final (named, contextual) in cases) {
          for (final (first, second) in [
            (named, contextual),
            (contextual, named),
          ]) {
            final firstFragment = BoxStyler().width(100.0);
            final secondFragment = BoxStyler().height(50.0);
            final merged = _withVariant(
              first,
              firstFragment,
            ).merge(_withVariant(second, secondFragment));

            expect(
              merged.$variants,
              hasLength(2),
              reason:
                  '${first.runtimeType} and ${second.runtimeType} both use '
                  'the display key "${first.key}"',
            );
            expect(merged.$variants![0].variant, same(first));
            expect(merged.$variants![0].value, same(firstFragment));
            expect(merged.$variants![1].variant, same(second));
            expect(merged.$variants![1].value, same(secondFragment));
          }
        }
      },
    );

    test('keeps same-label context predicates independently active', () {
      var firstActive = true;
      var secondActive = false;
      final first = ContextVariant('shared', (_) => firstActive);
      final second = ContextVariant('shared', (_) => secondActive);
      final merged = _withVariant(
        first,
        BoxStyler().width(100.0),
      ).merge(_withVariant(second, BoxStyler().height(50.0)));
      final context = MockBuildContext();

      expect(merged.$variants!.map((entry) => entry.variant), [first, second]);
      final reused = _withVariant(
        first,
        BoxStyler().width(100.0),
      ).merge(_withVariant(first, BoxStyler().height(50.0)));
      expect(reused.$variants, hasLength(1));

      final firstResult = merged
          .mergeActiveVariants(context, namedVariants: const {})
          .resolve(context)
          .constraints;
      expect(firstResult?.minWidth, 100.0);
      expect(firstResult?.maxWidth, 100.0);
      expect(firstResult?.maxHeight, double.infinity);

      firstActive = false;
      secondActive = true;
      final secondResult = merged
          .mergeActiveVariants(context, namedVariants: const {})
          .resolve(context)
          .constraints;
      expect(secondResult?.maxWidth, double.infinity);
      expect(secondResult?.minHeight, 50.0);
      expect(secondResult?.maxHeight, 50.0);
    });

    test('uses builder function equality in a separate namespace', () {
      BoxStyler firstBuilder(BuildContext _) => BoxStyler().width(100.0);
      BoxStyler secondBuilder(BuildContext _) => BoxStyler().height(50.0);

      final first = ContextVariantBuilder<BoxStyler>(firstBuilder);
      final second = ContextVariantBuilder<BoxStyler>(secondBuilder);
      final sameFunction = ContextVariantBuilder<BoxStyler>(firstBuilder);

      expect(_mergeKey(first), equals(_mergeKey(sameFunction)));
      expect(_mergeKey(first), isNot(equals(_mergeKey(second))));

      final distinctBuilders = _withVariant(
        first,
        BoxStyler().width(100.0),
      ).merge(_withVariant(second, BoxStyler().height(50.0)));
      expect(distinctBuilders.$variants, hasLength(2));

      final sameBuilders = _withVariant(
        first,
        BoxStyler().width(100.0),
      ).merge(_withVariant(sameFunction, BoxStyler().height(50.0)));
      expect(sameBuilders.$variants, hasLength(1));

      final namedWithBuilderKey = NamedVariant(first.key);

      for (final (left, right) in <(Variant, Variant)>[
        (first, namedWithBuilderKey),
        (namedWithBuilderKey, first),
      ]) {
        final merged = _withVariant(
          left,
          BoxStyler().width(100.0),
        ).merge(_withVariant(right, BoxStyler().height(50.0)));
        expect(merged.$variants, hasLength(2));
      }
    });

    test('distinct builders execute and their returned styles merge', () {
      var firstCalls = 0;
      var secondCalls = 0;
      final first = BoxStyler().onBuilder((_) {
        firstCalls++;

        return BoxStyler().width(100.0);
      });
      final second = BoxStyler().onBuilder((_) {
        secondCalls++;

        return BoxStyler().height(50.0);
      });
      final context = MockBuildContext();

      final constraints = first
          .merge(second)
          .mergeActiveVariants(context, namedVariants: const {})
          .resolve(context)
          .constraints;

      expect(firstCalls, 1);
      expect(secondCalls, 1);
      expect(constraints?.minWidth, 100.0);
      expect(constraints?.maxWidth, 100.0);
      expect(constraints?.minHeight, 50.0);
      expect(constraints?.maxHeight, 50.0);
    });

    test('reused builder function keeps execute-once behavior', () {
      var calls = 0;
      BoxStyler builder(BuildContext _) {
        calls++;

        return BoxStyler().width(100.0);
      }

      final first = BoxStyler().onBuilder(builder);
      final second = BoxStyler().onBuilder(builder);
      final merged = first.merge(second);
      final context = MockBuildContext();

      expect(merged.$variants, hasLength(1));
      final constraints = merged
          .mergeActiveVariants(context, namedVariants: const {})
          .resolve(context)
          .constraints;

      expect(calls, 1);
      expect(constraints?.minWidth, 100.0);
      expect(constraints?.maxWidth, 100.0);
    });

    test('normalizes named and enum variants while preserving precedence', () {
      const named = NamedVariant('primary');
      const cases = <(Variant, Variant)>[
        (NamedVariant('primary'), NamedVariant('primary')),
        (named, _TestVariant.primary),
        (_TestVariant.primary, named),
      ];
      final context = MockBuildContext();

      for (final (first, second) in cases) {
        final merged = _withVariant(
          first,
          BoxStyler().width(100.0).height(40.0),
        ).merge(_withVariant(second, BoxStyler().width(200.0)));

        expect(merged.$variants, hasLength(1));
        expect(merged.$variants!.single.variant, same(first));
        final constraints = merged.$variants!.single.value
            .resolve(context)
            .constraints;
        expect(constraints?.minWidth, 200.0);
        expect(constraints?.maxWidth, 200.0);
        expect(constraints?.minHeight, 40.0);
        expect(constraints?.maxHeight, 40.0);
      }
    });

    test('coalesces equivalent built-in context variants', () {
      const breakpoint = Breakpoint(minWidth: 400.0, maxWidth: 800.0);
      final cases = <(ContextVariant, ContextVariant)>[
        (
          ContextVariant.widgetState(WidgetState.hovered),
          ContextVariant.widgetState(WidgetState.hovered),
        ),
        (
          ContextVariant.brightness(Brightness.dark),
          ContextVariant.brightness(Brightness.dark),
        ),
        (
          ContextVariant.breakpoint(breakpoint),
          ContextVariant.breakpoint(breakpoint),
        ),
        (
          ContextVariant.orientation(Orientation.portrait),
          ContextVariant.orientation(Orientation.portrait),
        ),
        (
          ContextVariant.directionality(TextDirection.ltr),
          ContextVariant.directionality(TextDirection.ltr),
        ),
        (
          ContextVariant.platform(TargetPlatform.macOS),
          ContextVariant.platform(TargetPlatform.macOS),
        ),
        (ContextVariant.web(), ContextVariant.web()),
        (
          ContextVariant.not(ContextVariant.web()),
          ContextVariant.not(ContextVariant.web()),
        ),
      ];
      final context = MockBuildContext();

      for (final (first, second) in cases) {
        final merged = _withVariant(
          first,
          BoxStyler().width(100.0),
        ).merge(_withVariant(second, BoxStyler().height(50.0)));

        expect(
          merged.$variants,
          hasLength(1),
          reason: '${first.runtimeType} should have value equality',
        );
        expect(merged.$variants!.single.variant, same(first));
        final constraints = merged.$variants!.single.value
            .resolve(context)
            .constraints;
        expect(constraints?.minWidth, 100.0);
        expect(constraints?.maxWidth, 100.0);
        expect(constraints?.minHeight, 50.0);
        expect(constraints?.maxHeight, 50.0);
      }
    });

    test('direct incompatible merge reports both variants', () {
      final named = VariantStyle<BoxSpec>(
        const NamedVariant('web'),
        BoxStyler().width(100.0),
      );
      final contextual = VariantStyle<BoxSpec>(
        ContextVariant.web(),
        BoxStyler().height(50.0),
      );

      for (final (first, second)
          in <(VariantStyle<BoxSpec>, VariantStyle<BoxSpec>)>[
            (named, contextual),
            (contextual, named),
          ]) {
        expect(
          () => first.merge(second),
          throwsA(
            isA<ArgumentError>().having(
              (error) => error.message,
              'message',
              allOf(
                contains('NamedVariant'),
                contains('WebVariant'),
                contains('"web"'),
              ),
            ),
          ),
        );
      }
    });
  });
}

BoxStyler _withVariant(Variant variant, BoxStyler fragment) {
  return BoxStyler(variants: [VariantStyle<BoxSpec>(variant, fragment)]);
}

Object _mergeKey(Variant variant) {
  return VariantStyle<BoxSpec>(variant, BoxStyler()).mergeKey;
}
