import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/src/core/mix_schema_scope.dart';
import 'package:mix_schema/src/core/schema_wire_types.dart';
import 'package:mix_schema/src/errors/mix_schema_error_code.dart';
import 'package:mix_schema/src/errors/schema_error_mapper.dart';
import 'package:mix_schema/src/registry/frozen_registry.dart';
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
        variantConditionDefinition(
          SchemaVariant.widgetState,
        ).buildLeaf({'state': WidgetState.hovered}),
        variantConditionDefinition(
          SchemaVariant.breakpoint,
        ).buildLeaf(const {'minWidth': 768.0}),
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

    test('encodes context_variant_builder variants through reverse lookup', () {
      BoxStyler buildVariant(BuildContext context) => _style;
      final schema = _buildBoxVariantSchema(
        registries: RegistryCatalog([
          FrozenRegistry<Object>(
            scope: MixSchemaScope.contextVariantBuilder.wireValue,
            values: {'context-box': buildVariant},
          ),
        ]),
      );
      final variant = ContextVariantBuilder<BoxStyler>(buildVariant);

      expect(schema.encode(VariantStyle<BoxSpec>(variant, _style)), {
        'type': SchemaVariant.contextBuilder.wireValue,
        'id': 'context-box',
      });
    });

    test('fails clearly for unregistered context_variant_builder values', () {
      final schema = _buildBoxVariantSchema();
      final variant = ContextVariantBuilder<BoxStyler>((_) => _style);
      final result = schema.safeEncode(VariantStyle<BoxSpec>(variant, _style));

      expect(result.isFail, isTrue);
      final errors = const SchemaErrorMapper().map(result.getError());

      final registryErrors = errors.where(
        (error) => error.code == MixSchemaErrorCode.unknownRegistryValue,
      );
      expect(registryErrors, isNotEmpty);
      expect(registryErrors.first.message, contains('No registry id found'));
    });
  });
}

const JsonMap _encodedStyle = {'marker': 'encoded'};
final BoxStyler _style = BoxStyler();

AckSchema<JsonMap, VariantStyle<BoxSpec>> _buildBoxVariantSchema({
  RegistryCatalog? registries,
}) {
  return buildVariantSchema<BoxSpec, BoxStyler>(
    styleSchema: _boxStyleSchema,
    emptyStyle: BoxStyler(),
    registries: registries ?? RegistryCatalog(const []),
  );
}

final _boxStyleSchema = Ack.codec<JsonMap, JsonMap, BoxStyler>(
  input: Ack.object({'marker': Ack.string()}),
  output: Ack.instance<BoxStyler>(),
  decode: (_) => _style,
  encode: (_) => _encodedStyle,
);
