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
import 'core/checkers.dart';
import 'core/errors.dart';
import 'core/models/field_model.dart';
import 'core/models/type_helpers.dart' as type_helpers;

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

      final mixTypeOverride = _setterTypeOverride(field);

      return (
        index: info.index,
        field: ModifierFieldModel.fromField(
          field: FieldModel.fromElement(field, stylerName: modifierName),
          isNamedParam: info.isNamed,
          propWrapperKind: mixTypeOverride == null ? null : .maybeMix,
          mixTypeName: mixTypeOverride,
        ),
      );
    }).toList()..sort((a, b) => a.index.compareTo(b.index));

    return indexedFields.map((entry) => entry.field).toList();
  }

  /// Reads `@MixableField(setterType: ...)` on [field] and returns the
  /// resolved type code, or `null` when no override is present.
  ///
  /// A modifier field whose runtime type has no automatic Mix counterpart
  /// (e.g. `List<BoxShadow>`) can opt into a Mix-typed setter so the generated
  /// `ModifierMix` constructor accepts the Mix and wraps it with
  /// `Prop.maybeMix`.
  String? _setterTypeOverride(FieldElement field) {
    final annotation = mixableFieldAnnotationChecker.firstAnnotationOf(field);
    final setterType = annotation?.getField('setterType')?.toTypeValue();
    if (setterType == null) return null;

    return type_helpers.visibleTypeCodeForField(
      field,
      visibleFrom: field.library,
      type: setterType,
      usage: 'setter type',
    );
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
