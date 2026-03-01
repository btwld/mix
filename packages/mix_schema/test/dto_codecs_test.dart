import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('DtoCodecs layout', () {
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
    test('encodes and decodes box decoration with shadow list', () {
      final input = <String, Object?>{
        'kind': 'boxDecoration',
        'color': 0xFF00FF00,
        'boxShadow': <Object?>[
          <String, Object?>{
            'color': 0x66000000,
            'offset': <String, Object?>{'dx': 1.0, 'dy': 2.0},
            'blurRadius': 6.0,
            'spreadRadius': 0.5,
          },
        ],
      };

      final mix = DtoCodecs.decodeBoxDecoration(input);
      final encoded = DtoCodecs.encodeBoxDecoration(mix);

      expect(encoded, input);
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
