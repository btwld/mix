/// Generator for Mix widget wrappers.
///
/// `@MixWidget` applies to a top-level `final` styler declaration or a
/// top-level factory function returning a styler. The generator:
///
/// 1. Reads the `name` override from the annotation.
/// 2. Resolves the target styler type and its spec type.
/// 3. Resolves the styler's `call()` method and mirrors its public
///    parameters onto the generated wrapper.
/// 4. Emits a direct `style.call(...)` invocation.
///
/// The pipeline is split across four modules:
///
///   * `core/models/widget_target.dart` — data types carried between phases.
///   * `core/resolvers/widget_builder_resolver.dart` — styler call lookup and
///     parameter validation.
///   * `core/builders/widget_class_builder.dart` — `code_builder`-driven
///     emission of the generated class.
///   * `core/errors.dart` + `core/checkers.dart` — shared primitives.
library;

import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/widget_class_builder.dart';
import 'core/checkers.dart';
import 'core/errors.dart';
import 'core/helpers/type_hierarchy.dart';
import 'core/models/widget_target.dart';
import 'core/resolvers/widget_builder_resolver.dart';

const _reservedParameterNames = {'key', 'build'};
const _mixAnnotationsPackagePrefix = 'package:mix_annotations/';

class MixWidgetGenerator extends GeneratorForAnnotation<MixWidget> {
  const MixWidgetGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (!_isMixWidgetObject(annotation.objectValue)) {
      return '';
    }

    final nameOverride = _parseGeneratedNameOverride(annotation);
    final target = _extractAnnotatedTarget(element);
    final generatedName =
        nameOverride ?? _deriveGeneratedName(target.sourceName, element);

    final inputLibrary = await buildStep.inputLibrary;
    _validateGeneratedName(
      library: inputLibrary,
      currentElement: element,
      generatedName: generatedName,
    );

    final resolvedCall = resolveStylerCall(target: target, element: element);

    final factoryParameters = _resolveFactoryParameters(
      _extractFactoryParameters(target.factoryElement, inputLibrary),
      element,
    );

    _validateParameterCollisions(
      factoryParameters: factoryParameters,
      widgetParameters: resolvedCall.parameters,
      element: element,
    );

    return buildWidgetClass(
      generatedName: generatedName,
      target: target,
      resolvedCall: resolvedCall,
      factoryParameters: factoryParameters,
    );
  }

  /// Overrides the default `TypeChecker.fromRuntime(MixWidget)` with the
  /// URL-based [mixWidgetAnnotationChecker] so the generator still discovers
  /// `@MixWidget` annotations when the annotation package is loaded via
  /// `build_test` stubs (whose runtime types don't match the package's own).
  @override
  TypeChecker get typeChecker => mixWidgetAnnotationChecker;
}

// ─── Annotation parsing ─────────────────────────────────────────────────

String? _parseGeneratedNameOverride(ConstantReader annotation) =>
    annotation.peek('name')?.stringValue;

/// Matches `MixWidget` annotation objects originating from
/// `package:mix_annotations`, whether the `TypeChecker.fromUrl` canonical
/// URL matches or the annotation is declared via a stub library (e.g. in
/// generator tests using `build_test`). Rejects same-named classes from
/// unrelated libraries (see the "ignores same-named non-MixWidget
/// annotations" integration test).
bool _isMixWidgetObject(DartObject value) {
  final type = value.type;
  if (type == null) {
    return false;
  }

  if (mixWidgetAnnotationChecker.isExactlyType(type)) {
    return true;
  }

  final element = type.element;
  final libraryUri = element?.library?.uri.toString();

  return element?.name == 'MixWidget' &&
      libraryUri != null &&
      libraryUri.startsWith(_mixAnnotationsPackagePrefix);
}

/// Single-pass reader: returns whether [element] carries a `@MixWidget`
/// annotation and the `name` override, if any, without re-iterating
/// metadata or recomputing the constant value.
({bool hasAnnotation, String? overrideName}) _readMixWidgetAnnotation(
  Element element,
) {
  for (final annotation in element.metadata.annotations) {
    final value = annotation.computeConstantValue();
    if (value == null || !_isMixWidgetObject(value)) {
      continue;
    }

    return (
      hasAnnotation: true,
      overrideName: value.getField('name')?.toStringValue(),
    );
  }

  return (hasAnnotation: false, overrideName: null);
}

// ─── Target extraction ──────────────────────────────────────────────────

