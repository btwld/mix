import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../core/schema_wire_types.dart';
import 'mix_schema_catalog.dart';
import 'styler_definition.dart';

/// Type-erased bridge used by decoder bootstrap to register typed stylers.
sealed class ErasedStylerDefinition {
  static ErasedStylerDefinition fromDefinition<
    S extends Spec<S>,
    T extends Style<S>
  >(StylerDefinition<S, T> definition) {
    return _TypedErasedStylerDefinition(definition);
  }

  SchemaStyler get type;

  AckSchema<Object> buildFullSchema(MixSchemaCatalog catalog);
}

final class _TypedErasedStylerDefinition<S extends Spec<S>, T extends Style<S>>
    implements ErasedStylerDefinition {
  final StylerDefinition<S, T> _definition;

  const _TypedErasedStylerDefinition(this._definition);

  @override
  AckSchema<Object> buildFullSchema(MixSchemaCatalog catalog) {
    return buildStylerSchemas(
          definition: _definition,
          catalog: catalog,
        ).fullSchema
        as AckSchema<Object>;
  }

  @override
  SchemaStyler get type => _definition.type;
}
