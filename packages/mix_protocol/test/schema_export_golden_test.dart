import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_protocol/testing.dart' show SchemaStyler;

void main() {
  test('schema export structurally describes every built-in branch', () {
    final contract = mixProtocol;
    final schema = contract.exportStyleJsonSchema();
    final encoded = jsonEncode(schema);
    final branches = _branches(schema);
    final branchesByType = {
      for (final branch in branches) _branchType(branch): branch,
    };
    final expectedTypes = SchemaStyler.values
        .map((value) => value.wireValue)
        .toList(growable: false);

    expect(schema[r'$schema'], 'http://json-schema.org/draft-07/schema#');
    expect(schema['x-mix-protocol-contract'], 'mix_protocol');
    expect(schema['x-mix-protocol-version'], isA<String>());
    expect(schema['x-mix-protocol-format-version'], mixProtocolFormatVersion);
    expect(branches, hasLength(expectedTypes.length));
    expect(branchesByType.keys.toSet(), expectedTypes.toSet());

    for (final type in expectedTypes) {
      final branch = branchesByType[type]!;
      final properties = _properties(branch);
      final required = _required(branch);
      final version = _object(properties['v']);
      final discriminator = _object(properties['type']);

      expect(required, contains('v'), reason: type);
      expect(required, contains('type'), reason: type);
      expect(version['type'], 'integer', reason: type);
      expect(version['const'], mixProtocolFormatVersion, reason: type);
      expect(discriminator['type'], 'string', reason: type);
      expect(discriminator['const'], type, reason: type);
      expect(properties.keys.toSet(), {
        'v',
        'type',
        ..._expectedBranchProperties[type]!,
      }, reason: type);
      expect(_expectedBranchProperties[type], isNot(contains('v')));
      expect(_expectedBranchProperties[type], isNot(contains('type')));
    }

    expect(encoded, isNot(contains('x-ack-codec')));
    expect(encoded, contains(r'"$token"'));
    expect(encoded, contains(r'"$merge"'));
    expect(encoded, contains(r'"apply"'));
    expect(encoded, contains(r'"op"'));
    final definitions = _object(schema['definitions']);
    expect(
      definitions.keys,
      containsAll([
        'mix_protocol_property_term',
        'mix_protocol_property_control_term',
        'mix_protocol_box_decoration_literal',
        'mix_protocol_directive',
        'mix_protocol_strut_style_literal',
        'mix_protocol_text_style_literal',
      ]),
    );
    expect(
      _hasPropertyControlTerm(
        _propertySchemaAt(branchesByType['text']!, [
          'style',
          'color',
        ], definitions),
      ),
      isTrue,
    );
    expect(
      _hasPropertyControlTerm(
        _propertySchemaAt(branchesByType['text']!, [
          'strutStyle',
          'fontSize',
        ], definitions),
      ),
      isTrue,
    );
    expect(
      _hasPropertyControlTerm(
        _propertySchemaAt(branchesByType['box']!, [
          'decoration',
          'boxShadow',
        ], definitions),
      ),
      isTrue,
    );
    expect(encoded, contains(r'"fractionally_sized_box"'));
    expect(encoded, contains(r'"default_text_styler"'));
    expect(encoded, contains(r'"spring"'));
    expect(encoded, contains(r'"cubic"'));
    expect(encoded, contains(r'"context_orientation"'));
    expect(encoded, contains(r'"context_directionality"'));
    expect(encoded, contains(r'"context_platform"'));
    expect(encoded, contains(r'"context_web"'));
    expect(encoded, contains(r'"context_not"'));
    expect(encoded, contains(r'"foregroundDecoration"'));
    expect(encoded, contains(r'"strutStyle"'));
    expect(encoded, contains(r'"textScaler"'));
    expect(encoded, contains(r'"centerSlice"'));
    expect(encoded, contains(r'[A-Za-z0-9_.-]{1,128}'));
    expect(encoded, contains(r'"space"'));
    expect(encoded, contains(r'"double"'));
    expect(encoded.length, lessThan(520000));
    expect(_object(_properties(branchesByType['box']!)['padding']), {
      r'$ref': '#/definitions/mix_protocol_double_property_term',
    });
    final propertyTerm = _object(definitions['mix_protocol_property_term']);
    expect(_matchesPropertyTerm(propertyTerm, 4, definitions), isTrue);
    expect(
      _matchesPropertyTerm(propertyTerm, {'left': 4}, definitions),
      isTrue,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {
        r'$token': 'space.stack.sm',
      }, definitions),
      isTrue,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {
        r'$merge': [4, 8],
      }, definitions),
      isTrue,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {r'$token': 7}, definitions),
      isFalse,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {
        r'$token': 'x',
        'bad': 1,
      }, definitions),
      isFalse,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {
        r'$token': 'color.brand',
        'kind': 'space',
      }, definitions),
      isFalse,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {r'$merge': []}, definitions),
      isFalse,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {
        r'$merge': [4],
      }, definitions),
      isFalse,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {
        r'$merge': [4],
        'apply': [
          {'op': 'number_multiply', 'factor': 2},
        ],
      }, definitions),
      isTrue,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {
        r'$merge': [4],
        'apply': [],
      }, definitions),
      isFalse,
    );
    expect(
      _matchesPropertyTerm(propertyTerm, {'apply': []}, definitions),
      isFalse,
    );
    expect(
      _matchesJsonSchema(
        _object(_properties(branchesByType['text']!)['selectionColor']),
        {r'$token': 'color.brand', 'kind': 'space'},
        definitions,
      ),
      isFalse,
    );
    expect(
      _matchesJsonSchema(
        _object(_properties(branchesByType['flex']!)['spacing']),
        {r'$token': 'space.stack.sm', 'kind': 'space'},
        definitions,
      ),
      isTrue,
    );
    expect(
      _matchesJsonSchema(
        _object(_properties(branchesByType['flex']!)['spacing']),
        {r'$token': 'double.gap', 'kind': 'double'},
        definitions,
      ),
      isTrue,
    );
    expect(
      _matchesJsonSchema(
        _object(_properties(branchesByType['flex']!)['spacing']),
        {
          r'$merge': [
            {r'$token': 'space.stack.sm', 'kind': 'space'},
            4,
          ],
        },
        definitions,
      ),
      isTrue,
    );
    expect(
      _matchesJsonSchema(
        _propertySchemaAt(branchesByType['text']!, [
          'style',
          'fontSize',
        ], definitions),
        {r'$token': 'space.font.md', 'kind': 'space'},
        definitions,
      ),
      isTrue,
    );
    expect(
      _matchesJsonSchema(
        _propertySchemaAt(branchesByType['text']!, [
          'style',
          'color',
        ], definitions),
        {r'$token': 'color.brand', 'kind': 'space'},
        definitions,
      ),
      isFalse,
    );
    expect(
      _matchesJsonSchema(
        _propertySchemaAt(branchesByType['text']!, [
          'strutStyle',
          'leading',
        ], definitions),
        {r'$token': 'space.leading.tight', 'kind': 'space'},
        definitions,
      ),
      isTrue,
    );
    final directive = _object(definitions['mix_protocol_directive']);
    expect(
      _matchesJsonSchema(directive, {
        'op': 'color_opacity',
        'opacity': 0.5,
      }, definitions),
      isTrue,
    );
    expect(
      _matchesJsonSchema(directive, {
        'op': 'color_opacity',
        'opacity': 0.5,
        'alpha': 0.7,
      }, definitions),
      isFalse,
    );
    expect(
      _requiredListsContainingVersion(schema),
      hasLength(SchemaStyler.values.length),
      reason: 'Only top-level branches require the v envelope.',
    );
  });
}

