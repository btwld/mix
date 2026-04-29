/// Resolves how a `@MixWidget` target renders.
///
/// Looks up `@MixWidgetRenderer` on the spec class for the target's
/// `Style<TSpec>`, validates the renderer is a Flutter widget with a
/// compatible `style:` parameter, and mirrors the renderer's unnamed
/// constructor (excluding `key`, `style`, `styleSpec`) onto the generated
/// wrapper.
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

const _reservedRendererParameterNames = {'key', 'style', 'styleSpec'};

/// Resolves the rendering strategy for [target].
///
/// The renderer is declared once on the spec class via `@MixWidgetRenderer`.
/// Specs without that annotation produce a clear codegen error.
ResolvedWidgetRenderer resolveWidgetRenderer({
  required AnnotatedTarget target,
  required Element element,
}) {
  final specType = target.specType;
  final specElement = specType is InterfaceType ? specType.element : null;
  if (specElement == null) {
    fail(
      element,
      'Could not resolve spec class for ${specType.getDisplayString()}.',
    );
  }

  final rendererElement = _readRendererFromSpec(
    specElement: specElement,
    element: element,
  );

  _validateRendererIsWidget(
    rendererElement: rendererElement,
    specElement: specElement,
    element: element,
  );

  final constructor = rendererElement.unnamedConstructor;
  final rendererName = rendererElement.name ?? '<unknown>';
  if (constructor == null) {
    final specName = specElement.name ?? '<unknown>';
    fail(
      element,
      'Renderer `$rendererName` declared on '
      '$specName via @MixWidgetRenderer must expose an unnamed '
      'constructor.',
    );
  }

  _validateStyleParameter(
    constructor: constructor,
    rendererName: rendererName,
    target: target,
    element: element,
  );

  _validateKeyParameter(
    constructor: constructor,
    rendererName: rendererName,
    element: element,
  );

  final wrapperParameters = _extractRendererParameters(
    constructor: constructor,
    rendererName: rendererName,
    element: element,
  );

  final widgetReference = _resolveWidgetReference(
    widgetElement: rendererElement,
    library: element.library!,
    element: element,
  );

  _log.info(
    '${target.sourceName}: rendering via $widgetReference for '
    '${specType.getDisplayString()}.',
  );

  return ResolvedWidgetRenderer(
    widgetReference: widgetReference,
    parameters: wrapperParameters,
  );
}

InterfaceElement _readRendererFromSpec({
  required InterfaceElement specElement,
  required Element element,
}) {
  for (final annotation in specElement.metadata.annotations) {
    final value = annotation.computeConstantValue();
    if (value == null) {
      continue;
    }

    final type = value.type;
    if (type == null ||
        !mixWidgetRendererAnnotationChecker.isExactlyType(type)) {
      continue;
    }

    final widgetType = value.getField('widget')?.toTypeValue();
    if (widgetType == null) {
      final specName = specElement.name ?? '<unknown>';
      fail(
        element,
        '@MixWidgetRenderer on $specName did not provide a widget '
        'type.',
      );
    }

    if (widgetType is! InterfaceType) {
      final specName = specElement.name ?? '<unknown>';
      fail(
        element,
        '@MixWidgetRenderer on $specName must reference a class, '
        'got ${widgetType.getDisplayString()}.',
      );
    }

    return widgetType.element;
  }

  fail(
    element,
    'No renderer found for ${specElement.name ?? '<unknown>'}. '
    'Annotate the spec class with '
    '@MixWidgetRenderer(YourWidget) to declare its renderer.',
  );
}

void _validateRendererIsWidget({
  required InterfaceElement rendererElement,
  required InterfaceElement specElement,
  required Element element,
}) {
  if (rendererElement is! ClassElement) {
    final specName = specElement.name ?? '<unknown>';
    final rendererName = rendererElement.name ?? '<unknown>';
    fail(
      element,
      '@MixWidgetRenderer on $specName must reference a class. Got '
      '$rendererName.',
    );
  }

  if (rendererElement.isAbstract) {
    final specName = specElement.name ?? '<unknown>';
    final rendererName = rendererElement.name ?? '<unknown>';
    fail(
      element,
      '@MixWidgetRenderer on $specName must reference a concrete widget '
      'class. Got abstract class $rendererName.',
    );
  }

  final rendererInterface = rendererElement.thisType;
  if (!flutterWidgetChecker.isAssignableFromType(rendererInterface)) {
    final specName = specElement.name ?? '<unknown>';
    final rendererName = rendererElement.name ?? '<unknown>';
    fail(
      element,
      '@MixWidgetRenderer on $specName must reference a Flutter '
      'Widget subclass. Got $rendererName.',
    );
  }
}

