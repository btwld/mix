import '../json_map.dart';

/// Primitive types supported by Figma variables.
enum FigmaVariableType { color, float, string, boolean }

/// One collection mode.
final class FigmaVariableMode {
  final String id;

  final String name;
  const FigmaVariableMode({required this.id, required this.name});

  JsonMap toJson() => {'id': id, 'name': name};
}

/// A variable collection and its modes.
final class FigmaVariableCollection {
  final String id;

  final String key;
  final String name;
  final String defaultModeId;
  final List<FigmaVariableMode> modes;
  final Map<String, String> pluginData;
  final bool hiddenFromPublishing;
  final bool remote;
  FigmaVariableCollection({
    required this.id,
    required this.name,
    required this.defaultModeId,
    required Iterable<FigmaVariableMode> modes,
    this.key = '',
    Map<String, String> pluginData = const {},
    this.hiddenFromPublishing = false,
    this.remote = false,
  }) : modes = List.unmodifiable(modes),
       pluginData = Map.unmodifiable(pluginData);

  JsonMap toJson() => {
    'id': id,
    'key': key,
    'name': name,
    'defaultModeId': defaultModeId,
    'modes': modes.map((mode) => mode.toJson()).toList(),
    'pluginData': pluginData,
    'hiddenFromPublishing': hiddenFromPublishing,
    'remote': remote,
  };
}

/// Reference to another Figma variable.
final class FigmaVariableAlias {
  final String variableId;

  const FigmaVariableAlias(this.variableId);

  JsonMap toJson() => {'type': 'VARIABLE_ALIAS', 'id': variableId};
}

/// One variable and its per-mode values.
final class FigmaVariable {
  final String id;

  final String name;
  final String collectionId;
  final FigmaVariableType resolvedType;
  final Map<String, Object?> valuesByMode;
  final List<String> scopes;
  final Map<String, String> codeSyntax;
  final Map<String, String> pluginData;
  final String description;
  final bool remote;
  FigmaVariable({
    required this.id,
    required this.name,
    required this.collectionId,
    required this.resolvedType,
    required Map<String, Object?> valuesByMode,
    Iterable<String> scopes = const [],
    Map<String, String> codeSyntax = const {},
    Map<String, String> pluginData = const {},
    this.description = '',
    this.remote = false,
  }) : valuesByMode = Map.unmodifiable(valuesByMode),
       scopes = List.unmodifiable(scopes),
       codeSyntax = Map.unmodifiable(codeSyntax),
       pluginData = Map.unmodifiable(pluginData);

  JsonMap toJson() => {
    'id': id,
    'name': name,
    'collectionId': collectionId,
    'resolvedType': resolvedType.name.toUpperCase(),
    'valuesByMode': {
      for (final entry in valuesByMode.entries)
        entry.key: switch (entry.value) {
          FigmaVariableAlias alias => alias.toJson(),
          final value => value,
        },
    },
    'scopes': scopes,
    'codeSyntax': codeSyntax,
    'pluginData': pluginData,
    'description': description,
    'remote': remote,
  };
}

/// Values-bearing variable document emitted by the Figma plugin.
final class FigmaVariablesDocument {
  final List<FigmaVariableCollection> collections;

  final List<FigmaVariable> variables;
  FigmaVariablesDocument({
    required Iterable<FigmaVariableCollection> collections,
    required Iterable<FigmaVariable> variables,
  }) : collections = List.unmodifiable(collections),
       variables = List.unmodifiable(variables);

  FigmaVariableCollection collectionFor(String id) =>
      collections.singleWhere((collection) => collection.id == id);

  JsonMap toJson() => {
    'schema': 'mix_figma/figma-variables/v1',
    'collections': collections.map((item) => item.toJson()).toList(),
    'variables': variables.map((item) => item.toJson()).toList(),
  };
}
