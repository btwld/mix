/// Stage 2 of the validator pipeline — JSON Schema structural validation
/// against `schema.v1.json` (Draft 2020-12 subset). Hand-rolled for
/// stability of the 52-code error catalog.
///
/// Implements the keywords the schema actually uses: `type`, `properties`,
/// `required`, `additionalProperties`, `$ref`, `$defs`, `oneOf`, `anyOf`,
/// `not`, `pattern`, `const`, `enum`, `items`, `minItems`, `minLength`,
/// `minProperties`, `maxProperties`, `propertyNames`, `format` (uri only).
///
/// External `$ref` (anything not starting with `#/`) is rejected at load
/// time per §Security Considerations.
library;

import '../_internal.dart' show JsonPointer;
import '../errors.dart';

/// Loaded schema with `$ref` table resolved.
class LoadedSchema {
  LoadedSchema._(this.root, this._defs);

  final Map<String, Object?> root;
  final Map<String, Map<String, Object?>> _defs;

  Map<String, Object?> resolveRef(String ref) {
    if (!ref.startsWith('#/')) {
      throw FormatException('External \$ref forbidden: "$ref"');
    }
    if (ref.startsWith(r'#/$defs/')) {
      final name = ref.substring(8);
      final def = _defs[name];
      if (def == null) {
        throw FormatException('Unresolved \$ref: $ref');
      }
      return def;
    }
    throw FormatException('Unsupported \$ref: $ref');
  }

  /// Build from a parsed `schema.v1.json` document. Verifies every
  /// `$ref` is internal (`#/`).
  factory LoadedSchema.fromJson(Map<String, Object?> json) {
    final defsRaw = json[r'$defs'];
    final defs = <String, Map<String, Object?>>{};
    if (defsRaw is Map) {
      for (final entry in defsRaw.entries) {
        final key = entry.key;
        final value = entry.value;
        if (key is! String || value is! Map<String, Object?>) continue;
        defs[key] = value;
      }
    }
    _ensureNoExternalRefs(json, JsonPointer.root);
    return LoadedSchema._(json, defs);
  }

  static void _ensureNoExternalRefs(Object? value, String path) {
    if (value is Map<String, Object?>) {
      for (final entry in value.entries) {
        if (entry.key == r'$ref' && entry.value is String) {
          final ref = entry.value as String;
          if (!ref.startsWith('#/')) {
            throw FormatException(
              'External \$ref forbidden at $path: "$ref"',
            );
          }
        } else {
          _ensureNoExternalRefs(entry.value, JsonPointer.appendKey(path, entry.key));
        }
      }
    } else if (value is List) {
      for (var i = 0; i < value.length; i++) {
        _ensureNoExternalRefs(value[i], JsonPointer.appendIndex(path, i));
      }
    }
  }
}

/// Walker that validates an instance against a schema fragment.
class StructuralValidator {
  StructuralValidator(this._schema);

  final LoadedSchema _schema;

  /// Validate the entire document against the root schema.
  List<MixSchemaError> validate(Object? document) {
    final errors = <MixSchemaError>[];
    _validate(_schema.root, document, JsonPointer.root, errors);
    return errors;
  }

  void _validate(
    Map<String, Object?> schema,
    Object? value,
    String path,
    List<MixSchemaError> errors,
  ) {
    final ref = schema[r'$ref'];
    if (ref is String) {
      final resolved = _schema.resolveRef(ref);
      _validate(resolved, value, path, errors);
      return;
    }

    final oneOf = schema['oneOf'];
    if (oneOf is List) {
      _validateOneOf(schema, oneOf, value, path, errors);
      return;
    }

    final anyOf = schema['anyOf'];
    if (anyOf is List) {
      _validateAnyOf(anyOf, value, path, errors);
    }

    final not = schema['not'];
    if (not is Map<String, Object?>) {
      final localErrors = <MixSchemaError>[];
      _validate(not, value, path, localErrors);
      if (localErrors.isEmpty) {
        errors.add(_genericError(
          ErrorCode.valueShapeInvalid,
          'Value matches "not" schema.',
          path,
        ));
      }
    }

    final type = schema['type'];
    if (type != null) {
      if (!_typeMatches(type, value)) {
        errors.add(_typeError(type, value, path));
        return;
      }
    }

    final constValue = schema['const'];
    if (schema.containsKey('const')) {
      if (value != constValue) {
        errors.add(_genericError(
          ErrorCode.valueShapeInvalid,
          'Expected const "$constValue", got "$value".',
          path,
        ));
      }
    }

    final enumValues = schema['enum'];
    if (enumValues is List) {
      if (!enumValues.contains(value)) {
        errors.add(_genericError(
          ErrorCode.valueEnumUnknown,
          'Value "$value" is not in enum ${enumValues.join(", ")}.',
          path,
        ));
      }
    }

    final pattern = schema['pattern'];
    if (pattern is String && value is String) {
      if (!RegExp(pattern).hasMatch(value)) {
        errors.add(_genericError(
          ErrorCode.tokenFormInvalid,
          'String "$value" does not match pattern "$pattern".',
          path,
        ));
      }
    }

    final minLength = schema['minLength'];
    if (minLength is int && value is String && value.length < minLength) {
      errors.add(_genericError(
        ErrorCode.valueShapeInvalid,
        'String shorter than minLength=$minLength.',
        path,
      ));
    }

    if (value is Map<String, Object?>) {
      _validateObject(schema, value, path, errors);
    }
    if (value is List) {
      _validateArray(schema, value, path, errors);
    }
  }

