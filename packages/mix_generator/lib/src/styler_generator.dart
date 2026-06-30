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
    return classElement.fields
        .where((f) => f.name?.startsWith(r'$') ?? false)
        .where((f) => !_isBaseField(f.name!))
        .map((field) {
          return StylerFieldModel.fromElement(field, stylerName: stylerName);
        })
        .toList();
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

  String? _buildCallMethod({
    required ClassElement stylerElement,
    required String stylerName,
    required InterfaceElement specElement,
    required String specName,
  }) {
    final specAnnotation = mixableSpecAnnotationChecker.firstAnnotationOf(
      specElement,
    );
    if (specAnnotation == null) return null;

    final reader = ConstantReader(specAnnotation).peek('target');
    if (reader == null || reader.isNull) return null;

    final fn = reader.objectValue.toFunctionValue();
    if (fn is! ConstructorElement) {
      fail(
        specElement,
        '@MixableSpec(target:) must be a constructor tear-off '
        '(e.g., Box.new).',
      );
    }

    final widgetClass = fn.enclosingElement;
    final widgetName = mixableSpecTargetWidgetName(fn);
    final hiddenWidgetType = firstInvisibleTypeName(
      widgetClass.thisType,
      stylerElement.library,
    );
    if (hiddenWidgetType != null) {
      fail(
        stylerElement,
        'Target widget `$hiddenWidgetType` is used by @MixableSpec(target:) '
        'but is not visible from the @MixableStyler library.',
        todo:
            'Import or re-export `$hiddenWidgetType` where the styler is declared.',
      );
    }

    validateMixableSpecTargetConstructor(
      constructor: fn,
      widgetName: widgetName,
      specElement: specElement,
      specName: specName,
      anchor: specElement,
    );

    final result = extractCallParams(
      fn,
      anchor: stylerElement,
      library: stylerElement.library,
      factoryReference: stylerName,
      excludeNames: const {'style', 'styleSpec'},
      annotationLabel: '@MixableSpec(target:)',
      keyOwner: 'the target constructor',
    );

    return renderWidgetCall(
      widgetName: widgetName,
      params: result.params,
      forwardsKey: result.forwardsKey,
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
      specName: specName,
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
