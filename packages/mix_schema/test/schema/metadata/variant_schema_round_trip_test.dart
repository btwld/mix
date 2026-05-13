import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/src/core/schema_wire_types.dart';
import 'package:mix_schema/src/registry/registry_catalog.dart';
import 'package:mix_schema/src/schema/metadata/variant_condition_definition.dart';
import 'package:mix_schema/src/schema/metadata/variant_condition_schema.dart';
import 'package:mix_schema/src/schema/metadata/variant_schema.dart';

void main() {
  group('buildVariantSchema', () {
    test('encodes named variants', () {
      final schema = _buildBoxVariantSchema();

      expect(
        schema.encode(VariantStyle<BoxSpec>(Variant.named('primary'), _style)),
        {
          'type': SchemaVariant.named.wireValue,
          'name': 'primary',
          'style': _encodedStyle,
        },
      );
    });

    test('encodes context_all_of variants through shared leaf codecs', () {
      final schema = _buildBoxVariantSchema();
      final conditionSet = ContextConditionSet.compound([
        ContextConditionSet.leaf(
          variantConditionDefinition(
            SchemaVariant.widgetState,
          ).buildLeaf({'state': WidgetState.hovered}),
        ),
        ContextConditionSet.leaf(
          variantConditionDefinition(
            SchemaVariant.breakpoint,
          ).buildLeaf(const {'minWidth': 768.0}),
        ),
      ]);

      expect(
        schema.encode(VariantStyle<BoxSpec>(conditionSet.toVariant(), _style)),
        {
          'type': SchemaVariant.contextAllOf.wireValue,
          'conditions': [
            payloadBreakpointCondition(minWidth: 768),
            payloadWidgetStateCondition(WidgetState.hovered),
          ],
          'style': _encodedStyle,
        },
      );
    });

    test('fails clearly when encoding context_variant_builder variants', () {
      final schema = _buildBoxVariantSchema();
      final variant = ContextVariantBuilder<BoxStyler>((_) => _style);

      expect(
        () => schema.encode(VariantStyle<BoxSpec>(variant, _style)),
        throwsA(
          isA<AckException>().having(
            (error) => error.toString(),
            'error',
            contains('context_variant_builder variants cannot be encoded'),
          ),
        ),
      );
    });
  });
}

const JsonMap _encodedStyle = {'marker': 'encoded'};
final BoxStyler _style = BoxStyler();

AckSchema<VariantStyle<BoxSpec>> _buildBoxVariantSchema() {
  return buildVariantSchema<BoxSpec, BoxStyler>(
    styleSchema: _boxStyleSchema,
    emptyStyle: BoxStyler(),
    registries: RegistryCatalog(const []),
  );
}

final AckSchema<BoxStyler> _boxStyleSchema = Ack.codec<JsonMap, BoxStyler>(
  input: Ack.object({'marker': Ack.string()}),
  output: Ack.instance<BoxStyler>(),
  decoder: (_) => _style,
  encoder: (_) => _encodedStyle,
);