AnnotatedTarget _extractAnnotatedTarget(Element element) {
  if (element is TopLevelVariableElement) {
    _validateTopLevelElement(element);
    if (!element.isFinal) {
      fail(
        element,
        '@MixWidget only supports top-level final variables.',
        todo: 'Change `var` to `final`.',
      );
    }

    final sourceName = _requireName(element);
    final stylerType = _extractStylerType(element.type, element);

    return AnnotatedTarget(
      sourceName: sourceName,
      stylerType: stylerType,
      specType: _extractSpecType(stylerType, element),
      factoryElement: null,
    );
  }

  if (element is TopLevelFunctionElement) {
    _validateTopLevelElement(element);
    if (element.typeParameters.isNotEmpty) {
      fail(
        element,
        '@MixWidget does not support generic style factories.',
        todo:
            'Move the generic value into a concrete named parameter or '
            'create a non-generic factory.',
      );
    }
    final sourceName = _requireName(element);
    final stylerType = _extractStylerType(element.returnType, element);

    return AnnotatedTarget(
      sourceName: sourceName,
      stylerType: stylerType,
      specType: _extractSpecType(stylerType, element),
      factoryElement: element,
    );
  }

  fail(
    element,
    '@MixWidget only supports top-level final variables and top-level '
    'functions.',
  );
}

void _validateTopLevelElement(Element element) {
  if (element.enclosingElement is! LibraryElement) {
    fail(element, '@MixWidget only supports top-level declarations.');
  }
}

String _requireName(Element element) {
  final name = element.name;
  if (name == null) {
    fail(element, '@MixWidget target must have a name.');
  }

  if (name.startsWith('_')) {
    fail(
      element,
      '@MixWidget does not support private declarations.',
      todo: 'Remove the leading underscore from the declaration name.',
    );
  }

  return name;
}

InterfaceType _extractStylerType(DartType type, Element element) {
  if (type is! InterfaceType) {
    fail(element, '@MixWidget requires a concrete Mix styler type.');
  }

  if (type.nullabilitySuffix == .question) {
    fail(
      element,
      '@MixWidget does not support nullable styler types.',
      todo: 'Remove the `?` from the declared type.',
    );
  }

  final styleType = _findStyleSupertype(type);
  if (styleType == null) {
    fail(
      element,
      '@MixWidget can only be applied to declarations returning a Style<T> '
      'subtype.',
      todo:
          'Return a concrete Mix styler such as BoxStyler(), TextStyler(), '
          'or FlexBoxStyler().',
    );
  }

  if (styleChecker.isExactlyType(type)) {
    fail(
      element,
      '@MixWidget requires a concrete styler type with a callable `call()` '
      'method.',
      todo:
          'Declare the target as a concrete styler such as BoxStyler instead '
          'of Style<T>.',
    );
  }

  return type;
}

InterfaceType? _findStyleSupertype(InterfaceType type) {
  return findSupertypeMatching(type, styleChecker);
}

DartType _extractSpecType(InterfaceType stylerType, Element element) {
  final styleType = _findStyleSupertype(stylerType);
  if (styleType != null && styleType.typeArguments.isNotEmpty) {
    final specType = styleType.typeArguments.first;
    if (specType is InterfaceType && specType.nullabilitySuffix != .question) {
      return specType;
    }
  }

  fail(element, 'Could not determine the Style<T> spec type for @MixWidget.');
}

// ─── Factory parameter resolution ───────────────────────────────────────

List<ParameterSpec> _extractFactoryParameters(
  TopLevelFunctionElement? factoryElement,
  LibraryElement library,
) {
  if (factoryElement == null) {
    return const [];
  }

  return factoryElement.formalParameters
      .map(
        (parameter) =>
            ParameterSpec.fromParameter(parameter, visibleFrom: library),
      )
      .toList();
}

