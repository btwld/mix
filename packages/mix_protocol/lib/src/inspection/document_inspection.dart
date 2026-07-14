import 'dart:collection';
import 'dart:convert';

import '../contract/json_map.dart';
import '../contract/mix_protocol_contract.dart';
import '../errors/mix_protocol_error.dart';
import '../tokens/token_reference_walker.dart';

/// Whether a theme token is declared as a literal or as an alias.
enum MixProtocolTokenDeclaration { direct, alias }

/// The declared selector surrounding a style term.
final class MixProtocolSelectorContext {
  MixProtocolSelectorContext({
    required this.kind,
    required this.value,
    required this.jsonPointer,
    required Map<String, Object?> fields,
  }) : fields = UnmodifiableMapView(fields);

  final String kind;
  final String value;
  final String jsonPointer;
  final Map<String, Object?> fields;

  String get key => '$kind:$value';
}

/// One exact token occurrence in declared style JSON.
final class MixProtocolTokenOccurrence {
  const MixProtocolTokenOccurrence({
    required this.kind,
    required this.name,
    required this.jsonPointer,
  });

  final String kind;
  final String name;
  final String jsonPointer;
}

/// One declared leaf term in a style document.
final class MixProtocolStyleTerm {
  MixProtocolStyleTerm({
    required List<String> propertyPath,
    required this.jsonPointer,
    required List<MixProtocolSelectorContext> selectors,
    required this.mergeSource,
    required this.literalValue,
    required this.token,
  }) : propertyPath = List.unmodifiable(propertyPath),
       selectors = List.unmodifiable(selectors);

  final List<String> propertyPath;
  final String jsonPointer;
  final List<MixProtocolSelectorContext> selectors;
  final int? mergeSource;
  final Object? literalValue;
  final MixProtocolTokenOccurrence? token;

  String get property => propertyPath.join('.');
}

/// Declared, pointer-addressable evidence from a valid style document.
final class MixProtocolStyleInspection {
  MixProtocolStyleInspection({
    required this.styleType,
    required List<MixProtocolStyleTerm> terms,
  }) : terms = List.unmodifiable(terms);

  final String styleType;
  final List<MixProtocolStyleTerm> terms;

  List<MixProtocolTokenOccurrence> get tokenOccurrences => List.unmodifiable(
    terms.map((term) => term.token).whereType<MixProtocolTokenOccurrence>(),
  );
}

/// One declared token entry and its decoded theme value.
final class MixProtocolThemeTokenInspection {
  MixProtocolThemeTokenInspection({
    required this.kind,
    required this.name,
    required this.jsonPointer,
    required this.declaration,
    required this.declaredValue,
    required List<String> aliasChain,
    required this.resolvedValue,
  }) : aliasChain = List.unmodifiable(aliasChain);

  final String kind;
  final String name;
  final String jsonPointer;
  final MixProtocolTokenDeclaration declaration;
  final Object? declaredValue;
  final List<String> aliasChain;
  final Object resolvedValue;
}

/// Declared token entries from a valid theme document.
final class MixProtocolThemeInspection {
  MixProtocolThemeInspection({
    required List<MixProtocolThemeTokenInspection> tokens,
  }) : tokens = List.unmodifiable(tokens);

  final List<MixProtocolThemeTokenInspection> tokens;
}

/// Inspects only declared data after a strict style decode succeeds.
MixProtocolResult<MixProtocolStyleInspection> inspectStyleDocument(
  Object? payload,
) {
  final decoded = mixProtocol.decodeStyle<Object>(payload);
  if (decoded case MixProtocolFailure<Object>(:final errors, :final warnings)) {
    return MixProtocolFailure(errors, warnings: warnings);
  }
  final style = (decoded as MixProtocolSuccess<Object>).value;
  final document = payload as JsonMap;
  final referencesByName = <String, List<MixProtocolTokenReference>>{};
  for (final reference in tokenReferencesOf(style)) {
    referencesByName.putIfAbsent(reference.name, () => []).add(reference);
  }
  final terms = <MixProtocolStyleTerm>[];
  _walkStyle(
    document,
    pointer: '',
    propertyPath: const [],
    selectors: const [],
    mergeSource: null,
    referencesByName: referencesByName,
    terms: terms,
  );
  terms.sort((left, right) => left.jsonPointer.compareTo(right.jsonPointer));

  return MixProtocolSuccess(
    MixProtocolStyleInspection(
      styleType: document['type']! as String,
      terms: terms,
    ),
    warnings: decoded.warnings,
  );
}