void _validateStyleParameter({
  required ConstructorElement constructor,
  required String rendererName,
  required AnnotatedTarget target,
  required Element element,
}) {
  final styleParameter = _findNamedParameter(constructor, 'style');
  if (styleParameter == null) {
    fail(
      element,
      'Renderer `$rendererName` must declare a named `style:` parameter '
      'compatible with ${target.stylerType.getDisplayString()}.',
    );
  }

  final typeSystem = element.library!.typeSystem;
  if (!typeSystem.isAssignableTo(
    target.stylerType,
    styleParameter.type,
    strictCasts: false,
  )) {
    fail(
      element,
      'Renderer `$rendererName.style` is '
      '${styleParameter.type.getDisplayString()}, but the styler returns '
      '${target.stylerType.getDisplayString()}. The style parameter must '
      'accept the styler type.',
    );
  }
}

void _validateKeyParameter({
  required ConstructorElement constructor,
  required String rendererName,
  required Element element,
}) {
  final keyParameter = _findNamedParameter(constructor, 'key');
  if (keyParameter == null) {
    fail(
      element,
      'Renderer `$rendererName` must declare a named `Key? key` parameter.',
    );
  }

  final keyType = keyParameter.type;
  final isKey = flutterKeyChecker.isExactlyType(keyType);
  final isNullable = keyType.nullabilitySuffix == .question;
  if (!isKey || !isNullable) {
    fail(
      element,
      'Renderer `$rendererName.key` is '
      '${keyType.getDisplayString()}, but must be `Key?`.',
    );
  }
}

FormalParameterElement? _findNamedParameter(
  ConstructorElement constructor,
  String name,
) {
  for (final parameter in constructor.formalParameters) {
    if (parameter.isNamed && parameter.name == name) {
      return parameter;
    }
  }

  return null;
}

List<ParameterSpec> _extractRendererParameters({
  required ConstructorElement constructor,
  required String rendererName,
  required Element element,
}) {
  final parameters = <ParameterSpec>[];
  for (final parameter in constructor.formalParameters) {
    final name = parameter.name;
    if (name == null) {
      continue;
    }
    if (_reservedRendererParameterNames.contains(name)) {
      continue;
    }

    _validateForwardedRendererParameter(
      parameter: parameter,
      rendererName: rendererName,
      element: element,
    );

    parameters.add(
      ParameterSpec.fromParameter(parameter, visibleFrom: element.library),
    );
  }

  return parameters;
}

void _validateForwardedRendererParameter({
  required FormalParameterElement parameter,
  required String rendererName,
  required Element element,
}) {
  if (parameter.isOptionalPositional) {
    final parameterName = parameter.name ?? '?';
    fail(
      element,
      'Renderer `$rendererName` constructor parameter '
      '`$parameterName` is optional positional. Use a required '
      'positional or named parameter instead.',
    );
  }

  _validateParameterTypeVisible(
    parameter: parameter,
    rendererName: rendererName,
    element: element,
  );
  _validateParameterDefaultVisible(
    parameter: parameter,
    rendererName: rendererName,
    element: element,
  );
}

void _validateParameterTypeVisible({
  required FormalParameterElement parameter,
  required String rendererName,
  required Element element,
}) {
  final hiddenType = firstInvisibleTypeName(parameter.type, element.library!);
  if (hiddenType == null) {
    return;
  }

  final parameterName = parameter.name ?? '<unknown>';
  fail(
    element,
    'Renderer `$rendererName` parameter `$parameterName` has type '
    '${parameter.type.getDisplayString()}, which is not visible to the '
    'annotated library. Import or re-export `$hiddenType` where @MixWidget '
    'is used.',
  );
}

void _validateParameterDefaultVisible({
  required FormalParameterElement parameter,
  required String rendererName,
  required Element element,
}) {
  final defaultValueCode = parameter.defaultValueCode;
  if (defaultValueCode == null) {
    return;
  }

  final hiddenName = _firstInvisibleDefaultName(
    defaultValueCode,
    element.library!,
  );
  if (hiddenName == null) {
    return;
  }

  final parameterName = parameter.name ?? '<unknown>';
  fail(
    element,
    'Renderer `$rendererName` parameter `$parameterName` has default '
    'value `$defaultValueCode`, which references `$hiddenName` that is not '
    'visible to the annotated library. Import or re-export `$hiddenName` '
    'where @MixWidget is used.',
  );
}

String? _firstInvisibleDefaultName(
  String defaultValueCode,
  LibraryElement library,
) {
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
    var isVisible = false;
    for (final fragment in library.fragments) {
      final lookup = fragment.scope.lookup(identifier);
      if (lookup.getter != null || lookup.setter != null) {
        isVisible = true;
        break;
      }
      for (final prefix in fragment.prefixes) {
        if (prefix.name == identifier) {
          isVisible = true;
          break;
        }
      }
      if (isVisible) {
        break;
      }
    }

    if (!isVisible) {
      return identifier;
    }
  }

  return null;
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

String _resolveWidgetReference({
  required InterfaceElement widgetElement,
  required LibraryElement library,
  required Element element,
}) {
  final name = widgetElement.name;
  if (name == null) {
    fail(element, '@MixWidget requires a named renderer widget.');
  }

  final reference = referenceFor(widgetElement, library);
  if (reference != null) {
    return reference;
  }

  fail(
    element,
    '@MixWidget could not reference renderer widget `$name`. Import the '
    'library that exports `$name` without hiding it, or import it with a '
    'visible prefix.',
  );
}
