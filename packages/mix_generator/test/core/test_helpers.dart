import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mix_generator/src/core/models/field_model.dart';
import 'package:mix_generator/src/core/models/mix_field_model.dart';
import 'package:mix_generator/src/core/registry/mix_type_registry.dart';

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
    dartType: FakeDartType(resolvedSpecType, isNullable),
    element: FakeFieldElement(name),
    isNullable: isNullable,
    typeName: typeName,
    isList: isList,
    listElementType: listElementType,
    effectiveSpecType: resolvedSpecType,
    effectivePublicParamType: resolvedSpecType,
    isLerpable: isLerpable,
    propWrapperKind: PropWrapperKind.none,
    isWrappedInProp: false,
    diagnosticKind: diagnosticKind,
    diagnosticLabel: diagnosticLabel,
    generateSetter: true,
    flagDescription: flagDescription,
  );
}

MixFieldModel createTestMixFieldModel({
  required String name,
  String? declaredName,
  required String dartTypeDisplayString,
  bool isNullable = false,
  String? innerTypeName,
  bool isWrappedInProp = false,
}) {
  return MixFieldModel(
    name: name,
    declaredName: declaredName ?? '\$$name',
    dartType: FakeDartType(dartTypeDisplayString, isNullable),
    element: FakeFieldElement(name),
    isNullable: isNullable,
    innerTypeName:
        innerTypeName ?? dartTypeDisplayString.replaceFirst(RegExp(r'\?$'), ''),
    isWrappedInProp: isWrappedInProp,
  );
}

class FakeDartType implements DartType {
  final String _displayString;
  final bool _isNullable;

  FakeDartType(this._displayString, this._isNullable);

  @override
  String getDisplayString({bool withNullability = true}) => _displayString;

  @override
  NullabilitySuffix get nullabilitySuffix =>
      _isNullable ? NullabilitySuffix.question : NullabilitySuffix.none;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError(
      'Unexpected DartType access in test: ${invocation.memberName}',
    );
  }
}

class FakeFieldElement implements FieldElement {
  @override
  final String name;

  FakeFieldElement(this.name);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError(
      'Unexpected FieldElement access in test: ${invocation.memberName}',
    );
  }
}
