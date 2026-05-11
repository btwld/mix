/// Emits the generated wrapper class for a `@MixWidget` target.
///
/// Uses `package:code_builder` for the class / field / constructor / method
/// shape and raw `Code` blocks for method bodies. The produced source is a
/// `part of` contribution, so type references are emitted as bare names —
/// import prefixes are inherited from the annotated library.
library;

import 'package:code_builder/code_builder.dart';

import '../models/widget_target.dart';

/// Renders the generated wrapper class as Dart source.
///
/// The returned source is unformatted; `SharedPartBuilder` applies
/// `DartFormatter` when assembling the final `.g.dart` output.
String buildWidgetClass({
  required String generatedName,
  required AnnotatedTarget target,
  required ResolvedStylerCall resolvedCall,
  required FactoryParameters factoryParameters,
}) {
  final allParameters = [
    ...factoryParameters.publicParameters,
    ...resolvedCall.parameters,
  ];

  final classSpec = Class((c) {
    c.name = generatedName;
    c.extend = refer('StatelessWidget');

    for (final parameter in allParameters) {
      c.fields.add(_buildField(parameter.name, parameter.typeCode));
    }

    c.constructors.add(_buildConstructor(allParameters: allParameters));

    c.methods.add(
      _buildBuildMethod(
        target: target,
        resolvedCall: resolvedCall,
        factoryParameters: factoryParameters,
      ),
    );
  });

  final buffer = StringBuffer();
  classSpec.accept(DartEmitter(useNullSafetySyntax: true), buffer);

  return buffer.toString();
}

Field _buildField(String name, String typeCode) => .new(
  (f) => f
    ..name = name
    ..type = refer(typeCode)
    ..modifier = .final$,
);

Constructor _buildConstructor({required List<ParameterSpec> allParameters}) {
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

  return Constructor(
    (c) => c
      ..constant = true
      ..requiredParameters.addAll(requiredPositional)
      ..optionalParameters.addAll(namedOrOptional),
  );
}

Parameter _parameter(ParameterSpec parameter) => .new((p) {
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
  required ResolvedStylerCall resolvedCall,
  required FactoryParameters factoryParameters,
}) {
  final styleSource = target.sourceName;
  final styleExpression = target.factoryElement != null
      ? '$styleSource(${_factoryInvocationArguments(factoryParameters)})'
      : styleSource;

  final dispatch = _emitStylerCall(
    styleExpression: styleExpression,
    callParameters: resolvedCall.parameters,
    forwardsKey: resolvedCall.forwardsKey,
  );

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
      ..body = Code('return $dispatch;'),
  );
}

String _emitStylerCall({
  required String styleExpression,
  required List<ParameterSpec> callParameters,
  required bool forwardsKey,
}) {
  final positional = [
    for (final parameter in callParameters)
      if (!parameter.isNamed) _parameterReference(parameter),
  ];
  final named = [
    if (forwardsKey) 'key: key',
    for (final parameter in callParameters)
      if (parameter.isNamed)
        '${parameter.name}: ${_parameterReference(parameter)}',
  ];

  final sections = [if (positional.isNotEmpty) positional.join(', '), ...named];

  return '$styleExpression.call(${sections.join(', ')})';
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
