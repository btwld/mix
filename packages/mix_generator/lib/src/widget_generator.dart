/// Generator for Mix widget wrappers.
library;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/registry/mix_widget_descriptor_registry.dart';

const _reservedParameterNames = {'key', 'style', 'styleSpec'};

class MixWidgetGenerator extends GeneratorForAnnotation<MixWidget> {
  const MixWidgetGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final config = _parseAnnotationConfig(annotation, element);
    final target = _extractAnnotatedTarget(element);
    final descriptor = _resolveDescriptor(target, config, element);
    final generatedName =
        config.name ?? _deriveGeneratedName(target.sourceName, element);

    final inputLibrary = await buildStep.inputLibrary;
    _validateGeneratedName(
      library: inputLibrary,
      currentElement: element,
      generatedName: generatedName,
    );

    final widgetElement = await _resolveWidgetElement(
      descriptor: descriptor,
      buildStep: buildStep,
      element: element,
    );
    final callSignature = _extractCallSignature(
      stylerType: target.stylerType,
      element: element,
    );
    _validateWidgetCompatibility(
      widgetElement: widgetElement,
      config: config,
      mirroredParameters: callSignature.parameters,
      callReturnType: callSignature.returnType,
      hasExplicitWidgetBuilder: config.widgetBuilderKind != null,
      element: element,
    );
    final factoryParameters = _extractFactoryParameters(target.factoryElement);

    _validateParameterCollisions(
      factoryParameters: factoryParameters,
      mirroredParameters: callSignature.parameters,
      element: element,
    );

