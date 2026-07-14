import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_protocol/src/schema/common_codecs.dart';

void main() {
  MixProtocol contract() => mixProtocol;

  test('modifiers decode in payload order', () {
    final decoded = contract().decodeStyle<BoxStyler>({
      'v': 1,
      'type': 'box',
      'modifiers': [
        {'type': 'opacity', 'opacity': 0.5},
        {'type': 'blur', 'sigma': 2},
        {
          'type': 'default_text_style',
          'style': {'color': '#112233'},
          'textAlign': 'center',
          'softWrap': false,
          'overflow': 'ellipsis',
          'maxLines': 2,
        },
      ],
    });

    final style = switch (decoded) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final modifiers = style.$modifier!.$modifiers!;

    expect(modifiers, [
      isA<OpacityModifierMix>(),
      isA<BlurModifierMix>(),
      isA<DefaultTextStyleModifierMix>(),
    ]);
    expect(
      singleValueProp((modifiers[0] as OpacityModifierMix).opacity, 'opacity'),
      0.5,
    );
  });

  test('modifiers encode in config order', () {
    final encoded = contract().encodeStyle(
      BoxStyler(
        modifier: WidgetModifierConfig.modifiers([
          OpacityModifierMix(opacity: 0.5),
          BlurModifierMix(sigma: 2),
          DefaultTextStyleModifierMix(
            style: TextStyleMix(color: const Color(0xFF112233)),
            textAlign: TextAlign.center,
            softWrap: false,
          ),
        ]),
      ),
    );

    final payload = switch (encoded) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'box',
      'modifiers': [
        {'type': 'opacity', 'opacity': 0.5},
        {'type': 'blur', 'sigma': 2.0},
        {
          'type': 'default_text_style',
          'style': {'color': '#112233'},
          'textAlign': 'center',
          'softWrap': false,
        },
      ],
    });
  });

  test('data-representable modifiers decode and re-encode canonically', () {
    final payload = {
      'v': 1,
      'type': 'box',
      'modifiers': [
        {
          'type': 'align',
          'alignment': 'bottomRight',
          'widthFactor': 0.5,
          'heightFactor': 0.75,
        },
        {'type': 'aspect_ratio', 'aspectRatio': 1.6},
        {
          'type': 'box',
          'style': {
            'type': 'box',
            'padding': 4,
            'decoration': {'color': '#112233'},
          },
        },
        {'type': 'clip_oval', 'clipBehavior': 'antiAlias'},
        {'type': 'clip_rect', 'clipBehavior': 'hardEdge'},
        {
          'type': 'clip_r_rect',
          'borderRadius': 4,
          'clipBehavior': 'antiAliasWithSaveLayer',
        },
        {'type': 'clip_triangle', 'clipBehavior': 'none'},
        {
          'type': 'default_text_styler',
          'style': {'type': 'text', 'maxLines': 1},
        },
        {
          'type': 'fractionally_sized_box',
          'widthFactor': 0.5,
          'heightFactor': 0.25,
          'alignment': 'topLeft',
        },
        {
          'type': 'icon_theme',
          'color': '#445566',
          'size': 20,
          'fill': 1,
          'weight': 400,
          'grade': 0,
          'opticalSize': 24,
          'opacity': 0.8,
          'shadows': [
            {
              'color': '#000000',
              'offset': {'x': 1, 'y': 2},
              'blurRadius': 3,
            },
          ],
          'applyTextScaling': true,
        },
        {'type': 'intrinsic_height'},
        {'type': 'intrinsic_width'},
        {
          'type': 'padding',
          'padding': {'left': 1, 'right': 2},
        },
        {'type': 'rotate', 'radians': 0.3, 'alignment': 'bottomRight'},
        {'type': 'rotated_box', 'quarterTurns': 1},
        {'type': 'scale', 'x': 1.2, 'y': 0.8, 'alignment': 'center'},
        {
          'type': 'scroll_view',
          'scrollDirection': 'horizontal',
          'reverse': true,
          'padding': 4,
          'clipBehavior': 'hardEdge',
        },
        {'type': 'sized_box', 'width': 10, 'height': 20},
        {
          'type': 'skew',
          'skewX': 0.1,
          'skewY': 0.2,
          'alignment': 'centerRight',
        },
        {
          'type': 'transform',
          'transform': _identityMatrixWire,
          'alignment': 'center',
        },
        {'type': 'translate', 'x': 4, 'y': 5},
        {'type': 'visibility', 'visible': false},
      ],
    };

    final decoded = switch (contract().decodeStyle<BoxStyler>(payload)) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };

    expect(decoded.$modifier!.$modifiers!, [
      isA<AlignModifierMix>(),
      isA<AspectRatioModifierMix>(),
      isA<BoxModifierMix>(),
      isA<ClipOvalModifierMix>(),
      isA<ClipRectModifierMix>(),
      isA<ClipRRectModifierMix>(),
      isA<ClipTriangleModifierMix>(),
      isA<DefaultTextStylerModifierMix>(),
      isA<FractionallySizedBoxModifierMix>(),
      isA<IconThemeModifierMix>(),
      isA<IntrinsicHeightModifierMix>(),
      isA<IntrinsicWidthModifierMix>(),
      isA<PaddingModifierMix>(),
      isA<RotateModifierMix>(),
      isA<RotatedBoxModifierMix>(),
      isA<ScaleModifierMix>(),
      isA<ScrollViewModifierMix>(),
      isA<SizedBoxModifierMix>(),
      isA<SkewModifierMix>(),
      isA<TransformModifierMix>(),
      isA<TranslateModifierMix>(),
      isA<VisibilityModifierMix>(),
    ]);

    expect(_encode(contract(), decoded), {'v': 1, ...payload});
  });

  test('fluent rotate and scale styler output is encodable', () {
    final payload = _encode(
      contract(),
      BoxStyler()
          .rotate(0.5, alignment: Alignment.bottomRight)
          .scale(1.25, alignment: Alignment.topLeft),
    );

    expect(payload, {
      'v': 1,
      'type': 'box',
      'transform': [
        1.25,
        0.0,
        0.0,
        0.0,
        0.0,
        1.25,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
      ],
      'transformAlignment': 'topLeft',
      'modifiers': [
        {'type': 'rotate', 'radians': 0.5, 'alignment': 'bottomRight'},
      ],
    });

    final modifierPayload = _encode(
      contract(),
      BoxStyler(
        modifier: WidgetModifierConfig.scale(
          x: 1.25,
          y: 1.25,
          alignment: Alignment.topLeft,
        ),
      ),
    );

    expect(modifierPayload['modifiers'], [
      {'type': 'scale', 'x': 1.25, 'y': 1.25, 'alignment': 'topLeft'},
    ]);
  });

  test('custom modifier order round-trips as modifier kind strings', () {
    final payload = {
      'v': 1,
      'type': 'box',
      'modifiers': {
        'order': ['blur', 'opacity'],
        'items': [
          {'type': 'opacity', 'opacity': 0.5},
          {'type': 'blur', 'sigma': 2},
        ],
      },
    };

    final decoded = switch (contract().decodeStyle<BoxStyler>(payload)) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };

    expect(decoded.$modifier!.$orderOfModifiers, [
      BlurModifier,
      OpacityModifier,
    ]);
    expect(_encode(contract(), decoded), {'v': 1, ...payload});
  });

  test('flexible modifier decodes flex parent-data intent', () {
    final decoded = contract().decodeStyle<BoxStyler>({
      'v': 1,
      'type': 'box',
      'modifiers': [
        {'type': 'flexible', 'flex': 1, 'fit': 'tight'},
      ],
    });

    final style = switch (decoded) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    final modifier = style.$modifier!.$modifiers!.single;

    expect(modifier, isA<FlexibleModifierMix>());
    final flexible = modifier as FlexibleModifierMix;
    expect(singleValueProp(flexible.flex, 'flex'), 1);
    expect(singleValueProp(flexible.fit, 'fit'), FlexFit.tight);
  });

  test('flexible modifier encodes flex parent-data intent', () {
    final encoded = contract().encodeStyle(
      BoxStyler(
        modifier: WidgetModifierConfig.flexible(flex: 1, fit: FlexFit.tight),
      ),
    );

    final payload = switch (encoded) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'box',
      'modifiers': [
        {'type': 'flexible', 'flex': 1, 'fit': 'tight'},
      ],
    });
  });

  test('flexible modifier rejects invalid fit', () {
    final result = contract().decodeStyle<Object>({
      'v': 1,
      'type': 'box',
      'modifiers': [
        {'type': 'flexible', 'fit': 'fixed'},
      ],
    });

    final errors = switch (result) {
      MixProtocolFailure<Object>(:final errors) => errors,
      MixProtocolSuccess<Object>() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixProtocolErrorCode.invalidEnum),
    );
  });

  test('unsupported modifier order types fail encode explicitly', () {
    final result = contract().encodeStyle(
      BoxStyler(
        modifier: WidgetModifierConfig.orderOfModifiers([ShaderMaskModifier]),
      ),
    );

    final errors = switch (result) {
      MixProtocolFailure<JsonMap>(:final errors) => errors,
      MixProtocolSuccess<JsonMap>() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixProtocolErrorCode.unsupportedEncodeValue),
    );
  });

  test('scroll view modifier physics fails encode explicitly', () {
    final result = contract().encodeStyle(
      BoxStyler(
        modifier: WidgetModifierConfig.modifier(
          ScrollViewModifierMix(physics: const AlwaysScrollableScrollPhysics()),
        ),
      ),
    );

    final errors = switch (result) {
      MixProtocolFailure<JsonMap>(:final errors) => errors,
      MixProtocolSuccess<JsonMap>() => fail('expected failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixProtocolErrorCode.unsupportedEncodeValue),
    );
    expect(
      errors.map((error) => error.message).join('\n'),
      contains('modifiers.scrollView.physics'),
    );
  });
}

const _identityMatrixWire = [
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
];

JsonMap _encode(MixProtocol contract, Object value) {
  return switch (contract.encodeStyle(value)) {
    MixProtocolSuccess<JsonMap>(:final value) => value,
    MixProtocolFailure<JsonMap>(:final errors) => throw TestFailure('$errors'),
  };
}
