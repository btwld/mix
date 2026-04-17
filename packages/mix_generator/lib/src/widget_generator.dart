/// Generator for Mix widget wrappers.
library;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

const _reservedParameterNames = {'key', 'style', 'styleSpec'};
const _flutterBuildContextLibraryUri =
    'package:flutter/src/widgets/framework.dart';

/// Maps a Mix spec type name to the class name of its default
/// [MixWidgetBuilder] subclass.
///
/// When `@MixWidget()` is applied without an explicit `widgetBuilder`, the
/// generator looks up the target styler's spec in this map. `RowBoxBuilder`
/// and `ColumnBoxBuilder` are explicit-only (not present) because both map to
/// [FlexBoxSpec] — defaulting `FlexBoxStyler` to `FlexBoxBuilder` preserves
/// today's behavior.
const _defaultBuildersBySpec = <String, String>{
  'BoxSpec': 'BoxBuilder',
  'FlexBoxSpec': 'FlexBoxBuilder',
  'TextSpec': 'StyledTextBuilder',
  'IconSpec': 'StyledIconBuilder',
  'ImageSpec': 'StyledImageBuilder',
  'StackBoxSpec': 'StackBoxBuilder',
};

class MixWidgetGenerator extends GeneratorForAnnotation<MixWidget> {
  const MixWidgetGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final config = _parseAnnotationConfig(annotation);
    final target = _extractAnnotatedTarget(element);
    final generatedName =
        config.name ?? _deriveGeneratedName(target.sourceName, element);

    final inputLibrary = await buildStep.inputLibrary;
    _validateGeneratedName(
      library: inputLibrary,
      currentElement: element,
      generatedName: generatedName,
    );

    final callSignature = _extractCallSignature(
      stylerType: target.stylerType,
      element: element,
    );

    final resolvedBuilder = _resolveBuilder(
      annotation: annotation,
      target: target,
      element: element,
    );

    final factoryParameters = _resolveFactoryParameters(
      _extractFactoryParameters(target.factoryElement),
      element,
    );

    _validateParameterCollisions(
      factoryParameters: factoryParameters,
      mirroredParameters: callSignature.parameters,
      element: element,
    );

