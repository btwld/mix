import 'package:ack/ack.dart';

import '../core/json_map.dart';
import '../core/schema_wire_types.dart';
import '../schema/builtins/box_schema.dart';
import '../schema/builtins/flex_box_schema.dart';
import '../schema/builtins/flex_schema.dart';
import '../schema/builtins/icon_schema.dart';
import '../schema/builtins/image_schema.dart';
import '../schema/builtins/stack_box_schema.dart';
import '../schema/builtins/stack_schema.dart';
import '../schema/builtins/text_schema.dart';
import '../schema/discriminated_branch_registry.dart';
import '../schema/erased_styler_definition.dart';
import '../schema/mix_schema_catalog.dart';
import 'frozen_registry.dart';
import 'registry_catalog.dart';

/// Mutable registry of styler schemas used to build the payload decoder.
final class StylerRegistry {
  final DiscriminatedBranchRegistry<Object> _branches =
      DiscriminatedBranchRegistry<Object>(discriminatorKey: 'type');
  AckSchema<Object>? _payloadSchema;
  bool _frozen = false;

  StylerRegistry();

  /// Whether the registry has been frozen and is ready for decode.
  bool get isFrozen => _frozen;

  /// Creates a mutable registry pre-populated with the built-in styler set.
  ///
  /// The provided registries are wired into the built-in schemas immediately,
  /// so they must contain any runtime values those stylers need at decode time.
  factory StylerRegistry.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
  }) {
    final stylerRegistry = StylerRegistry();
    final registryCatalog = RegistryCatalog(registries);
    final catalog = MixSchemaCatalog(registries: registryCatalog);

    _registerBuiltInStylers(registry: stylerRegistry, catalog: catalog);

    return stylerRegistry;
  }

  /// Registers a styler schema under its wire `type` value.
  void register<T extends Object>(String type, AckSchema<T> stylerSchema) {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    _branches.register(type, stylerSchema);
  }

  /// Freezes the registry and builds the discriminated payload schema.
  void freeze() {
    if (_frozen) {
      throw StateError('Registry is frozen.');
    }

    _payloadSchema = _branches.freeze();
    _frozen = true;
  }

  /// Parses a payload using the frozen discriminated schema.
  SchemaResult<Object> decode(JsonMap payload) {
    if (!_frozen || _payloadSchema == null) {
      throw StateError('Registry must be frozen before decode.');
    }

    return _payloadSchema!.safeParse(payload);
  }
}

void _registerBuiltInStylers({
  required StylerRegistry registry,
  required MixSchemaCatalog catalog,
}) {
  for (final type in SchemaStyler.values) {
    final definition = _selectBuiltInStylerDefinition(
      catalog: catalog,
      type: type,
    );

    _registerBuiltInStyler(
      registry: registry,
      catalog: catalog,
      definition: definition,
    );
  }
}

void _registerBuiltInStyler({
  required StylerRegistry registry,
  required MixSchemaCatalog catalog,
  required ErasedStylerDefinition definition,
}) {
  registry.register(
    definition.type.wireValue,
    definition.buildFullSchema(catalog),
  );
}

ErasedStylerDefinition _selectBuiltInStylerDefinition({
  required MixSchemaCatalog catalog,
  required SchemaStyler type,
}) {
  return switch (type) {
    .box => ErasedStylerDefinition.fromDefinition(
      buildBoxStylerDefinition(catalog),
    ),
    .text => ErasedStylerDefinition.fromDefinition(
      buildTextStylerDefinition(catalog),
    ),
    .flex => ErasedStylerDefinition.fromDefinition(
      buildFlexStylerDefinition(catalog),
    ),
    .icon => ErasedStylerDefinition.fromDefinition(
      buildIconStylerDefinition(catalog),
    ),
    .image => ErasedStylerDefinition.fromDefinition(
      buildImageStylerDefinition(catalog),
    ),
    .stack => ErasedStylerDefinition.fromDefinition(
      buildStackStylerDefinition(catalog),
    ),
    .flexBox => ErasedStylerDefinition.fromDefinition(
      buildFlexBoxStylerDefinition(catalog),
    ),
    .stackBox => ErasedStylerDefinition.fromDefinition(
      buildStackBoxStylerDefinition(catalog),
    ),
  };
}
