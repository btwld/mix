/// Generator for `@MixableStyler` classes.
///
/// Emits `_$XStylerMixin` implementations from `@MixableStyler` annotations.
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
import 'core/models/mix_widget_model.dart';
import 'core/models/styler_field_model.dart';

/// Source-gen generator for Mix Styler code.
class StylerGenerator extends GeneratorForAnnotation<MixableStyler> {
  const StylerGenerator();

  bool _isStyleClass(ClassElement element) {
    return findSupertypeMatching(element.supertype, styleChecker) != null;
  }

  InterfaceType? _extractSpecType(ClassElement classElement) {
    final styleType = findSupertypeMatching(
      classElement.supertype,
      styleChecker,
    );
    if (styleType == null || styleType.typeArguments.isEmpty) {
      return null;
    }

    final specType = styleType.typeArguments.first;

    return specType is InterfaceType ? specType : null;
  }

  String? _extractSpecName(ClassElement classElement) {
    final specType = _extractSpecType(classElement);
    if (specType == null) return null;

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

  String? _buildCallMethod({
    required ClassElement stylerElement,
    required String stylerName,
    required InterfaceType specType,
    required String specName,
  }) {
    final specElement = specType.element;
    final annotation = mixableSpecAnnotationChecker.firstAnnotationOf(
      specElement,
    );
    if (annotation == null) return null;

    final reader = ConstantReader(annotation).peek('target');
    if (reader == null || reader.isNull) return null;

    final fn = reader.objectValue.toFunctionValue();
    if (fn is! ConstructorElement) {
      fail(
        stylerElement,
        '@MixableSpec(target:) must be a constructor tear-off '
        '(e.g., Box.new).',
      );
    }

    final widgetClass = fn.enclosingElement;
    final widgetName = requireName(
      widgetClass,
      orFailWith: '@MixableSpec(target:) widget class must have a name.',
    );
    final styleWidgetSupertype = findSupertypeMatching(
      widgetClass.thisType,
      styleWidgetChecker,
    );
    if (styleWidgetSupertype == null) {
      fail(
        stylerElement,
        'Widget $widgetName must extend StyleWidget<$specName> '
        'to be used as @MixableSpec(target:).',
      );
    }

    final widgetSpecArg = styleWidgetSupertype.typeArguments.first;
    if (widgetSpecArg is! InterfaceType ||
        widgetSpecArg.element != specElement) {
      fail(
        stylerElement,
        'Spec generic mismatch: $specName annotated, but '
        '$widgetName extends StyleWidget<${widgetSpecArg.getDisplayString()}>.',
      );
    }

    final optionalPositional = optionalPositionalNames(fn.formalParameters);
    if (optionalPositional.isNotEmpty) {
      fail(
        stylerElement,
        '@MixableSpec(target:) does not support optional positional target '
        'constructor parameters on $widgetName: '
        '[${optionalPositional.join(', ')}].',
        todo: 'Convert these parameters to required positional or named.',
      );
    }

    _requireStyleParameter(stylerElement, fn, widgetName);

    final result = extractCallParams(
      fn,
      anchor: stylerElement,
      library: stylerElement.library,
      factoryReference: stylerName,
      excludeNames: const {'style', 'styleSpec'},
      annotationLabel: '@MixableSpec(target:)',
      keyOwner: 'the target constructor',
    );

    return _renderCallMethod(
      widgetName: widgetName,
      params: result.params,
      forwardsKey: result.forwardsKey,
    );
  }

  void _requireStyleParameter(
    Element anchor,
    ConstructorElement constructor,
    String widgetName,
  ) {
    for (final parameter in constructor.formalParameters) {
      if (parameter.name == 'style' && parameter.isNamed) return;
    }

    fail(
      anchor,
      '@MixableSpec(target:) requires $widgetName to expose a named '
      '`style` constructor parameter so the generated call() can pass '
      '`style: this`.',
    );
  }

  String _renderCallMethod({
    required String widgetName,
    required List<WidgetCallParam> params,
    required bool forwardsKey,
  }) {
    final positional = params.where((p) => p.isPositional).toList();
    final named = params.where((p) => !p.isPositional).toList();
    final signatureParams = [
      ...positional.map(_callParameterCode),
      if (forwardsKey || named.isNotEmpty)
        '{${[if (forwardsKey) 'Key? key', ...named.map(_callParameterCode)].join(', ')}}',
    ];
    final invocationArgs = [
      ...positional.map((p) => p.name),
      if (forwardsKey) 'key: key',
      'style: this',
      ...named.map((p) => '${p.name}: ${p.name}'),
    ];

    return '''
  $widgetName call(${signatureParams.join(', ')}) {
    return $widgetName(${invocationArgs.join(', ')});
  }
''';
  }

  String _callParameterCode(WidgetCallParam param) {
    final required = param.isRequired && !param.isPositional ? 'required ' : '';
    final defaultClause = param.defaultValueCode != null
        ? ' = ${param.defaultValueCode}'
        : '';

    return '$required${param.typeCode} ${param.name}$defaultClause';
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
    final specType = _extractSpecType(classElement);
    if (specType == null) {
      fail(element, 'Could not determine Spec type from Style<T> supertype.');
    }

    final fields = _extractFields(classElement);
    final config = _extractAnnotationConfig(annotation);
    final callMethodCode = _buildCallMethod(
      stylerElement: classElement,
      stylerName: stylerName,
      specType: specType,
      specName: specName,
    );
    final buffer = StringBuffer();
    final stylerMixinBuilder = StylerMixinBuilder(
      stylerName: stylerName,
      specName: specName,
      fields: fields,
      config: config,
      callMethodCode: callMethodCode,
    );
    buffer.writeln(stylerMixinBuilder.build());

    return buffer.toString();
  }
}
