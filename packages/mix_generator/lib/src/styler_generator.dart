/// Styler generator for Styler mixin code generation.
///
/// Generates _$XStylerMixin from @MixableStyler annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/styler_mixin_builder.dart';
import 'core/checkers.dart';
import 'core/errors.dart';
import 'core/helpers/library_scope.dart';
import 'core/helpers/type_hierarchy.dart';
import 'core/models/annotation_config.dart';
import 'core/models/styler_field_model.dart';

/// Main generator for Mix Styler code.
///
/// Triggers on @MixableStyler annotations and generates:
/// - _$XStylerMixin (Styler method implementations)
class StylerGenerator extends GeneratorForAnnotation<MixableStyler> {
  const StylerGenerator();

  bool _isStyleClass(ClassElement element) {
    return findSupertypeMatching(element.supertype, styleChecker) != null;
  }

  String? _extractSpecName(ClassElement classElement) {
    final styleType = findSupertypeMatching(
      classElement.supertype,
      styleChecker,
    );
    if (styleType == null || styleType.typeArguments.isEmpty) {
      return null;
    }

    final specType = styleType.typeArguments.first;
    final hiddenType = firstInvisibleTypeName(specType, classElement.library);
    if (hiddenType != null) {
      final className = classElement.name ?? '<unknown>';
      fail(
        classElement,
        'Style type `$hiddenType` is used but not imported into the '
        'annotated library. Import or re-export `$hiddenType` where '
        '$className is declared.',
      );
    }

    return typeCode(specType, visibleFrom: classElement.library);
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
    return MixableStylerAnnotationConfig(
      methods: peekMethodsBitmask(annotation, GeneratedStylerMethods.all),
    );
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final classElement = requireClassElement(element, '@MixableStyler');
    final stylerName = requireName(
      classElement,
      orFailWith: '@MixableStyler class must have a name.',
    );

    // Validate it's a Style class
    if (!_isStyleClass(classElement)) {
      fail(
        element,
        '@MixableStyler can only be applied to classes extending Style<T>.',
        todo:
            'Make the class extend a concrete Style subclass such as '
            '`Style<YourSpec>` or `MixStyler<YourStyler, YourSpec>`.',
      );
    }

    // Extract Spec name from Style<SpecName>
    final specName = _extractSpecName(classElement);
    if (specName == null) {
      fail(element, 'Could not determine Spec type from Style<T> supertype.');
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
