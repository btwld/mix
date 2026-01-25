/// Mix generator for Spec code generation.
///
/// Generates _$XSpecMethods mixins from @MixableSpec annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/spec_mixin_builder.dart';
import 'core/models/annotation_config.dart';
import 'core/models/field_model.dart';

/// Main generator for Mix Spec code.
///
/// Triggers on @MixableSpec annotations and generates:
/// - _$XSpecMethods mixin (Spec method overrides)
class MixGenerator extends GeneratorForAnnotation<MixableSpec> {
  const MixGenerator();
  bool _isSpecClass(ClassElement element) {
    // Check if class extends Spec<T>
    final supertype = element.supertype;
    if (supertype == null) return false;

    final supertypeName = supertype.element.name;

    return supertypeName == 'Spec';
  }

  List<FieldModel> _extractFields(ClassElement classElement) {
    final specName = classElement.name;
    final stylerName = _deriveStylerName(specName);

    final constructor = classElement.unnamedConstructor;
    if (constructor == null) return [];

    // Get named parameters
    final namedParams = constructor.formalParameters
        .where((p) => p.isNamed)
        .toList();

    return namedParams.map((p) {
      // FormalParameterElement.name is String? in analyzer 10.x, but named params always have names
      final paramName = p.name!;
      final field = classElement.getField(paramName);
      if (field == null) {
        throw InvalidGenerationSourceError(
          'Field $paramName not found in $specName',
          element: classElement,
        );
      }

      return FieldModel.fromElement(field, stylerName: stylerName);
    }).toList();
  }

  String _deriveStylerName(String? specName) {
    if (specName == null) return 'Styler';
    if (specName.endsWith('Spec')) {
      return '${specName.substring(0, specName.length - 4)}Styler';
    }

    return '${specName}Styler';
  }

  MixableSpecAnnotationConfig _extractAnnotationConfig(
    ConstantReader annotation,
  ) {
    final methodsReader = annotation.peek('methods');
    final componentsReader = annotation.peek('components');

    return MixableSpecAnnotationConfig(
      methods: methodsReader?.intValue ?? GeneratedSpecMethods.all,
      components: componentsReader?.intValue ?? GeneratedSpecComponents.all,
    );
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // Validate element is a class
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@MixableSpec can only be applied to classes.',
        element: element,
      );
    }

    final classElement = element;
    final specName = classElement.name;
    if (specName == null) {
      throw InvalidGenerationSourceError(
        '@MixableSpec class must have a name.',
        element: element,
      );
    }

    // Validate it's a Spec class
    if (!_isSpecClass(classElement)) {
      throw InvalidGenerationSourceError(
        '@MixableSpec can only be applied to classes extending Spec<$specName>.',
        element: element,
      );
    }

    // Validate constructor exists
    final constructor = classElement.unnamedConstructor;
    if (constructor == null) {
      throw InvalidGenerationSourceError(
        '$specName must have an unnamed constructor.',
        element: element,
      );
    }

    // Extract field models
    final fields = _extractFields(classElement);

    // Extract annotation configuration (methods and components flags)
    final config = _extractAnnotationConfig(annotation);

    // Build output
    final buffer = StringBuffer();

    // Generate Spec mixin
    final specMixinBuilder = SpecMixinBuilder(
      specName: specName,
      fields: fields,
      config: config,
    );
    buffer.writeln(specMixinBuilder.build());

    return buffer.toString();
  }
}
