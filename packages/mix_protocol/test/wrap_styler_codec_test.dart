import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  final contract = mixProtocol;

  JsonMap encode(Object styler) {
    return switch (contract.encodeStyle(styler)) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };
  }

  T decode<T extends Object>(JsonMap payload) {
    return switch (contract.decodeStyle<T>(payload)) {
      MixProtocolSuccess<T>(:final value) => value,
      MixProtocolFailure<T>(:final errors) => fail('$errors'),
    };
  }

  test('wrap canonical payload covers every field and tokenized spacing', () {
    final payload = <String, Object>{
      'v': 1,
      'type': 'wrap',
      'direction': 'vertical',
      'alignment': 'spaceBetween',
      'spacing': {r'$token': 'space.wrap.item', 'kind': 'space'},
      'runAlignment': 'center',
      'runSpacing': {r'$token': 'double.wrap.run', 'kind': 'double'},
      'crossAxisAlignment': 'end',
      'textDirection': 'rtl',
      'verticalDirection': 'up',
      'clipBehavior': 'hardEdge',
    };

    expect(encode(decode<WrapStyler>(payload)), payload);
    expect(tokenReferencesOf(decode<WrapStyler>(payload)), {
      const MixProtocolTokenReference('spaces', 'space.wrap.item'),
      const MixProtocolTokenReference('doubles', 'double.wrap.run'),
    });
  });

  test('wrap_box canonical payload covers Box, Wrap, and root metadata', () {
    final payload = <String, Object>{
      'v': 1,
      'type': 'wrap_box',
      'alignment': 'topLeft',
      'padding': {r'$token': 'space.wrap.padding', 'kind': 'space'},
      'margin': {
        'left': {r'$token': 'space.wrap.margin', 'kind': 'space'},
        'bottom': 3.0,
      },
      'constraints': {'minWidth': 40.0, 'maxWidth': 240.0},
      'clipBehavior': 'antiAlias',
      'transform': <double>[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
      'transformAlignment': 'center',
      'decoration': {'color': '#112233'},
      'foregroundDecoration': {'color': '#80112233'},
      'direction': 'horizontal',
      'wrapAlignment': 'spaceAround',
      'spacing': {r'$token': 'space.wrap.item', 'kind': 'space'},
      'runAlignment': 'end',
      'runSpacing': {r'$token': 'double.wrap.run', 'kind': 'double'},
      'crossAxisAlignment': 'center',
      'textDirection': 'ltr',
      'verticalDirection': 'down',
      'wrapClipBehavior': 'hardEdge',
      'variants': [
        {
          'kind': 'named',
          'name': 'compact',
          'style': {'type': 'wrap_box', 'spacing': 2.0},
        },
      ],
      'modifiers': [
        {'type': 'opacity', 'opacity': 0.75},
      ],
      'animation': {'duration': 120, 'curve': 'easeInOut', 'delay': 10},
    };

    final decoded = decode<WrapBoxStyler>(payload);

    expect(encode(decoded), payload);
    expect(tokenReferencesOf(decoded), {
      const MixProtocolTokenReference('spaces', 'space.wrap.padding'),
      const MixProtocolTokenReference('spaces', 'space.wrap.margin'),
      const MixProtocolTokenReference('spaces', 'space.wrap.item'),
      const MixProtocolTokenReference('doubles', 'double.wrap.run'),
    });
  });

  test('wrap_box preserves both collision pairs simultaneously', () {
    final payload = <String, Object>{
      'v': 1,
      'type': 'wrap_box',
      'alignment': 'bottomRight',
      'wrapAlignment': 'center',
      'clipBehavior': 'antiAlias',
      'wrapClipBehavior': 'hardEdge',
    };

    final style = decode<WrapBoxStyler>(payload);

    expect(encode(style), payload);
  });

  test('fluent multi-source WrapBox encodes ordered field merges', () {
    final style = WrapBoxStyler()
        .paddingTop(4)
        .paddingLeft(8)
        .spacing(2)
        .spacing(6)
        .runSpacing(10)
        .wrapAlignment(WrapAlignment.end);

    final payload = encode(style);

    expect(payload, {
      'v': 1,
      'type': 'wrap_box',
      'padding': {
        r'$merge': [
          {'top': 4.0},
          {'left': 8.0},
        ],
      },
      'wrapAlignment': 'end',
      'spacing': {
        r'$merge': [2.0, 6.0],
      },
      'runSpacing': 10.0,
    });
    expect(encode(decode<WrapBoxStyler>(payload)), payload);
  });

  test('runtime Wrap and WrapBox styles round-trip with field fidelity', () {
    final modifier = WidgetModifierConfig.modifiers([
      OpacityModifierMix(opacity: 0.5),
    ]);
    final animation = CurveAnimationConfig.easeInOut(
      const Duration(milliseconds: 150),
    );
    final wrap = WrapStyler(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      spacing: 4,
      runAlignment: WrapAlignment.spaceBetween,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.end,
      textDirection: TextDirection.rtl,
      verticalDirection: VerticalDirection.up,
      clipBehavior: Clip.antiAlias,
      animation: animation,
      modifier: modifier,
      variants: [
        VariantStyle(const NamedVariant('dense'), WrapStyler(spacing: 2)),
      ],
    );
    final wrapBox = WrapBoxStyler(
      foregroundDecoration: BoxDecorationMix(color: const Color(0x80112233)),
      padding: EdgeInsetsMix.all(8),
      wrapAlignment: WrapAlignment.center,
      spacing: 4,
      wrapClipBehavior: Clip.hardEdge,
      animation: animation,
      modifier: modifier,
      variants: [
        VariantStyle(const NamedVariant('dense'), WrapBoxStyler(runSpacing: 2)),
      ],
    );

    expect(decode<WrapStyler>(encode(wrap)), wrap);
    expect(decode<WrapBoxStyler>(encode(wrapBox)), wrapBox);
  });
}
