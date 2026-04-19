/// Emits the generated wrapper class for a `@MixWidget` target.
///
/// Uses `package:code_builder` for the class / field / constructor / method
/// shape and raw `Code` blocks for method bodies. The produced source is a
/// `part of` contribution, so type references are emitted as bare names —
/// import prefixes are inherited from the annotated library.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

import '../errors.dart';
import '../models/widget_target.dart';

/// Renders the generated wrapper class as Dart source.
///
/// The returned source is unformatted; `SharedPartBuilder` applies
/// `DartFormatter` when assembling the final `.g.dart` output.
String buildWidgetClass({
  required String generatedName,
  required AnnotatedTarget target,
  required MixWidgetConfig config,
  required ResolvedBuilder resolvedBuilder,
  required InterfaceType callReturnType,
  required FactoryParameters factoryParameters,
  required List<ParameterSpec> mirroredParameters,
  required Element element,
}) {
  final allParameters = [
    ...factoryParameters.publicParameters,
    ...mirroredParameters,
  ];
  final styleTypeName = target.stylerType.getDisplayString();

  final classSpec = Class((c) {
    c.name = generatedName;
    c.extend = refer('StatelessWidget');

    for (final parameter in allParameters) {
      c.fields.add(_buildField(parameter.name, parameter.typeCode));
    }
    if (config.styleable) {
      c.fields.add(_buildField('style', '$styleTypeName?'));
    }

    c.constructors.add(
      _buildConstructor(
        allParameters: allParameters,
        addsStyleField: config.styleable,
      ),
    );

    c.methods.add(
      _buildBuildMethod(
        target: target,
        config: config,
        resolvedBuilder: resolvedBuilder,
        callReturnType: callReturnType,
        factoryParameters: factoryParameters,
        mirroredParameters: mirroredParameters,
        element: element,
      ),
    );
  });

  final buffer = StringBuffer();
  classSpec.accept(DartEmitter(useNullSafetySyntax: true), buffer);

  return buffer.toString();
}

Field _buildField(String name, String typeCode) => Field(
  (f) => f
    ..name = name
    ..type = refer(typeCode)
    ..modifier = .final$,
);

Constructor _buildConstructor({
  required List<ParameterSpec> allParameters,
  required bool addsStyleField,
}) {
  final requiredPositional = <Parameter>[];
  final namedOrOptional = [
    Parameter(
      (p) => p
        ..name = 'key'
        ..toSuper = true
        ..named = true,
    ),
  ];

  for (final parameter in allParameters) {
    if (parameter.isRequiredPositional) {
      requiredPositional.add(_parameter(parameter));
    } else {
      namedOrOptional.add(_parameter(parameter));
    }
  }

  if (addsStyleField) {
    namedOrOptional.add(
      Parameter(
        (p) => p
          ..name = 'style'
          ..toThis = true
          ..named = true,
      ),
    );
  }

  return Constructor(
    (c) => c
      ..constant = true
      ..requiredParameters.addAll(requiredPositional)
      ..optionalParameters.addAll(namedOrOptional),
  );
}

Parameter _parameter(ParameterSpec parameter) => Parameter((p) {
  p
    ..name = parameter.name
    ..toThis = true
    ..named = parameter.isNamed
    ..required = parameter.isRequiredNamed;
  final defaultValue = parameter.defaultValueCode;
  if (defaultValue != null && !parameter.isRequiredNamed) {
    p.defaultTo = Code(defaultValue);
  }
});

Method _buildBuildMethod({
  required AnnotatedTarget target,
  required MixWidgetConfig config,
  required ResolvedBuilder resolvedBuilder,
  required InterfaceType callReturnType,
  required FactoryParameters factoryParameters,
  required List<ParameterSpec> mirroredParameters,
  required Element element,
}) {
  return Method(
    (m) => m
      ..annotations.add(refer('override'))
      ..returns = refer('Widget')
      ..name = 'build'
      ..requiredParameters.add(
        Parameter(
          (p) => p
            ..name = 'context'
            ..type = refer('BuildContext'),
        ),
      )
      ..body = _buildMethodBody(
        target: target,
        config: config,
        resolvedBuilder: resolvedBuilder,
        callReturnType: callReturnType,
        factoryParameters: factoryParameters,
        mirroredParameters: mirroredParameters,
        element: element,
      ),
  );
}

