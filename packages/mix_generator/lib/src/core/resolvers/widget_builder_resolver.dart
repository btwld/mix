/// Resolves which `MixWidgetBuilder` subclass a `@MixWidget` target
/// dispatches through.
///
/// Two resolution paths:
///   1. If the annotation provides `widgetBuilder: CustomBuilder()`, the
///      expression is validated (unprefixed, unnamed, zero-arg const
///      constructor), its type is validated as a `MixWidgetBuilder<TSpec>`
///      subtype from a library outside `package:mix`, and its `TSpec` is
///      confirmed to match the target's spec. On success the class name is
///      returned.
///   2. Otherwise, if the target's spec is declared in `package:mix` and
///      has an entry in [defaultBuildersBySpec], the default Mix built-in
///      is used.
///
/// Targets whose spec is not Mix-owned and have no explicit
/// `widgetBuilder` fall through to direct-widget emission (represented as
/// [ResolvedBuilder.direct]).
library;

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

import '../checkers.dart';
import '../errors.dart';
import '../models/widget_target.dart';

final _log = Logger('mix_generator.widget_builder');

const _mixPackageUriPrefix = 'package:mix/';

const _customBuilderShapeMessage =
    '`widgetBuilder` must be an unprefixed zero-argument unnamed const '
    'constructor call for a custom MixWidgetBuilder subclass, such as '
    'GlassCardBuilder().';

const _builtInBuilderMessage =
    'Built-in Mix widget builders are inferred automatically. `widgetBuilder` '
    'is only for custom MixWidgetBuilder subclasses.';

/// Names of Mix-owned spec types mapped to their default built-in builder
/// class names.
///
/// Keep `RowBoxBuilder` / `ColumnBoxBuilder` out — both map to
/// `FlexBoxSpec` and the default resolves to `FlexBoxBuilder`.
const defaultBuildersBySpec = {
  'BoxSpec': 'BoxBuilder',
  'FlexBoxSpec': 'FlexBoxBuilder',
  'TextSpec': 'StyledTextBuilder',
  'IconSpec': 'StyledIconBuilder',
  'ImageSpec': 'StyledImageBuilder',
  'StackBoxSpec': 'StackBoxBuilder',
};

/// Resolves the dispatch strategy for [target] using the `@MixWidget`
/// [annotation].
///
/// Validates custom builders, infers Mix-owned defaults, or falls back to
/// [ResolvedBuilder.direct] when no builder applies.
ResolvedBuilder resolveWidgetBuilder({
  required ConstantReader annotation,
  required AnnotatedTarget target,
  required Element element,
}) {
  final explicit = _extractExplicitBuilder(
    annotation: annotation,
    element: element,
  );
  if (explicit != null) {
    _validateCustomBuilderType(
      builderType: explicit.type,
      targetSpec: target.specType,
      element: element,
    );
    _log.info(
      '${target.sourceName}: using custom widgetBuilder '
      '${explicit.className}.',
    );

    return ResolvedBuilder.named(explicit.className);
  }

  final defaultName = _resolveDefaultBuilder(target.specType);
  if (defaultName != null) {
    _log.info(
      '${target.sourceName}: inferred $defaultName for '
      '${target.specType.getDisplayString()}.',
    );

    return ResolvedBuilder.named(defaultName);
  }

  _log.info(
    '${target.sourceName}: no builder inferred; falling back to direct '
    'widget emission.',
  );

  return const ResolvedBuilder.direct();
}

String? _resolveDefaultBuilder(DartType specType) {
  if (specType is! InterfaceType || !_isFromMixPackage(specType.element)) {
    return null;
  }

  return defaultBuildersBySpec[specType.element.name];
}

bool _isFromMixPackage(InterfaceElement element) {
  return element.library.uri.toString().startsWith(_mixPackageUriPrefix);
}

/// A `widgetBuilder:` value the user supplied, after shape and type checks.
class _ExplicitBuilder {
  final InterfaceType type;
  final String className;

  const _ExplicitBuilder({required this.type, required this.className});
}

_ExplicitBuilder? _extractExplicitBuilder({
  required ConstantReader annotation,
  required Element element,
}) {
  final reader = annotation.peek('widgetBuilder');
  if (reader == null || reader.isNull) {
    return null;
  }

  final expression = _extractExplicitBuilderExpression(element);
  if (!_isSupportedExplicitBuilderExpression(expression)) {
    fail(element, _customBuilderShapeMessage);
  }

  final type = reader.objectValue.type;
  if (type is! InterfaceType) {
    fail(element, _customBuilderShapeMessage);
  }

  final className = type.element.name;
  if (className == null) {
    fail(element, _customBuilderShapeMessage);
  }

  return _ExplicitBuilder(type: type, className: className);
}

