import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/schema/shared/color_schema.dart';
import 'package:mix_schema/src/schema/shared/primitive_schemas.dart';

void main() {
  group('primitive codecs encode', () {
    test('encodes colors as #RRGGBBAA', () {
      expect(colorCodec.encode(const Color(0x803B82F6)), '#3B82F680');
      expect(colorCodec.encode(const Color(0xFFFFFFFF)), '#FFFFFFFF');
    });

    test('encodes absolute alignments', () {
      expect(alignmentCodec.encode(Alignment.centerLeft), {
        'x': -1.0,
        'y': 0.0,
      });
    });

    test('rejects directional alignments instead of flattening direction', () {
      final result = alignmentCodec.safeEncode(
        AlignmentDirectional.centerStart,
      );

      expect(result.isFail, isTrue);
      result.match(
        onOk: (_) => fail('Directional alignment should not encode.'),
        onFail: (error) => expect(
          error.message,
          contains('Only absolute Alignment values can be encoded'),
        ),
      );
    });

    test('encodes offsets', () {
      expect(offsetCodec.encode(const Offset(3, 4)), {'dx': 3.0, 'dy': 4.0});
    });

    test('encodes circular and elliptical radii', () {
      expect(radiusCodec.encode(const Radius.circular(6)), {'x': 6.0});
      expect(radiusCodec.encode(const Radius.elliptical(6, 8)), {
        'x': 6.0,
        'y': 8.0,
      });
    });

    test('rectCodec round-trips through encode and decode', () {
      const rect = Rect.fromLTRB(1, 2, 3, 4);
      final wire = rectCodec.encode(rect);
      expect(wire, {'left': 1.0, 'top': 2.0, 'right': 3.0, 'bottom': 4.0});
      expect(rectCodec.parse(wire as Map<String, Object?>), rect);
    });

    test('matrix4Codec round-trips through encode and decode', () {
      final matrix = Matrix4.identity()..translateByDouble(10.0, 20.0, 0, 1);
      final wire = matrix4Codec.encode(matrix) as List<Object?>;
      expect(wire.length, 16);
      expect(matrix4Codec.parse(wire), matrix);
    });

    test('matrix4Codec rejects wrong-length payloads', () {
      final result = matrix4Codec.safeParse(List<double>.filled(8, 0));
      expect(result.isFail, isTrue);
    });
  });
}