/// Inspects direct and alias token declarations after strict theme decode.
MixProtocolResult<MixProtocolThemeInspection> inspectThemeDocument(
  Object? payload,
) {
  final decoded = mixProtocol.decodeTheme(payload);
  if (decoded case MixProtocolFailure<MixProtocolTheme>(
    :final errors,
    :final warnings,
  )) {
    return MixProtocolFailure(errors, warnings: warnings);
  }
  final theme = (decoded as MixProtocolSuccess<MixProtocolTheme>).value;
  final document = payload as JsonMap;
  final resolved = <String, Object>{};
  for (final entry in theme.tokens.entries) {
    final reference = MixProtocolTokenReference.fromToken(entry.key);
    resolved['${reference.kind}/${reference.name}'] = entry.value;
  }
  final tokens = <MixProtocolThemeTokenInspection>[];
  final kinds =
      document.keys.where((key) => key != 'v' && key != 'type').toList()
        ..sort();
  for (final kind in kinds) {
    final declarations = document[kind]! as JsonMap;
    final names = declarations.keys.toList()..sort();
    for (final name in names) {
      final value = declarations[name]!;
      final alias = _aliasTarget(value);
      tokens.add(
        MixProtocolThemeTokenInspection(
          kind: kind,
          name: name,
          jsonPointer: '/${_escape(kind)}/${_escape(name)}',
          declaration: alias == null
              ? MixProtocolTokenDeclaration.direct
              : MixProtocolTokenDeclaration.alias,
          declaredValue: _immutableJson(value),
          aliasChain: alias == null
              ? const []
              : _aliasChain(name, declarations),
          resolvedValue: resolved['$kind/$name']!,
        ),
      );
    }
  }

  return MixProtocolSuccess(
    MixProtocolThemeInspection(tokens: tokens),
    warnings: decoded.warnings,
  );
}

void _walkStyle(
  Object? value, {
  required String pointer,
  required List<String> propertyPath,
  required List<MixProtocolSelectorContext> selectors,
  required int? mergeSource,
  required Map<String, List<MixProtocolTokenReference>> referencesByName,
  required List<MixProtocolStyleTerm> terms,
}) {
  if (value is JsonMap) {
    final tokenName = value[r'$token'];
    if (tokenName is String) {
      final occurrence = MixProtocolTokenOccurrence(
        kind: _tokenKind(value, tokenName, propertyPath, referencesByName),
        name: tokenName,
        jsonPointer: '$pointer/\$token',
      );
      terms.add(
        MixProtocolStyleTerm(
          propertyPath: propertyPath,
          jsonPointer: pointer,
          selectors: selectors,
          mergeSource: mergeSource,
          literalValue: null,
          token: occurrence,
        ),
      );
      for (final entry in value.entries) {
        if (entry.key == r'$token' || entry.key == 'kind') continue;
        _walkStyle(
          entry.value,
          pointer: '$pointer/${_escape(entry.key)}',
          propertyPath: [...propertyPath, entry.key],
          selectors: selectors,
          mergeSource: mergeSource,
          referencesByName: referencesByName,
          terms: terms,
        );
      }

      return;
    }
    final merge = value[r'$merge'];
    if (merge is List<Object?>) {
      for (var index = 0; index < merge.length; index += 1) {
        _walkStyle(
          merge[index],
          pointer: '$pointer/\$merge/$index',
          propertyPath: propertyPath,
          selectors: selectors,
          mergeSource: index,
          referencesByName: referencesByName,
          terms: terms,
        );
      }

      return;
    }
    final variants = value['variants'];
    if (variants is List<Object?>) {
      for (var index = 0; index < variants.length; index += 1) {
        final variant = variants[index]! as JsonMap;
        final selector = _selector(variant, '$pointer/variants/$index');
        _walkStyle(
          variant['style'],
          pointer: '$pointer/variants/$index/style',
          propertyPath: propertyPath,
          selectors: [...selectors, selector],
          mergeSource: mergeSource,
          referencesByName: referencesByName,
          terms: terms,
        );
      }
    }
    final keys =
        value.keys
            .where((key) => key != 'v' && key != 'type' && key != 'variants')
            .toList()
          ..sort();
    for (final key in keys) {
      _walkStyle(
        value[key],
        pointer: '$pointer/${_escape(key)}',
        propertyPath: [...propertyPath, key],
        selectors: selectors,
        mergeSource: mergeSource,
        referencesByName: referencesByName,
        terms: terms,
      );
    }

    return;
  }
  if (value is List<Object?>) {
    for (var index = 0; index < value.length; index += 1) {
      _walkStyle(
        value[index],
        pointer: '$pointer/$index',
        propertyPath: propertyPath,
        selectors: selectors,
        mergeSource: mergeSource,
        referencesByName: referencesByName,
        terms: terms,
      );
    }

    return;
  }
  terms.add(
    MixProtocolStyleTerm(
      propertyPath: propertyPath,
      jsonPointer: pointer,
      selectors: selectors,
      mergeSource: mergeSource,
      literalValue: value,
      token: null,
    ),
  );
}

