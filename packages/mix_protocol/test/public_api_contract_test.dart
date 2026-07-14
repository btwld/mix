import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_protocol/testing.dart' as protocol_testing;

void main() {
  test('public API exposes one fixed protocol facade and generic results', () {
    final MixProtocol protocol = mixProtocol;
    final MixProtocolResult<BoxStyler> decoded = protocol
        .decodeStyle<BoxStyler>({'v': 1, 'type': 'box'});
    final MixProtocolResult<JsonMap> encoded = protocol.encodeStyle(
      BoxStyler(),
    );
    final MixProtocolResult<MixProtocolTheme> theme = protocol.decodeTheme({
      'v': 1,
      'type': 'theme',
    });
    final decodedTheme = switch (theme) {
      MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
      MixProtocolFailure<MixProtocolTheme>(:final errors) => fail('$errors'),
    };
    final MixProtocolResult<JsonMap> encodedTheme = protocol.encodeTheme(
      decodedTheme,
    );

    expect(decoded, isA<MixProtocolSuccess<BoxStyler>>());
    expect(encoded, isA<MixProtocolSuccess<JsonMap>>());
    expect(theme, isA<MixProtocolSuccess<MixProtocolTheme>>());
    expect(encodedTheme, isA<MixProtocolSuccess<JsonMap>>());
    expect(protocol.exportStyleJsonSchema(), isA<JsonMap>());
    expect(protocol.exportThemeJsonSchema(), isA<JsonMap>());
  });

  test('protocol results and decoded themes expose immutable collections', () {
    final success =
        mixProtocol.decodeStyle<BoxStyler>({'v': 1, 'type': 'box'})
            as MixProtocolSuccess<BoxStyler>;
    final failure =
        mixProtocol.decodeStyle<BoxStyler>({'v': 1, 'type': 'missing'})
            as MixProtocolFailure<BoxStyler>;
    final theme =
        mixProtocol.decodeTheme({
              'v': 1,
              'type': 'theme',
              'colors': {'color.brand': '#336699'},
            })
            as MixProtocolSuccess<MixProtocolTheme>;

    expect(
      () => success.warnings.add(failure.errors.single),
      throwsUnsupportedError,
    );
    expect(() => failure.errors.clear(), throwsUnsupportedError);
    expect(
      () => failure.warnings.add(failure.errors.single),
      throwsUnsupportedError,
    );
    expect(
      () => theme.value.tokens[const ColorToken('color.other')] = 0,
      throwsUnsupportedError,
    );
  });

  test('testing vocabulary exactly matches the built-in style schema', () {
    final schema = mixProtocol.exportStyleJsonSchema();
    final branches = (schema['anyOf']! as List).cast<JsonMap>();
    final definitions = _jsonObject(schema['definitions']);
    final schemaTypes = {
      for (final branch in branches)
        ((branch['properties']! as JsonMap)['type']! as JsonMap)['const']!
            as String,
    };
    final modifierTypes = <String>{};
    final variantKinds = <String>{};
    for (final branch in branches) {
      final properties = _jsonObject(branch['properties']);
      modifierTypes.addAll(
        _discriminatorValues(properties['modifiers'], 'type', definitions),
      );
      variantKinds.addAll(
        _discriminatorValues(properties['variants'], 'kind', definitions),
      );
    }

    expect(
      schemaTypes,
      protocol_testing.SchemaStyler.values
          .map((value) => value.wireValue)
          .toSet(),
    );
    expect(
      modifierTypes,
      protocol_testing.SchemaModifier.values
          .map((value) => value.wireValue)
          .toSet(),
    );
    expect(
      variantKinds,
      protocol_testing.SchemaVariant.values
          .map((value) => value.wireValue)
          .toSet(),
    );
    expect(protocol_testing.payloadStyler(protocol_testing.SchemaStyler.box), {
      'type': 'box',
    });
  });
}

Set<String> _discriminatorValues(
  Object? value,
  String discriminator,
  JsonMap definitions,
) {
  final values = <String>{};
  final activeRefs = <String>{};

  void visit(Object? node) {
    if (node is List) {
      for (final child in node) {
        visit(child);
      }
      return;
    }
    if (node is! Map) return;

    final ref = node[r'$ref'];
    if (ref is String && ref.startsWith('#/definitions/')) {
      final name = ref.substring('#/definitions/'.length);
      if (!activeRefs.add(name)) return;
      try {
        visit(definitions[name]);
      } finally {
        activeRefs.remove(name);
      }
      return;
    }

    final properties = node['properties'];
    if (properties is Map) {
      final discriminatorSchema = properties[discriminator];
      if (discriminatorSchema is Map) {
        final value = discriminatorSchema['const'];
        if (value is String) {
          values.add(value);
          return;
        }
      }
    }

    for (final child in node.values) {
      visit(child);
    }
  }

  visit(value);

  return values;
}

JsonMap _jsonObject(Object? value) {
  return Map<String, Object?>.from(value! as Map);
}
