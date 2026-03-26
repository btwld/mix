import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../core/json_casts.dart';
import '../core/schema_wire_types.dart';
import 'mix_schema_catalog.dart';

typedef StylerBuilder<S extends Spec<S>, T extends Style<S>> =
    T Function(
      Map<String, Object?> data, {
      AnimationConfig? animation,
      WidgetModifierConfig? modifier,
      List<VariantStyle<S>>? variants,
    });

final class StylerDefinition<S extends Spec<S>, T extends Style<S>> {
  final SchemaStyler type;

  final T emptyStyle;
  final Map<String, AckSchema> fields;
  final StylerBuilder<S, T> build;
  const StylerDefinition({
    required this.type,
    required this.emptyStyle,
    required this.fields,
    required this.build,
  });
}

final class StylerSchemaBundle<T extends Object> {
  final AckSchema<T> fieldsSchema;

  final AckSchema<T> fullSchema;
  const StylerSchemaBundle({
    required this.fieldsSchema,
    required this.fullSchema,
  });
}

StylerSchemaBundle<T>
buildStylerSchemas<S extends Spec<S>, T extends Style<S>>({
  required StylerDefinition<S, T> definition,
  required MixSchemaCatalog catalog,
}) {
  final fields = Map<String, AckSchema>.unmodifiable(definition.fields);
  final fieldsSchema = Ack.object(fields).transform<T>((data) {
    return definition.build(data);
  });
  final variantStyleSchema =
      Ack.object({
        ...fields,
        'modifiers': Ack.list(catalog.modifier).optional(),
        'modifierOrder': Ack.list(Ack.string()).optional(),
      }).transform<T>((data) {
        final map = data;

        return definition.build(
          map,
          modifier: catalog.buildModifierConfig(map),
        );
      });

  final fullSchema =
      Ack.object({
        ...fields,
        ...catalog.buildMetadataFields<S, T>(
          styleSchema: variantStyleSchema,
          emptyStyle: definition.emptyStyle,
        ),
      }).transform<T>((data) {
        final map = data;
        final List<VariantStyle<S>>? variants = castListOrNull(map['variants']);

        return definition.build(
          map,
          animation: map['animation'] as AnimationConfig?,
          modifier: catalog.buildModifierConfig(map),
          variants: variants,
        );
      });

  return StylerSchemaBundle<T>(
    fieldsSchema: fieldsSchema,
    fullSchema: fullSchema,
  );
}
