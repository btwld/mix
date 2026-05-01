/// Diagnostic resolver for determining DiagnosticsProperty type.
///
/// Maps DartType → DiagnosticsProperty subclass.
library;

import '../models/field_model.dart';

String _generateFlagProperty(FieldModel field) {
  final name = field.name;
  final displayName = field.displayName;

  if (field.flagDescription != null) {
    return "FlagProperty('$displayName', value: $name, ifTrue: '${field.flagDescription}')";
  }

  // Fallback to DiagnosticsProperty if no flag description
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
