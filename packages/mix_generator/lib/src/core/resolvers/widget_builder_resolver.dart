/// Resolves how a `@MixWidget` target renders.
///
/// The styler's concrete `call()` method is the source of truth for generated
/// wrapper parameters and widget creation.
library;

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:logging/logging.dart';

import '../checkers.dart';
import '../errors.dart';
import '../helpers/library_scope.dart';
import '../models/widget_target.dart';

final _log = Logger('mix_generator.widget_builder');

/// Resolves the styler `call()` contract for [target].
ResolvedStylerCall resolveStylerCall({
  required AnnotatedTarget target,
  required Element element,
}) {
  final callMethod = target.stylerType.lookUpMethod(
    MethodElement.CALL_METHOD_NAME,
    element.library!,
  );
  final stylerName = target.stylerType.getDisplayString();
  if (callMethod == null) {
    fail(element, 'No callable `call()` method found for $stylerName.');
  }

  if (callMethod.typeParameters.isNotEmpty) {
    fail(
      element,
      'Styler `$stylerName.call` must not be generic. Move generic values '
      'into concrete method parameters.',
    );
  }

  _validateCallReturnsWidget(
    callMethod: callMethod,
    stylerName: stylerName,
    element: element,
  );

  _validateFlutterFrameworkVisibility(
    returnType: callMethod.returnType,
    library: element.library!,
    element: element,
  );

  final (:parameters, :forwardsKey) = _extractCallParameters(
    callMethod: callMethod,
    stylerName: stylerName,
    element: element,
  );

  _log.info(
    '${target.sourceName}: rendering via $stylerName.call for '
    '${target.specType.getDisplayString()}.',
  );

  return ResolvedStylerCall(parameters: parameters, forwardsKey: forwardsKey);
}

void _validateCallReturnsWidget({
  required MethodElement callMethod,
  required String stylerName,
  required Element element,
}) {
  final returnType = callMethod.returnType;
  if (flutterWidgetChecker.isAssignableFromType(returnType)) {
    return;
  }

  fail(
    element,
    'Styler `$stylerName.call` returns ${returnType.getDisplayString()}, '
    'but must return a Flutter Widget.',
  );
}

({List<ParameterSpec> parameters, bool forwardsKey}) _extractCallParameters({
  required MethodElement callMethod,
  required String stylerName,
  required Element element,
}) {
  final parameters = <ParameterSpec>[];
  var forwardsKey = false;

  for (final parameter in callMethod.formalParameters) {
    final name = parameter.name;
    if (name == null) {
      continue;
    }

    if (name == 'key') {
      if (!parameter.isNamed) {
        fail(
          element,
          'Styler `$stylerName.call` parameter `key` must be named `Key? key`.',
        );
      }
      _validateKeyParameter(
        parameter: parameter,
        stylerName: stylerName,
        element: element,
      );
      forwardsKey = true;
      continue;
    }

    _validateForwardedCallParameter(
      parameter: parameter,
      stylerName: stylerName,
      element: element,
    );

    parameters.add(
      ParameterSpec.fromParameter(parameter, visibleFrom: element.library),
    );
  }

  return (parameters: parameters, forwardsKey: forwardsKey);
}

void _validateKeyParameter({
  required FormalParameterElement parameter,
  required String stylerName,
  required Element element,
}) {
  final keyType = parameter.type;
  final isKey = flutterKeyChecker.isExactlyType(keyType);
  final isNullable = keyType.nullabilitySuffix == .question;
  if (!isKey || !isNullable) {
    fail(
      element,
      'Styler `$stylerName.call` parameter `key` is '
      '${keyType.getDisplayString()}, but must be `Key?`.',
    );
  }
}

void _validateForwardedCallParameter({
  required FormalParameterElement parameter,
  required String stylerName,
  required Element element,
}) {
  if (parameter.isOptionalPositional) {
    final parameterName = parameter.name ?? '?';
    fail(
      element,
      'Styler `$stylerName.call` parameter `$parameterName` is optional '
      'positional. Use a required positional or named parameter instead.',
    );
  }

  _validateParameterTypeVisible(
    parameter: parameter,
    stylerName: stylerName,
    element: element,
  );
  _validateParameterDefaultVisible(
    parameter: parameter,
    stylerName: stylerName,
    element: element,
  );
}

void _validateParameterTypeVisible({
  required FormalParameterElement parameter,
  required String stylerName,
  required Element element,
}) {
  final hiddenType = firstInvisibleTypeName(parameter.type, element.library!);
  if (hiddenType == null) {
    return;
  }

  final parameterName = parameter.name ?? '<unknown>';
  fail(
    element,
    'Styler `$stylerName.call` parameter `$parameterName` has type '
    '${parameter.type.getDisplayString()}, which is not visible to the '
    'annotated library. Import or re-export `$hiddenType` where @MixWidget '
    'is used.',
  );
}

