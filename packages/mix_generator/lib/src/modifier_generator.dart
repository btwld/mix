/// Modifier generator for ModifierMix class code generation.
///
/// Generates a modifier mixin and ModifierMix class from @MixableModifier annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/modifier_mix_builder.dart';
import 'core/builders/modifier_mixin_builder.dart';
import 'core/curated/flag_descriptions.dart';
import 'core/curated/type_mappings.dart';
import 'core/registry/mix_type_registry.dart';

/// Main generator for ModifierMix class code.
///
/// Triggers on @MixableModifier annotations and generates:
/// - A _$XModifierMethods mixin (copyWith, lerp, debugFillProperties, props)
/// - A full ModifierMix class (resolve, merge, debugFillProperties, props)
class ModifierGenerator extends GeneratorForAnnotation<MixableModifier> {
  const ModifierGenerator();

  bool _isWidgetModifierClass(ClassElement element) {
    for (final interface in element.allSupertypes) {
      if (interface.element.name == 'WidgetModifier') return true;
    }

    return false;
  }

  List<ModifierFieldModel> _extractFields(ClassElement classElement) {
    const registry = MixTypeRegistry();

    // Get only fields declared directly on this class (not inherited)
    final fields = classElement.fields
        .where((f) => !f.isStatic && !f.isSynthetic && f.isFinal)
        .toList();

    // Build a map of constructor param names to their named/positional status
    final constructor = classElement.unnamedConstructor;
    final paramMap = <String, bool>{};
    if (constructor != null) {
      for (final param in constructor.formalParameters) {
        paramMap[param.name!] = param.isNamed;
      }
    }

    // Sort by name for stable ordering
    fields.sort((a, b) => a.name!.compareTo(b.name!));

    return fields.map((field) {
      final name = field.name!;
      final type = field.type;
      final typeName = _getBaseTypeName(type);
      final isNullable = type.nullabilitySuffix == NullabilitySuffix.question;

      final propWrapperKind = registry.getPropWrapperKind(
        typeName,
        isList: _isList(type),
        listElementType: _getListElementType(type),
        fieldName: name,
      );

      final mixTypeName = propWrapperKind == PropWrapperKind.maybeMix
          ? registry.getMixType(typeName)
          : null;

      final isEnum = _isEnum(type);
      final isLerpable = _computeIsLerpable(typeName, isEnum);

      final flagDescription = typeName == 'bool'
          ? getFlagDescription(name)
          : null;

      return ModifierFieldModel(
        name: name,
        typeName: typeName,
        propWrapperKind: propWrapperKind,
        mixTypeName: mixTypeName,
        isNamedParam: paramMap[name] ?? true,
        isNullable: isNullable,
        isLerpable: isLerpable,
        isEnum: isEnum,
        flagDescription: flagDescription,
      );
    }).toList();
  }

  String _getBaseTypeName(DartType type) {
    final displayString = type.getDisplayString();
    if (displayString.endsWith('?')) {
      return displayString.substring(0, displayString.length - 1);
    }

    return displayString;
  }

  bool _isList(DartType type) {
    if (type is! InterfaceType) return false;

    return type.element.name == 'List';
  }

  String? _getListElementType(DartType type) {
    if (type is! InterfaceType) return null;
    if (type.element.name != 'List') return null;
    if (type.typeArguments.isEmpty) return null;

    return _getBaseTypeName(type.typeArguments.first);
  }

  bool _isEnum(DartType type) {
    if (type is InterfaceType) {
      return type.element is EnumElement;
    }

    return false;
  }

  bool _computeIsLerpable(String typeName, bool isEnum) {
    if (isEnum || enumTypes.contains(typeName)) return false;
    if (snappableTypes.contains(typeName)) return false;
    if (lerpableTypes.contains(typeName)) return true;

    return false;
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@MixableModifier can only be applied to classes.',
        element: element,
      );
    }

    final classElement = element;
    final modifierName = classElement.name;
    if (modifierName == null) {
      throw InvalidGenerationSourceError(
        '@MixableModifier class must have a name.',
        element: element,
      );
    }

    if (!_isWidgetModifierClass(classElement)) {
      throw InvalidGenerationSourceError(
        '@MixableModifier can only be applied to classes extending WidgetModifier<T>.',
        element: element,
      );
    }

    final fields = _extractFields(classElement);

    final mixinBuilder = ModifierMixinBuilder(
      modifierName: modifierName,
      fields: fields,
    );

    final mixBuilder = ModifierMixBuilder(
      modifierName: modifierName,
      fields: fields,
    );

    return '${mixinBuilder.build()}\n${mixBuilder.build()}';
  }
}
