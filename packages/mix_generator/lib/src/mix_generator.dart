/// Generator for `@MixableSpec` classes.
///
/// Emits self-contained `_$XSpec` mixins from `@MixableSpec` annotations.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/spec_mixin_builder.dart';
import 'core/errors.dart';
import 'core/models/annotation_config.dart';
import 'core/models/field_model.dart';

/// Source-gen generator for Mix Spec code.
///
/// Triggers on `@MixableSpec` annotations and generates a self-contained
/// `_$XSpec` mixin with header `implements Spec<XSpec>, Diagnosticable`.
/// User code is `final class XSpec with _$XSpec { ... }` — single
/// keyword. The mixin inlines `==`, `hashCode` (via
/// `propsEquals` / `propsHash` from `mix/src/core/equatable.dart`) and
/// Diagnosticable's concrete surface so no user-side mixin ceremony is
/// required.
class SpecGenerator extends GeneratorForAnnotation<MixableSpec> {
  const SpecGenerator();

  /// Extracts field models from [classElement].
  ///
  /// [specName] must be the validated non-null class name:
  /// `generateForAnnotatedElement` fails before this is called, so nullability
  /// is not handled defensively here.
  List<FieldModel> _extractFields(ClassElement classElement, String specName) {
    final stylerName = _deriveStylerName(specName);

    final constructor = classElement.unnamedConstructor;
    if (constructor == null) return [];

    final namedParams = constructor.formalParameters
        .where((p) => p.isNamed)
        .toList();

    return namedParams.map((p) {
      final paramName = p.name!;
      final field = classElement.getField(paramName);
      if (field == null) {
        fail(classElement, 'Field $paramName not found in $specName');
      }

      return FieldModel.fromElement(field, stylerName: stylerName);
    }).toList();
  }

  String _deriveStylerName(String specName) {
    if (specName.endsWith('Spec')) {
      return '${specName.substring(0, specName.length - 4)}Styler';
    }

    return '${specName}Styler';
  }

  MixableSpecAnnotationConfig _extractAnnotationConfig(
    ConstantReader annotation,
  ) {
    final componentsReader = annotation.peek('components');

    return MixableSpecAnnotationConfig(
      methods: peekMethodsBitmask(annotation, GeneratedSpecMethods.all),
      components: componentsReader?.intValue ?? GeneratedSpecComponents.all,
    );
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // Validate element shape: a named class with an unnamed constructor.
    // The generated mixin's `implements Spec<$specName>, Diagnosticable`
    // header enforces Spec-shape at the type level, so the supertype check
    // is intentionally absent here.
    final classElement = requireClassElement(element, '@MixableSpec');
    final specName = requireName(
      classElement,
      orFailWith: '@MixableSpec class must have a name.',
    );

    final constructor = classElement.unnamedConstructor;
    if (constructor == null) {
      fail(element, '$specName must have an unnamed constructor.');
    }

    final fields = _extractFields(classElement, specName);
    final config = _extractAnnotationConfig(annotation);
    final buffer = StringBuffer();
    final specMixinBuilder = SpecMixinBuilder(
      specName: specName,
      fields: fields,
      config: config,
    );
    buffer.writeln(specMixinBuilder.build());

    return buffer.toString();
  }
}
