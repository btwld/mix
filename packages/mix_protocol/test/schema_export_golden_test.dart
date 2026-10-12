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
    expect(encoded.contains(r'"$token"'), isTrue, reason: r'"$token"');
    expect(encoded.contains(r'"$merge"'), isTrue, reason: r'"$merge"');
    expect(encoded.contains(r'"apply"'), isTrue, reason: r'"apply"');
    expect(encoded.contains(r'"op"'), isTrue, reason: r'"op"');
    final definitions = _object(schema['definitions']);
    expect(
      definitions.keys,
      containsAll([
        'mix_protocol_color_directive',
        'mix_protocol_number_directive',
        'mix_protocol_string_directive',
      ]),
    );
    expect(
      encoded.contains(r'"fractionally_sized_box"'),
      isTrue,
      reason: r'"fractionally_sized_box"',
    );
    expect(
      encoded.contains(r'"default_text_styler"'),
      isTrue,
      reason: r'"default_text_styler"',
    );
    expect(encoded.contains(r'"spring"'), isTrue, reason: r'"spring"');
    expect(encoded.contains(r'"cubic"'), isTrue, reason: r'"cubic"');
    expect(
      encoded.contains(r'"context_orientation"'),
      isTrue,
      reason: r'"context_orientation"',
    );
    expect(
      encoded.contains(r'"context_directionality"'),
      isTrue,
      reason: r'"context_directionality"',
    );
    expect(
      encoded.contains(r'"context_platform"'),
      isTrue,
      reason: r'"context_platform"',
    );
    expect(
      encoded.contains(r'"context_web"'),
      isTrue,
      reason: r'"context_web"',
    );
    expect(
      encoded.contains(r'"context_not"'),
      isTrue,
      reason: r'"context_not"',
    );
    expect(
      encoded.contains(r'"foregroundDecoration"'),
      isTrue,
      reason: r'"foregroundDecoration"',
    );
    expect(encoded.contains(r'"strutStyle"'), isTrue, reason: r'"strutStyle"');
    expect(encoded.contains(r'"textScaler"'), isTrue, reason: r'"textScaler"');
    expect(
      encoded.contains(r'"centerSlice"'),
      isTrue,
      reason: r'"centerSlice"',
    );
    expect(
      encoded.contains(r'[A-Za-z0-9_.-]{1,128}'),
      isTrue,
      reason: r'[A-Za-z0-9_.-]{1,128}',
    );
    expect(encoded.contains(r'"space"'), isTrue, reason: r'"space"');
    expect(encoded.contains(r'"double"'), isTrue, reason: r'"double"');
    expect(encoded.length, lessThan(520000));
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
  'wrap': {
    'direction',
    'alignment',
    'spacing',
    'runAlignment',
    'runSpacing',
    'crossAxisAlignment',
    'textDirection',
    'verticalDirection',
    'clipBehavior',
    'variants',
    'modifiers',
    'animation',
  },
  'wrap_box': {
    'alignment',
    'padding',
    'margin',
    'constraints',
    'clipBehavior',
    'transform',
    'transformAlignment',
    'decoration',
    'foregroundDecoration',
    'direction',
    'wrapAlignment',
    'spacing',
    'runAlignment',
    'runSpacing',
    'crossAxisAlignment',
    'textDirection',
    'verticalDirection',
    'wrapClipBehavior',
    'variants',
    'modifiers',
    'animation',
  },
  'grid_box': {
    'columns',
    'rows',
    'autoRows',
    'columnGap',
    'rowGap',
    'clipBehavior',
    'constraintBranches',
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

List<String> _required(JsonMap branch) {
  return (branch['required'] as List).cast<String>();
}

JsonMap _object(Object? value) {
  return Map<String, Object?>.from(value! as Map);
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
