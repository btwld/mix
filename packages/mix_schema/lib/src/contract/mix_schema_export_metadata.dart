import '../core/mix_schema_scope.dart';

/// Exportable contract metadata for future producers and tooling.
final class MixSchemaExportMetadata {
  /// The supported top-level styler `type` values.
  final List<String> stylerTypes;

  /// The supported metadata modifier `type` values.
  final List<String> modifierTypes;

  /// The supported top-level variant `type` values.
  final List<String> variantTypes;

  /// The supported `conditions[].type` values inside `context_all_of`.
  final List<String> contextConditionTypes;

  /// The top-level metadata fields allowed on full styler payloads.
  final List<String> topLevelMetadataFields;

  /// The metadata fields allowed inside nested variant styles.
  final List<String> variantStyleMetadataFields;

  /// The declared field names for each registered styler type.
  final Map<String, List<String>> stylerFields;

  /// The styler fields that decode but are not representable in v1 payloads.
  final Map<String, List<String>> unsupportedFields;

  /// The built-in registry scopes recognized by the contract.
  final List<String> builtInScopes;

  /// Creates immutable export metadata from stable contract vocabularies.
  factory MixSchemaExportMetadata({
    required List<String> stylerTypes,
    required List<String> modifierTypes,
    required List<String> variantTypes,
    required List<String> contextConditionTypes,
    required List<String> topLevelMetadataFields,
    required List<String> variantStyleMetadataFields,
    required Map<String, List<String>> stylerFields,
    required Map<String, List<String>> unsupportedFields,
  }) {
    final copiedStylerFields = <String, List<String>>{
      for (final entry in stylerFields.entries)
        entry.key: List.unmodifiable(entry.value),
    };
    final copiedUnsupportedFields = <String, List<String>>{
      for (final entry in unsupportedFields.entries)
        entry.key: List.unmodifiable(entry.value),
    };

    return MixSchemaExportMetadata._(
      stylerTypes: List.unmodifiable(stylerTypes),
      modifierTypes: List.unmodifiable(modifierTypes),
      variantTypes: List.unmodifiable(variantTypes),
      contextConditionTypes: List.unmodifiable(contextConditionTypes),
      topLevelMetadataFields: List.unmodifiable(topLevelMetadataFields),
      variantStyleMetadataFields: List.unmodifiable(variantStyleMetadataFields),
      stylerFields: Map.unmodifiable(copiedStylerFields),
      unsupportedFields: Map.unmodifiable(copiedUnsupportedFields),
      builtInScopes: List.unmodifiable(
        MixSchemaScope.values.map((scope) => scope.wireValue),
      ),
    );
  }

  const MixSchemaExportMetadata._({
    required this.stylerTypes,
    required this.modifierTypes,
    required this.variantTypes,
    required this.contextConditionTypes,
    required this.topLevelMetadataFields,
    required this.variantStyleMetadataFields,
    required this.stylerFields,
    required this.unsupportedFields,
    required this.builtInScopes,
  });

  /// Serializes the export metadata for external tooling consumption.
  Map<String, Object?> toJson() {
    return {
      'stylerTypes': stylerTypes,
      'modifierTypes': modifierTypes,
      'variantTypes': variantTypes,
      'contextConditionTypes': contextConditionTypes,
      'topLevelMetadataFields': topLevelMetadataFields,
      'variantStyleMetadataFields': variantStyleMetadataFields,
      'stylerFields': stylerFields,
      'unsupportedFields': unsupportedFields,
      'builtInScopes': builtInScopes,
    };
  }
}
