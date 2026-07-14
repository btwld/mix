import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

/// Regression coverage for issue #980: fluent chaining accumulates more than one
/// nested [BoxStyler]/[FlexStyler]/[StackStyler] source on a composite slot
/// (`$box`, `$flex`, `$stack`). Those styles must encode with the ordinary v1
/// grammar — merging the sources and emitting `$merge` per-field where needed —
/// instead of being rejected as "N sources; expected one".
void main() {
  final contract = mixProtocol;

  JsonMap encode(Object styler) {
    final result = contract.encodeStyle(styler);

    return switch (result) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };
  }

  List<MixProtocolError> encodeErrors(Object styler) {
    final result = contract.encodeStyle(styler);

    return switch (result) {
      MixProtocolSuccess<JsonMap>() => fail('expected encode failure'),
      MixProtocolFailure<JsonMap>(:final errors) => errors,
    };
  }

  T decode<T extends Object>(JsonMap payload) {
    final result = contract.decodeStyle<T>(payload);

    return switch (result) {
      MixProtocolSuccess<T>(:final value) => value,
      MixProtocolFailure<T>(:final errors) => fail('$errors'),
    };
  }

  group('fluent composites with multiple nested sources', () {
    test('FlexBoxStyler multi-box-source chain encodes like its constructor', () {
      // Two distinct box authoring calls (`color`, `paddingAll`) accumulate two
      // BoxStyler sources on `$box`; `spacing` adds a FlexStyler source.
      final fluent = FlexBoxStyler()
          .color(const Color(0xFF112233))
          .paddingAll(8)
          .spacing(4);

      final wire = encode(fluent);
      expect(wire, {
        'v': 1,
        'type': 'flex_box',
        'padding': 8.0,
        'decoration': {'color': '#112233'},
        'spacing': 4.0,
      });

      // The equivalent single-constructor style is a single source per slot and
      // must produce byte-identical canonical wire.
      final constructor = FlexBoxStyler(
        decoration: BoxDecorationMix(color: const Color(0xFF112233)),
        padding: EdgeInsetsGeometryMix.all(8),
        spacing: 4,
      );
      expect(encode(constructor), wire);

      // Strict decode then encode returns identical canonical JSON.
      expect(encode(decode<FlexBoxStyler>(wire)), wire);
    });

    test('StackBoxStyler multi-source chain across box and stack encodes', () {
      final fluent = StackBoxStyler()
          .color(const Color(0xFF445566))
          .paddingAll(6)
          .stackAlignment(Alignment.center)
          .fit(StackFit.expand);

      final wire = encode(fluent);
      expect(wire, {
        'v': 1,
        'type': 'stack_box',
        'padding': 6.0,
        'decoration': {'color': '#445566'},
        'stackAlignment': 'center',
        'fit': 'expand',
      });

      final constructor = StackBoxStyler(
        decoration: BoxDecorationMix(color: const Color(0xFF445566)),
        padding: EdgeInsetsGeometryMix.all(6),
        stackAlignment: Alignment.center,
        fit: StackFit.expand,
      );
      expect(encode(constructor), wire);
      expect(encode(decode<StackBoxStyler>(wire)), wire);
    });
  });

  group('merge order', () {
    test('accumulating Mix sources on one field emit ordered \$merge', () {
      // `paddingTop` then `paddingLeft` both target `$padding`, so the merged
      // BoxStyler carries two ordered EdgeInsets sources.
      final fluent = FlexBoxStyler().paddingTop(4).paddingLeft(8);

      final wire = encode(fluent);
      expect(wire, {
        'v': 1,
        'type': 'flex_box',
        'padding': {
          r'$merge': [
            {'top': 4.0},
            {'left': 8.0},
          ],
        },
      });

      // Order is preserved through a strict decode/re-encode cycle.
      expect(encode(decode<FlexBoxStyler>(wire)), wire);
    });

    test('last-wins value sources on one field keep ordered \$merge', () {
      final fluent = FlexBoxStyler()
          .clipBehavior(Clip.hardEdge)
          .clipBehavior(Clip.antiAlias);

      final wire = encode(fluent);
      expect(wire, {
        'v': 1,
        'type': 'flex_box',
        'clipBehavior': {
          r'$merge': ['hardEdge', 'antiAlias'],
        },
      });
      expect(encode(decode<FlexBoxStyler>(wire)), wire);
    });
  });

  group('token references across sources', () {
    test('tokens spread over sources stay discoverable and encodable', () {
      final fluent = FlexBoxStyler()
          .color(const ColorToken('color.accent')())
          .paddingAll(const SpaceToken('space.pad')())
          .spacing(const SpaceToken('space.gap')());

      final wire = encode(fluent);
      expect(wire, {
        'v': 1,
        'type': 'flex_box',
        'padding': {r'$token': 'space.pad', 'kind': 'space'},
        'decoration': {
          'color': {r'$token': 'color.accent'},
        },
        'spacing': {r'$token': 'space.gap', 'kind': 'space'},
      });

      final expectedRefs = {
        const MixProtocolTokenReference('colors', 'color.accent'),
        const MixProtocolTokenReference('spaces', 'space.pad'),
        const MixProtocolTokenReference('spaces', 'space.gap'),
      };
      // Discoverable on the original multi-source style...
      expect(tokenReferencesOf(fluent), expectedRefs);
      // ...and on the decoded single-source style.
      expect(tokenReferencesOf(decode<FlexBoxStyler>(wire)), expectedRefs);
    });
  });

  group('resolution equivalence', () {
    testWidgets('decoded style resolves to the same spec as the original', (
      tester,
    ) async {
      final fluent = FlexBoxStyler()
          .color(const Color(0xFF112233))
          .paddingAll(8)
          .paddingTop(2)
          .spacing(4)
          .mainAxisAlignment(MainAxisAlignment.spaceBetween);

      final decoded = decode<FlexBoxStyler>(encode(fluent));

      late final BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              context = ctx;

              return const SizedBox();
            },
          ),
        ),
      );

      expect(fluent.build(context).spec, decoded.build(context).spec);
    });
  });

  group('atomic failure diagnostics', () {
    test('nested metadata on any merged source fails with a slot path', () {
      // Two box sources; the second carries a nested variant that the built-in
      // schema cannot represent. Encoding must fail atomically with a single
      // path-qualified diagnostic (no partial output, no sibling-branch noise).
      final styler = FlexBoxStyler.create(
        box: Prop.mix(BoxStyler(padding: EdgeInsetsMix.all(8))).mergeProp(
          Prop.mix(
            BoxStyler(
              variants: [
                VariantStyle(const NamedVariant('nested'), BoxStyler()),
              ],
            ),
          ),
        ),
      );

      final error = encodeErrors(styler).single;
      expect(error.code, MixProtocolErrorCode.unsupportedEncodeValue);
      expect(error.path, '/box/variants');
    });

    test('flex slot metadata fails with the flex slot path', () {
      final styler = FlexBoxStyler.create(
        flex: Prop.mix(FlexStyler(spacing: 2)).mergeProp(
          Prop.mix(
            FlexStyler(
              modifier: WidgetModifierConfig.modifiers([
                OpacityModifierMix(opacity: 0.5),
              ]),
            ),
          ),
        ),
      );

      final error = encodeErrors(styler).single;
      expect(error.code, MixProtocolErrorCode.unsupportedEncodeValue);
      expect(error.path, '/flex/modifiers');
    });

    test('unsupported nested source kind fails with the slot path', () {
      // A raw StyleSpec value source (not a Styler) is not representable.
      final styler = FlexBoxStyler.create(
        box: Prop.value<StyleSpec<BoxSpec>>(const StyleSpec(spec: BoxSpec())),
      );

      final error = encodeErrors(styler).single;
      expect(error.code, MixProtocolErrorCode.unsupportedEncodeValue);
      expect(error.path, '/box');
    });
  });

  group('single-source compatibility', () {
    test('single-source constructor composites are unchanged', () {
      final styler = FlexBoxStyler(
        padding: EdgeInsetsMix.all(8),
        decoration: BoxDecorationMix(color: const Color(0xFF112233)),
        direction: Axis.vertical,
        spacing: 4,
        flexClipBehavior: Clip.hardEdge,
      );

      final wire = encode(styler);
      expect(wire, {
        'v': 1,
        'type': 'flex_box',
        'padding': 8.0,
        'decoration': {'color': '#112233'},
        'direction': 'vertical',
        'flexClipBehavior': 'hardEdge',
        'spacing': 4.0,
      });
      expect(encode(decode<FlexBoxStyler>(wire)), wire);
    });
  });
}
