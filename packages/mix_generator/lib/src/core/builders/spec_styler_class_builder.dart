library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../errors.dart';
import '../models/field_model.dart';

class SpecStylerClassBuilder {
  final ClassElement specElement;
  final String specName;
  final ConstantReader annotation;
  final BuildStep buildStep;

  const SpecStylerClassBuilder({
    required this.specElement,
    required this.specName,
    required this.annotation,
    required this.buildStep,
  });

  String get stylerName => specName.endsWith('Spec')
      ? '${specName.substring(0, specName.length - 4)}Styler'
      : '${specName}Styler';

  List<FieldModel> _extractFields() {
    final constructor = specElement.unnamedConstructor;
    if (constructor == null) return [];

    final namedParams = constructor.formalParameters
        .where((p) => p.isNamed)
        .toList();

    return namedParams.map((p) {
      final paramName = p.name!;
      final field = specElement.getField(paramName);
      if (field == null) {
        fail(specElement, 'Field $paramName not found in $specName');
      }

      return FieldModel.fromElement(field, stylerName: stylerName);
    }).toList();
  }

  String build() {
    final fields = _extractFields();
    final buffer = StringBuffer();
    buffer.writeln(
      'class $stylerName extends MixStyler<$stylerName, $specName> {',
    );

    for (final field in fields) {
      buffer.writeln('  final Prop<${field.typeName}>? \$${field.name};');
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}
