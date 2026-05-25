/// Field model for Mix fields.
///
/// Represents a Mix field with computed values for code generation.
library;

import 'package:analyzer/dart/element/element.dart';

import 'type_helpers.dart' as type_helpers;

/// Represents a Mix field with computed values for generation.
class MixFieldModel {
  /// The field name (without $ prefix).
  final String name;

  /// The field name as declared (with $ prefix).
  final String declaredName;

  /// The Dart code for this field's type from the annotated library.
  final String fieldTypeCode;

  const MixFieldModel({
    required this.name,
    required this.declaredName,
    required this.fieldTypeCode,
  });

  /// Creates a MixFieldModel from a FieldElement.
  factory MixFieldModel.fromElement(
    FieldElement element, {
    required LibraryElement visibleFrom,
  }) {
    final field = type_helpers.extractField(element, stripDollar: true);

    return MixFieldModel(
      name: field.name,
      declaredName: field.declaredName,
      fieldTypeCode: type_helpers.visibleTypeCodeForField(
        element,
        visibleFrom: visibleFrom,
      ),
    );
  }

  @override
  String toString() => 'MixFieldModel($name: $fieldTypeCode)';
}
