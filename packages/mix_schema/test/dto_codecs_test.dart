import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('DtoCodecs layout', () {
    test('encodes and decodes edge insets', () {
      final input = <String, Object?>{
        'kind': 'edgeInsets',
        'left': 8.0,
        'top': 4.0,
        'right': 12.0,
        'bottom': 2.0,
      };

      final mix = DtoCodecs.decodeEdgeInsetsGeometry(input);
      final encoded = DtoCodecs.encodeEdgeInsetsGeometry(mix);

      expect(encoded, input);
    });

    test('encodes and decodes directional edge insets', () {
      final input = <String, Object?>{
        'kind': 'edgeInsetsDirectional',
        'start': 8.0,
        'top': 4.0,
        'end': 12.0,
        'bottom': 2.0,
      };

      final mix = DtoCodecs.decodeEdgeInsetsGeometry(input);
      final encoded = DtoCodecs.encodeEdgeInsetsGeometry(mix);

      expect(encoded, input);
    });

    test('encodes and decodes alignment geometry', () {
      final input = <String, Object?>{
        'kind': 'alignment',
        'x': -0.5,
        'y': 0.75,
      };

      final alignment = DtoCodecs.decodeAlignmentGeometry(input);
      final encoded = DtoCodecs.encodeAlignmentGeometry(alignment);

      expect(encoded, input);
    });

    test('encodes and decodes directional alignment geometry', () {
      final input = <String, Object?>{
        'kind': 'alignmentDirectional',
        'start': 0.25,
        'y': -0.4,
      };

      final alignment = DtoCodecs.decodeAlignmentGeometry(input);
      final encoded = DtoCodecs.encodeAlignmentGeometry(alignment);

      expect(encoded, input);
    });

    test('encodes and decodes matrix4 values', () {
      final input = <Object?>[
        1.0,
        2.0,
        3.0,
        4.0,
        5.0,
        6.0,
        7.0,
        8.0,
        9.0,
        10.0,
        11.0,
        12.0,
        13.0,
        14.0,
        15.0,
        16.0,
      ];

      final matrix = DtoCodecs.decodeMatrix4(input);
      final encoded = DtoCodecs.encodeMatrix4(matrix);

      expect(encoded, input);
    });

    test('encodes and decodes constraints', () {
      final input = <String, Object?>{
        'minWidth': 10.0,
        'maxWidth': 120.0,
        'minHeight': 4.0,
        'maxHeight': 40.0,
      };

      final mix = DtoCodecs.decodeBoxConstraints(input);
      final encoded = DtoCodecs.encodeBoxConstraints(mix);

      expect(encoded, input);
    });
  });

  group('DtoCodecs painting', () {
    test('encodes and decodes border', () {
      final input = <String, Object?>{
        'kind': 'border',
        'top': <String, Object?>{
          'color': 0xFF112233,
          'width': 2.0,
          'style': 'solid',
          'strokeAlign': 0.0,
        },
        'bottom': <String, Object?>{
          'color': 0xFF223344,
          'width': 1.5,
          'style': 'none',
          'strokeAlign': -1.0,
        },
      };

      final mix = DtoCodecs.decodeBoxBorder(input);
      final encoded = DtoCodecs.encodeBoxBorder(mix);

      expect(encoded, input);
    });

    test('encodes and decodes border directional', () {
      final input = <String, Object?>{
        'kind': 'borderDirectional',
        'start': <String, Object?>{'color': 0xFFAA0000, 'width': 2.0},
        'end': <String, Object?>{'color': 0xFF00AA00, 'width': 3.0},
      };

      final mix = DtoCodecs.decodeBoxBorder(input);
      final encoded = DtoCodecs.encodeBoxBorder(mix);

      expect(encoded, input);
    });

    test('encodes and decodes border radius', () {
      final input = <String, Object?>{
        'kind': 'borderRadius',
        'topLeft': <String, Object?>{'x': 10.0, 'y': 10.0},
        'bottomRight': <String, Object?>{'x': 8.0, 'y': 8.0},
      };

      final mix = DtoCodecs.decodeBorderRadiusGeometry(input);
      final encoded = DtoCodecs.encodeBorderRadiusGeometry(mix);

      expect(encoded, input);
    });

    test('encodes and decodes directional border radius', () {
      final input = <String, Object?>{
        'kind': 'borderRadiusDirectional',
        'topStart': <String, Object?>{'x': 7.0, 'y': 9.0},
        'bottomEnd': <String, Object?>{'x': 3.0, 'y': 4.0},
      };

      final mix = DtoCodecs.decodeBorderRadiusGeometry(input);
      final encoded = DtoCodecs.encodeBorderRadiusGeometry(mix);

      expect(encoded, input);
    });

    test('encodes and decodes linear gradient', () {
      final input = <String, Object?>{
        'kind': 'linearGradient',
        'begin': <String, Object?>{'kind': 'alignment', 'x': -1.0, 'y': 0.0},
        'end': <String, Object?>{'kind': 'alignment', 'x': 1.0, 'y': 0.0},
        'tileMode': 'clamp',
        'transform': <String, Object?>{
          'kind': 'gradientRotation',
          'radians': 0.25,
        },
        'colors': <Object?>[0xFF000000, 0xFFFFFFFF],
        'stops': <Object?>[0.0, 1.0],
      };

      final mix = DtoCodecs.decodeGradient(input);
      final encoded = DtoCodecs.encodeGradient(mix);

      expect(encoded, input);
    });

    test('encodes and decodes box decoration with expanded fields', () {
      final input = <String, Object?>{
        'kind': 'boxDecoration',
        'color': 0xFF00FF00,
        'border': <String, Object?>{
          'kind': 'border',
          'top': <String, Object?>{'color': 0x66000000, 'width': 1.0},
        },
        'borderRadius': <String, Object?>{
          'kind': 'borderRadius',
          'topLeft': <String, Object?>{'x': 8.0, 'y': 8.0},
          'topRight': <String, Object?>{'x': 8.0, 'y': 8.0},
        },
        'gradient': <String, Object?>{
          'kind': 'linearGradient',
          'begin': <String, Object?>{'kind': 'alignment', 'x': 0.0, 'y': -1.0},
          'end': <String, Object?>{'kind': 'alignment', 'x': 0.0, 'y': 1.0},
          'colors': <Object?>[0xFF111111, 0xFF999999],
          'stops': <Object?>[0.0, 1.0],
        },
        'boxShadow': <Object?>[
          <String, Object?>{
            'color': 0x66000000,
            'offset': <String, Object?>{'dx': 1.0, 'dy': 2.0},
            'blurRadius': 6.0,
            'spreadRadius': 0.5,
          },
        ],
        'shape': 'rectangle',
        'backgroundBlendMode': 'srcOver',
      };

      final mix = DtoCodecs.decodeBoxDecoration(input);
      final encoded = DtoCodecs.encodeBoxDecoration(mix);

      expect(encoded, input);
    });

    test('throws on unsupported box decoration image field', () {
      final input = <String, Object?>{
        'kind': 'boxDecoration',
        'image': <String, Object?>{'provider': 'x'},
      };

      expect(
        () => DtoCodecs.decodeBoxDecoration(input),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('DtoCodecs typography', () {
    test('encodes and decodes text style subset', () {
      final input = <String, Object?>{
        'color': 0xFF123456,
        'fontSize': 14.0,
        'fontWeight': 'w600',
        'fontStyle': 'italic',
        'letterSpacing': 0.3,
        'wordSpacing': 0.7,
        'height': 1.2,
        'fontFamily': 'Roboto',
      };

      final mix = DtoCodecs.decodeTextStyle(input);
      final encoded = DtoCodecs.encodeTextStyle(mix);

      expect(encoded, input);
    });

    test('accepts whole-number doubles for int fields', () {
      final input = <String, Object?>{'color': 4278190335.0};

      final mix = DtoCodecs.decodeTextStyle(input);
      final encoded = DtoCodecs.encodeTextStyle(mix);

      expect(encoded['color'], 4278190335);
    });

    test('encodes and decodes strut style subset', () {
      final input = <String, Object?>{
        'fontFamily': 'Roboto',
        'fontSize': 16.0,
        'fontWeight': 'w500',
        'fontStyle': 'normal',
        'height': 1.0,
        'leading': 0.2,
        'forceStrutHeight': true,
      };

      final mix = DtoCodecs.decodeStrutStyle(input);
      final encoded = DtoCodecs.encodeStrutStyle(mix);

      expect(encoded, input);
    });

    test('encodes and decodes text height behavior', () {
      final input = <String, Object?>{
        'applyHeightToFirstAscent': true,
        'applyHeightToLastDescent': false,
        'leadingDistribution': 'even',
      };

      final mix = DtoCodecs.decodeTextHeightBehavior(input);
      final encoded = DtoCodecs.encodeTextHeightBehavior(mix);

      expect(encoded, input);
    });

    test('throws on unsupported typography enum names', () {
      expect(
        () =>
            DtoCodecs.decodeTextStyle(<String, Object?>{'fontWeight': 'w950'}),
        throwsA(isA<StateError>()),
      );
      expect(
        () => DtoCodecs.decodeTextHeightBehavior(<String, Object?>{
          'leadingDistribution': 'custom',
        }),
        throwsA(isA<StateError>()),
      );
    });
  });
}
