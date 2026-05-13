import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('FlexStyler codec', () {
    test(
      'encodes and decodes representative fields and animation metadata',
      () {
        final contract = MixSchemaContract.builtIn();
        final style = FlexStyler(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.up,
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.ideographic,
          clipBehavior: Clip.antiAlias,
          spacing: 12,
          animation: AnimationConfig.easeIn(
            const Duration(milliseconds: 200),
            delay: const Duration(milliseconds: 40),
          ),
        );

        final encoded = contract.encode(style);

        expect(encoded.ok, isTrue);
        expect(encoded.value, {
          'type': 'flex',
          'direction': 'horizontal',
          'mainAxisAlignment': 'spaceBetween',
          'crossAxisAlignment': 'end',
          'mainAxisSize': 'min',
          'verticalDirection': 'up',
          'textDirection': 'rtl',
          'textBaseline': 'ideographic',
          'clipBehavior': 'antiAlias',
          'spacing': 12.0,
          'animation': {'duration': 200, 'curve': 'easeIn', 'delay': 40},
        });

        final decoded = contract.decode(encoded.value!);
        expect(decoded.ok, isTrue);
        expect(contract.encode(decoded.value!).value, encoded.value);
      },
    );

    test('reports encode errors for unsupported multi-source props', () {
      final contract = MixSchemaContract.builtIn();
      final style = FlexStyler(
        direction: Axis.horizontal,
      ).merge(FlexStyler(direction: Axis.vertical));

      final encoded = contract.encode(style);

      expect(encoded.ok, isFalse);
      expect(encoded.value, isNull);
      expect(
        encoded.errors.map((error) => error.message).join('\n'),
        contains('Only single-source'),
      );
    });
  });

  group('StackStyler codec', () {
    test('encodes and decodes representative fields and variant metadata', () {
      final contract = MixSchemaContract.builtIn();
      final style = StackStyler(
        alignment: Alignment.topLeft,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.hardEdge,
        variants: [
          VariantStyle<StackSpec>(
            Variant.named('compact'),
            StackStyler(alignment: Alignment.bottomRight, fit: StackFit.loose),
          ),
        ],
      );

      final encoded = contract.encode(style);

      expect(encoded.ok, isTrue);
      expect(encoded.value, {
        'type': 'stack',
        'alignment': {'x': -1.0, 'y': -1.0},
        'fit': 'expand',
        'textDirection': 'ltr',
        'clipBehavior': 'hardEdge',
        'variants': [
          {
            'type': 'named',
            'name': 'compact',
            'style': {
              'alignment': {'x': 1.0, 'y': 1.0},
              'fit': 'loose',
            },
          },
        ],
      });

      final decoded = contract.decode(encoded.value!);
      expect(decoded.ok, isTrue);
      expect(contract.encode(decoded.value!).value, encoded.value);
    });

    test('reports encode errors for directional alignment values', () {
      final contract = MixSchemaContract.builtIn();
      final style = StackStyler(alignment: AlignmentDirectional.topStart);

      final encoded = contract.encode(style);

      expect(encoded.ok, isFalse);
      expect(encoded.value, isNull);
      expect(
        encoded.errors.map((error) => error.message).join('\n'),
        contains('Only absolute Alignment values can be encoded'),
      );
    });
  });
}
