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
  final List<String> unsupportedFields;
  final StylerBuilder<S, T> build;

  const StylerDefinition({
    required this.type,
    required this.emptyStyle,
    required this.fields,
    this.unsupportedFields = const [],
    required this.build,
  });
}

AckSchema<T> buildStylerSchema<S extends Spec<S>, T extends Style<S>>({
  required StylerDefinition<S, T> definition,
  required MixSchemaCatalog catalog,
}) {
  final fields = Map<String, AckSchema>.unmodifiable(definition.fields);
  final variantStyleSchema =
      Ack.object({
        ...fields,
        ...catalog.buildVariantStyleMetadataFields(),
      }).transform<T>((data) {
        final map = data;

        return definition.build(
          map,
          modifier: catalog.buildModifierConfig(map),
        );
      });

  return Ack.object({
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
}
