import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test('R-2 schema export structurally describes every built-in branch', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final schema = contract.exportJsonSchema();
    final encoded = jsonEncode(schema);
    final branches = _branches(schema);
    final branchesByType = {
      for (final branch in branches) _branchType(branch): branch,
    };

    expect(schema[r'$schema'], 'http://json-schema.org/draft-07/schema#');
    expect(schema['x-mix-schema-contract'], 'mix_schema');
    expect(schema['x-mix-schema-version'], isA<String>());
    expect(schema['x-mix-schema-limits'], isA<Map>());
    expect(branches, hasLength(contract.registeredTypes.length));
    expect(branchesByType.keys.toSet(), contract.registeredTypes.toSet());

    for (final type in contract.registeredTypes) {
      final branch = branchesByType[type]!;
      final properties = _properties(branch);
      final required = _required(branch);
      final discriminator = _object(properties['type']);

      expect(required, contains('type'), reason: type);
      expect(discriminator['type'], 'string', reason: type);
      expect(discriminator['const'], type, reason: type);
      expect(
        properties.keys.toSet(),
        containsAll({'type', ..._expectedBranchProperties[type]!}),
        reason: type,
      );
      expect(_expectedBranchProperties[type], isNot(contains('type')));
    }

    expect(encoded, isNot(contains('x-ack-codec')));
    expect(encoded.length, lessThan(150000));
  });
}

const _expectedBranchProperties = {
  'box': {
    'alignment',
    'padding',
    'margin',
    'constraints',
    'clipBehavior',
    'decoration',
    'variants',
    'modifiers',
    'animation',
  },
  'text': {
    'overflow',
    'textAlign',
    'maxLines',
    'style',
    'textDirection',
    'softWrap',
    'selectionColor',
    'semanticsLabel',
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
    'modifiers',
    'animation',
  },
  'stack': {
    'alignment',
    'fit',
    'textDirection',
    'clipBehavior',
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
    'textDirection',
    'applyTextScaling',
    'fill',
    'semanticsLabel',
    'opacity',
    'blendMode',
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
    'filterQuality',
    'colorBlendMode',
    'semanticLabel',
    'excludeFromSemantics',
    'gaplessPlayback',
    'isAntiAlias',
    'matchTextDirection',
    'modifiers',
    'animation',
  },
  'flex_box': {
    'alignment',
    'padding',
    'margin',
    'constraints',
    'clipBehavior',
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
    'modifiers',
    'animation',
  },
  'stack_box': {
    'alignment',
    'padding',
    'margin',
    'constraints',
    'clipBehavior',
    'decoration',
    'stackAlignment',
    'fit',
    'textDirection',
    'stackClipBehavior',
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

List<String> _required(JsonMap branch) {
  return (branch['required'] as List).cast<String>();
}

JsonMap _object(Object? value) {
  return Map<String, Object?>.from(value! as Map);
}