void _validateCustomBuilderType({
  required InterfaceType builderType,
  required DartType targetSpec,
  required Element element,
}) {
  final builderElement = builderType.element;
  if (_isFromMixPackage(builderElement)) {
    fail(element, _builtInBuilderMessage);
  }

  final constructor = builderElement.unnamedConstructor;
  if (constructor == null ||
      !constructor.isConst ||
      constructor.formalParameters.isNotEmpty) {
    fail(element, _customBuilderShapeMessage);
  }

  final builderName = builderElement.name ?? builderType.getDisplayString();
  final mixBuilderType = _findSupertype(builderType, mixWidgetBuilderChecker);
  if (mixBuilderType == null) {
    fail(
      element,
      '`widgetBuilder` must extend package:mix\'s MixWidgetBuilder<TSpec>. '
      'Got ${builderType.getDisplayString()}.',
    );
  }

  if (mixBuilderType.typeArguments.isEmpty) {
    fail(
      element,
      '`widgetBuilder` type `$builderName` must bind a spec type parameter.',
    );
  }

  final builderSpec = mixBuilderType.typeArguments.first;
  if (builderSpec is! InterfaceType || targetSpec is! InterfaceType) {
    fail(
      element,
      '`widgetBuilder` spec could not be resolved for $builderName.',
    );
  }

  if (!_isSameSpec(builderSpec, targetSpec, element.library!)) {
    fail(
      element,
      '`widgetBuilder` $builderName targets '
      '${builderSpec.getDisplayString()} but the styler produces '
      '${targetSpec.getDisplayString()}.',
    );
  }
}

/// Walks the class-extension chain (not `implements`/`with`) so that callers
/// can enforce the difference between `extends` and structural conformance
/// — callers reject builders that merely implement `MixWidgetBuilder`.
InterfaceType? _findSupertype(InterfaceType type, TypeChecker checker) {
  InterfaceType? current = type;
  while (current != null) {
    if (checker.isExactlyType(current)) {
      return current;
    }

    current = current.superclass;
  }

  return null;
}

bool _isSameSpec(DartType left, DartType right, LibraryElement library) {
  final typeSystem = library.typeSystem;

  return typeSystem.isAssignableTo(left, right, strictCasts: false) &&
      typeSystem.isAssignableTo(right, left, strictCasts: false);
}

/// Locates the `widgetBuilder:` argument expression in the annotation's AST.
///
/// `ConstantReader` exposes the constant value but not the raw AST. Re-parse
/// the annotation's source text to extract the named argument expression so
/// shape checks (`_isSupportedExplicitBuilderExpression`) can run.
Expression _extractExplicitBuilderExpression(Element element) {
  for (final annotation in element.metadata.annotations) {
    final value = annotation.computeConstantValue();
    if (value == null) {
      continue;
    }

    final type = value.type;
    if (type == null || !mixWidgetAnnotationChecker.isExactlyType(type)) {
      continue;
    }

    final expression = _tryExtractExplicitBuilderExpression(
      annotation.toSource(),
    );
    if (expression != null) {
      return expression;
    }
  }

  fail(element, 'Could not inspect the `widgetBuilder` annotation argument.');
}

Expression? _tryExtractExplicitBuilderExpression(String annotationSource) {
  if (!annotationSource.contains('MixWidget')) {
    return null;
  }

  final result = parseString(
    content: '$annotationSource\nclass _MixWidgetAnnotationTarget {}',
  );
  final declaration = result.unit.declarations.first;
  final parsedAnnotation = declaration.metadata.first;
  final arguments = parsedAnnotation.arguments?.arguments ?? const [];

  for (final argument in arguments) {
    if (argument is NamedExpression &&
        argument.name.label.name == 'widgetBuilder') {
      return argument.expression;
    }
  }

  return null;
}

bool _isSupportedExplicitBuilderExpression(Expression expression) {
  if (expression is InstanceCreationExpression) {
    final constructorName = expression.constructorName;
    final typeName = constructorName.type;

    return typeName.importPrefix == null &&
        constructorName.name == null &&
        constructorName.period == null &&
        typeName.typeArguments == null &&
        expression.argumentList.arguments.isEmpty;
  }

  if (expression is MethodInvocation) {
    return expression.target == null &&
        expression.operator == null &&
        expression.typeArguments == null &&
        expression.argumentList.arguments.isEmpty;
  }

  return false;
}

