import 'dart:convert';

import '../contract/identity_resolution.dart';
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
  }) : fields = _immutableJson(fields) as Map<String, Object?>;

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

/// Evidence emitted while inspecting a declared style document.
sealed class MixProtocolStyleEvidence {
  const MixProtocolStyleEvidence();

  String get jsonPointer;
  List<int> get mergePath;
}

/// One declared leaf value in a style document.
final class MixProtocolValueEvidence extends MixProtocolStyleEvidence {
  MixProtocolValueEvidence({
    required List<String> propertyPath,
    required this.jsonPointer,
    required List<MixProtocolSelectorContext> selectors,
    required List<int> mergePath,
    required this.literalValue,
    required this.token,
  }) : propertyPath = List.unmodifiable(propertyPath),
       selectors = List.unmodifiable(selectors),
       mergePath = List.unmodifiable(mergePath);

  final List<String> propertyPath;
  @override
  final String jsonPointer;
  final List<MixProtocolSelectorContext> selectors;
  @override
  final List<int> mergePath;
  final Object? literalValue;
  final MixProtocolTokenOccurrence? token;

  String get property => propertyPath.join('.');
}

/// One declared directive attached to a style value.
final class MixProtocolDirectiveEvidence extends MixProtocolStyleEvidence {
  MixProtocolDirectiveEvidence({
    required List<String> propertyPath,
    required this.jsonPointer,
    required List<MixProtocolSelectorContext> selectors,
    required List<int> mergePath,
    required this.op,
    required Map<String, Object?> parameters,
  }) : propertyPath = List.unmodifiable(propertyPath),
       selectors = List.unmodifiable(selectors),
       mergePath = List.unmodifiable(mergePath),
       parameters = _immutableJson(parameters) as Map<String, Object?>;

  final List<String> propertyPath;
  @override
  final String jsonPointer;
  final List<MixProtocolSelectorContext> selectors;
  @override
  final List<int> mergePath;
  final String op;
  final Map<String, Object?> parameters;

  String get property => propertyPath.join('.');
}

/// One declared selector and any token occurrences within that selector.
final class MixProtocolSelectorEvidence extends MixProtocolStyleEvidence {
  MixProtocolSelectorEvidence({
    required this.jsonPointer,
    required List<MixProtocolSelectorContext> selectors,
    required List<int> mergePath,
    required this.selector,
    required List<MixProtocolTokenOccurrence> tokenOccurrences,
  }) : selectors = List.unmodifiable(selectors),
       mergePath = List.unmodifiable(mergePath),
       tokenOccurrences = List.unmodifiable(tokenOccurrences);

  @override
  final String jsonPointer;
  final List<MixProtocolSelectorContext> selectors;
  @override
  final List<int> mergePath;
  final MixProtocolSelectorContext selector;
  final List<MixProtocolTokenOccurrence> tokenOccurrences;
}

/// Declared, pointer-addressable evidence from a valid style document.
final class MixProtocolStyleInspection {
  MixProtocolStyleInspection({
    required this.styleType,
    required List<MixProtocolStyleEvidence> evidence,
  }) : evidence = List.unmodifiable(evidence);

  final String styleType;
  final List<MixProtocolStyleEvidence> evidence;
}

/// One declared token entry and its decoded theme value.
final class MixProtocolThemeTokenInspection {
  MixProtocolThemeTokenInspection({
    required this.kind,
    required this.name,
    required this.jsonPointer,
    required this.declaration,
    required this.declaredWireValue,
    required List<String> aliasChain,
    required Object? resolvedWireValue,
  }) : aliasChain = List.unmodifiable(aliasChain),
       resolvedWireValue = _immutableJson(resolvedWireValue);

  final String kind;
  final String name;
  final String jsonPointer;
  final MixProtocolTokenDeclaration declaration;
  final Object? declaredWireValue;
  final List<String> aliasChain;
  final Object? resolvedWireValue;
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
  Object? payload, {
  MixProtocolIconResolver? resolveIcon,
  MixProtocolImageResolver? resolveImage,
}) {
  final decoded = mixProtocol.decodeStyle<Object>(
    payload,
    options: MixProtocolDecodeOptions(
      resolveIcon: resolveIcon,
      resolveImage: resolveImage,
    ),
  );
  if (decoded case MixProtocolFailure<Object>(:final errors, :final warnings)) {
    return MixProtocolFailure(errors, warnings: warnings);
  }
  final style = (decoded as MixProtocolSuccess<Object>).value;
  final document = payload as JsonMap;
  final evidence = _StyleInspectionEvidence(tokenReferencesOf(style));
  _walkStyle(
    document,
    pointer: '',
    propertyPath: const [],
    selectors: const [],
    mergePath: const [],
    evidence: evidence,
  );

  return MixProtocolSuccess(
    evidence.build(document['type']! as String),
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
  final encoded = mixProtocol.encodeTheme(theme);
  if (encoded case MixProtocolFailure<JsonMap>(:final errors)) {
    return MixProtocolFailure(errors, warnings: decoded.warnings);
  }
  final document = payload as JsonMap;
  final resolvedDocument = (encoded as MixProtocolSuccess<JsonMap>).value;
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
          declaredWireValue: _immutableJson(value),
          aliasChain: alias == null
              ? const []
              : _aliasChain(name, declarations),
          resolvedWireValue: (resolvedDocument[kind]! as JsonMap)[name],
        ),
      );
    }
  }

  return MixProtocolSuccess(
    MixProtocolThemeInspection(tokens: tokens),
    warnings: decoded.warnings,
  );
}

