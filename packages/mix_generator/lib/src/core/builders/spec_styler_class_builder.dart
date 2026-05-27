library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../checkers.dart';
import '../models/annotation_config.dart';
import '../curated/type_metadata.dart';
import '../errors.dart';
import '../helpers/mixin_method_collector.dart';
import '../models/field_model.dart';
import '../models/styler_field_model.dart';
import 'styler_mixin_builder.dart';

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
    final stylerMixinName = '_\$${stylerName}Mixin';
    final allMixins = [...mixins, stylerMixinName];
    final mixinClause = mixins.isEmpty
        ? ' with $stylerMixinName'
        : ' with ${[
            ...mixins.map((m) => '$m<$stylerName>'),
            stylerMixinName,
          ].join(', ')}';
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
    buffer.writeln();

    for (final mixinName in mixins) {
      final mixinElement = _resolveMixinElement(mixinName);
      if (mixinElement == null) continue;

      for (final method in MixinMethodCollector.collect(mixinElement)) {
        buffer.writeln(
          '  factory $stylerName.${method.name}(${_parameterList(method.parameters)}) =>',
        );
        buffer.writeln(
          '      $stylerName().${method.name}(${_argumentList(method.parameters)});',
        );
      }
    }

    for (final field in fields) {
      if (_isOwnedByMixin(field)) continue;
      final factoryName = _fieldFactoryName(field);
      if (factoryName == null) continue;

      final paramType = _publicParamType(field);
      buffer.writeln(
        '  factory $stylerName.$factoryName($paramType value) =>',
      );
      buffer.writeln('      $stylerName().${field.name}(value);');
    }
    if (allMixins.isNotEmpty || fields.any((f) => !_isOwnedByMixin(f))) {
      buffer.writeln();
    }

    buffer.writeln('}');
    buffer.writeln();
    buffer.writeln(_buildStylerMixin(fields));

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

  bool _isOwnedByMixin(FieldModel field) {
    final reader = _mixableFieldReader(field.name);
    if (reader?.peek('skipMixin')?.boolValue ?? false) return false;
    if (reader?.peek('mixin')?.typeValue.element != null) return true;

    return ownerMixinsFor(field.typeName).isNotEmpty;
  }

  InterfaceElement? _resolveMixinElement(String mixinName) {
    final localMixin = specElement.library.getMixin(mixinName);
    if (localMixin != null) return localMixin;

    final localClass = specElement.library.getClass(mixinName);
    if (localClass != null) return localClass;

    for (final import in specElement.library.firstFragment.libraryImports) {
      final imported = import.importedLibrary;
      if (imported == null) continue;

      final element = imported.exportNamespace.get2(mixinName);
      if (element is InterfaceElement) return element;
    }

    return null;
  }

  String _parameterList(List<FormalParameterElement> parameters) {
    final required = <String>[];
    final optional = <String>[];
    final named = <String>[];

    for (final parameter in parameters) {
      final type = parameter.type.getDisplayString();
      final name = parameter.name;
      final requiredPrefix = parameter.isRequiredNamed ? 'required ' : '';
      final defaultValue = parameter.defaultValueCode;
      final defaultClause = defaultValue == null ? '' : ' = $defaultValue';
      final code = name == null
          ? '$requiredPrefix$type$defaultClause'
          : '$requiredPrefix$type $name$defaultClause';

      if (parameter.isNamed) {
        named.add(code);
      } else if (parameter.isOptionalPositional) {
        optional.add(code);
      } else {
        required.add(code);
      }
    }

    return [
      ...required,
      if (optional.isNotEmpty) '[${optional.join(', ')}]',
      if (named.isNotEmpty) '{${named.join(', ')}}',
    ].join(', ');
  }

  String _argumentList(List<FormalParameterElement> parameters) {
    final positional = <String>[];
    final named = <String>[];

    for (final parameter in parameters) {
      final name = parameter.name;
      if (name == null) continue;
      if (parameter.isNamed) {
        named.add('$name: $name');
      } else {
        positional.add(name);
      }
    }

    return [...positional, ...named].join(', ');
  }

  String? _fieldFactoryName(FieldModel field) {
    final reader = _mixableFieldReader(field.name);
    if (reader?.peek('skipFactory')?.boolValue ?? false) return null;

    return reader?.peek('factoryName')?.stringValue ?? field.name;
  }

  String _buildStylerMixin(List<FieldModel> fields) {
    final stylerFields = fields
        .map(
          (field) => StylerFieldModel(
            name: field.name,
            declaredName: field.stylerFieldName,
            fieldTypeCode: 'Prop<${field.typeName}>?',
            isRawList: isRawListField(field.name),
            effectivePublicParamType: _publicParamType(field),
            generateSetter: true,
            setterName: field.name,
            diagnosticLabel: field.diagnosticLabel,
          ),
        )
        .toList();

    return StylerMixinBuilder(
      stylerName: stylerName,
      specName: specName,
      fields: stylerFields,
      config: const MixableStylerAnnotationConfig(),
    ).build();
  }
}
