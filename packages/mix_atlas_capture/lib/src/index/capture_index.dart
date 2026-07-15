import 'dart:convert';

import 'package:mix_protocol/mix_protocol.dart';

import '../artifacts/capture_bundle.dart';
import '../artifacts/capture_parser.dart';
import '../artifacts/component_document.dart';

/// Whether a captured token use references a direct or alias declaration.
enum AtlasTokenReferenceType { direct, alias }

/// One exact declared token definition in a captured theme document.
final class AtlasTokenDefinition {
  final String themeId;

  final String kind;
  final String name;
  final String sourcePath;
  final String jsonPointer;
  final AtlasTokenReferenceType declaration;
  final Object? declaredValue;
  final List<String> aliasChain;
  final String resolvedValue;
  AtlasTokenDefinition({
    required this.themeId,
    required this.kind,
    required this.name,
    required this.sourcePath,
    required this.jsonPointer,
    required this.declaration,
    required this.declaredValue,
    required List<String> aliasChain,
    required this.resolvedValue,
  }) : aliasChain = List.unmodifiable(aliasChain);

  Map<String, Object?> toJson() => {
    'theme': themeId,
    'kind': kind,
    'name': name,
    'source': sourcePath,
    'pointer': jsonPointer,
    'declaration': declaration.name,
    'declaredValue': declaredValue,
    'aliasChain': aliasChain,
    'resolvedValue': resolvedValue,
  };
}

/// Exact declared property evidence exposed to Atlas UI surfaces.
final class AtlasPropertyEvidence {
  final String componentId;

  final String recipeId;
  final String selector;
  final String themeId;
  final String slotId;
  final String property;
  final String sourcePath;
  final String jsonPointer;
  final int? mergeSource;
  final Object? literalValue;
  final String? tokenKind;
  final String? tokenName;
  final String? capturedThemeValue;
  const AtlasPropertyEvidence({
    required this.componentId,
    required this.recipeId,
    required this.selector,
    required this.themeId,
    required this.slotId,
    required this.property,
    required this.sourcePath,
    required this.jsonPointer,
    required this.mergeSource,
    required this.literalValue,
    required this.tokenKind,
    required this.tokenName,
    required this.capturedThemeValue,
  });

  Map<String, Object?> toJson() => {
    'component': componentId,
    'recipe': recipeId,
    'selector': selector,
    'theme': themeId,
    'slot': slotId,
    'property': property,
    'source': sourcePath,
    'pointer': jsonPointer,
    'mergeSource': ?mergeSource,
    'literal': ?literalValue,
    'tokenKind': ?tokenKind,
    'tokenName': ?tokenName,
    'capturedThemeValue': ?capturedThemeValue,
  };
}

/// One exact, filterable token occurrence in a captured component recipe.
final class AtlasTokenUse {
  final String componentId;

  final String recipeId;
  final String selector;
  final String themeId;
  final String slotId;
  final String property;
  final String sourcePath;
  final String jsonPointer;
  final String tokenKind;
  final String tokenName;
  final AtlasTokenReferenceType referenceType;
  const AtlasTokenUse({
    required this.componentId,
    required this.recipeId,
    required this.selector,
    required this.themeId,
    required this.slotId,
    required this.property,
    required this.sourcePath,
    required this.jsonPointer,
    required this.tokenKind,
    required this.tokenName,
    required this.referenceType,
  });

  String get referenceId => [
    componentId,
    recipeId,
    selector,
    slotId,
    property,
    sourcePath,
    jsonPointer,
    tokenKind,
    tokenName,
  ].join('|');

  Map<String, Object?> toJson() => {
    'component': componentId,
    'recipe': recipeId,
    'selector': selector,
    'theme': themeId,
    'slot': slotId,
    'property': property,
    'source': sourcePath,
    'pointer': jsonPointer,
    'tokenKind': tokenKind,
    'tokenName': tokenName,
    'referenceType': referenceType.name,
  };
}

/// Deterministic evidence and token-use index for a validated capture.
final class AtlasCaptureIndex {
  final List<AtlasPropertyEvidence> propertyEvidence;

  final List<AtlasTokenUse> tokenUses;

  final List<AtlasTokenDefinition> tokenDefinitions;
  AtlasCaptureIndex._({
    required List<AtlasPropertyEvidence> propertyEvidence,
    required List<AtlasTokenUse> tokenUses,
    required List<AtlasTokenDefinition> tokenDefinitions,
  }) : propertyEvidence = List.unmodifiable(propertyEvidence),
       tokenUses = List.unmodifiable(tokenUses),
       tokenDefinitions = List.unmodifiable(tokenDefinitions);

