import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  test('focus-visible has a canonical v1 representation', () {
    final style = BoxStyler().onFocusVisible(
      BoxStyler().color(const Color(0xFF123456)),
    );
    final encoded = _encode(style);
    final variants = encoded['variants']! as List;
    expect((variants.single as JsonMap)['kind'], 'context_focus_visible');
    expect(_encode(_decode(encoded)), encoded);
  });

  test('negated focus-visible keeps its selector', () {
    final style = BoxStyler.create(
      variants: [
        VariantStyle(
          ContextVariant.not(ContextVariant.focusVisible()),
          BoxStyler().color(const Color(0xFF123456)),
        ),
      ],
    );
    final encoded = _encode(style);
    final variant = (encoded['variants']! as List).single as JsonMap;
    expect(variant['kind'], 'context_not');
    expect(variant['variant'], {'kind': 'context_focus_visible'});
    expect(_encode(_decode(encoded)), encoded);
  });

  testWidgets('focus-visible preserves modality, overrides, and breakpoints', (
    tester,
  ) async {
    final manager = FocusManager.instance;
    final previous = manager.highlightStrategy;
    addTearDown(() => manager.highlightStrategy = previous);
    const base = Color(0xFF0000FF);
    const active = Color(0xFFFF0000);
    for (final negate in [false, true]) {
      final selector = ContextVariant.focusVisible();
      final original = BoxStyler.create(
        variants: [
          VariantStyle(
            ContextVariant.breakpoint(const Breakpoint(minWidth: 600)),
            BoxStyler.create(
              variants: [
                VariantStyle(
                  negate ? ContextVariant.not(selector) : selector,
                  BoxStyler().color(active),
                ),
              ],
            ),
          ),
        ],
      ).color(base);
      final decoded = _decode(_encode(original));
      for (final traditional in [false, true]) {
        manager.highlightStrategy = traditional
            ? FocusHighlightStrategy.alwaysTraditional
            : FocusHighlightStrategy.alwaysTouch;
        for (final focused in [false, true]) {
          for (final forced in <bool?>[null, false, true]) {
            for (final width in [480.0, 768.0]) {
              Widget child = Builder(
                builder: (context) {
                  final before = original.build(context).spec;
                  final after = decoded.build(context).spec;
                  expect(after, before);
                  final matches = forced ?? (focused && traditional);
                  final selected =
                      width >= 600 && (negate ? !matches : matches);
                  expect(
                    (after.decoration! as BoxDecoration).color,
                    selected ? active : base,
                  );
                  return const SizedBox();
                },
              );
              if (forced != null) {
                child = WidgetStateStyleOverride(
                  states: {if (forced) WidgetState.focused},
                  child: child,
                );
              }
              await tester.pumpWidget(
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: MediaQuery(
                    data: MediaQueryData(size: Size(width, 800)),
                    child: WidgetStateProvider(
                      states: {if (focused) WidgetState.focused},
                      child: child,
                    ),
                  ),
                ),
              );
            }
          }
        }
      }
    }
  });

  test('focus-visible rejects extra fields and wrong nested style types', () {
    for (final variant in <JsonMap>[
      {
        'kind': 'context_focus_visible',
        'unexpected': true,
        'style': {'type': 'box'},
      },
      {
        'kind': 'context_focus_visible',
        'style': {'type': 'text'},
      },
      {
        'kind': 'context_not',
        'variant': {'kind': 'context_focus_visible', 'state': 'focused'},
        'style': {'type': 'box'},
      },
    ]) {
      expect(
        mixProtocol.decodeStyle<BoxStyler>({
          'v': 1,
          'type': 'box',
          'variants': [variant],
        }),
        isA<MixProtocolFailure<BoxStyler>>(),
      );
    }
  });
}

JsonMap _encode(BoxStyler style) => switch (mixProtocol.encodeStyle(style)) {
  MixProtocolSuccess<JsonMap>(:final value) => value,
  MixProtocolFailure<JsonMap>(:final errors) => throw TestFailure('$errors'),
};

BoxStyler _decode(JsonMap data) => switch (mixProtocol.decodeStyle<BoxStyler>(
  data,
)) {
  MixProtocolSuccess<BoxStyler>(:final value) => value,
  MixProtocolFailure<BoxStyler>(:final errors) => throw TestFailure('$errors'),
};
