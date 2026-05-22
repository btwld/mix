import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/core/schema_wire_types.dart';
import 'package:mix_schema/src/schema/metadata/context_variant_leaf_schema.dart';
import 'package:mix_schema/src/schema/metadata/variant_condition_definition.dart';
import 'package:mix_schema/src/schema/metadata/variant_condition_schema.dart';

void main() {
  group('variantConditionDefinitions', () {
    test('cover every shared context condition type', () {
      expect(
        variantConditionDefinitions.keys,
        unorderedEquals(sharedContextVariantLeafTypes),
      );
    });

    test('encode and decode every shared context condition', () {
      final leafSchema = buildContextConditionInputSchema();

      for (final type in sharedContextVariantLeafTypes) {
        final definition = variantConditionDefinitions[type]!;
        final sampleFields = _sampleConditionFields(type);
        final expected = definition.buildLeaf(sampleFields);
        final payload = definition.encode(sampleFields);

        final parsedResult = leafSchema.safeParse(payload);
        expect(parsedResult.isOk, isTrue, reason: 'Failed for $type');
        final parsed = parsedResult.getOrThrow()!;

        expect(parsed.canonicalKey, expected.canonicalKey);
      }
    });

    test(
      'leaf schemas encode shared context conditions through Ack codecs',
      () {
        for (final type in sharedContextVariantLeafTypes) {
          final definition = variantConditionDefinitions[type]!;
          final sampleFields = _sampleConditionFields(type);
          final expected = definition.buildLeaf(sampleFields);
          final expectedFields = definition.encode(sampleFields);

          expect(
            buildContextVariantLeafSchema(type: type).encode(expected),
            expectedFields,
            reason: 'Failed to encode $type through its leaf schema',
          );
        }
      },
    );

    test('rejects breakpoint height constraints the runtime cannot encode', () {
      final leafSchema = buildContextConditionInputSchema();

      final result = leafSchema.safeParse({
        'type': 'context_breakpoint',
        'minHeight': 600.0,
      });

      expect(result.isFail, isTrue);
    });
  });
}

Map<String, Object?> _sampleConditionFields(SchemaVariant type) {
  return switch (type) {
    SchemaVariant.widgetState => {'state': WidgetState.hovered},
    SchemaVariant.enabled => const {},
    SchemaVariant.brightness => {'brightness': Brightness.dark},
    SchemaVariant.breakpoint => const {'minWidth': 768.0},
    SchemaVariant.notWidgetState => {'state': WidgetState.focused},
    SchemaVariant.named ||
    SchemaVariant.contextAllOf ||
    SchemaVariant.contextBuilder => throw StateError(
      'Unsupported shared context leaf type: $type',
    ),
  };
}