FactoryParameters _resolveFactoryParameters(
  List<ParameterSpec> factoryParameters,
  Element element,
) {
  if (factoryParameters.isEmpty) {
    return .empty;
  }

  final publicParameters = <ParameterSpec>[];
  var injectsBuildContext = false;

  for (var index = 0; index < factoryParameters.length; index++) {
    final parameter = factoryParameters[index];
    final isFlutterBuildContext = flutterBuildContextChecker.isExactlyType(
      parameter.type,
    );
    final isNamedBuildContext =
        parameter.type is InterfaceType &&
        (parameter.type as InterfaceType).element.name == 'BuildContext';

    if (parameter.isOptionalPositional &&
        !isFlutterBuildContext &&
        !isNamedBuildContext) {
      fail(
        element,
        '@MixWidget factory parameter `${parameter.name}` is optional '
        'positional. Use a required positional or named parameter instead.',
        todo:
            'Make the parameter named (and `required` if needed) or '
            'required positional.',
      );
    }

    if (index == 0 &&
        parameter.name == 'context' &&
        parameter.isRequiredPositional &&
        isFlutterBuildContext) {
      injectsBuildContext = true;
      continue;
    }

    if (isFlutterBuildContext && index == 0) {
      fail(
        element,
        '@MixWidget can inject only a first required positional BuildContext '
        'parameter named `context`.',
      );
    }

    if (isFlutterBuildContext) {
      fail(
        element,
        '@MixWidget does not expose BuildContext factory parameters. Use a '
        'first required positional `BuildContext context` parameter.',
      );
    }

    if (isNamedBuildContext) {
      fail(
        element,
        '@MixWidget BuildContext injection requires Flutter BuildContext '
        'from package:flutter/widgets.dart.',
      );
    }

    publicParameters.add(parameter);
  }

  return FactoryParameters(
    publicParameters: publicParameters,
    injectsBuildContext: injectsBuildContext,
  );
}

void _validateParameterCollisions({
  required FactoryParameters factoryParameters,
  required List<ParameterSpec> widgetParameters,
  required Element element,
}) {
  if (factoryParameters.injectsBuildContext &&
      widgetParameters.any((parameter) => parameter.name == 'context')) {
    fail(
      element,
      'Parameter `context` conflicts with the injected BuildContext used by '
      '@MixWidget.',
    );
  }

  final seenNames = <String>{};

  for (final parameter in [
    ...factoryParameters.publicParameters,
    ...widgetParameters,
  ]) {
    if (parameter.name.startsWith('_')) {
      fail(
        element,
        'Parameter `${parameter.name}` cannot be private in a generated '
        '@MixWidget wrapper.',
      );
    }

    if (_reservedParameterNames.contains(parameter.name)) {
      fail(element, 'Parameter `${parameter.name}` is reserved by @MixWidget.');
    }

    if (!seenNames.add(parameter.name)) {
      fail(
        element,
        'Duplicate generated parameter `${parameter.name}` detected for '
        '@MixWidget.',
      );
    }
  }
}

// ─── Generated-name derivation & validation ─────────────────────────────

String _deriveGeneratedName(String sourceName, Element element) {
  var baseName = sourceName;
  if (baseName.endsWith('Styler')) {
    baseName = baseName.substring(0, baseName.length - 'Styler'.length);
  } else if (baseName.endsWith('Style')) {
    baseName = baseName.substring(0, baseName.length - 'Style'.length);
  }

  if (baseName.isEmpty) {
    fail(
      element,
      '@MixWidget could not derive a widget name from `$sourceName`.',
    );
  }

  return baseName
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join();
}

/// Matches a public Dart class identifier: upper-case letter followed by
/// any word characters. Enforces that `@MixWidget(name:)` overrides produce
/// syntactically valid class names (rejecting e.g. `'123 Card'`, `'my-card'`,
/// `'myCard'`).
final _classIdentifier = RegExp(r'^[A-Z][A-Za-z0-9_]*$');

void _validateGeneratedName({
  required LibraryElement library,
  required Element currentElement,
  required String generatedName,
}) {
  if (generatedName.isEmpty) {
    fail(
      currentElement,
      '@MixWidget requires a non-empty generated class name.',
    );
  }

  if (generatedName.startsWith('_')) {
    fail(currentElement, '@MixWidget requires a public generated class name.');
  }

  if (!_classIdentifier.hasMatch(generatedName)) {
    fail(
      currentElement,
      'Generated widget name `$generatedName` is not a valid Dart class '
      'identifier. Use UpperCamelCase letters, digits, and underscores only.',
    );
  }

  final existingNames = {
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
    fail(
      currentElement,
      'Generated widget name `$generatedName` conflicts with an existing '
      'declaration.',
    );
  }

  final generatedNames = <String>[];
  for (final element in [
    ...library.topLevelVariables,
    ...library.topLevelFunctions,
  ]) {
    final info = _readMixWidgetAnnotation(element);
    if (!info.hasAnnotation) {
      continue;
    }

    final elementName = element.name;
    if (elementName == null) {
      fail(element, '@MixWidget target must have a name.');
    }

    generatedNames.add(
      info.overrideName ?? _deriveGeneratedName(elementName, element),
    );
  }

  final collisions = generatedNames.where((name) => name == generatedName);
  if (collisions.length > 1) {
    fail(
      currentElement,
      'Generated widget name `$generatedName` is duplicated in this library.',
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