  factory AtlasCaptureIndex.build(LoadedCapture capture) {
    final themes = <String, Map<String, MixProtocolThemeTokenInspection>>{};
    final definitions = <AtlasTokenDefinition>[];
    for (final theme in capture.manifest.themes) {
      final payload = decodeJsonObject(
        capture.files[theme.documentPath]!,
        path: theme.documentPath,
      );
      final result = inspectThemeDocument(payload);
      final inspection = switch (result) {
        MixProtocolSuccess<MixProtocolThemeInspection>(:final value) => value,
        MixProtocolFailure<MixProtocolThemeInspection>(:final errors) =>
          throw StateError('Validated theme could not be inspected: $errors'),
      };
      themes[theme.id] = {
        for (final token in inspection.tokens)
          '${token.kind}/${token.name}': token,
      };
      for (final token in inspection.tokens) {
        definitions.add(
          AtlasTokenDefinition(
            themeId: theme.id,
            kind: token.kind,
            name: token.name,
            sourcePath: theme.documentPath,
            jsonPointer: token.jsonPointer,
            declaration: token.declaration == .alias ? .alias : .direct,
            declaredValue: token.declaredValue,
            aliasChain: token.aliasChain,
            resolvedValue: token.resolvedValue.toString(),
          ),
        );
      }
    }
    final inspections = <String, MixProtocolStyleInspection>{};
    final evidence = <AtlasPropertyEvidence>[];
    final uses = <AtlasTokenUse>[];
    for (final component in capture.componentDocuments) {
      final componentPath = capture.manifest.componentDocuments
          .singleWhere((entry) => entry.id == component.id)
          .documentPath;
      for (final recipe in component.recipes) {
        void appendBinding({
          required String slotId,
          required String property,
          required AtlasPortableBinding binding,
          required String jsonPointer,
        }) {
          final tokenKind = binding.tokenKind == null
              ? null
              : _protocolTokenKind(binding.tokenKind!);
          final tokenKey = tokenKind == null
              ? null
              : '$tokenKind/${binding.tokenName!}';
          for (final theme in capture.manifest.themes) {
            final themeToken = tokenKey == null
                ? null
                : themes[theme.id]![tokenKey];
            evidence.add(
              AtlasPropertyEvidence(
                componentId: component.id,
                recipeId: recipe.id,
                selector: 'binding',
                themeId: theme.id,
                slotId: slotId,
                property: property,
                sourcePath: componentPath,
                jsonPointer: jsonPointer,
                mergeSource: null,
                literalValue: switch (binding.kind) {
                  .literal => binding.literalValue,
                  .property => {'property': binding.propertyId},
                  .token => null,
                },
                tokenKind: tokenKind,
                tokenName: binding.tokenName,
                capturedThemeValue: themeToken?.resolvedValue.toString(),
              ),
            );
            if (tokenKind != null) {
              uses.add(
                AtlasTokenUse(
                  componentId: component.id,
                  recipeId: recipe.id,
                  selector: 'binding',
                  themeId: theme.id,
                  slotId: slotId,
                  property: property,
                  sourcePath: componentPath,
                  jsonPointer: jsonPointer,
                  tokenKind: tokenKind,
                  tokenName: binding.tokenName!,
                  referenceType: themeToken?.declaration == .alias
                      ? .alias
                      : .direct,
                ),
              );
            }
          }
        }

        for (final styleEntry in recipe.styles.entries) {
          final slot = component.slots[styleEntry.key]!;
          final reference = styleEntry.value;
          if (!reference.isSupported) continue;
          final styleId = reference.styleId;
          final sourcePath = styleId == null
              ? reference.documentPath!
              : componentPath;
          final inspectionKey = styleId == null
              ? sourcePath
              : '${component.id}/$styleId';
          final pointerPrefix = styleId == null
              ? ''
              : '/styles/${_escapePointer(styleId)}';
          final inspection = inspections.putIfAbsent(inspectionKey, () {
            final payload = styleId == null
                ? decodeJsonObject(capture.files[sourcePath]!, path: sourcePath)
                : component.styleLibrary[styleId]!.document;
            final result = inspectStyleDocument(payload);

            return switch (result) {
              MixProtocolSuccess<MixProtocolStyleInspection>(:final value) =>
                value,
              MixProtocolFailure<MixProtocolStyleInspection>(:final errors) =>
                throw StateError(
                  'Validated style could not be inspected: $errors',
                ),
            };
          });
          for (final term in inspection.terms) {
            final selector = term.selectors.isEmpty
                ? 'base'
                : term.selectors.map((selector) => selector.key).join(' > ');
            for (final theme in capture.manifest.themes) {
              final token = term.token;
              final themeToken = token == null
                  ? null
                  : themes[theme.id]!['${token.kind}/${token.name}'];
              evidence.add(
                AtlasPropertyEvidence(
                  componentId: component.id,
                  recipeId: recipe.id,
                  selector: selector,
                  themeId: theme.id,
                  slotId: slot.id,
                  property: term.property,
                  sourcePath: sourcePath,
                  jsonPointer: '$pointerPrefix${term.jsonPointer}',
                  mergeSource: term.mergeSource,
                  literalValue: term.literalValue,
                  tokenKind: token?.kind,
                  tokenName: token?.name,
                  capturedThemeValue: themeToken?.resolvedValue.toString(),
                ),
              );
              if (token != null) {
                uses.add(
                  AtlasTokenUse(
                    componentId: component.id,
                    recipeId: recipe.id,
                    selector: selector,
                    themeId: theme.id,
                    slotId: slot.id,
                    property: term.property,
                    sourcePath: sourcePath,
                    jsonPointer: '$pointerPrefix${term.jsonPointer}',
                    tokenKind: token.kind,
                    tokenName: token.name,
                    referenceType: themeToken?.declaration == .alias
                        ? .alias
                        : .direct,
                  ),
                );
              }
            }
          }
        }
        if (component.schema == .v2) {
          final nodes = component.anatomy.nodes.values.toList();
          for (var nodeIndex = 0; nodeIndex < nodes.length; nodeIndex += 1) {
            final node = nodes[nodeIndex];
            for (final binding in node.bindings.entries) {
              appendBinding(
                slotId: node.slotId ?? node.id,
                property: 'binding.${binding.key}',
                binding: binding.value,
                jsonPointer:
                    '/anatomy/nodes/$nodeIndex/bindings/'
                    '${_escapePointer(binding.key)}',
              );
            }
            if (node.recipeBinding case final binding?) {
              appendBinding(
                slotId: node.id,
                property: 'nested.recipe',
                binding: binding,
                jsonPointer: '/anatomy/nodes/$nodeIndex/recipe',
              );
            }
            if (node.stateBinding case final binding?) {
              appendBinding(
                slotId: node.id,
                property: 'nested.state',
                binding: binding,
                jsonPointer: '/anatomy/nodes/$nodeIndex/state',
              );
            }
            for (final binding in node.propertyBindings.entries) {
              appendBinding(
                slotId: node.id,
                property: 'nested.property.${binding.key}',
                binding: binding.value,
                jsonPointer:
                    '/anatomy/nodes/$nodeIndex/properties/'
                    '${_escapePointer(binding.key)}',
              );
            }
          }
          for (final binding in component.semantics.bindings.entries) {
            appendBinding(
              slotId: 'semantics',
              property: 'semantics.${binding.key}',
              binding: binding.value,
              jsonPointer: '/semantics/bindings/${_escapePointer(binding.key)}',
            );
          }
        }
      }
    }
    evidence.sort(
      (left, right) => _evidenceKey(left).compareTo(_evidenceKey(right)),
    );
    uses.sort((left, right) => _useKey(left).compareTo(_useKey(right)));
    definitions.sort(
      (left, right) => _definitionKey(left).compareTo(_definitionKey(right)),
    );

    return AtlasCaptureIndex._(
      propertyEvidence: evidence,
      tokenUses: uses,
      tokenDefinitions: definitions,
    );
  }