const _expectedBranchProperties = {
  'box': {
    'alignment',
    'padding',
    'margin',
    'constraints',
    'clipBehavior',
    'transform',
    'transformAlignment',
    'decoration',
    'foregroundDecoration',
    'variants',
    'modifiers',
    'animation',
  },
  'text': {
    'overflow',
    'strutStyle',
    'textAlign',
    'textScaler',
    'maxLines',
    'style',
    'textWidthBasis',
    'textDirection',
    'softWrap',
    'selectionColor',
    'semanticsLabel',
    'locale',
    'textHeightBehavior',
    'textDirectives',
    'variants',
    'modifiers',
    'animation',
  },
  'flex': {
    'direction',
    'mainAxisAlignment',
    'crossAxisAlignment',
    'mainAxisSize',
    'verticalDirection',
    'textDirection',
    'textBaseline',
    'clipBehavior',
    'spacing',
    'variants',
    'modifiers',
    'animation',
  },
  'stack': {
    'alignment',
    'fit',
    'textDirection',
    'clipBehavior',
    'variants',
    'modifiers',
    'animation',
  },
  'icon': {
    'icon',
    'color',
    'size',
    'weight',
    'grade',
    'opticalSize',
    'shadows',
    'textDirection',
    'applyTextScaling',
    'fill',
    'semanticsLabel',
    'opacity',
    'blendMode',
    'variants',
    'modifiers',
    'animation',
  },
  'image': {
    'image',
    'width',
    'height',
    'color',
    'repeat',
    'fit',
    'alignment',
    'centerSlice',
    'filterQuality',
    'colorBlendMode',
    'semanticLabel',
    'excludeFromSemantics',
    'gaplessPlayback',
    'isAntiAlias',
    'matchTextDirection',
    'variants',
    'modifiers',
    'animation',
  },
  'flex_box': {
    'alignment',
    'padding',
    'margin',
    'constraints',
    'clipBehavior',
    'transform',
    'transformAlignment',
    'decoration',
    'direction',
    'mainAxisAlignment',
    'crossAxisAlignment',
    'mainAxisSize',
    'verticalDirection',
    'textDirection',
    'textBaseline',
    'flexClipBehavior',
    'spacing',
    'variants',
    'modifiers',
    'animation',
  },
  'stack_box': {
    'alignment',
    'padding',
    'margin',
    'constraints',
    'clipBehavior',
    'transform',
    'transformAlignment',
    'decoration',
    'stackAlignment',
    'fit',
    'textDirection',
    'stackClipBehavior',
    'variants',
    'modifiers',
    'animation',
  },
};

