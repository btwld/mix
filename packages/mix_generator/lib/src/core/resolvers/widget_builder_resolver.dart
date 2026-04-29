/// Resolves how a `@MixWidget` target renders.
///
/// Looks up `@MixWidgetRenderer` on the spec class for the target's
/// `Style<TSpec>`, validates the renderer is a Flutter widget with a
/// compatible `style:` parameter, and mirrors the renderer's unnamed
/// constructor (excluding `key`, `style`, `styleSpec`) onto the generated
/// wrapper.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:logging/logging.dart';

import '../checkers.dart';
import '../errors.dart';
import '../models/widget_target.dart';

final _log = Logger('mix_generator.widget_builder');

const _reservedRendererParameterNames = {'key', 'style', 'styleSpec'};
const _dartDefaultValueIdentifiers = {
  'const',
  'false',
  'null',
  'true',
  'bool',
  'double',
  'Duration',
  'int',
  'Iterable',
  'List',
  'Map',
  'num',
  'Object',
  'Set',
  'String',
};

/// Resolves the rendering strategy for [target].
///
/// The renderer is declared once on the spec class via `@MixWidgetRenderer`.
/// Specs without that annotation produce a clear codegen error.
Future<ResolvedWidgetRenderer> resolveWidgetRenderer({
  required AnnotatedTarget target,
  required Element element,
}) async {
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
    fail(
      element,
      'Renderer `$rendererName` declared on '
      '${specElement.name} via @MixWidgetRenderer must expose an unnamed '
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
      fail(
        element,
        '@MixWidgetRenderer on ${specElement.name} did not provide a widget '
        'type.',
      );
    }

    if (widgetType is! InterfaceType) {
      fail(
        element,
        '@MixWidgetRenderer on ${specElement.name} must reference a class, '
        'got ${widgetType.getDisplayString()}.',
      );
    }

    return widgetType.element;
  }

  fail(
    element,
    'No renderer found for ${specElement.name}. Annotate the spec class with '
    '@MixWidgetRenderer(YourWidget) to declare its renderer.',
  );
}

void _validateRendererIsWidget({
  required InterfaceElement rendererElement,
  required InterfaceElement specElement,
  required Element element,
}) {
  if (rendererElement is! ClassElement) {
    fail(
      element,
      '@MixWidgetRenderer on ${specElement.name} must reference a class. Got '
      '${rendererElement.name ?? '<unknown>'}.',
    );
  }

  final rendererInterface = rendererElement.thisType;
  if (!flutterWidgetChecker.isAssignableFromType(rendererInterface)) {
    fail(
      element,
      '@MixWidgetRenderer on ${specElement.name} must reference a Flutter '
      'Widget subclass. Got ${rendererElement.name}.',
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
    fail(
      element,
      'Renderer `$rendererName` constructor parameter '
      '`${parameter.name ?? '?'}` is optional positional. Use a required '
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
  final hiddenType = _firstInvisibleTypeName(parameter.type, element.library!);
  if (hiddenType == null) {
    return;
  }

  fail(
    element,
    'Renderer `$rendererName` parameter `${parameter.name}` has type '
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

  fail(
    element,
    'Renderer `$rendererName` parameter `${parameter.name}` has default '
    'value `$defaultValueCode`, which references `$hiddenName` that is not '
    'visible to the annotated library. Import or re-export `$hiddenName` '
    'where @MixWidget is used.',
  );
}

String? _firstInvisibleTypeName(DartType type, LibraryElement library) {
  final alias = type.alias;
  if (alias != null) {
    final name = alias.element.name;
    if (name != null &&
        !_isElementVisibleUnprefixed(library, name, alias.element)) {
      return name;
    }

    for (final argument in alias.typeArguments) {
      final hiddenName = _firstInvisibleTypeName(argument, library);
      if (hiddenName != null) {
        return hiddenName;
      }
    }
  }

  if (type is InterfaceType) {
    final name = type.element.name;
    if (name != null &&
        !_isElementVisibleUnprefixed(library, name, type.element)) {
      return name;
    }

    for (final argument in type.typeArguments) {
      final hiddenName = _firstInvisibleTypeName(argument, library);
      if (hiddenName != null) {
        return hiddenName;
      }
    }
  }

  if (type is FunctionType) {
    final hiddenReturnType = _firstInvisibleTypeName(type.returnType, library);
    if (hiddenReturnType != null) {
      return hiddenReturnType;
    }

    for (final parameter in type.formalParameters) {
      final hiddenName = _firstInvisibleTypeName(parameter.type, library);
      if (hiddenName != null) {
        return hiddenName;
      }
    }
  }

  return null;
}

String? _firstInvisibleDefaultName(
  String defaultValueCode,
  LibraryElement library,
) {
  final identifiers = RegExp(r'\b[A-Za-z_]\w*\b')
      .allMatches(defaultValueCode)
      .map((match) => match.group(0)!)
      .where(
        (identifier) => !_dartDefaultValueIdentifiers.contains(identifier),
      );

  for (final identifier in identifiers) {
    if (identifier.startsWith('_')) {
      return identifier;
    }

    final startsLikeType = RegExp(r'^[A-Z]').hasMatch(identifier);
    if (!startsLikeType) {
      continue;
    }

    var isVisible = false;
    for (final fragment in library.fragments) {
      if (fragment.scope.lookup(identifier).getter != null) {
        isVisible = true;
        break;
      }
    }

    if (!isVisible) {
      return identifier;
    }
  }

  return null;
}

/// Finds the identifier (optionally prefixed) that references
/// [widgetElement] from [library]'s imports.
///
/// Generated widgets are emitted as `part of` contributions, so they inherit
/// the annotated library's visible imports and prefixes.
String _resolveWidgetReference({
  required InterfaceElement widgetElement,
  required LibraryElement library,
  required Element element,
}) {
  final name = widgetElement.name;
  if (name == null) {
    fail(element, '@MixWidget requires a named renderer widget.');
  }

  if (_isElementVisibleUnprefixed(library, name, widgetElement)) {
    return name;
  }

  for (final fragment in library.fragments) {
    for (final prefix in fragment.prefixes) {
      final result = prefix.scope.lookup(name).getter;
      if (_isSameElement(result, widgetElement)) {
        final prefixName = prefix.name;
        if (prefixName != null) {
          return '$prefixName.$name';
        }
      }
    }
  }

  fail(
    element,
    '@MixWidget could not reference renderer widget `$name`. Import the '
    'library that exports `$name` without hiding it, or import it with a '
    'visible prefix.',
  );
}

bool _isElementVisibleUnprefixed(
  LibraryElement library,
  String name,
  Element expected,
) {
  for (final fragment in library.fragments) {
    final result = fragment.scope.lookup(name).getter;
    if (_isSameElement(result, expected)) {
      return true;
    }
  }

  return false;
}

bool _isSameElement(Element? left, Element right) =>
    left?.baseElement == right.baseElement;