  String toCanonicalJson() => jsonEncode({
    'properties': propertyEvidence
        .map((evidence) => evidence.toJson())
        .toList(),
    'tokenDefinitions': tokenDefinitions
        .map((definition) => definition.toJson())
        .toList(),
    'tokenUses': tokenUses.map((use) => use.toJson()).toList(),
  });
}

/// Compatibility result for a baseline/current capture pair.
final class AtlasCaptureCompatibility {
  final bool isCompatible;

  final String? reason;

  const AtlasCaptureCompatibility._({required this.isCompatible, this.reason});

  factory AtlasCaptureCompatibility.evaluate(
    LoadedCapture baseline,
    LoadedCapture current,
  ) {
    if (!_supportedSchema(baseline.manifest.schemaVersion) ||
        !_supportedSchema(current.manifest.schemaVersion)) {
      return const AtlasCaptureCompatibility._(
        isCompatible: false,
        reason: 'Unsupported capture schema.',
      );
    }
    if (baseline.catalog.id != current.catalog.id) {
      return const AtlasCaptureCompatibility._(
        isCompatible: false,
        reason: 'Catalog identities do not match.',
      );
    }
    if (baseline.manifest.producer.mixProtocolFormat !=
        current.manifest.producer.mixProtocolFormat) {
      return const AtlasCaptureCompatibility._(
        isCompatible: false,
        reason: 'Mix protocol formats do not match.',
      );
    }

    return const AtlasCaptureCompatibility._(isCompatible: true);
  }
}

bool _supportedSchema(int schema) => schema == 1 || schema == 2;

String _evidenceKey(AtlasPropertyEvidence evidence) => [
  evidence.componentId,
  evidence.recipeId,
  evidence.selector,
  evidence.themeId,
  evidence.slotId,
  evidence.property,
  evidence.sourcePath,
  evidence.jsonPointer,
].join('|');

String _useKey(AtlasTokenUse use) => '${use.referenceId}|${use.themeId}';

String _definitionKey(AtlasTokenDefinition definition) =>
    '${definition.themeId}|${definition.kind}|${definition.name}';

String _escapePointer(String value) =>
    value.replaceAll('~', '~0').replaceAll('/', '~1');

String _protocolTokenKind(String value) => switch (value) {
  'color' => 'colors',
  'space' => 'spaces',
  'double' => 'doubles',
  'radius' => 'radii',
  'textStyle' => 'textStyles',
  'shadow' => 'shadows',
  'boxShadow' => 'boxShadows',
  'border' => 'borders',
  'fontWeight' => 'fontWeights',
  'breakpoint' => 'breakpoints',
  'duration' => 'durations',
  _ => throw StateError('Parser admitted an unknown token binding kind.'),
};
