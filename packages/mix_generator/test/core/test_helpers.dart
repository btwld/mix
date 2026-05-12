import 'package:build/build.dart';
import 'package:mix_generator/src/core/models/field_model.dart';
import 'package:mix_generator/src/core/models/mix_field_model.dart';
import 'package:source_gen/source_gen.dart';

Builder partBuilder(Generator generator) => PartBuilder([generator], '.g.dart');

const styleStub = r'''
library mix_style;

class Style<T> {
  final Object? $variants;
  final Object? $modifier;
  final Object? $animation;

  const Style({Object? variants, Object? modifier, Object? animation})
    : $variants = variants,
      $modifier = modifier,
      $animation = animation;
}
''';

const mixElementStub = r'''
library mix_element;

abstract class Mixable<T> {
  const Mixable();
}

class Mix<T> extends Mixable<T> {
  const Mix();
}

mixin DefaultValue<T> {
  T get defaultValue;
}
''';

const propStub = r'''
library prop;

class Prop<T> {
  const Prop();
}
''';

const visibleTypeStub = r'''
library visible;

class VisibleType {}
''';

const mixAnnotationsSources = {
  'mix_annotations|lib/mix_annotations.dart': "export 'src/annotations.dart';",
  'mix_annotations|lib/src/annotations.dart': r'''
library annotations;

class MixableSpec {
  final int methods;
  final int components;

  const MixableSpec({this.methods = 0x01 | 0x02 | 0x04, this.components = 0});
}

class MixableStyler {
  final int methods;

  const MixableStyler({
    this.methods = 0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20,
  });
}

class Mixable {
  final int methods;
  final String? resolveToType;

  const Mixable({this.methods = 0x01 | 0x02 | 0x04 | 0x08, this.resolveToType});
}

class MixableField {
  final bool ignoreSetter;
  final Type? setterType;

  const MixableField({this.ignoreSetter = false, this.setterType});
}

class GeneratedSpecMethods {
  static const int copyWith = 0x01;
  static const int equals = 0x02;
  static const int lerp = 0x04;
  static const int all = copyWith | equals | lerp;
  static const int skipEquals = all & ~equals;
}
''',
};

FieldModel createTestFieldModel({
  required String name,
  String? typeName,
  String? effectiveSpecType,
  bool isNullable = false,
  bool isList = false,
  String? listElementType,
  bool isLerpable = false,
  DiagnosticKind diagnosticKind = DiagnosticKind.diagnostics,
  String? diagnosticLabel,
  String? flagDescription,
}) {
  final resolvedTypeName =
      typeName ??
      effectiveSpecType?.replaceAll('?', '') ??
      (throw ArgumentError('typeName or effectiveSpecType is required'));
  final resolvedSpecType =
      effectiveSpecType ?? '$resolvedTypeName${isNullable ? '?' : ''}';

  return FieldModel(
    name: name,
    typeName: resolvedTypeName,
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