/// Reads the `MixWidgetBuilder.build()` method's named parameter types from
/// `package:mix`, keyed by parameter name. Used by the caller to assert that
/// every `call()` parameter forwarded to a builder is assignable to its
/// counterpart on `build()`.
Future<Map<String, DartType>> resolveBuilderBuildParameterTypes(
  Element element,
) async {
  const reservedNames = {'key', 'style', 'styleSpec'};
  final result = await element.library!.session.getLibraryByUri(
    'package:mix/src/core/widget_builder.dart',
  );
  if (result is! LibraryElementResult) {
    fail(
      element,
      'Could not resolve package:mix\'s MixWidgetBuilder.build() signature.',
    );
  }

  final builderElement = result.element.exportNamespace.get2(
    'MixWidgetBuilder',
  );
  if (builderElement is! InterfaceElement) {
    fail(
      element,
      'Could not resolve package:mix\'s MixWidgetBuilder.build() signature.',
    );
  }

  final buildMethod = builderElement.getMethod('build');
  if (buildMethod == null) {
    fail(
      element,
      'Could not resolve package:mix\'s MixWidgetBuilder.build() signature.',
    );
  }

  return {
    for (final parameter in buildMethod.formalParameters)
      if (parameter.isNamed && !reservedNames.contains(parameter.name))
        parameter.name!: parameter.type,
  };
}

/// Confirms every mirrored `call()` parameter forwarded through a named
/// builder is assignable to the matching `MixWidgetBuilder.build()`
/// parameter.
void validateBuilderForwardedParameters({
  required List<ParameterSpec> mirroredParameters,
  required Map<String, DartType> buildParameterTypes,
  required Element element,
}) {
  final typeSystem = element.library!.typeSystem;

  for (final parameter in mirroredParameters) {
    final buildParameterType = buildParameterTypes[parameter.name];
    if (buildParameterType == null) {
      fail(
        element,
        '`call()` parameter `${parameter.name}` cannot be forwarded through '
        'MixWidgetBuilder.build(). Add it to MixWidgetBuilder.build() or use '
        'direct widget fallback.',
      );
    }

    if (!typeSystem.isAssignableTo(
      parameter.type,
      buildParameterType,
      strictCasts: false,
    )) {
      fail(
        element,
        '`call()` parameter `${parameter.name}` has type '
        '${parameter.typeCode}, which cannot be forwarded through '
        'MixWidgetBuilder.build(). Expected '
        '${buildParameterType.getDisplayString()}.',
      );
    }
  }
}

/// Confirms the direct-fallback widget can accept the generator's emitted
/// `key:` and `style:` named arguments.
///
/// When `@MixWidget` has no `widgetBuilder` and the target spec is not in the
/// built-in default map, the generator emits the styler's `call()` return
/// widget directly and forwards `key:` and `style:` to it. The widget must
/// therefore expose both as named constructor parameters.
void validateDirectFallbackWidget({
  required InterfaceType callReturnType,
  required Element element,
}) {
  final widgetElement = callReturnType.element;
  final widgetName = widgetElement.name ?? callReturnType.getDisplayString();

  if (widgetElement is! ClassElement) {
    fail(
      element,
      '@MixWidget direct-widget fallback requires `$widgetName` to be a '
      'concrete class. Either provide a `widgetBuilder` or ensure the '
      'styler `call()` returns a standard widget class.',
    );
  }

  final constructor = widgetElement.unnamedConstructor;
  if (constructor == null) {
    fail(
      element,
      '@MixWidget direct-widget fallback requires `$widgetName` to expose an '
      'unnamed constructor.',
    );
  }

  final namedParameters = {
    for (final parameter in constructor.formalParameters)
      if (parameter.isNamed && parameter.name != null) parameter.name!,
  };
  for (final required in const {'key', 'style'}) {
    if (!namedParameters.contains(required)) {
      fail(
        element,
        '@MixWidget direct-widget fallback requires `$widgetName` to accept a '
        'named `$required` constructor parameter. Either add it, or supply a '
        'custom `widgetBuilder: MyBuilder()` so the wrapper can dispatch '
        'through MixWidgetBuilder.build().',
      );
    }
  }
}