void _validateParameterDefaultVisible({
  required FormalParameterElement parameter,
  required String stylerName,
  required Element element,
}) {
  final defaultValueCode = parameter.defaultValueCode;
  if (defaultValueCode == null) {
    return;
  }

  final issue = _firstDefaultVisibilityIssue(
    defaultValueCode,
    annotatedLibrary: element.library!,
    callLibrary: parameter.library!,
  );
  if (issue == null) {
    return;
  }

  final parameterName = parameter.name ?? '<unknown>';
  if (issue.shadowed) {
    fail(
      element,
      'Styler `$stylerName.call` parameter `$parameterName` has default '
      'value `$defaultValueCode`, where `${issue.identifier}` resolves to a '
      'different declaration in the annotated library than in the call '
      'method library. Rename the conflicting symbol in the annotated '
      "library, or restructure imports so it sees the call method's "
      '`${issue.identifier}`.',
    );
  }

  fail(
    element,
    'Styler `$stylerName.call` parameter `$parameterName` has default '
    'value `$defaultValueCode`, which references `${issue.identifier}` that '
    'is not visible to the annotated library. Import or re-export '
    '`${issue.identifier}` where @MixWidget is used.',
  );
}

({String identifier, bool shadowed})? _firstDefaultVisibilityIssue(
  String defaultValueCode, {
  required LibraryElement annotatedLibrary,
  required LibraryElement callLibrary,
}) {
  final result = parseString(
    content: 'dynamic __mix_default__ = $defaultValueCode;',
    throwIfDiagnostics: false,
  );

  final declaration =
      result.unit.declarations.first as TopLevelVariableDeclaration;
  final initializer = declaration.variables.variables.first.initializer;
  if (initializer == null) {
    return null;
  }

  final collector = _FreeIdentifierCollector();
  initializer.accept(collector);

  for (final identifier in collector.identifiers) {
    final annotatedElement = _resolveTopLevel(annotatedLibrary, identifier);
    final hasAnnotatedPrefix = _hasPrefixNamed(annotatedLibrary, identifier);

    if (annotatedElement == null && !hasAnnotatedPrefix) {
      return (identifier: identifier, shadowed: false);
    }

    final callElement = _resolveTopLevel(callLibrary, identifier);
    if (annotatedElement != null &&
        callElement != null &&
        annotatedElement.baseElement != callElement.baseElement) {
      return (identifier: identifier, shadowed: true);
    }
  }

  return null;
}

Element? _resolveTopLevel(LibraryElement library, String identifier) {
  for (final fragment in library.fragments) {
    final lookup = fragment.scope.lookup(identifier);
    final element = lookup.getter ?? lookup.setter;
    if (element != null) {
      return element;
    }
  }

  return null;
}

bool _hasPrefixNamed(LibraryElement library, String identifier) {
  for (final fragment in library.fragments) {
    for (final prefix in fragment.prefixes) {
      if (prefix.name == identifier) {
        return true;
      }
    }
  }

  return false;
}

/// Collects identifiers used as the head of an expression — direct references,
/// constructor receivers, prefixes — while skipping member-access RHS
/// (`Foo.bar` skips `bar`) and named-argument labels.
class _FreeIdentifierCollector extends RecursiveAstVisitor<void> {
  final List<String> identifiers = [];

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    final parent = node.parent;

    if (parent is PrefixedIdentifier && identical(parent.identifier, node)) {
      return;
    }
    if (parent is PropertyAccess && identical(parent.propertyName, node)) {
      return;
    }
    if (parent is MethodInvocation &&
        identical(parent.methodName, node) &&
        parent.target != null) {
      return;
    }
    if (parent is ConstructorName && identical(parent.name, node)) {
      return;
    }
    if (parent is Label) {
      return;
    }

    identifiers.add(node.name);
  }
}

/// The generated wrapper emits bare `StatelessWidget`, `Widget`, and
/// `BuildContext` references in a `part of` contribution. They must be
/// visible without a prefix in the annotated library; otherwise the
/// generated code does not compile.
void _validateFlutterFrameworkVisibility({
  required DartType returnType,
  required LibraryElement library,
  required Element element,
}) {
  final widgetElement = _flutterWidgetElement(returnType);
  if (widgetElement == null) {
    return;
  }

  final frameworkLibrary = widgetElement.library;
  final requiredElements = [
    widgetElement,
    _interfaceElementNamed(frameworkLibrary, 'StatelessWidget'),
    _interfaceElementNamed(frameworkLibrary, 'BuildContext'),
  ];

  for (final requiredElement in requiredElements) {
    final reference = requiredElement == null
        ? null
        : referenceFor(requiredElement, library);
    if (reference == null || reference.contains('.')) {
      fail(
        element,
        '@MixWidget requires `Widget`, `StatelessWidget`, and `BuildContext` '
        'to be available without an import prefix in this library.',
        todo:
            "Add an unprefixed `import 'package:flutter/widgets.dart';` (or "
            '`material.dart`/`cupertino.dart`) so the generated wrapper '
            'compiles.',
      );
    }
  }
}

InterfaceElement? _interfaceElementNamed(LibraryElement library, String name) {
  for (final element in library.classes) {
    if (element.name == name) {
      return element;
    }
  }

  return null;
}

InterfaceElement? _flutterWidgetElement(DartType returnType) {
  if (returnType is! InterfaceType) {
    return null;
  }

  if (flutterWidgetChecker.isExactlyType(returnType)) {
    return returnType.element;
  }

  for (final supertype in returnType.allSupertypes) {
    if (flutterWidgetChecker.isExactlyType(supertype)) {
      return supertype.element;
    }
  }

  return null;
}
