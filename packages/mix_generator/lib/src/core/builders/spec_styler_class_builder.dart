library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../checkers.dart';
import '../curated/type_metadata.dart';
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
    final mixins = _collectOwnerMixins(fields);
    final mixinClause = mixins.isEmpty
        ? ''
        : ' with ${mixins.map((m) => '$m<$stylerName>').join(', ')}';
    final buffer = StringBuffer();
    buffer.writeln(
      'class $stylerName extends MixStyler<$stylerName, $specName>$mixinClause {',
    );

    for (final field in fields) {
      buffer.writeln('  final Prop<${field.typeName}>? \$${field.name};');
    }
    buffer.writeln();

    buffer.writeln('  const $stylerName.create({');
    for (final field in fields) {
      buffer.writeln('    Prop<${field.typeName}>? ${field.name},');
    }
    buffer.writeln('    super.variants,');
    buffer.writeln('    super.modifier,');
    buffer.writeln('    super.animation,');
    if (fields.isEmpty) {
      buffer.writeln('  });');
    } else {
      buffer.writeln('  }) :');
      for (var i = 0; i < fields.length; i++) {
        final field = fields[i];
        final suffix = i == fields.length - 1 ? ';' : ',';
        buffer.writeln('       \$${field.name} = ${field.name}$suffix');
      }
    }
    buffer.writeln();

    buffer.writeln('  $stylerName({');
    for (final field in fields) {
      buffer.writeln('    ${_publicParamType(field)}? ${field.name},');
    }
    buffer.writeln('    AnimationConfig? animation,');
    buffer.writeln('    WidgetModifierConfig? modifier,');
    buffer.writeln('    List<VariantStyle<$specName>>? variants,');
    buffer.writeln('  }) : this.create(');
    for (final field in fields) {
      buffer.writeln(
        '         ${field.name}: ${_propFactory(field)}(${field.name}),',
      );
    }
    buffer.writeln('         variants: variants,');
    buffer.writeln('         modifier: modifier,');
    buffer.writeln('         animation: animation,');
    buffer.writeln('       );');

    buffer.writeln('}');

    return buffer.toString();
  }

  String _publicParamType(FieldModel field) =>
      mixTypeFor(field.typeName) ?? field.typeName;

  String _propFactory(FieldModel field) =>
      mixTypeFor(field.typeName) == null ? 'Prop.maybe' : 'Prop.maybeMix';

  Set<String> _collectOwnerMixins(List<FieldModel> fields) {
    final mixins = <String>{};

    for (final field in fields) {
      final reader = _mixableFieldReader(field.name);
      if (reader?.peek('skipMixin')?.boolValue ?? false) continue;

      final overrideType = reader?.peek('mixin')?.typeValue;
      final overrideName = overrideType?.element?.name;
      if (overrideName != null) {
        mixins.add(overrideName);
        continue;
      }

      mixins.addAll(ownerMixinsFor(field.typeName));
    }

    final extra = annotation.peek('extraStylerMixins')?.listValue ?? const [];
    for (final object in extra) {
      final type = object.toTypeValue();
      final name = type?.element?.name;
      if (name != null) mixins.add(name);
    }

    return mixins;
  }

  ConstantReader? _mixableFieldReader(String fieldName) {
    final field = specElement.getField(fieldName);
    if (field == null) return null;

    final annotation = mixableFieldAnnotationChecker.firstAnnotationOf(field);
    return annotation == null ? null : ConstantReader(annotation);
  }
}