final class _StyleInspectionEvidence {
  _StyleInspectionEvidence(Iterable<MixProtocolTokenReference> references) {
    for (final reference in references) {
      referencesByName.putIfAbsent(reference.name, () => []).add(reference);
    }
  }

  final referencesByName = <String, List<MixProtocolTokenReference>>{};
  final evidence = <MixProtocolStyleEvidence>[];

  MixProtocolStyleInspection build(String styleType) {
    evidence.sort(
      (left, right) =>
          _compareJsonPointers(left.jsonPointer, right.jsonPointer),
    );

    return MixProtocolStyleInspection(styleType: styleType, evidence: evidence);
  }
}

void _walkStyle(
  Object? value, {
  required String pointer,
  required List<String> propertyPath,
  required List<MixProtocolSelectorContext> selectors,
  required List<int> mergePath,
  required _StyleInspectionEvidence evidence,
}) {
  if (value is JsonMap) {
    final tokenName = value[r'$token'];
    if (tokenName is String) {
      final occurrence = MixProtocolTokenOccurrence(
        kind: _tokenKind(
          value,
          tokenName,
          propertyPath,
          evidence.referencesByName,
        ),
        name: tokenName,
        jsonPointer: '$pointer/\$token',
      );
      evidence.evidence.add(
        MixProtocolValueEvidence(
          propertyPath: propertyPath,
          jsonPointer: pointer,
          selectors: selectors,
          mergePath: mergePath,
          literalValue: null,
          token: occurrence,
        ),
      );
      _collectApplyDirectives(
        value,
        pointer: pointer,
        propertyPath: propertyPath,
        selectors: selectors,
        mergePath: mergePath,
        evidence: evidence.evidence,
      );

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
          mergePath: [...mergePath, index],
          evidence: evidence,
        );
      }
      _collectApplyDirectives(
        value,
        pointer: pointer,
        propertyPath: propertyPath,
        selectors: selectors,
        mergePath: mergePath,
        evidence: evidence.evidence,
      );

      return;
    }
    final variants = value['variants'];
    if (variants is List<Object?>) {
      for (var index = 0; index < variants.length; index += 1) {
        final variant = variants[index]! as JsonMap;
        final selectorPointer = '$pointer/variants/$index';
        final selectorInspection = _inspectSelector(variant, selectorPointer);
        final selector = selectorInspection.selector;
        evidence.evidence.add(
          MixProtocolSelectorEvidence(
            jsonPointer: selectorPointer,
            selectors: selectors,
            mergePath: mergePath,
            selector: selector,
            tokenOccurrences: selectorInspection.tokenOccurrences,
          ),
        );
        _walkStyle(
          variant['style'],
          pointer: '$pointer/variants/$index/style',
          propertyPath: propertyPath,
          selectors: [...selectors, selector],
          mergePath: mergePath,
          evidence: evidence,
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
        mergePath: mergePath,
        evidence: evidence,
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
        mergePath: mergePath,
        evidence: evidence,
      );
    }

    return;
  }
  evidence.evidence.add(
    MixProtocolValueEvidence(
      propertyPath: propertyPath,
      jsonPointer: pointer,
      selectors: selectors,
      mergePath: mergePath,
      literalValue: value,
      token: null,
    ),
  );
}

void _collectApplyDirectives(
  JsonMap term, {
  required String pointer,
  required List<String> propertyPath,
  required List<MixProtocolSelectorContext> selectors,
  required List<int> mergePath,
  required List<MixProtocolStyleEvidence> evidence,
}) {
  final apply = term['apply'];
  if (apply is! List<Object?>) return;

  for (var index = 0; index < apply.length; index += 1) {
    final wire = apply[index]! as JsonMap;
    evidence.add(
      MixProtocolDirectiveEvidence(
        propertyPath: propertyPath,
        jsonPointer: '$pointer/apply/$index',
        selectors: selectors,
        mergePath: mergePath,
        op: wire['op']! as String,
        parameters: {
          for (final entry in wire.entries)
            if (entry.key != 'op') entry.key: entry.value,
        },
      ),
    );
  }
}

