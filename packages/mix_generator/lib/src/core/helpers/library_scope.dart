/// Helpers for writing element references in a generated part.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

/// Returns how to write [target] inside [from]'s library.
///
/// Returns a bare name when the element is visible without a prefix,
/// `prefix.name` when it is visible through an import prefix, and `null`
/// when it is not visible from the library at all.
String? referenceFor(Element target, LibraryElement from) {
  final name = target.name;
  if (name == null) {
    return null;
  }

  for (final fragment in from.fragments) {
    final result = fragment.scope.lookup(name).getter;
    if (_isSameElement(result, target)) {
      return name;
    }
  }

  for (final fragment in from.fragments) {
    for (final prefix in fragment.prefixes) {
      final result = prefix.scope.lookup(name).getter;
      if (_isSameElement(result, target)) {
        final prefixName = prefix.name;
        if (prefixName != null) {
          return '$prefixName.$name';
        }
      }
    }
  }

  return null;
}

/// Returns Dart code for [type] as it should be written from [visibleFrom].
String typeCode(DartType type, {LibraryElement? visibleFrom}) {
  final alias = type.alias;
  if (alias != null) {
    final aliasName = alias.element.name;
    if (aliasName == null) {
      return type.getDisplayString();
    }

    final name = visibleFrom == null
        ? aliasName
        : (referenceFor(alias.element, visibleFrom) ?? aliasName);
    final typeArguments = alias.typeArguments;
    final nullableSuffix = _nullableSuffix(type);

    if (typeArguments.isEmpty) {
      return '$name$nullableSuffix';
    }

    final arguments = typeArguments
        .map((argument) => typeCode(argument, visibleFrom: visibleFrom))
        .join(', ');

    return '$name<$arguments>$nullableSuffix';
  }

  if (type is InterfaceType) {
    final elementName = type.element.name;
    if (elementName == null) {
      return type.getDisplayString();
    }

    final name = visibleFrom == null
        ? elementName
        : (referenceFor(type.element, visibleFrom) ?? elementName);
    final nullableSuffix = _nullableSuffix(type);

    if (type.typeArguments.isEmpty) {
      return '$name$nullableSuffix';
    }

    final arguments = type.typeArguments
        .map((argument) => typeCode(argument, visibleFrom: visibleFrom))
        .join(', ');

    return '$name<$arguments>$nullableSuffix';
  }

  if (type is FunctionType) {
    return _functionTypeCode(type, visibleFrom: visibleFrom);
  }

  return type.getDisplayString();
}

/// Returns the first type name in [type] that is not visible from [library].
String? firstInvisibleTypeName(DartType type, LibraryElement library) {
  final alias = type.alias;
  if (alias != null) {
    final name = alias.element.name;
    if (name != null && referenceFor(alias.element, library) == null) {
      return name;
    }

    for (final argument in alias.typeArguments) {
      final hiddenName = firstInvisibleTypeName(argument, library);
      if (hiddenName != null) {
        return hiddenName;
      }
    }
  }

  if (type is InterfaceType) {
    final name = type.element.name;
    if (name != null && referenceFor(type.element, library) == null) {
      return name;
    }

    for (final argument in type.typeArguments) {
      final hiddenName = firstInvisibleTypeName(argument, library);
      if (hiddenName != null) {
        return hiddenName;
      }
    }
  }

  if (type is FunctionType) {
    final hiddenReturnType = firstInvisibleTypeName(type.returnType, library);
    if (hiddenReturnType != null) {
      return hiddenReturnType;
    }

    for (final parameter in type.formalParameters) {
      final hiddenName = firstInvisibleTypeName(parameter.type, library);
      if (hiddenName != null) {
        return hiddenName;
      }
    }
  }

  if (type is RecordType) {
    for (final field in type.positionalFields) {
      final hiddenName = firstInvisibleTypeName(field.type, library);
      if (hiddenName != null) {
        return hiddenName;
      }
    }
    for (final field in type.namedFields) {
      final hiddenName = firstInvisibleTypeName(field.type, library);
      if (hiddenName != null) {
        return hiddenName;
      }
    }
  }

  return null;
}

String _nullableSuffix(DartType type) =>
    type.nullabilitySuffix == .question ? '?' : '';

String _functionTypeCode(FunctionType type, {LibraryElement? visibleFrom}) {
  final returnType = typeCode(type.returnType, visibleFrom: visibleFrom);
  final requiredPositional = <String>[];
  final optionalPositional = <String>[];
  final named = <String>[];

  for (final parameter in type.formalParameters) {
    final parameterCode = _functionParameterCode(
      parameter,
      visibleFrom: visibleFrom,
    );

    if (parameter.isNamed) {
      named.add(parameterCode);
    } else if (parameter.isOptionalPositional) {
      optionalPositional.add(parameterCode);
    } else {
      requiredPositional.add(parameterCode);
    }
  }

  final parameters = [
    ...requiredPositional,
    if (optionalPositional.isNotEmpty) '[${optionalPositional.join(', ')}]',
    if (named.isNotEmpty) '{${named.join(', ')}}',
  ].join(', ');

  return '$returnType Function($parameters)${_nullableSuffix(type)}';
}

String _functionParameterCode(
  FormalParameterElement parameter, {
  LibraryElement? visibleFrom,
}) {
  final type = typeCode(parameter.type, visibleFrom: visibleFrom);
  final name = parameter.name;
  final requiredPrefix = parameter.isRequiredNamed ? 'required ' : '';

  return name == null ? '$requiredPrefix$type' : '$requiredPrefix$type $name';
}

bool _isSameElement(Element? left, Element right) =>
    left?.baseElement == right.baseElement;