Code _buildMethodBody({
  required AnnotatedTarget target,
  required MixWidgetConfig config,
  required ResolvedBuilder resolvedBuilder,
  required InterfaceType callReturnType,
  required FactoryParameters factoryParameters,
  required List<ParameterSpec> mirroredParameters,
  required Element element,
}) {
  final styleSource = target.factoryElement?.name ?? target.sourceName;
  final baseStyleExpression = target.factoryElement != null
      ? '$styleSource(${_factoryInvocationArguments(factoryParameters)})'
      : styleSource;

  final styleArgument = config.styleable ? 'effectiveStyle' : baseStyleExpression;
  final dispatch = switch (resolvedBuilder) {
    NamedBuilder(:final className) => _emitBuilderCall(
      builderClassName: className,
      mirroredParameters: mirroredParameters,
      styleArgument: styleArgument,
    ),
    DirectBuilder() => _emitDirectWidgetCall(
      widgetReference: _resolveWidgetReference(
        callReturnType.element as ClassElement,
        element.library!,
        element,
      ),
      mirroredParameters: mirroredParameters,
      styleArgument: styleArgument,
    ),
  };

  final buffer = StringBuffer();
  if (config.styleable) {
    buffer.writeln('final baseStyle = $baseStyleExpression;');
    buffer.writeln('final effectiveStyle = baseStyle.merge(style);');
  }
  buffer.writeln('return $dispatch;');

  return Code(buffer.toString());
}

String _emitBuilderCall({
  required String builderClassName,
  required List<ParameterSpec> mirroredParameters,
  required String styleArgument,
}) {
  final namedArgs = <String>['key: key'];
  for (final parameter in mirroredParameters) {
    namedArgs.add('${parameter.name}: ${_parameterReference(parameter)}');
  }

  return 'const $builderClassName().build($styleArgument, ${namedArgs.join(', ')})';
}

String _emitDirectWidgetCall({
  required String widgetReference,
  required List<ParameterSpec> mirroredParameters,
  required String styleArgument,
}) {
  final positional = [
    for (final parameter in mirroredParameters)
      if (!parameter.isNamed) _parameterReference(parameter),
  ];
  final named = [
    for (final parameter in mirroredParameters)
      if (parameter.isNamed)
        '${parameter.name}: ${_parameterReference(parameter)}',
    'key: key',
    'style: $styleArgument',
  ];

  final sections = [if (positional.isNotEmpty) positional.join(', '), ...named];

  return '$widgetReference(${sections.join(', ')})';
}

String _factoryInvocationArguments(FactoryParameters factoryParameters) {
  final sections = <String>[];
  if (factoryParameters.injectsBuildContext) {
    sections.add('context');
  }

  for (final parameter in factoryParameters.publicParameters) {
    if (parameter.isNamed) {
      continue;
    }
    sections.add(_parameterReference(parameter));
  }

  for (final parameter in factoryParameters.publicParameters.where(
    (p) => p.isNamed,
  )) {
    sections.add('${parameter.name}: ${_parameterReference(parameter)}');
  }

  return sections.join(', ');
}

String _parameterReference(ParameterSpec parameter) =>
    parameter.name == 'context' ? 'this.context' : parameter.name;

/// Finds the identifier (optionally prefixed) that references
/// [widgetElement] from [library]'s imports.
///
/// The generated file is a `part of` contribution: it inherits the annotated
/// library's import prefixes. A widget imported via
/// `import 'package:foo/foo.dart' as foo;` must be referenced as `foo.Widget`.
String _resolveWidgetReference(
  ClassElement widgetElement,
  LibraryElement library,
  Element element,
) {
  final name = widgetElement.name;
  if (name == null) {
    fail(
      element,
      '@MixWidget direct widget fallback requires a named widget class.',
    );
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
    '@MixWidget direct widget fallback could not reference widget `$name`. '
    'Import the widget without a prefix, or ensure the prefix is visible to '
    'the annotated library.',
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
