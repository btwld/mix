/// Styler generator for Styler mixin code generation.
///
/// Generates _$XStylerMixin from @MixableStyler annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/styler_mixin_builder.dart';
import 'core/models/annotation_config.dart';
import 'core/models/styler_field_model.dart';

/// Main generator for Mix Styler code.
///
/// Triggers on @MixableStyler annotations and generates:
/// - _$XStylerMixin (Styler method implementations)
class StylerGenerator extends GeneratorForAnnotation<MixableStyler> {
  const StylerGenerator();

  bool _isStyleClass(ClassElement element) {
    // Check if class extends Style<T>
    final supertype = element.supertype;
    if (supertype == null) return false;

    final supertypeName = supertype.element.name;

    return supertypeName == 'Style';
  }

  String? _extractSpecName(ClassElement classElement) {
    final supertype = classElement.supertype;
    if (supertype == null) return null;

    // Style<BoxSpec> -> BoxSpec
    if (supertype.typeArguments.isNotEmpty) {
      final specType = supertype.typeArguments.first;

      return specType.getDisplayString();
    }

    return null;
  }

  List<StylerFieldModel> _extractFields(ClassElement classElement) {
    // ClassElement.name is String? in analyzer 10.x, but classes always have names
    final stylerName = classElement.name!;

    // Get all fields that start with $
    // FieldElement.name is String? but fields always have names
    final dollarFields = classElement.fields
        .where((f) => f.name!.startsWith(r'$'))
        .where((f) => !_isBaseField(f.name!))
        .toList();

    // Sort by name for stable ordering
    dollarFields.sort((a, b) => a.name!.compareTo(b.name!));

    return dollarFields.map((f) {
      return StylerFieldModel.fromElement(f, stylerName: stylerName);
    }).toList();
  }

  bool _isBaseField(String name) {
    // Base fields from Style<T>
    return const {r'$variants', r'$modifier', r'$animation'}.contains(name);
  }

  MixableStylerAnnotationConfig _extractAnnotationConfig(
    ConstantReader annotation,
  ) {
    final methodsReader = annotation.peek('methods');

    return MixableStylerAnnotationConfig(
      methods: methodsReader?.intValue ?? GeneratedStylerMethods.all,
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
        '@MixableStyler can only be applied to classes.',
        element: element,
      );
    }

    final classElement = element;
    final stylerName = classElement.name;
    if (stylerName == null) {
      throw InvalidGenerationSourceError(
        '@MixableStyler class must have a name.',
        element: element,
      );
    }

    // Validate it's a Style class
    if (!_isStyleClass(classElement)) {
      throw InvalidGenerationSourceError(
        '@MixableStyler can only be applied to classes extending Style<T>.',
        element: element,
      );
    }

    // Extract Spec name from Style<SpecName>
    final specName = _extractSpecName(classElement);
    if (specName == null) {
      throw InvalidGenerationSourceError(
        'Could not determine Spec type from Style<T> supertype.',
        element: element,
      );
    }

    // Extract field models
    final fields = _extractFields(classElement);

    // Extract annotation configuration
    final config = _extractAnnotationConfig(annotation);

    // Build output
    final buffer = StringBuffer();

    // Generate Styler mixin
    final stylerMixinBuilder = StylerMixinBuilder(
      stylerName: stylerName,
      specName: specName,
      fields: fields,
      config: config,
    );
    buffer.writeln(stylerMixinBuilder.build());

    return buffer.toString();
  }
}
