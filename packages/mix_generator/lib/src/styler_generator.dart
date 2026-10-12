/// Legacy generator for `@MixableStyler` classes.
///
/// Emits only `_$XStylerMixin` implementations for handwritten styler classes.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/styler_mixin_builder.dart';
import 'core/checkers.dart';
import 'core/errors.dart';
import 'core/helpers/library_scope.dart';
import 'core/helpers/type_hierarchy.dart';
import 'core/helpers/widget_call_planner.dart';
import 'core/models/annotation_config.dart';
import 'core/models/styler_field_model.dart';

/// Source-gen generator for legacy handwritten Mix Styler code.
class StylerGenerator extends GeneratorForAnnotation<MixableStyler> {
  const StylerGenerator();

  InterfaceType? _extractSpecType(InterfaceType styleType) {
    if (styleType.typeArguments.isEmpty) return null;

    final specType = styleType.typeArguments.first;

    return specType is InterfaceType ? specType : null;
  }

  String _specNameFor(InterfaceType specType, ClassElement classElement) {
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

  List<StylerFieldModel> _extractFields(
    ClassElement classElement,
    String stylerName,
  ) {
    for (final member in [...classElement.fields, ...classElement.methods]) {
      if (member.name != stylerFieldMetadataGetter) continue;
      fail(
        member,
        '`$stylerFieldMetadataGetter` is reserved for generated Styler metadata. '
        'Rename the Styler member.',
        todo: 'Rename the Styler member.',
      );
    }

    final fields = classElement.fields
        .where((f) => f.name?.startsWith(r'$') ?? false)
        .where((f) => !_isBaseField(f.name!));

    return fields.map((field) {
      return StylerFieldModel.fromElement(field, stylerName: stylerName);
    }).toList();
  }

  bool _isBaseField(String name) {
    // Base fields come from `Style<T>` and are handled separately.
    return stylerBaseFieldNames.any((fieldName) => name == '\$$fieldName');
  }

  MixableStylerAnnotationConfig _extractAnnotationConfig(
    ConstantReader annotation,
  ) {
    return MixableStylerAnnotationConfig(
      methods: peekMethodsBitmask(annotation, GeneratedStylerMethods.all),
    );
  }

  String? _buildCallMethod({
    required ClassElement stylerElement,
    required String stylerName,
    required InterfaceElement specElement,
  }) {
    final specAnnotation = mixableSpecAnnotationChecker.firstAnnotationOf(
      specElement,
    );
    if (specAnnotation == null) return null;

    return buildMixableSpecTargetCall(
      annotation: ConstantReader(specAnnotation),
      specElement: specElement,
      stylerName: stylerName,
      allowExactGeneratedStyler: false,
      hostElement: stylerElement,
      hostLibrary: stylerElement.library,
      validateTargetVisibility: true,
      indent: '  ',
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

    final styleType = findSupertypeMatching(
      classElement.supertype,
      styleChecker,
    );
    if (styleType == null) {
      fail(
        element,
        '@MixableStyler can only be applied to classes extending Style<T>.',
        todo:
            'Make the class extend a concrete Style subclass such as '
            '`Style<YourSpec>` or `MixStyler<YourStyler, YourSpec>`.',
      );
    }

    final specType = _extractSpecType(styleType);
    if (specType == null) {
      fail(element, 'Could not determine Spec type from Style<T> supertype.');
    }

    final specName = _specNameFor(specType, classElement);
    final callMethodCode = _buildCallMethod(
      stylerElement: classElement,
      stylerName: stylerName,
      specElement: specType.element,
    );
    final fields = _extractFields(classElement, stylerName);
    final config = _extractAnnotationConfig(annotation);

    return StylerMixinBuilder(
      stylerName: stylerName,
      specName: specName,
      fields: fields,
      config: config,
      callMethodCode: callMethodCode,
    ).build();
  }
}
