/// Computed metadata for `@Mixable` fields.
library;

import 'package:analyzer/dart/element/element.dart';

import 'type_helpers.dart' as type_helpers;

/// A Mix field with names and type code ready for generated output.
class MixFieldModel {
  /// The public field name, without the `$` prefix.
  final String name;

  /// The field name as declared, including the `$` prefix.
  final String declaredName;

  /// The Dart code for this field's type from the annotated library.
  final String fieldTypeCode;

  const MixFieldModel({
    required this.name,
    required this.declaredName,
    required this.fieldTypeCode,
  });

  /// Creates a [MixFieldModel] from an analyzer [FieldElement].
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