    return _buildWidgetClass(
      generatedName: generatedName,
      target: target,
      config: config,
      resolvedBuilder: resolvedBuilder,
      callReturnType: callSignature.returnType,
      factoryParameters: factoryParameters,
      mirroredParameters: callSignature.parameters,
    );
  }

  _MixWidgetConfig _parseAnnotationConfig(ConstantReader annotation) {
    return _MixWidgetConfig(
      name: annotation.peek('name')?.stringValue,
      styleable: annotation.peek('styleable')?.boolValue ?? false,
    );
  }

  _AnnotatedTarget _extractAnnotatedTarget(Element element) {
    if (element is TopLevelVariableElement) {
      _validateTopLevelElement(element);
      if (!element.isFinal) {
        throw InvalidGenerationSource(
          '@MixWidget only supports top-level final variables.',
          element: element,
        );
      }

      final sourceName = element.name;
      if (sourceName == null) {
        throw InvalidGenerationSource(
          '@MixWidget target must have a name.',
          element: element,
        );
      }

      if (sourceName.startsWith('_')) {
        throw InvalidGenerationSource(
          '@MixWidget does not support private declarations.',
          element: element,
        );
      }

      final stylerType = _extractStylerType(element.type, element);
      final specType = _extractSpecType(stylerType, element);

      return _AnnotatedTarget(
        sourceName: sourceName,
        stylerType: stylerType,
        specType: specType,
        factoryElement: null,
      );
    }

    if (element is TopLevelFunctionElement) {
      _validateTopLevelElement(element);
      final sourceName = element.name;
      if (sourceName == null) {
        throw InvalidGenerationSource(
          '@MixWidget target must have a name.',
          element: element,
        );
      }

      if (sourceName.startsWith('_')) {
        throw InvalidGenerationSource(
          '@MixWidget does not support private declarations.',
          element: element,
        );
      }

      final stylerType = _extractStylerType(element.returnType, element);
      final specType = _extractSpecType(stylerType, element);

      return _AnnotatedTarget(
        sourceName: sourceName,
        stylerType: stylerType,
        specType: specType,
        factoryElement: element,
      );
    }

    throw InvalidGenerationSource(
      '@MixWidget only supports top-level final variables and top-level functions.',
      element: element,
    );
  }

  void _validateTopLevelElement(Element element) {
    if (element.enclosingElement is! LibraryElement) {
      throw InvalidGenerationSource(
        '@MixWidget only supports top-level declarations.',
        element: element,
      );
    }
  }

  InterfaceType _extractStylerType(DartType type, Element element) {
    if (type is! InterfaceType) {
      throw InvalidGenerationSource(
        '@MixWidget requires a concrete Mix styler type.',
        element: element,
      );
    }

    if (type.nullabilitySuffix == NullabilitySuffix.question) {
      throw InvalidGenerationSource(
        '@MixWidget does not support nullable styler types.',
        element: element,
      );
    }

    if (!_isStyleType(type)) {
      throw InvalidGenerationSource(
        '@MixWidget can only be applied to declarations returning a Style<T> subtype.',
        element: element,
      );
    }

    return type;
  }

  bool _isStyleType(InterfaceType type) {
    InterfaceType? currentType = type;

    while (currentType != null) {
      if (currentType.element.name == 'Style') {
        return true;
      }

      currentType = currentType.superclass;
    }

    return false;
  }

  DartType _extractSpecType(InterfaceType stylerType, Element element) {
    InterfaceType? currentType = stylerType;

    while (currentType != null) {
      if (currentType.element.name == 'Style') {
        if (currentType.typeArguments.isEmpty) {
          break;
        }

        final specType = currentType.typeArguments.first;
        if (specType is InterfaceType &&
            specType.nullabilitySuffix != NullabilitySuffix.question) {
          return specType;
        }
        break;
      }

      currentType = currentType.superclass;
    }

    throw InvalidGenerationSource(
      'Could not determine the Style<T> spec type for @MixWidget.',
      element: element,
    );
  }

  /// Resolves the widget-construction strategy for a `@MixWidget` target.
  ///
  /// Priority:
  ///   1. If the annotation's `widgetBuilder` argument is non-null, validate
  ///      it is a subtype of `MixWidgetBuilder<TSpec>` whose `TSpec` matches
  ///      the target's spec, and use its class name for emission.
  ///   2. If the target's spec has a default entry in [_defaultBuildersBySpec],
  ///      use that builder.
  ///   3. Otherwise return `null` to fall back to direct widget emission using
  ///      the styler's `call()` return type.
  _ResolvedBuilder? _resolveBuilder({
    required ConstantReader annotation,
    required _AnnotatedTarget target,
    required Element element,
  }) {
    final explicit = _extractExplicitBuilderType(annotation);
    if (explicit != null) {
      _validateBuilderType(
        builderType: explicit,
        targetSpec: target.specType,
        element: element,
      );
      return _ResolvedBuilder(className: explicit.element.name!);
    }

    final specName = target.specType is InterfaceType
        ? (target.specType as InterfaceType).element.name
        : null;
    if (specName != null) {
      final defaultBuilder = _defaultBuildersBySpec[specName];
      if (defaultBuilder != null) {
        return _ResolvedBuilder(className: defaultBuilder);
      }
    }

    return null;
  }

  InterfaceType? _extractExplicitBuilderType(ConstantReader annotation) {
    final reader = annotation.peek('widgetBuilder');
    if (reader == null || reader.isNull) {
      return null;
    }

    final type = reader.objectValue.type;
    if (type is! InterfaceType) {
      return null;
    }

    return type;
  }

  void _validateBuilderType({
    required InterfaceType builderType,
    required DartType targetSpec,
    required Element element,
  }) {
    InterfaceType? current = builderType;
    while (current != null) {
      if (current.element.name == 'MixWidgetBuilder') {
        if (current.typeArguments.isEmpty) {
          throw InvalidGenerationSource(
            '`widgetBuilder` type `${builderType.element.name}` must bind a spec type parameter.',
            element: element,
          );
        }

        final builderSpec = current.typeArguments.first;
        if (builderSpec is! InterfaceType || targetSpec is! InterfaceType) {
          throw InvalidGenerationSource(
            '`widgetBuilder` spec could not be resolved for ${builderType.element.name}.',
            element: element,
          );
        }

        if (builderSpec.element != targetSpec.element) {
          throw InvalidGenerationSource(
            '`widgetBuilder` ${builderType.element.name} targets ${builderSpec.getDisplayString()} '
            'but the styler produces ${targetSpec.getDisplayString()}.',
            element: element,
          );
        }

        return;
      }

      current = current.superclass;
    }

    throw InvalidGenerationSource(
      '`widgetBuilder` must be a subtype of MixWidgetBuilder<TSpec>. '
      'Got ${builderType.getDisplayString()}.',
      element: element,
    );
  }

  _CallSignature _extractCallSignature({
    required InterfaceType stylerType,
    required Element element,
  }) {
    final callMethod = _resolveCallMethod(stylerType);
    if (callMethod == null) {
      throw InvalidGenerationSource(
        '${stylerType.element.name} must expose a concrete instance `call()` method for @MixWidget.',
        element: element,
      );
    }

    final returnType = callMethod.returnType;
    if (returnType is! InterfaceType || !_isWidgetType(returnType)) {
      throw InvalidGenerationSource(
        '${stylerType.element.name}.call() must return a Widget subtype for @MixWidget.',
        element: element,
      );
    }

    return _CallSignature(
      returnType: returnType,
      parameters: [
        for (final parameter in callMethod.formalParameters)
          if (!_reservedParameterNames.contains(parameter.name))
            _ParameterSpec.fromParameter(parameter),
      ],
    );
  }

  MethodElement? _resolveCallMethod(InterfaceType stylerType) {
    InterfaceType? currentType = stylerType;

    while (currentType != null) {
      for (final method in currentType.element.methods) {
        if (method.name != 'call') {
          continue;
        }

        if (!method.isStatic && !method.isAbstract) {
          return method;
        }
      }

      currentType = currentType.superclass;
    }

    return null;
  }

  bool _isWidgetType(InterfaceType type) {
    InterfaceType? currentType = type;

    while (currentType != null) {
      if (currentType.element.name == 'Widget') {
        return true;
      }

      currentType = currentType.superclass;
    }

    return false;
  }

  List<_ParameterSpec> _extractFactoryParameters(
    TopLevelFunctionElement? factoryElement,
  ) {
    if (factoryElement == null) {
      return const [];
    }

    return factoryElement.formalParameters
        .map(_ParameterSpec.fromParameter)
        .toList();
  }

  _FactoryParameters _resolveFactoryParameters(
    List<_ParameterSpec> factoryParameters,
    Element element,
  ) {
    if (factoryParameters.isEmpty) {
      return const _FactoryParameters(
        publicParameters: [],
        injectsBuildContext: false,
      );
    }

    final publicParameters = <_ParameterSpec>[];
    var injectsBuildContext = false;

    for (var index = 0; index < factoryParameters.length; index++) {
      final parameter = factoryParameters[index];
      final isFlutterBuildContext = _isFlutterBuildContext(parameter.type);
      final hasBuildContextName = _hasBuildContextTypeName(parameter.type);

      if (_isInjectedBuildContextParameter(parameter, index)) {
        injectsBuildContext = true;
        continue;
      }

      if (isFlutterBuildContext && index == 0) {
        throw InvalidGenerationSource(
          '@MixWidget can inject only a first required positional BuildContext parameter named `context`.',
          element: element,
        );
      }

      if (isFlutterBuildContext) {
        throw InvalidGenerationSource(
          '@MixWidget does not expose BuildContext factory parameters. Use a first required positional `BuildContext context` parameter.',
          element: element,
        );
      }

      if (hasBuildContextName) {
        throw InvalidGenerationSource(
          '@MixWidget BuildContext injection requires Flutter BuildContext from package:flutter/widgets.dart.',
          element: element,
        );
      }

      publicParameters.add(parameter);
    }

    return _FactoryParameters(
      publicParameters: publicParameters,
      injectsBuildContext: injectsBuildContext,
    );
  }

  bool _isInjectedBuildContextParameter(_ParameterSpec parameter, int index) {
    return index == 0 &&
        parameter.name == 'context' &&
        parameter.isRequiredPositional &&
        _isFlutterBuildContext(parameter.type);
  }

  bool _isFlutterBuildContext(DartType type) {
    return type is InterfaceType &&
        type.element.name == 'BuildContext' &&
        type.element.library.uri.toString() == _flutterBuildContextLibraryUri;
  }

  bool _hasBuildContextTypeName(DartType type) {
    return type is InterfaceType && type.element.name == 'BuildContext';
  }

  void _validateParameterCollisions({
    required _FactoryParameters factoryParameters,
    required List<_ParameterSpec> mirroredParameters,
    required Element element,
  }) {
    if (factoryParameters.injectsBuildContext &&
        mirroredParameters.any((parameter) => parameter.name == 'context')) {
      throw InvalidGenerationSource(
        'Parameter `context` conflicts with the injected BuildContext used by @MixWidget.',
        element: element,
      );
    }

    final seenNames = <String>{};

    for (final parameter in [
      ...factoryParameters.publicParameters,
      ...mirroredParameters,
    ]) {
      if (_reservedParameterNames.contains(parameter.name)) {
        throw InvalidGenerationSource(
          'Parameter `${parameter.name}` is reserved by @MixWidget.',
          element: element,
        );
      }

      if (!seenNames.add(parameter.name)) {
        throw InvalidGenerationSource(
          'Duplicate generated parameter `${parameter.name}` detected for @MixWidget.',
          element: element,
        );
      }
    }
  }

  String _deriveGeneratedName(String sourceName, Element element) {
    var baseName = sourceName;
    if (baseName.endsWith('Styler')) {
      baseName = baseName.substring(0, baseName.length - 'Styler'.length);
    } else if (baseName.endsWith('Style')) {
      baseName = baseName.substring(0, baseName.length - 'Style'.length);
    }

    if (baseName.isEmpty) {
      throw InvalidGenerationSource(
        '@MixWidget could not derive a widget name from `$sourceName`.',
        element: element,
      );
    }

    return baseName
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join();
  }

  void _validateGeneratedName({
    required LibraryElement library,
    required Element currentElement,
    required String generatedName,
  }) {
    if (generatedName.isEmpty) {
      throw InvalidGenerationSource(
        '@MixWidget requires a non-empty generated class name.',
        element: currentElement,
      );
    }

    if (generatedName.startsWith('_')) {
      throw InvalidGenerationSource(
        '@MixWidget requires a public generated class name.',
        element: currentElement,
      );
    }

    final existingNames = <String>{
      ..._collectElementNames(library.classes),
      ..._collectElementNames(library.enums),
      ..._collectElementNames(library.mixins),
      ..._collectElementNames(library.extensions),
      ..._collectElementNames(library.extensionTypes),
      ..._collectElementNames(library.typeAliases),
      ..._collectElementNames(library.topLevelFunctions),
      ..._collectElementNames(library.topLevelVariables),
    };

    if (existingNames.contains(generatedName)) {
      throw InvalidGenerationSource(
        'Generated widget name `$generatedName` conflicts with an existing declaration.',
        element: currentElement,
      );
    }

    final generatedNames = <String>[];
    for (final element in [
      ...library.topLevelVariables,
      ...library.topLevelFunctions,
    ]) {
      if (!_hasMixWidgetAnnotation(element)) {
        continue;
      }

      generatedNames.add(_resolvedGeneratedNameForElement(element));
    }

    final collisions = generatedNames.where((name) => name == generatedName);
    if (collisions.length > 1) {
      throw InvalidGenerationSource(
        'Generated widget name `$generatedName` is duplicated in this library.',
        element: currentElement,
      );
    }
  }

  bool _hasMixWidgetAnnotation(Element element) {
    return element.metadata.annotations.any((annotation) {
      final value = annotation.computeConstantValue();
      return value?.type?.element?.name == 'MixWidget';
    });
  }

  String? _annotationOverrideName(Element element) {
    for (final annotation in element.metadata.annotations) {
      final value = annotation.computeConstantValue();
      if (value?.type?.element?.name != 'MixWidget') {
        continue;
      }

      return value?.getField('name')?.toStringValue();
    }

    return null;
  }

  String _resolvedGeneratedNameForElement(Element element) {
    final overrideName = _annotationOverrideName(element);
    if (overrideName != null) {
      return overrideName;
    }

    final elementName = element.name;
    if (elementName == null) {
      throw InvalidGenerationSource(
        '@MixWidget target must have a name.',
        element: element,
      );
    }

    return _deriveGeneratedName(elementName, element);
  }

  String _buildWidgetClass({
    required String generatedName,
    required _AnnotatedTarget target,
    required _MixWidgetConfig config,
    required _ResolvedBuilder? resolvedBuilder,
    required InterfaceType callReturnType,
    required _FactoryParameters factoryParameters,
    required List<_ParameterSpec> mirroredParameters,
  }) {
    final buffer = StringBuffer();
    final allParameters = [
      ...factoryParameters.publicParameters,
      ...mirroredParameters,
    ];
    final styleTypeName = target.stylerType.getDisplayString();

    buffer.writeln('class $generatedName extends StatelessWidget {');
    for (final parameter in allParameters) {
      buffer.writeln('  final ${parameter.typeCode} ${parameter.name};');
    }
    if (config.styleable) {
      buffer.writeln('  final $styleTypeName? style;');
    }
    buffer.writeln();

    final requiredPositional = allParameters.where(
      (p) => p.isRequiredPositional,
    );
    final optionalPositional = allParameters.where(
      (p) => p.isOptionalPositional,
    );
    final namedParameters = allParameters.where((p) => p.isNamed);

    buffer.write('  const $generatedName(');
    final constructorSections = <String>[];

    if (requiredPositional.isNotEmpty) {
      constructorSections.add(
        requiredPositional.map(_buildConstructorParameter).join(', '),
      );
    }

    if (optionalPositional.isNotEmpty) {
      constructorSections.add(
        '[${optionalPositional.map(_buildConstructorParameter).join(', ')}]',
      );
    }

    final namedParts = <String>['super.key'];
    namedParts.addAll(namedParameters.map(_buildConstructorParameter));
    if (config.styleable) {
      namedParts.add('this.style');
    }
    constructorSections.add('{${namedParts.join(', ')}}');
    buffer.write(constructorSections.join(', '));
    buffer.write(')');
    buffer.writeln(';');
    buffer.writeln();

    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context) {');
    final styleSource = target.factoryElement?.name ?? target.sourceName;
    final baseStyleExpression = target.factoryElement != null
        ? '$styleSource(${_buildInvocationArguments(factoryParameters)})'
        : styleSource;

    if (config.styleable) {
      buffer.writeln('    final baseStyle = $baseStyleExpression;');
      buffer.writeln('    final effectiveStyle = baseStyle.merge(style);');
    }
    final styleArgumentExpression = config.styleable
        ? 'effectiveStyle'
        : baseStyleExpression;

    final dispatch = resolvedBuilder == null
        ? _emitDirectWidgetCall(
            widgetElement: callReturnType.element as ClassElement,
            mirroredParameters: mirroredParameters,
            styleArgumentExpression: styleArgumentExpression,
          )
        : _emitBuilderCall(
            builderClassName: resolvedBuilder.className,
            mirroredParameters: mirroredParameters,
            styleArgumentExpression: styleArgumentExpression,
          );

    buffer.writeln('    return $dispatch;');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }

  String _emitBuilderCall({
    required String builderClassName,
    required List<_ParameterSpec> mirroredParameters,
    required String styleArgumentExpression,
  }) {
    final namedArgs = <String>['key: key'];
    for (final parameter in mirroredParameters) {
      namedArgs.add(
        '${parameter.name}: ${_buildParameterReference(parameter)}',
      );
    }
    return 'const $builderClassName().build($styleArgumentExpression, ${namedArgs.join(', ')})';
  }

  String _emitDirectWidgetCall({
    required ClassElement widgetElement,
    required List<_ParameterSpec> mirroredParameters,
    required String styleArgumentExpression,
  }) {
    final invocationArgs = _buildWidgetInvocationArguments(mirroredParameters);
    final sections = <String>[];
    if (invocationArgs.positional.isNotEmpty) {
      sections.add(invocationArgs.positional.join(', '));
    }
    sections.addAll(invocationArgs.named);
    sections.add('key: key');
    sections.add('style: $styleArgumentExpression');
    return '${widgetElement.name}(${sections.join(', ')})';
  }

  String _buildConstructorParameter(_ParameterSpec parameter) {
    final fieldReference = 'this.${parameter.name}';
    final defaultValue = parameter.defaultValueCode;

    if (parameter.isNamed) {
      if (parameter.isRequiredNamed) {
        return 'required $fieldReference';
      }

      if (defaultValue != null) {
        return '$fieldReference = $defaultValue';
      }

      return fieldReference;
    }

    if (parameter.isOptionalPositional && defaultValue != null) {
      return '$fieldReference = $defaultValue';
    }

    return fieldReference;
  }

  String _buildInvocationArguments(_FactoryParameters factoryParameters) {
    final sections = <String>[];
    if (factoryParameters.injectsBuildContext) {
      sections.add('context');
    }

    for (final parameter in factoryParameters.publicParameters) {
      if (parameter.isNamed) {
        continue;
      }

      sections.add(_buildParameterReference(parameter));
    }

    sections.addAll(
      factoryParameters.publicParameters
          .where((p) => p.isNamed)
          .map(
            (parameter) =>
                '${parameter.name}: ${_buildParameterReference(parameter)}',
          ),
    );

    return sections.join(', ');
  }

  _InvocationArguments _buildWidgetInvocationArguments(
    List<_ParameterSpec> parameters,
  ) {
    return _InvocationArguments(
      positional: [
        for (final parameter in parameters)
          if (!parameter.isNamed) _buildParameterReference(parameter),
      ],
      named: [
        for (final parameter in parameters)
          if (parameter.isNamed)
            '${parameter.name}: ${_buildParameterReference(parameter)}',
      ],
    );
  }

  String _buildParameterReference(_ParameterSpec parameter) {
    return parameter.name == 'context' ? 'this.context' : parameter.name;
  }
}

