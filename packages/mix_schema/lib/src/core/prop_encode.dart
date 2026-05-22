import 'package:ack/ack.dart' show JsonMap;
import 'package:mix/mix.dart';

import '../errors/schema_transform_exceptions.dart';

/// Reads the raw value from a single-source `Prop<T>` that holds a direct
/// [ValueSource].
///
/// Returns `null` for null props (the encoder should omit the field).
/// Throws [UnsupportedEncodeValueError] if the prop has multiple sources or a
/// non-value source — codec encoders today only handle direct `Prop.value(...)`
/// form. Token and derived props need a richer Prop-aware codec story.
T? directPropValue<T>(Prop<T>? prop) {
  if (prop == null) return null;
  if (prop.sources.length != 1) {
    throw UnsupportedEncodeValueError(
      'Only single-source value props can be encoded.',
      value: prop,
    );
  }

  final source = prop.sources.single;
  if (source is ValueSource<T>) {
    return source.value;
  }

  throw UnsupportedEncodeValueError(
    'Only direct value props can be encoded.',
    value: prop,
  );
}

/// Reads the raw value of a required direct prop. Throws if missing.
T requiredDirectPropValue<T>(Prop<T>? prop, String field) {
  final value = directPropValue(prop);
  if (value == null) {
    throw UnsupportedEncodeValueError(
      'Field "$field" is required.',
      value: prop,
    );
  }

  return value;
}

/// Reads the nested `Mix<V>` from a single-source `Prop<V>` whose only source
/// is a `MixSource<V>`. Returns `null` for null props.
M? directPropMix<M extends Mix>(Prop? prop) {
  if (prop == null) return null;
  if (prop.sources.length != 1) {
    throw UnsupportedEncodeValueError(
      'Only single-source mix props can be encoded.',
      value: prop,
    );
  }

  final source = prop.sources.single;
  if (source is MixSource && source.mix is M) {
    return source.mix as M;
  }

  throw UnsupportedEncodeValueError(
    'Only direct mix props can be encoded.',
    value: prop,
  );
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