MixProtocolSelectorContext _selector(JsonMap variant, String pointer) {
  final fields = <String, Object?>{
    for (final entry in variant.entries)
      if (entry.key != 'style') entry.key: _immutableJson(entry.value),
  };
  final kind = fields['kind']! as String;
  const valueKeys = [
    'state',
    'name',
    'brightness',
    'orientation',
    'textDirection',
    'platform',
    'token',
  ];
  final selected = valueKeys
      .where(fields.containsKey)
      .map((key) => fields[key].toString())
      .firstOrNull;

  return MixProtocolSelectorContext(
    kind: kind,
    value: selected ?? jsonEncode(fields),
    jsonPointer: pointer,
    fields: fields,
  );
}

String _tokenKind(
  JsonMap token,
  String name,
  List<String> propertyPath,
  Map<String, List<MixProtocolTokenReference>> referencesByName,
) {
  final wireKind = token['kind'];
  if (wireKind is String) return _pluralKind(wireKind);
  final matches = referencesByName[name] ?? const [];
  if (matches.length == 1) return matches.single.kind;
  final property = propertyPath.lastOrNull;
  final inferred = switch (property) {
    'color' || 'selectionColor' || 'decorationColor' => 'colors',
    'padding' || 'margin' || 'spacing' || 'size' => 'spaces',
    'borderRadius' || 'radius' => 'radii',
    'fontWeight' => 'fontWeights',
    'duration' || 'delay' => 'durations',
    _ => null,
  };
  if (inferred != null) return inferred;

  return matches.isEmpty ? 'unknown' : matches.first.kind;
}

String _pluralKind(String kind) => switch (kind) {
  'color' => 'colors',
  'space' => 'spaces',
  'double' => 'doubles',
  'radius' => 'radii',
  'text_style' => 'textStyles',
  'shadow' => 'shadows',
  'box_shadow' => 'boxShadows',
  'border' => 'borders',
  'font_weight' => 'fontWeights',
  'breakpoint' => 'breakpoints',
  'duration' => 'durations',
  _ => kind,
};

String? _aliasTarget(Object? value) {
  if (value is! JsonMap) return null;
  final target = value[r'$token'];

  return target is String ? target : null;
}

List<String> _aliasChain(String name, JsonMap declarations) {
  final chain = <String>[name];
  var current = name;
  while (true) {
    final target = _aliasTarget(declarations[current]);
    if (target == null) return chain;
    chain.add(target);
    current = target;
  }
}

Object? _immutableJson(Object? value) {
  if (value is JsonMap) {
    final keys = value.keys.toList()..sort();

    return Map<String, Object?>.unmodifiable({
      for (final key in keys) key: _immutableJson(value[key]),
    });
  }
  if (value is List<Object?>) {
    return List<Object?>.unmodifiable(value.map(_immutableJson));
  }

  return value;
}

String _escape(String value) =>
    value.replaceAll('~', '~0').replaceAll('/', '~1');