Iterable<String> _collectElementNames(Iterable<Element> elements) sync* {
  for (final element in elements) {
    final name = element.name;
    if (name != null) {
      yield name;
    }
  }
}

class _MixWidgetConfig {
  final String? name;
  final bool styleable;

  const _MixWidgetConfig({required this.name, required this.styleable});
}

class _AnnotatedTarget {
  final String sourceName;
  final InterfaceType stylerType;
  final DartType specType;
  final TopLevelFunctionElement? factoryElement;

  const _AnnotatedTarget({
    required this.sourceName,
    required this.stylerType,
    required this.specType,
    required this.factoryElement,
  });
}

class _CallSignature {
  final InterfaceType returnType;
  final List<_ParameterSpec> parameters;

  const _CallSignature({required this.returnType, required this.parameters});
}

class _FactoryParameters {
  final List<_ParameterSpec> publicParameters;
  final bool injectsBuildContext;

  const _FactoryParameters({
    required this.publicParameters,
    required this.injectsBuildContext,
  });
}

class _ResolvedBuilder {
  final String className;

  const _ResolvedBuilder({required this.className});
}

class _ParameterSpec {
  final String name;
  final DartType type;
  final String typeCode;
  final bool isNamed;
  final bool isRequiredNamed;
  final bool isRequiredPositional;
  final bool isOptionalPositional;
  final String? defaultValueCode;

  _ParameterSpec({
    required this.name,
    required this.type,
    required this.typeCode,
    required this.isNamed,
    required this.isRequiredNamed,
    required this.isRequiredPositional,
    required this.isOptionalPositional,
    required this.defaultValueCode,
  });

  factory _ParameterSpec.fromParameter(FormalParameterElement parameter) {
    return _ParameterSpec(
      name: parameter.name!,
      type: parameter.type,
      typeCode: parameter.type.getDisplayString(),
      isNamed: parameter.isNamed,
      isRequiredNamed: parameter.isRequiredNamed,
      isRequiredPositional: parameter.isRequiredPositional,
      isOptionalPositional: parameter.isOptionalPositional,
      defaultValueCode: parameter.defaultValueCode,
    );
  }
}

class _InvocationArguments {
  final List<String> positional;
  final List<String> named;

  const _InvocationArguments({required this.positional, required this.named});
}
