import 'package:mix_generator/src/core/models/field_model.dart';
import 'package:mix_generator/src/core/models/mix_field_model.dart';

FieldModel createTestFieldModel({
  required String name,
  required String typeName,
  String? effectiveSpecType,
  bool isNullable = false,
  bool isList = false,
  String? listElementType,
  bool isLerpable = false,
  DiagnosticKind diagnosticKind = DiagnosticKind.diagnostics,
  String? diagnosticLabel,
  String? flagDescription,
}) {
  final resolvedSpecType =
      effectiveSpecType ?? '$typeName${isNullable ? '?' : ''}';

  return FieldModel(
    name: name,
    typeName: typeName,
    isList: isList,
    listElementType: listElementType,
    effectiveSpecType: resolvedSpecType,
    isLerpable: isLerpable,
    diagnosticKind: diagnosticKind,
    diagnosticLabel: diagnosticLabel,
    flagDescription: flagDescription,
  );
}

MixFieldModel createTestMixFieldModel({
  required String name,
  String? declaredName,
  required String dartTypeDisplayString,
}) {
  return MixFieldModel(
    name: name,
    declaredName: declaredName ?? '\$$name',
    fieldTypeCode: dartTypeDisplayString,
  );
}