    return _buildWidgetClass(
      generatedName: generatedName,
      target: target,
      config: config,
      widgetElement: widgetElement,
      factoryParameters: factoryParameters,
      mirroredParameters: callSignature.parameters,
    );
  }

  _MixWidgetConfig _parseAnnotationConfig(
    ConstantReader annotation,
    Element element,
  ) {
    final styleable = annotation.peek('styleable')?.boolValue ?? false;
    final name = annotation.peek('name')?.stringValue;
    final widgetBuilder = _extractWidgetBuilderKind(annotation);

    return _MixWidgetConfig(
      name: name,
      styleable: styleable,
      widgetBuilderKind: widgetBuilder,
    );
  }

  MixWidgetBuilderKind? _extractWidgetBuilderKind(ConstantReader annotation) {
    final widgetBuilderReader = annotation.peek('widgetBuilder');
    if (widgetBuilderReader == null || widgetBuilderReader.isNull) {
      return null;
    }

    final kindObject = widgetBuilderReader.objectValue.getField('kind');
    if (kindObject == null) {
      return null;
    }

    final accessor = ConstantReader(kindObject).revive().accessor;
    final kindName = accessor.split('.').last;

    return MixWidgetBuilderKind.values.byName(kindName);
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

  MixWidgetDescriptor _resolveDescriptor(
    _AnnotatedTarget target,
    _MixWidgetConfig config,
    Element element,
  ) {
    if (config.widgetBuilderKind case final kind?) {
      final descriptor = mixWidgetDescriptorRegistry.descriptorForKind(kind);
      if (descriptor == null) {
        throw InvalidGenerationSource(
          'Unsupported MixWidgetBuilder kind: $kind.',
          element: element,
        );
      }

      final specChecker = TypeChecker.fromUrl(descriptor.specTypeUrl);
      if (!specChecker.isExactlyType(target.specType)) {
        throw InvalidGenerationSource(
          'MixWidgetBuilder.${kind.name} is not compatible with ${target.specType.getDisplayString()}.',
          element: element,
        );
      }

      return descriptor;
    }

    for (final descriptor in mixWidgetDescriptorRegistry.defaultDescriptors) {
      final matchesStyler = descriptor.allowedStylerTypeUrls.any((url) {
        return TypeChecker.fromUrl(url).isAssignableFromType(target.stylerType);
      });
      if (matchesStyler) {
        return descriptor;
      }
    }

    throw InvalidGenerationSource(
      'No Mix widget mapping found for ${target.stylerType.getDisplayString()}. '
      'Provide an explicit widgetBuilder override.',
      element: element,
    );
  }

  Future<ClassElement> _resolveWidgetElement({
    required MixWidgetDescriptor descriptor,
    required BuildStep buildStep,
    required Element element,
  }) async {
    final widgetLibraryUri = descriptor.widgetTypeUrl.split('#').first;
    final widgetAssetId = AssetId.resolve(Uri.parse(widgetLibraryUri));
    final widgetLibrary = await buildStep.resolver.libraryFor(widgetAssetId);
    final widgetElement = widgetLibrary.getClass(descriptor.widgetTypeName);

    if (widgetElement == null) {
      throw InvalidGenerationSource(
        'Could not resolve widget type ${descriptor.widgetTypeName}.',
        element: element,
      );
    }

    return widgetElement;
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

  void _validateWidgetCompatibility({
    required ClassElement widgetElement,
    required _MixWidgetConfig config,
    required List<_ParameterSpec> mirroredParameters,
    required InterfaceType callReturnType,
    required bool hasExplicitWidgetBuilder,
    required Element element,
  }) {
    final typeSystem = widgetElement.library.typeSystem;
    final constructor = widgetElement.unnamedConstructor;
    if (constructor == null) {
      throw InvalidGenerationSource(
        '${widgetElement.name} must expose an unnamed constructor for @MixWidget.',
        element: element,
      );
    }

    final constructorParameters = constructor.formalParameters;
    final constructorNames = constructorParameters
        .map((parameter) => parameter.name)
        .nonNulls
        .toSet();

    if (!constructorNames.contains('key')) {
      throw InvalidGenerationSource(
        '${widgetElement.name} must expose a `key` constructor parameter for @MixWidget.',
        element: element,
      );
    }

    if (!constructorNames.contains('style')) {
      throw InvalidGenerationSource(
        '${widgetElement.name} must expose a `style` constructor parameter for @MixWidget.',
        element: element,
      );
    }

    if (!hasExplicitWidgetBuilder &&
        !_isSameType(typeSystem, callReturnType, widgetElement.thisType)) {
      throw InvalidGenerationSource(
        '${widgetElement.name} mapping drifted from ${callReturnType.element.name}. '
        'Use an explicit widgetBuilder override or update the descriptor mapping.',
        element: element,
      );
    }

    final constructorParametersByName = <String, FormalParameterElement>{
      for (final parameter in constructorParameters)
        if (parameter.name != null) parameter.name!: parameter,
    };
    final constructorPositionalParameters = [
      for (final parameter in constructorParameters)
        if (!parameter.isNamed) parameter,
    ];
    final mirroredNamedParameters = [
      for (final parameter in mirroredParameters)
        if (parameter.isNamed) parameter,
    ];
    final mirroredPositionalParameters = [
      for (final parameter in mirroredParameters)
        if (!parameter.isNamed) parameter,
    ];

    for (var index = 0; index < mirroredPositionalParameters.length; index++) {
      final mirroredParameter = mirroredPositionalParameters[index];
      if (index >= constructorPositionalParameters.length) {
        final conflictingParameter = constructorParametersByName[mirroredParameter.name];
        if (conflictingParameter != null && conflictingParameter.isNamed) {
          throw InvalidGenerationSource(
            'Parameter `${mirroredParameter.name}` is positional in ${callReturnType.element.name}.call() but named in ${widgetElement.name}.',
            element: element,
          );
        }

        throw InvalidGenerationSource(
          'Parameter `${mirroredParameter.name}` from ${callReturnType.element.name}.call() is missing from ${widgetElement.name}.',
          element: element,
        );
      }

      final constructorParameter = constructorPositionalParameters[index];
      if (!_isAssignable(
        typeSystem,
        mirroredParameter.type,
        constructorParameter.type,
      )) {
        throw InvalidGenerationSource(
          'Parameter `${mirroredParameter.name}` from ${callReturnType.element.name}.call() is not compatible with ${widgetElement.name}.${constructorParameter.name}.',
          element: element,
        );
      }
    }

    for (var index = mirroredPositionalParameters.length;
        index < constructorPositionalParameters.length;
        index++) {
      final constructorParameter = constructorPositionalParameters[index];
      if (constructorParameter.isRequiredPositional) {
        throw InvalidGenerationSource(
          '${widgetElement.name} requires constructor parameter `${constructorParameter.name}` that is not exposed by ${callReturnType.element.name}.call().',
          element: element,
        );
      }
    }

    for (final mirroredParameter in mirroredNamedParameters) {
      final constructorParameter = constructorParametersByName[mirroredParameter.name];
      if (constructorParameter == null) {
        throw InvalidGenerationSource(
          'Parameter `${mirroredParameter.name}` from ${callReturnType.element.name}.call() is missing from ${widgetElement.name}.',
          element: element,
        );
      }

      if (!constructorParameter.isNamed) {
        throw InvalidGenerationSource(
          'Parameter `${mirroredParameter.name}` is named in ${callReturnType.element.name}.call() but positional in ${widgetElement.name}.',
          element: element,
        );
      }

      if (!_isAssignable(
        typeSystem,
        mirroredParameter.type,
        constructorParameter.type,
      )) {
        throw InvalidGenerationSource(
          'Parameter `${mirroredParameter.name}` from ${callReturnType.element.name}.call() is not compatible with ${widgetElement.name}.${constructorParameter.name}.',
          element: element,
        );
      }
    }

    for (final constructorParameter in constructorParameters) {
      final name = constructorParameter.name;
      if (name == null || _reservedParameterNames.contains(name)) {
        continue;
      }

      final isMirrored = mirroredParameters.any((parameter) => parameter.name == name);
      if (!isMirrored && constructorParameter.isRequiredNamed) {
        throw InvalidGenerationSource(
          '${widgetElement.name} requires constructor parameter `$name` that is not exposed by ${callReturnType.element.name}.call().',
          element: element,
        );
      }
    }
  }

  bool _isSameType(
    TypeSystem typeSystem,
    DartType leftType,
    DartType rightType,
  ) {
    return typeSystem.isSubtypeOf(leftType, rightType) &&
        typeSystem.isSubtypeOf(rightType, leftType);
  }

  bool _isAssignable(TypeSystem typeSystem, DartType fromType, DartType toType) {
    return typeSystem.isAssignableTo(fromType, toType);
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

  void _validateParameterCollisions({
    required List<_ParameterSpec> factoryParameters,
    required List<_ParameterSpec> mirroredParameters,
    required Element element,
  }) {
    final seenNames = <String>{};

    for (final parameter in [...factoryParameters, ...mirroredParameters]) {
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
    required ClassElement widgetElement,
    required List<_ParameterSpec> factoryParameters,
    required List<_ParameterSpec> mirroredParameters,
  }) {
    final buffer = StringBuffer();
    final allParameters = [...factoryParameters, ...mirroredParameters];
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
    final invocationArgs = _buildWidgetInvocationArguments(mirroredParameters);
    final extraNamedArguments = <String>[
      'key: key',
      'style: $styleArgumentExpression',
    ];
    final widgetInvocationSections = <String>[];
    if (invocationArgs.positional.isNotEmpty) {
      widgetInvocationSections.add(invocationArgs.positional.join(', '));
    }
    widgetInvocationSections.addAll(invocationArgs.named);
    widgetInvocationSections.addAll(extraNamedArguments);
    buffer.writeln(
      '    return ${widgetElement.name}(${widgetInvocationSections.join(', ')});',
    );
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
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

  String _buildInvocationArguments(List<_ParameterSpec> parameters) {
    final sections = <String>[];
    sections.addAll(
      parameters.where((p) => !p.isNamed).map((parameter) => parameter.name),
    );
    sections.addAll(
      parameters
          .where((p) => p.isNamed)
          .map((parameter) => '${parameter.name}: ${parameter.name}'),
    );

    return sections.join(', ');
  }

  _InvocationArguments _buildWidgetInvocationArguments(
    List<_ParameterSpec> parameters,
  ) {
    return _InvocationArguments(
      positional: [
        for (final parameter in parameters)
          if (!parameter.isNamed) parameter.name,
      ],
      named: [
        for (final parameter in parameters)
          if (parameter.isNamed) '${parameter.name}: ${parameter.name}',
      ],
    );
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
  final MixWidgetBuilderKind? widgetBuilderKind;

  const _MixWidgetConfig({
    required this.name,
    required this.styleable,
    required this.widgetBuilderKind,
  });
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
