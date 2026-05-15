/// Field model for Mix fields.
///
/// Represents a Mix field with computed values for code generation.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'type_helpers.dart' as type_helpers;

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

    final isNullable = type.nullabilitySuffix == .question;

    // Check if wrapped in Prop<>
    final wrappedInProp = type_helpers.isWrappedInProp(type);
    final innerTypeName = type_helpers.getInnerTypeName(
      type,
      isWrapped: wrappedInProp,
    );

    return MixFieldModel(
      name: name,
      declaredName: declaredName,
      dartType: type,
      element: element,
      isNullable: isNullable,
      innerTypeName: innerTypeName,
      isWrappedInProp: wrappedInProp,
    );
  }

  @override
  String toString() => 'MixFieldModel($name: $innerTypeName)';
}