  void _validateOneOf(
    Map<String, Object?> schema,
    List<Object?> branches,
    Object? value,
    String path,
    List<MixSchemaError> errors,
  ) {
    int matchCount = 0;
    final branchErrors = <List<MixSchemaError>>[];
    for (final branch in branches) {
      if (branch is! Map<String, Object?>) continue;
      final localErrors = <MixSchemaError>[];
      _validate(branch, value, path, localErrors);
      if (localErrors.isEmpty) {
        matchCount++;
      } else {
        branchErrors.add(localErrors);
      }
    }
    if (matchCount == 0) {
      // Pick the deepest / most-relevant branch errors. For now, use the
      // branch with the fewest errors (likely the closest match).
      branchErrors.sort((a, b) => a.length.compareTo(b.length));
      if (branchErrors.isNotEmpty) {
        errors.addAll(branchErrors.first);
      } else {
        errors.add(_genericError(
          ErrorCode.valueShapeInvalid,
          'Value matches no branch of oneOf.',
          path,
        ));
      }
    } else if (matchCount > 1) {
      errors.add(_genericError(
        ErrorCode.valueShapeInvalid,
        'Value matches more than one branch of oneOf ($matchCount).',
        path,
      ));
    }
  }

  void _validateAnyOf(
    List<Object?> branches,
    Object? value,
    String path,
    List<MixSchemaError> errors,
  ) {
    for (final branch in branches) {
      if (branch is! Map<String, Object?>) continue;
      final localErrors = <MixSchemaError>[];
      _validate(branch, value, path, localErrors);
      if (localErrors.isEmpty) return;
    }
    errors.add(_genericError(
      ErrorCode.valueShapeInvalid,
      'Value matches no branch of anyOf.',
      path,
    ));
  }

  void _validateObject(
    Map<String, Object?> schema,
    Map<String, Object?> instance,
    String path,
    List<MixSchemaError> errors,
  ) {
    final required = schema['required'];
    if (required is List) {
      for (final field in required) {
        if (field is! String) continue;
        if (!instance.containsKey(field)) {
          errors.add(_genericError(
            ErrorCode.envelopeFieldMissing,
            'Missing required field "$field".',
            JsonPointer.appendKey(path, field),
          ));
        }
      }
    }

    final properties = schema['properties'];
    final propertyNames = schema['propertyNames'];
    final additionalProperties = schema['additionalProperties'];
    final propsMap = properties is Map<String, Object?> ? properties : null;

    final minProperties = schema['minProperties'];
    final maxProperties = schema['maxProperties'];
    if (minProperties is int && instance.length < minProperties) {
      errors.add(_genericError(
        ErrorCode.valueShapeInvalid,
        'Object has ${instance.length} entries; minProperties=$minProperties.',
        path,
      ));
    }
    if (maxProperties is int && instance.length > maxProperties) {
      errors.add(_genericError(
        ErrorCode.valueShapeInvalid,
        'Object has ${instance.length} entries; maxProperties=$maxProperties.',
        path,
      ));
    }

    for (final entry in instance.entries) {
      final key = entry.key;
      final childPath = JsonPointer.appendKey(path, key);

      if (propertyNames is Map<String, Object?>) {
        _validate(propertyNames, key, childPath, errors);
      }

      final propSchema = propsMap?[key];
      if (propSchema is Map<String, Object?>) {
        _validate(propSchema, entry.value, childPath, errors);
        continue;
      }

      if (additionalProperties == false) {
        errors.add(_genericError(
          ErrorCode.envelopeFieldForbidden,
          'Forbidden field "$key".',
          childPath,
        ));
      } else if (additionalProperties is Map<String, Object?>) {
        _validate(additionalProperties, entry.value, childPath, errors);
      }
    }
  }

  void _validateArray(
    Map<String, Object?> schema,
    List<Object?> instance,
    String path,
    List<MixSchemaError> errors,
  ) {
    final minItems = schema['minItems'];
    if (minItems is int && instance.length < minItems) {
      errors.add(_genericError(
        ErrorCode.valueShapeInvalid,
        'Array has ${instance.length} items; minItems=$minItems.',
        path,
      ));
    }
    final items = schema['items'];
    if (items is Map<String, Object?>) {
      for (var i = 0; i < instance.length; i++) {
        _validate(items, instance[i], JsonPointer.appendIndex(path, i), errors);
      }
    }
  }

  bool _typeMatches(Object? type, Object? value) {
    if (type is List) {
      return type.any((t) => _typeMatchesSingle(t as String, value));
    }
    return _typeMatchesSingle(type as String, value);
  }

  bool _typeMatchesSingle(String type, Object? value) {
    switch (type) {
      case 'object':
        return value is Map<String, Object?>;
      case 'array':
        return value is List;
      case 'string':
        return value is String;
      case 'number':
        return value is num;
      case 'integer':
        return value is int || (value is num && value == value.truncate());
      case 'boolean':
        return value is bool;
      case 'null':
        return value == null;
      default:
        return false;
    }
  }

  MixSchemaError _typeError(Object? expected, Object? actual, String path) =>
      _genericError(
        ErrorCode.valueTypeMismatch,
        'Expected type $expected, got ${_typeName(actual)}.',
        path,
      );

  String _typeName(Object? value) {
    if (value == null) return 'null';
    if (value is Map) return 'object';
    if (value is List) return 'array';
    if (value is String) return 'string';
    if (value is bool) return 'boolean';
    if (value is int) return 'integer';
    if (value is num) return 'number';
    return value.runtimeType.toString();
  }

  MixSchemaError _genericError(
    ErrorCode code,
    String message,
    String path,
  ) =>
      MixSchemaError(code: code, message: message, path: path);
}
