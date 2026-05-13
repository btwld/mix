import 'package:mix/mix.dart';

import 'json_map.dart';

/// Reads the raw value from a single-source `Prop<T>`.
///
/// Returns `null` for null props (the encoder should omit the field).
/// Throws if the prop has multiple sources or a non-value source — codec
/// encoders today only handle direct `Prop.value(...)` form. Token and
/// derived props need a richer Prop-aware codec story (Phase 8).
T? propValue<T>(Prop<T>? prop) {
  if (prop == null) return null;
  if (prop.sources.length != 1) {
    throw UnsupportedError('Only single-source value props can be encoded.');
  }

  final source = prop.sources.single;
  if (source is ValueSource<T>) {
    return source.value;
  }

  throw UnsupportedError('Only direct value props can be encoded.');
}

/// Reads the raw value of a required prop. Throws if missing.
T requiredPropValue<T>(Prop<T>? prop, String field) {
  final value = propValue(prop);
  if (value == null) {
    throw StateError('Field "$field" is required.');
  }

  return value;
}

/// Reads the nested `Mix<V>` from a single-source `Prop<V>` whose only source
/// is a `MixSource<V>`. Returns `null` for null props.
M? propMix<M extends Mix>(Prop? prop) {
  if (prop == null) return null;
  if (prop.sources.length != 1) {
    throw UnsupportedError('Only single-source mix props can be encoded.');
  }

  final source = prop.sources.single;
  if (source is MixSource && source.mix is M) {
    return source.mix as M;
  }

  throw UnsupportedError('Only direct mix props can be encoded.');
}

/// Builds a `JsonMap` from `(key, value)` pairs, omitting entries whose
/// value is `null`. Use for optional fields where wire absence is the
/// canonical form for "unset."
JsonMap optionalJsonMap(Iterable<(String, Object?)> fields) {
  final payload = <String, Object?>{};

  for (final (key, value) in fields) {
    if (value != null) {
      payload[key] = value;
    }
  }

  return payload;
}
