import '../core/json_map.dart';
import '../errors/mix_schema_decode_result.dart';
import '../errors/schema_error_mapper.dart';
import '../registry/frozen_registry.dart';
import '../registry/styler_registry.dart';

/// Decodes payload maps into Mix styling objects.
///
/// The decoder consumes a frozen [StylerRegistry] so that runtime payload
/// dispatch is deterministic and cannot change during decode.
final class MixSchemaDecoder {
  final StylerRegistry _stylerRegistry;

  final SchemaErrorMapper _errorMapper = const SchemaErrorMapper();

  MixSchemaDecoder({required StylerRegistry stylerRegistry})
    : _stylerRegistry = stylerRegistry {
    if (!stylerRegistry.isFrozen) {
      throw StateError('StylerRegistry must be frozen before decode.');
    }
  }

  /// Builds a decoder with the built-in styler set and the provided registries.
  factory MixSchemaDecoder.builtIn({
    Iterable<FrozenRegistry<Object>> registries = const [],
  }) {
    final stylerRegistry = StylerRegistry.builtIn(registries: registries)
      ..freeze();

    return MixSchemaDecoder(stylerRegistry: stylerRegistry);
  }

  /// Validates and decodes a payload into a Mix runtime object.
  MixSchemaDecodeResult<Object> decode(JsonMap payload) {
    final result = _stylerRegistry.decode(payload);

    return result.match(
      onOk: (value) => MixSchemaDecodeResult.success(value!),
      onFail: (error) => MixSchemaDecodeResult.failure(_errorMapper.map(error)),
    );
  }
}
