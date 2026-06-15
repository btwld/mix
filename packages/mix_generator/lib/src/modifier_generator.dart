/// Modifier generator for ModifierMix class code generation.
///
/// Generates a modifier mixin and `ModifierMix` class from `@MixableModifier`
/// annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/modifier_mix_builder.dart';
import 'core/builders/modifier_mixin_builder.dart';
import 'core/errors.dart';
import 'core/models/field_model.dart';

/// Main generator for `ModifierMix` class code.
///
/// Triggers on `@MixableModifier` annotations and generates:
/// - A `_$XModifier` mixin (WidgetModifier, Spec, Diagnosticable contract)
/// - A full `ModifierMix` class (resolve, merge, debugFillProperties, props)
class ModifierGenerator extends GeneratorForAnnotation<MixableModifier> {
  const ModifierGenerator();

  List<ModifierFieldModel> _extractFields(
    ClassElement classElement,
    String modifierName,
  ) {
    final constructor = classElement.unnamedConstructor;
    if (constructor == null) {
      fail(
        classElement,
        '@MixableModifier classes must have an unnamed constructor.',
        todo: 'Add an unnamed constructor that exposes every generated field.',
      );
    }

    final parameterInfo = <String, ({int index, bool isNamed})>{};
    final parameters = constructor.formalParameters;
    for (var i = 0; i < parameters.length; i++) {
      final parameter = parameters[i];
      final name = parameter.name;
      if (name == null) {
        fail(
          parameter,
          '@MixableModifier constructor parameters must be named by the analyzer.',
        );
      }
      if (parameterInfo.containsKey(name)) {
        fail(
          parameter,
          'Constructor parameter `$name` is duplicated in $modifierName.',
        );
      }

      parameterInfo[name] = (index: i, isNamed: parameter.isNamed);
    }

    final instanceFields = classElement.fields
        .where((field) => !field.isStatic && !field.isSynthetic)
        .toList();

    for (final field in instanceFields) {
      if (!field.isFinal) {
        final fieldName = field.name ?? '<unknown>';
        fail(
          field,
          '@MixableModifier field `$fieldName` must be final.',
          todo:
              'Make the field final so generated value semantics stay stable.',
        );
      }
    }

    final fieldNames = {
      for (final field in instanceFields) requireName(field, orFailWith: ''),
    };

    for (final parameter in parameters) {
      final name = parameter.name;
      if (name == null || fieldNames.contains(name)) continue;
      if (parameter.isRequired) {
        fail(
          parameter,
          'Required constructor parameter `$name` does not map to a generated '
          'field in $modifierName.',
        );
      }
    }

    final indexedFields = instanceFields.map((field) {
      final name = requireName(
        field,
        orFailWith: '@MixableModifier field must have a name.',
      );
      final info = parameterInfo[name];
      if (info == null) {
        fail(
          field,
          'Generated field `$name` must map to an unnamed-constructor '
          'parameter in $modifierName.',
          todo:
              'Add `$name` to the unnamed constructor or remove the annotation.',
        );
      }

      return (
        index: info.index,
        field: ModifierFieldModel.fromField(
          field: FieldModel.fromElement(field, stylerName: modifierName),
          isNamedParam: info.isNamed,
        ),
      );
    }).toList()..sort((a, b) => a.index.compareTo(b.index));

    return indexedFields.map((entry) => entry.field).toList();
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final classElement = requireClassElement(element, '@MixableModifier');
    final modifierName = requireName(
      classElement,
      orFailWith: '@MixableModifier class must have a name.',
    );

    final fields = _extractFields(classElement, modifierName);

    final generateLerp = annotation.read('lerp').boolValue;

    final mixinBuilder = ModifierMixinBuilder(
      modifierName: modifierName,
      fields: fields,
      generateLerp: generateLerp,
    );

    final mixBuilder = ModifierMixBuilder(
      modifierName: modifierName,
      fields: fields,
    );

    return '${mixinBuilder.build()}\n${mixBuilder.build()}';
  }
}
