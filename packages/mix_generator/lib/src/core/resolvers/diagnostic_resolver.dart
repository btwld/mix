/// Diagnostic property selection for Spec fields.
///
/// Maps a field model to the generated `DiagnosticsProperty` subclass.
library;

import '../models/field_model.dart';

String _generateFlagProperty(FieldModel field) {
  final name = field.name;
  final displayName = field.displayName;

  if (field.flagDescription != null) {
    return "FlagProperty('$displayName', value: $name, ifTrue: '${field.flagDescription}')";
  }

  // Fall back to `DiagnosticsProperty` when no flag description is curated.
  return "DiagnosticsProperty('$displayName', $name)";
}

String _generateIterableProperty(FieldModel field) {
  final name = field.name;
  final displayName = field.displayName;
  final elementType = field.listElementType ?? 'Object';

  return "IterableProperty<$elementType>('$displayName', $name)";
}

/// Generates the diagnostic property code for a Spec field.
String generateSpecDiagnosticCode(FieldModel field) {
  final name = field.name;
  final displayName = field.displayName;

  return switch (field.diagnosticKind) {
    .color => "ColorProperty('$displayName', $name)",
    .doubleProperty => "DoubleProperty('$displayName', $name)",
    .intProperty => "IntProperty('$displayName', $name)",
    .stringProperty => "StringProperty('$displayName', $name)",
    .enumProperty => "EnumProperty<${field.typeName}>('$displayName', $name)",
    .flagProperty => _generateFlagProperty(field),
    .iterableProperty => _generateIterableProperty(field),
    .diagnostics => "DiagnosticsProperty('$displayName', $name)",
  };
}
