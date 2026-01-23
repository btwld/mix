/// Diagnostic resolver for determining DiagnosticsProperty type.
///
/// Maps DartType → DiagnosticsProperty subclass.
library;

import '../models/field_model.dart';

/// Generates diagnostic property code for a field.
class DiagnosticResolver {
  const DiagnosticResolver();

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
      DiagnosticKind.color => "ColorProperty('$displayName', $name)",
      DiagnosticKind.doubleProperty => "DoubleProperty('$displayName', $name)",
      DiagnosticKind.intProperty => "IntProperty('$displayName', $name)",
      DiagnosticKind.stringProperty => "StringProperty('$displayName', $name)",
      DiagnosticKind.enumProperty =>
        "EnumProperty<${field.typeName}>('$displayName', $name)",
      DiagnosticKind.flagProperty => _generateFlagProperty(field),
      DiagnosticKind.iterableProperty => _generateIterableProperty(field),
      DiagnosticKind.diagnostics =>
        "DiagnosticsProperty('$displayName', $name)",
    };
  }
}

/// Default diagnostic resolver instance.
const diagnosticResolver = DiagnosticResolver();