List<JsonMap> _branches(JsonMap schema) {
  return (schema['anyOf'] as List).map((branch) => _object(branch)).toList();
}

String _branchType(JsonMap branch) {
  final typeProperty = _object(_properties(branch)['type']);

  return typeProperty['const']! as String;
}

JsonMap _properties(JsonMap branch) {
  return _object(branch['properties']);
}

JsonMap _propertySchemaAt(
  JsonMap schema,
  List<String> path,
  JsonMap definitions,
) {
  var current = schema;
  for (final segment in path) {
    current = _object(
      _literalPropertiesContaining(current, definitions, segment)[segment],
    );
  }

  return current;
}

JsonMap _literalPropertiesContaining(
  JsonMap schema,
  JsonMap definitions,
  String property,
) {
  final properties = _tryLiteralPropertiesContaining(
    schema,
    definitions,
    property,
  );
  if (properties != null) return properties;

  fail('Schema node does not expose literal property "$property": $schema');
}

JsonMap? _tryLiteralPropertiesContaining(
  Object? schema,
  JsonMap definitions,
  String property,
) {
  if (schema is! Map) return null;

  final ref = schema[r'$ref'];
  if (ref is String && ref.startsWith('#/definitions/')) {
    final name = ref.substring('#/definitions/'.length);

    return _tryLiteralPropertiesContaining(
      definitions[name],
      definitions,
      property,
    );
  }

  final properties = schema['properties'];
  if (properties is Map && properties.containsKey(property)) {
    return _object(properties);
  }

  final anyOf = schema['anyOf'];
  if (anyOf is List) {
    for (final branch in anyOf) {
      final nested = _tryLiteralPropertiesContaining(
        branch,
        definitions,
        property,
      );
      if (nested != null) return nested;
    }
  }

  return null;
}

