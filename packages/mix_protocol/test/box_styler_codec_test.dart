import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_protocol/src/schema/common_codecs.dart';

void main() {
  MixProtocol contract() => mixProtocol;

  test('decodes box without branch-owned type field', () {
    final result = contract().decodeStyle<BoxStyler>({
      'v': 1,
      'type': 'box',
      'padding': {'top': 8},
    });

    final box = switch (result) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };

    final padding = singleMixProp<EdgeInsetsMix, EdgeInsetsGeometry>(
      box.$padding,
      'padding',
    );
    expect(singleValueProp(padding!.$top, 'top'), 8);
    expect(box.$margin, isNull);
  });

  test('Ack root injects box discriminator on encode', () {
    final encoded = contract().encodeStyle(
      BoxStyler(
        alignment: Alignment.center,
        padding: EdgeInsetsMix(top: 8),
        decoration: BoxDecorationMix(color: const Color(0xCC336699)),
        clipBehavior: Clip.hardEdge,
      ),
    );

    final payload = switch (encoded) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };

    expect(payload, {
      'v': 1,
      'type': 'box',
      'alignment': 'center',
      'padding': {'top': 8.0},
      'clipBehavior': 'hardEdge',
      'decoration': {'color': '#CC336699'},
    });
  });

  test('merged constraints encode with ordered merge source stack', () {
    final style = BoxStyler().width(1).merge(BoxStyler().height(2));

    final payload = _encode(contract(), style);

    expect(payload['constraints'], {
      r'$merge': [
        {'minWidth': 1.0, 'maxWidth': 1.0},
        {'minHeight': 2.0, 'maxHeight': 2.0},
      ],
    });
    expect(_encode(contract(), _decodeBox(contract(), payload)), payload);
  });

  test('merged padding mix encodes with ordered merge source stack', () {
    final style = BoxStyler()
        .padding(EdgeInsetsMix(top: 1))
        .merge(BoxStyler().padding(EdgeInsetsMix(bottom: 2)));

    final payload = _encode(contract(), style);

    expect(payload['padding'], {
      r'$merge': [
        {'top': 1.0},
        {'bottom': 2.0},
      ],
    });
    expect(_encode(contract(), _decodeBox(contract(), payload)), payload);
  });

  testWidgets('merged props resolve identically after wire round-trip', (
    tester,
  ) async {
    final cases = [
      BoxStyler().width(1).merge(BoxStyler().height(2)),
      BoxStyler()
          .padding(EdgeInsetsMix(top: 1))
          .merge(BoxStyler().padding(EdgeInsetsMix(bottom: 2))),
    ];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            for (final original in cases) {
              final decoded = _decodeBox(
                contract(),
                _encode(contract(), original),
              );
              final originalSpec = original.resolve(context).spec;
              final decodedSpec = decoded.resolve(context).spec;

              expect(decodedSpec.constraints, originalSpec.constraints);
              expect(decodedSpec.padding, originalSpec.padding);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });

  test('single-source property terms stay flat', () {
    final payload = _encode(contract(), BoxStyler().width(1));

    expect(payload['constraints'], {'minWidth': 1.0, 'maxWidth': 1.0});
  });

  test('token color directives encode with apply grammar', () {
    final token = const ColorToken('color.brand');
    final style = BoxStyler().color(token().withAlpha(128));
    final payload = _encode(contract(), style);

    expect(payload['decoration'], {
      'color': {
        r'$token': 'color.brand',
        'apply': [
          {'op': 'color_alpha', 'alpha': 128},
        ],
      },
    });
    expect(_encode(contract(), _decodeBox(contract(), payload)), payload);
  });

  test('gradient payloads round-trip all supported kinds', () {
    final payloads = [
      {
        'v': 1,
        'type': 'box',
        'decoration': {
          'gradient': {
            'kind': 'linear',
            'begin': 'centerLeft',
            'end': 'centerRight',
            'colors': ['#000000', '#FFFFFF'],
            'stops': [0.0, 1.0],
            'tileMode': 'mirror',
            'transform': {'kind': 'rotation', 'radians': 0.25},
          },
        },
      },
      {
        'v': 1,
        'type': 'box',
        'decoration': {
          'gradient': {
            'kind': 'linear',
            'begin': 'centerLeft',
            'end': 'centerRight',
            'colors': ['#000000', '#FFFFFF'],
            'stops': [0.0, 1.0],
            'transform': {'kind': 'css_linear', 'direction': 'to-br'},
          },
        },
      },
      {
        'v': 1,
        'type': 'box',
        'decoration': {
          'gradient': {
            'kind': 'radial',
            'center': 'center',
            'radius': 0.75,
            'focal': 'topLeft',
            'focalRadius': 0.2,
            'colors': ['#FF0000', '#0000FF'],
            'stops': [0.0, 1.0],
            'tileMode': 'decal',
          },
        },
      },
      {
        'v': 1,
        'type': 'box',
        'decoration': {
          'gradient': {
            'kind': 'sweep',
            'center': 'bottomRight',
            'startAngle': 0.1,
            'endAngle': 2.4,
            'colors': ['#00FF00', '#FFFF00'],
            'stops': [0.25, 0.75],
            'tileMode': 'repeated',
          },
        },
      },
    ];

    for (final payload in payloads) {
      expect(_encode(contract(), _decodeBox(contract(), payload)), payload);
    }
  });

  test('gradient decode rejects fields from another kind', () {
    final result = contract().decodeStyle<BoxStyler>({
      'v': 1,
      'type': 'box',
      'decoration': {
        'gradient': {
          'kind': 'linear',
          'begin': 'centerLeft',
          'center': 'topLeft',
          'colors': ['#000000', '#FFFFFF'],
        },
      },
    });
    final errors = switch (result) {
      MixProtocolFailure<BoxStyler>(:final errors) => errors,
      MixProtocolSuccess<BoxStyler>() => fail('expected failure'),
    };

    expect(
      errors,
      contains(
        isA<MixProtocolError>()
            .having(
              (error) => error.code,
              'code',
              MixProtocolErrorCode.unknownField,
            )
            .having(
              (error) => error.path,
              'path',
              '/decoration/gradient/center',
            ),
      ),
    );
  });

  test('lenient gradient decode removes kind-incompatible fields only', () {
    final payload = {
      'v': 1,
      'type': 'box',
      'decoration': {
        'gradient': {
          'kind': 'linear',
          'begin': 'centerLeft',
          'center': 'topLeft',
          'colors': ['#000000', '#FFFFFF'],
        },
      },
    };
    final result = contract().decodeStyle<BoxStyler>(
      payload,
      options: const MixProtocolDecodeOptions(
        mode: MixProtocolDecodeMode.lenient,
      ),
    );
    final success = switch (result) {
      MixProtocolSuccess<BoxStyler> result => result,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };

    expect(success.warnings.single.path, '/decoration/gradient/center');
    expect(_encode(contract(), success.value), {
      'v': 1,
      'type': 'box',
      'decoration': {
        'gradient': {
          'kind': 'linear',
          'begin': 'centerLeft',
          'colors': ['#000000', '#FFFFFF'],
        },
      },
    });
  });

  test('linear gradient encode matches Tailwinds angle-strategy fixture', () {
    final style = BoxStyler(
      decoration: BoxDecorationMix(
        gradient: LinearGradientMix(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          transform: GradientRotation(math.pi / 4),
          colors: const [
            Color(0xFF000000),
            Color(0xFFFFFFFF),
            Color(0xFF000000),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );

    final payload = _encode(contract(), style);

    expect(payload['decoration'], {
      'gradient': {
        'kind': 'linear',
        'begin': 'centerLeft',
        'end': 'centerRight',
        'colors': ['#000000', '#FFFFFF', '#000000'],
        'stops': [0.0, 0.5, 1.0],
        'transform': {'kind': 'rotation', 'radians': math.pi / 4},
      },
    });
    expect(_encode(contract(), _decodeBox(contract(), payload)), payload);
  });

  test('linear gradient encode matches Tailwinds css-angle fixture', () {
    final style = BoxStyler(
      decoration: BoxDecorationMix(
        gradient: LinearGradientMix(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          transform: const CssKeywordLinearTransform('to-br'),
          colors: const [
            Color(0xFF000000),
            Color(0xFFFFFFFF),
            Color(0xFF000000),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );

    final payload = _encode(contract(), style);

    expect(payload['decoration'], {
      'gradient': {
        'kind': 'linear',
        'begin': 'centerLeft',
        'end': 'centerRight',
        'colors': ['#000000', '#FFFFFF', '#000000'],
        'stops': [0.0, 0.5, 1.0],
        'transform': {'kind': 'css_linear', 'direction': 'to-br'},
      },
    });
    expect(_encode(contract(), _decodeBox(contract(), payload)), payload);
  });

  testWidgets('gradient payloads resolve like hand-built Mix gradients', (
    tester,
  ) async {
    final cases = <({JsonMap wire, BoxStyler expected})>[
      (
        wire: {
          'v': 1,
          'type': 'box',
          'decoration': {
            'gradient': {
              'kind': 'linear',
              'begin': 'centerLeft',
              'end': 'centerRight',
              'colors': ['#000000', '#FFFFFF'],
              'stops': [0.0, 1.0],
              'tileMode': 'mirror',
              'transform': {'kind': 'rotation', 'radians': 0.25},
            },
          },
        },
        expected: BoxStyler(
          decoration: BoxDecorationMix(
            gradient: LinearGradientMix(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
              stops: const [0.0, 1.0],
              tileMode: TileMode.mirror,
              transform: const GradientRotation(0.25),
            ),
          ),
        ),
      ),
      (
        wire: {
          'v': 1,
          'type': 'box',
          'decoration': {
            'gradient': {
              'kind': 'linear',
              'begin': 'centerLeft',
              'end': 'centerRight',
              'colors': ['#000000', '#FFFFFF'],
              'stops': [0.0, 1.0],
              'transform': {'kind': 'css_linear', 'direction': 'to-br'},
            },
          },
        },
        expected: BoxStyler(
          decoration: BoxDecorationMix(
            gradient: LinearGradientMix(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
              stops: const [0.0, 1.0],
              transform: const CssKeywordLinearTransform('to-br'),
            ),
          ),
        ),
      ),
      (
        wire: {
          'v': 1,
          'type': 'box',
          'decoration': {
            'gradient': {
              'kind': 'radial',
              'center': 'center',
              'radius': 0.75,
              'focal': 'topLeft',
              'focalRadius': 0.2,
              'colors': ['#FF0000', '#0000FF'],
              'stops': [0.0, 1.0],
              'tileMode': 'decal',
            },
          },
        },
        expected: BoxStyler(
          decoration: BoxDecorationMix(
            gradient: RadialGradientMix(
              center: Alignment.center,
              radius: 0.75,
              focal: Alignment.topLeft,
              focalRadius: 0.2,
              colors: const [Color(0xFFFF0000), Color(0xFF0000FF)],
              stops: const [0.0, 1.0],
              tileMode: TileMode.decal,
            ),
          ),
        ),
      ),
      (
        wire: {
          'v': 1,
          'type': 'box',
          'decoration': {
            'gradient': {
              'kind': 'sweep',
              'center': 'bottomRight',
              'startAngle': 0.1,
              'endAngle': 2.4,
              'colors': ['#00FF00', '#FFFF00'],
              'stops': [0.25, 0.75],
              'tileMode': 'repeated',
            },
          },
        },
        expected: BoxStyler(
          decoration: BoxDecorationMix(
            gradient: SweepGradientMix(
              center: Alignment.bottomRight,
              startAngle: 0.1,
              endAngle: 2.4,
              colors: const [Color(0xFF00FF00), Color(0xFFFFFF00)],
              stops: const [0.25, 0.75],
              tileMode: TileMode.repeated,
            ),
          ),
        ),
      ),
    ];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            for (final (:wire, :expected) in cases) {
              final decoded = _decodeBox(contract(), wire);
              final decodedDecoration =
                  decoded.resolve(context).spec.decoration! as BoxDecoration;
              final expectedDecoration =
                  expected.resolve(context).spec.decoration! as BoxDecoration;

              expect(decodedDecoration, expectedDecoration);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });

  test('unsupported gradient transforms fail encode explicitly', () {
    final result = contract().encodeStyle(
      BoxStyler(
        decoration: BoxDecorationMix(
          gradient: LinearGradientMix(
            transform: const _UnsupportedGradientTransform(),
            colors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
          ),
        ),
      ),
    );

    final errors = switch (result) {
      MixProtocolFailure<JsonMap>(:final errors) => errors,
      MixProtocolSuccess<JsonMap>() => fail('expected failure'),
    };

    expect(
      errors,
      contains(
        isA<MixProtocolError>()
            .having(
              (error) => error.code,
              'code',
              MixProtocolErrorCode.unsupportedEncodeValue,
            )
            .having(
              (error) => error.message,
              'message',
              contains('decoration.gradient.transform'),
            ),
      ),
    );
  });

  test('unsupported css gradient directions fail encode explicitly', () {
    final result = contract().encodeStyle(
      BoxStyler(
        decoration: BoxDecorationMix(
          gradient: LinearGradientMix(
            transform: const CssKeywordLinearTransform('diagonal'),
            colors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
          ),
        ),
      ),
    );

    final errors = switch (result) {
      MixProtocolFailure<JsonMap>(:final errors) => errors,
      MixProtocolSuccess<JsonMap>() => fail('expected failure'),
    };

    expect(
      errors,
      contains(
        isA<MixProtocolError>()
            .having(
              (error) => error.code,
              'code',
              MixProtocolErrorCode.unsupportedEncodeValue,
            )
            .having(
              (error) => error.message,
              'message',
              contains('css_linear.direction'),
            ),
      ),
    );
  });

  test('unsupported decoration runtime values fail encode explicitly', () {
    final cases = [
      (
        style: BoxStyler(
          decoration: BoxDecorationMix(
            image: DecorationImageMix.image(
              const NetworkImage('https://example.com/image.png'),
            ),
          ),
        ),
        field: 'decoration.image',
      ),
    ];

    for (final (:style, :field) in cases) {
      final result = contract().encodeStyle(style);

      final errors = switch (result) {
        MixProtocolFailure<JsonMap>(:final errors) => errors,
        MixProtocolSuccess<JsonMap>() => fail('expected failure for $style'),
      };

      expect(
        errors,
        contains(
          isA<MixProtocolError>()
              .having(
                (error) => error.code,
                'code',
                MixProtocolErrorCode.unsupportedEncodeValue,
              )
              .having((error) => error.message, 'message', contains(field)),
        ),
      );
    }
  });
}

final class _UnsupportedGradientTransform extends GradientTransform {
  const _UnsupportedGradientTransform();

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity();
  }
}

JsonMap _encode(MixProtocol contract, Object value) {
  return switch (contract.encodeStyle(value)) {
    MixProtocolSuccess<JsonMap>(:final value) => value,
    MixProtocolFailure<JsonMap>(:final errors) => throw TestFailure('$errors'),
  };
}

BoxStyler _decodeBox(MixProtocol contract, JsonMap payload) {
  return switch (contract.decodeStyle<BoxStyler>({'v': 1, ...payload})) {
    MixProtocolSuccess<BoxStyler>(:final value) => value,
    MixProtocolFailure<BoxStyler>(:final errors) => throw TestFailure(
      '$errors',
    ),
  };
}
