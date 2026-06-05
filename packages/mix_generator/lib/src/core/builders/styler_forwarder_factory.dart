/// Derives static styler forwarder factories from typed owner mixin methods.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../curated/styler_surface_metadata.dart';
import '../errors.dart';
import '../helpers/library_scope.dart';
import '../helpers/widget_call_planner.dart';
import '../models/mix_widget_model.dart';

List<StylerFactoryDescriptor> deriveForwarderFactories({
  required InterfaceElement mixinElement,
  required List<String> orderedMethodNames,
  required Set<String> requiredFieldNames,
  required LibraryElement libraryScope,
  required Element anchor,
}) {
  final methodsByName = <String, MethodElement>{};
  for (final method in mixinElement.methods) {
    final name = method.name;
    if (name == null) continue;
    methodsByName[name] = method;
  }

  return [
    for (final methodName in orderedMethodNames)
      _descriptorFor(
        methodName,
        methodsByName[methodName],
        mixinElement: mixinElement,
        requiredFieldNames: requiredFieldNames,
        libraryScope: libraryScope,
        anchor: anchor,
      ),
  ];
}

StylerFactoryDescriptor _descriptorFor(
  String methodName,
  MethodElement? method, {
  required InterfaceElement mixinElement,
  required Set<String> requiredFieldNames,
  required LibraryElement libraryScope,
  required Element anchor,
}) {
  if (method == null) {
    final mixinName = mixinElement.name ?? '<unnamed>';
    fail(
      anchor,
      'SpecStylerGenerator could not derive forwarder factory `$methodName` '
      'because owner mixin `$mixinName` does not declare that method.',
      todo:
          'Update the curated forwarder allow-list or restore the method on '
          '`$mixinName`.',
    );
  }

  final params = [
    for (final parameter in method.formalParameters)
      _forwarderParamFor(parameter, libraryScope),
  ];

  return StylerFactoryDescriptor(
    name: methodName,
    signature: '$methodName(${_signatureParameters(params)})',
    invocation: '$methodName(${_invocationArguments(params)})',
    requiredFieldNames: requiredFieldNames,
  );
}

WidgetCallParam _forwarderParamFor(
  FormalParameterElement parameter,
  LibraryElement libraryScope,
) {
  final param = paramFor(
    parameter,
    library: libraryScope,
    annotationLabel: 'SpecStylerGenerator forwarder factory',
  );
  final forwarderTypeCode = _forwarderTypeCode(parameter.type, libraryScope);
  if (forwarderTypeCode == param.typeCode) return param;

  return WidgetCallParam(
    name: param.name,
    typeCode: forwarderTypeCode,
    isPositional: param.isPositional,
    isRequired: param.isRequired,
    defaultValueCode: param.defaultValueCode,
  );
}

String _forwarderTypeCode(DartType type, LibraryElement libraryScope) {
  final rawGenericTypeCode = _rawGenericBoundTypeCode(type, libraryScope);
  if (rawGenericTypeCode != null) return rawGenericTypeCode;

  if (type is InterfaceType) {
    final elementName = type.element.name;
    if (elementName == null) return typeCode(type, visibleFrom: libraryScope);

    final name = referenceFor(type.element, libraryScope) ?? elementName;
    final nullableSuffix = type.nullabilitySuffix == .question ? '?' : '';
    if (type.typeArguments.isEmpty) return '$name$nullableSuffix';

    final typeArguments = type.typeArguments
        .map((argument) => _forwarderTypeCode(argument, libraryScope))
        .join(', ');

    return '$name<$typeArguments>$nullableSuffix';
  }

  return typeCode(type, visibleFrom: libraryScope);
}

String? _rawGenericBoundTypeCode(DartType type, LibraryElement libraryScope) {
  if (type is! InterfaceType) return null;
  if (type.typeArguments.isEmpty) return null;

  final element = type.element;
  final typeParameters = element.typeParameters;
  if (typeParameters.length != type.typeArguments.length) return null;

  for (var i = 0; i < typeParameters.length; i++) {
    final bound = typeParameters[i].bound;
    final typeArgument = type.typeArguments[i];
    if (bound == null) {
      if (typeArgument is! DynamicType) return null;
    } else if (typeCode(bound, visibleFrom: libraryScope) !=
        typeCode(typeArgument, visibleFrom: libraryScope)) {
      return null;
    }
  }

  final name = referenceFor(element, libraryScope) ?? element.name;
  if (name == null) return null;

  return '$name${type.nullabilitySuffix == .question ? '?' : ''}';
}

String _signatureParameters(List<WidgetCallParam> params) {
  final requiredPositional = <String>[];
  final optionalPositional = <String>[];
  final named = <String>[];

  for (final param in params) {
    final code = renderCallParameter(param);
    if (param.isPositional && param.isRequired) {
      requiredPositional.add(code);
    } else if (param.isPositional) {
      optionalPositional.add(code);
    } else {
      named.add(code);
    }
  }

  return [
    ...requiredPositional,
    if (optionalPositional.isNotEmpty) '[${optionalPositional.join(', ')}]',
    if (named.isNotEmpty) '{${named.join(', ')}}',
  ].join(', ');
}

String _invocationArguments(List<WidgetCallParam> params) {
  return [
    for (final param in params)
      if (param.isPositional) param.name else '${param.name}: ${param.name}',
  ].join(', ');
}