bool _hasPropertyControlTerm(JsonMap schema) {
  final anyOf = schema['anyOf'];
  if (anyOf is! List) return false;

  return anyOf.any(
    (branch) =>
        branch is Map &&
        (branch[r'$ref'] ==
                '#/definitions/mix_protocol_property_control_term' ||
            branch[r'$ref'] ==
                '#/definitions/mix_protocol_double_property_control_term'),
  );
}

List<String> _required(JsonMap branch) {
  return (branch['required'] as List).cast<String>();
}

JsonMap _object(Object? value) {
  return Map<String, Object?>.from(value! as Map);
}

bool _matchesPropertyTerm(JsonMap schema, Object? value, JsonMap definitions) {
  final anyOf = schema['anyOf']! as List;

  return anyOf.any(
    (branch) => _matchesJsonSchema(_object(branch), value, definitions),
  );
}

bool _matchesJsonSchema(JsonMap schema, Object? value, JsonMap definitions) {
  final ref = schema[r'$ref'];
  if (ref is String && ref.startsWith('#/definitions/')) {
    final name = ref.substring('#/definitions/'.length);

    return _matchesJsonSchema(_object(definitions[name]), value, definitions);
  }

  final anyOf = schema['anyOf'];
  if (anyOf is List &&
      !anyOf.any(
        (branch) => _matchesJsonSchema(_object(branch), value, definitions),
      )) {
    return false;
  }

  final not = schema['not'];
  if (not is Map && _matchesJsonSchema(_object(not), value, definitions)) {
    return false;
  }

  final type = schema['type'];
  if (type is String && !_matchesJsonType(type, value)) return false;

  final required = (schema['required'] as List?)?.cast<String>() ?? const [];
  if (required.isNotEmpty) {
    if (value is! Map) return false;
    for (final key in required) {
      if (!value.containsKey(key)) return false;
    }
  }

  final minItems = schema['minItems'];
  if (minItems is int && value is List && value.length < minItems) {
    return false;
  }

  final maxItems = schema['maxItems'];
  if (maxItems is int && value is List && value.length > maxItems) {
    return false;
  }

  final items = schema['items'];
  if (items is Map && value is List) {
    for (final item in value) {
      if (!_matchesJsonSchema(_object(items), item, definitions)) {
        return false;
      }
    }
  }

  if (schema.containsKey('const') && schema['const'] != value) return false;

  final enumValues = schema['enum'];
  if (enumValues is List && !enumValues.contains(value)) return false;

  final properties = schema['properties'];
  if (properties is Map && value is Map) {
    final propertySchemas = Map<String, Object?>.from(properties);
    if (schema['additionalProperties'] == false) {
      for (final key in value.keys) {
        if (!propertySchemas.containsKey(key)) return false;
      }
    }
    for (final entry in propertySchemas.entries) {
      if (!value.containsKey(entry.key)) continue;
      if (!_matchesJsonSchema(
        _object(entry.value),
        value[entry.key],
        definitions,
      )) {
        return false;
      }
    }
  }

  final pattern = schema['pattern'];
  if (pattern is String &&
      value is String &&
      !RegExp(pattern).hasMatch(value)) {
    return false;
  }

  return true;
}

bool _matchesJsonType(String type, Object? value) {
  return switch (type) {
    'array' => value is List,
    'boolean' => value is bool,
    'integer' => value is int,
    'number' => value is num,
    'object' => value is Map,
    'string' => value is String,
    _ => false,
  };
}

List<List<String>> _requiredListsContainingVersion(Object? value) {
  final matches = <List<String>>[];
  void visit(Object? node) {
    if (node is Map) {
      final required = node['required'];
      if (required is List && required.contains('v')) {
        matches.add(required.cast<String>());
      }
      for (final child in node.values) {
        visit(child);
      }
    } else if (node is List) {
      for (final child in node) {
        visit(child);
      }
    }
  }

  visit(value);

  return matches;
}