({
  MixProtocolSelectorContext selector,
  List<MixProtocolTokenOccurrence> tokenOccurrences,
})
_inspectSelector(JsonMap variant, String pointer) {
  final tokenOccurrences = <MixProtocolTokenOccurrence>[];
  _collectSelectorTokenOccurrences(variant, pointer, tokenOccurrences);
  final fields =
      _immutableJson(<String, Object?>{
            for (final entry in variant.entries)
              if (entry.key != 'style') entry.key: _immutableJson(entry.value),
          })!
          as Map<String, Object?>;
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

  return (
    selector: MixProtocolSelectorContext(
      kind: kind,
      value: selected ?? jsonEncode(fields),
      jsonPointer: pointer,
      fields: fields,
    ),
    tokenOccurrences: tokenOccurrences,
  );
}

void _collectSelectorTokenOccurrences(
  JsonMap selector,
  String pointer,
  List<MixProtocolTokenOccurrence> tokenOccurrences,
) {
  final tokenName = selector['token'];
  if (selector['kind'] == 'context_breakpoint' && tokenName is String) {
    tokenOccurrences.add(
      MixProtocolTokenOccurrence(
        kind: 'breakpoints',
        name: tokenName,
        jsonPointer: '$pointer/token',
      ),
    );
  }

  final nested = selector['variant'];
  if (nested is JsonMap) {
    _collectSelectorTokenOccurrences(
      nested,
      '$pointer/variant',
      tokenOccurrences,
    );
  }
}

String _tokenKind(
  JsonMap token,
  String name,
  List<String> propertyPath,
  Map<String, List<MixProtocolTokenReference>> referencesByName,
) {
  final wireKind = token['kind'];
  if (wireKind is String) return _pluralKind(wireKind);
  final inferred = _schemaTokenKind(propertyPath);
  if (inferred != null) return inferred;
  final matches = referencesByName[name] ?? const [];
  final runtimeKinds = matches.map((match) => match.kind).toSet();
  if (runtimeKinds.length == 1) return runtimeKinds.single;

  return 'unknown';
}

String? _schemaTokenKind(List<String> propertyPath) {
  final property = propertyPath.lastOrNull;
  if (property == null) return null;
  final parent = propertyPath.length > 1
      ? propertyPath[propertyPath.length - 2]
      : null;

  if (_edgeProperties.contains(property)) {
    if (parent == 'padding' || parent == 'margin') return 'spaces';
    if (parent == 'border') return 'borders';
  }
  if (_cornerProperties.contains(property) && parent == 'borderRadius') {
    return 'radii';
  }

  return _tokenKindByProperty[property];
}

const _edgeProperties = {'top', 'right', 'bottom', 'left', 'start', 'end'};

const _cornerProperties = {
  'topLeft',
  'topRight',
  'bottomLeft',
  'bottomRight',
  'topStart',
  'topEnd',
  'bottomStart',
  'bottomEnd',
};

/// This table intentionally mirrors the supported wire properties. A separate
/// redesign can derive inference directly from the codecs without changing it.
const _tokenKindByProperty = <String, String>{
  'color': 'colors',
  'backgroundColor': 'colors',
  'selectionColor': 'colors',
  'decorationColor': 'colors',
  'padding': 'spaces',
  'margin': 'spaces',
  'spacing': 'spaces',
  'size': 'spaces',
  'width': 'spaces',
  'height': 'spaces',
  'minWidth': 'spaces',
  'maxWidth': 'spaces',
  'minHeight': 'spaces',
  'maxHeight': 'spaces',
  'fontSize': 'spaces',
  'letterSpacing': 'spaces',
  'wordSpacing': 'spaces',
  'leading': 'spaces',
  'decorationThickness': 'spaces',
  'blurRadius': 'spaces',
  'spreadRadius': 'spaces',
  'strokeAlign': 'spaces',
  'weight': 'spaces',
  'grade': 'spaces',
  'opticalSize': 'spaces',
  'fill': 'spaces',
  'opacity': 'spaces',
  'radius': 'spaces',
  'focalRadius': 'spaces',
  'startAngle': 'spaces',
  'endAngle': 'spaces',
  'borderRadius': 'radii',
  'style': 'textStyles',
  'shadows': 'shadows',
  'boxShadow': 'boxShadows',
  'border': 'borders',
  'fontWeight': 'fontWeights',
  'duration': 'durations',
  'delay': 'durations',
};

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

int _compareJsonPointers(String left, String right) {
  final leftSegments = left.split('/').skip(1).toList(growable: false);
  final rightSegments = right.split('/').skip(1).toList(growable: false);
  final commonLength = leftSegments.length < rightSegments.length
      ? leftSegments.length
      : rightSegments.length;
  for (var index = 0; index < commonLength; index += 1) {
    final leftIndex = int.tryParse(leftSegments[index]);
    final rightIndex = int.tryParse(rightSegments[index]);
    final comparison = leftIndex != null && rightIndex != null
        ? leftIndex.compareTo(rightIndex)
        : leftSegments[index].compareTo(rightSegments[index]);
    if (comparison != 0) return comparison;
  }

  return leftSegments.length.compareTo(rightSegments.length);
}
