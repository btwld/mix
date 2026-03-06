import 'package:ack/ack.dart';

import '../core/json_map.dart';
import '../schema/discriminated_branch_registry.dart';

/// Mutable registry of styler schemas used to build the payload decoder.
final class StylerRegistry {
  final DiscriminatedBranchRegistry<Object> _branches =
      DiscriminatedBranchRegistry<Object>(discriminatorKey: 'type');
  AckSchema<Object>? _payloadSchema;
  bool _frozen = false;

  /// Whether the registry has been frozen and is ready for decode.
  bool get isFrozen => _frozen;

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
