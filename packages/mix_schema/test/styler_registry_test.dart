import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/schema/shared/color_schema.dart';

void main() {
  group('StylerRegistry', () {
    test('decodes transformed custom branches', () {
      final registry = StylerRegistry()
        ..register(
          'demo',
          Ack.object({
            'value': Ack.integer(),
          }).transform<Object>((data) => data!['value'] as int),
        )
        ..freeze();

      final result = registry.decode({'type': 'demo', 'value': 42});

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), 42);
    });

    test('rejects decode before freeze', () {
      final registry = StylerRegistry();

      expect(
        () => registry.decode({'type': 'demo'}),
        throwsA(isA<StateError>()),
      );
    });

    test('supports developer-registered styler schemas', () {
      final registry = StylerRegistry()
        ..register(
          'custom_box',
          Ack.object({'color': colorSchema.optional()}).transform<BoxStyler>((
            data,
          ) {
            final map = data!;
            return BoxStyler(
              decoration: map['color'] == null
                  ? null
                  : BoxDecorationMix(color: map['color'] as Color),
            );
          }),
        )
        ..freeze();

      final decoder = MixSchemaDecoder(stylerRegistry: registry);
      final result = decoder.decode({
        'type': 'custom_box',
        'color': 0xFF336699,
      });

      expect(result.ok, isTrue);
      expect(result.value, isA<BoxStyler>());
    });
  });
}
