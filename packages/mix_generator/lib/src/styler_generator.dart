/// Generator for `@MixableStyler` classes.
///
/// Emits `_$XStylerMixin` implementations from `@MixableStyler` annotations.
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

/// Source-gen generator for Mix Styler code.
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
    // `requireClassElement` guarantees a named class before this is called.
    final stylerName = classElement.name!;

    final dollarFields = classElement.fields
        .where((f) => f.name!.startsWith(r'$'))
        .where((f) => !_isBaseField(f.name!))
        .toList();

    // Stable ordering keeps generated output deterministic.
    dollarFields.sort((a, b) => a.name!.compareTo(b.name!));

    return dollarFields.map((f) {
      return StylerFieldModel.fromElement(f, stylerName: stylerName);
    }).toList();
  }

  bool _isBaseField(String name) {
    // Base fields come from `Style<T>` and are handled separately.
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

    if (!_isStyleClass(classElement)) {
      fail(
        element,
        '@MixableStyler can only be applied to classes extending Style<T>.',
        todo:
            'Make the class extend a concrete Style subclass such as '
            '`Style<YourSpec>` or `MixStyler<YourStyler, YourSpec>`.',
      );
    }

    final specName = _extractSpecName(classElement);
    if (specName == null) {
      fail(element, 'Could not determine Spec type from Style<T> supertype.');
    }

    final fields = _extractFields(classElement);
    final config = _extractAnnotationConfig(annotation);
    final buffer = StringBuffer();
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
