import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/src/schema/metadata/modifier_definition.dart';
import 'package:mix_schema/src/schema/metadata/modifier_schema.dart';

void main() {
  group('modifierDefinitions', () {
    test('cover every wire enum value', () {
      expect(modifierDefinitions.keys, unorderedEquals(SchemaModifier.values));
    });

    test('encode and decode every modifier definition', () {
      final schema = buildModifierSchema();

      for (final type in SchemaModifier.values) {
        final definition = modifierDefinitions[type]!;
        final sample = definition.sample();
        final payload = definition.encode(sample);
        final result = schema.safeParse(payload);

        expect(result.isOk, isTrue, reason: 'Failed to decode $type: $payload');
        expect(
          result.getOrNull(),
          sample,
          reason: 'Round-trip failed for $type',
        );
      }
    });
  });
}
