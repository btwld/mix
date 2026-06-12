/// Modifier generator for ModifierMix class code generation.
///
/// Generates a modifier mixin and `ModifierMix` class from `@MixableModifier`
/// annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/modifier_mix_builder.dart';
import 'core/builders/modifier_mixin_builder.dart';
import 'core/curated/type_metadata.dart';
import 'core/errors.dart';

/// Main generator for `ModifierMix` class code.
///
/// Triggers on `@MixableModifier` annotations and generates:
/// - A `_$XModifierMethods` mixin (copyWith, lerp, debugFillProperties, props)
/// - A full `ModifierMix` class (resolve, merge, debugFillProperties, props)
class ModifierGenerator extends GeneratorForAnnotation<MixableModifier> {
  const ModifierGenerator();

  bool _isWidgetModifierClass(ClassElement element) {
    for (final interface in element.allSupertypes) {
      if (interface.element.name == 'WidgetModifier') return true;
    }

    return false;
  }

  List<ModifierFieldModel> _extractFields(ClassElement classElement) {
    // Only fields declared directly on this class (not inherited).
    final fields = classElement.fields
        .where((f) => !f.isStatic && !f.isSynthetic && f.isFinal)
        .toList();

    // Map constructor param names to their named/positional status.
    final constructor = classElement.unnamedConstructor;
    final paramMap = <String, bool>{};
    if (constructor != null) {
      for (final param in constructor.formalParameters) {
        final name = param.name;
        if (name != null) paramMap[name] = param.isNamed;
      }
    }

    // Stable ordering for deterministic generator output.
    fields.sort((a, b) => a.name!.compareTo(b.name!));

    return fields.map((field) {
      final name = field.name!;
      final type = field.type;
      final typeName = _baseTypeName(type);
      final isNullable = type.nullabilitySuffix == NullabilitySuffix.question;

      final mixTypeName = mixTypeFor(typeName);
      final propWrapperKind = mixTypeName != null
          ? PropWrapperKind.maybeMix
          : PropWrapperKind.maybe;

      final isEnum = _isEnum(type);
      final flagDescription = typeName == 'bool'
          ? flagDescriptionFor(name)
          : null;

      return ModifierFieldModel(
        name: name,
        typeName: typeName,
        propWrapperKind: propWrapperKind,
        mixTypeName: mixTypeName,
        isNamedParam: paramMap[name] ?? true,
        isNullable: isNullable,
        isLerpable: isLerpableType(typeName),
        isEnum: isEnum,
        flagDescription: flagDescription,
      );
    }).toList();
  }

  String _baseTypeName(DartType type) {
    final displayString = type.getDisplayString();
    if (displayString.endsWith('?')) {
      return displayString.substring(0, displayString.length - 1);
    }

    return displayString;
  }

  bool _isEnum(DartType type) {
    if (type is InterfaceType) {
      return type.element is EnumElement;
    }

    return false;
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

    if (!_isWidgetModifierClass(classElement)) {
      fail(
        element,
        '@MixableModifier can only be applied to classes extending '
        'WidgetModifier<T>.',
        todo: 'Make the class extend `WidgetModifier<YourModifier>`.',
      );
    }

    final fields = _extractFields(classElement);

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
