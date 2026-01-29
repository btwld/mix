/// Field model for Mix fields.
///
/// Represents a Mix field with computed values for code generation.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

/// Represents a Mix field with computed values for generation.
class MixFieldModel {
  /// The field name (without $ prefix).
  final String name;

  /// The field name as declared (with $ prefix).
  final String declaredName;

  /// The Dart type of the field.
  final DartType dartType;

  /// The field element from analyzer.
  final FieldElement element;

  /// Whether the field is nullable.
  final bool isNullable;

  /// The inner type name (inside Prop<>).
  final String innerTypeName;

  /// Whether this field is wrapped in Prop<>.
  final bool isWrappedInProp;

  const MixFieldModel({
    required this.name,
    required this.declaredName,
    required this.dartType,
    required this.element,
    required this.isNullable,
    required this.innerTypeName,
    required this.isWrappedInProp,
  });

  /// Creates a MixFieldModel from a FieldElement.
  factory MixFieldModel.fromElement(FieldElement element) {
    final type = element.type;
    // FieldElement.name is String? in analyzer 10.x, but fields always have names
    final declaredName = element.name!;

    // Field name without $ prefix
    final name = declaredName.startsWith(r'$')
        ? declaredName.substring(1)
        : declaredName;

    final isNullable = type.nullabilitySuffix == NullabilitySuffix.question;

    // Check if wrapped in Prop<>
    final isWrappedInProp = _isWrappedInProp(type);
    final innerTypeName = _getInnerTypeName(type, isWrappedInProp);

    return MixFieldModel(
      name: name,
      declaredName: declaredName,
      dartType: type,
      element: element,
      isNullable: isNullable,
      innerTypeName: innerTypeName,
      isWrappedInProp: isWrappedInProp,
    );
  }

  @override
  String toString() => 'MixFieldModel($name: $innerTypeName)';
}

// Helper functions

bool _isWrappedInProp(DartType type) {
  if (type is! InterfaceType) return false;

  return type.element.name == 'Prop';
}

String _getInnerTypeName(DartType type, bool isWrappedInProp) {
  if (!isWrappedInProp) {
    return _getBaseTypeName(type);
  }

  if (type is! InterfaceType) return _getBaseTypeName(type);

  // Get the type argument of Prop<T>
  if (type.typeArguments.isNotEmpty) {
    return _getBaseTypeName(type.typeArguments.first);
  }

  return _getBaseTypeName(type);
}

String _getBaseTypeName(DartType type) {
  final displayString = type.getDisplayString();
  // Remove nullability suffix
  if (displayString.endsWith('?')) {
    return displayString.substring(0, displayString.length - 1);
  }

  return displayString;
}
