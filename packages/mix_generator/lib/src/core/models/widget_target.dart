/// Models describing a `@MixWidget`-annotated target across codegen phases.
///
/// These types carry the resolved data from annotation parsing through
/// validation and emission. Each phase returns or consumes instances of
/// these models; no direct use of [Element] / [DartType] leaks into the
/// code emitter.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

/// A resolved `@MixWidget` target: a top-level styler declaration or factory.
class AnnotatedTarget {
  /// The declared name of the annotated element (variable or function name).
  final String sourceName;

  /// The concrete `Style<TSpec>` subtype produced by the target.
  final InterfaceType stylerType;

  /// The `TSpec` type argument of [stylerType].
  final DartType specType;

  /// When the target is a top-level function, the function element that
  /// produces the styler. `null` for variable-backed targets.
  final TopLevelFunctionElement? factoryElement;

  const AnnotatedTarget({
    required this.sourceName,
    required this.stylerType,
    required this.specType,
    required this.factoryElement,
  });
}

/// A single parameter surfaced on the generated wrapper widget.
class ParameterSpec {
  final String name;
  final DartType type;
  final String typeCode;
  final bool isNamed;
  final bool isRequiredNamed;
  final bool isRequiredPositional;
  final String? defaultValueCode;

  const ParameterSpec({
    required this.name,
    required this.type,
    required this.typeCode,
    required this.isNamed,
    required this.isRequiredNamed,
    required this.isRequiredPositional,
    required this.defaultValueCode,
  });

  factory ParameterSpec.fromParameter(
    FormalParameterElement parameter, {
    LibraryElement? visibleFrom,
  }) {
    return ParameterSpec(
      name: parameter.name!,
      type: parameter.type,
      typeCode: _typeCode(parameter.type, visibleFrom: visibleFrom),
      isNamed: parameter.isNamed,
      isRequiredNamed: parameter.isRequiredNamed,
      isRequiredPositional: parameter.isRequiredPositional,
      defaultValueCode: parameter.defaultValueCode,
    );
  }
}

String _typeCode(DartType type, {LibraryElement? visibleFrom}) {
  final alias = type.alias;
  if (alias != null) {
    final name =
        _visibleElementReference(alias.element, visibleFrom) ??
        alias.element.name;
    final typeArguments = alias.typeArguments;
    final nullableSuffix = type.nullabilitySuffix == NullabilitySuffix.question
        ? '?'
        : '';

    if (typeArguments.isEmpty) {
      return '$name$nullableSuffix';
    }

    final arguments = typeArguments
        .map((argument) => _typeCode(argument, visibleFrom: visibleFrom))
        .join(', ');

    return '$name<$arguments>$nullableSuffix';
  }

  return type.getDisplayString();
}

String? _visibleElementReference(Element expected, LibraryElement? library) {
  final name = expected.name;
  if (name == null || library == null) {
    return null;
  }

  for (final fragment in library.fragments) {
    final result = fragment.scope.lookup(name).getter;
    if (_isSameElement(result, expected)) {
      return name;
    }
  }

  for (final fragment in library.fragments) {
    for (final prefix in fragment.prefixes) {
      final result = prefix.scope.lookup(name).getter;
      if (_isSameElement(result, expected)) {
        final prefixName = prefix.name;
        if (prefixName != null) {
          return '$prefixName.$name';
        }
      }
    }
  }

  return null;
}

bool _isSameElement(Element? left, Element right) =>
    left?.baseElement == right.baseElement;

/// Factory-function parameters split between the user-visible wrapper
/// constructor params and the optional injected `BuildContext`.
class FactoryParameters {
  static const empty = FactoryParameters(
    publicParameters: [],
    injectsBuildContext: false,
  );

  final List<ParameterSpec> publicParameters;
  final bool injectsBuildContext;

  const FactoryParameters({
    required this.publicParameters,
    required this.injectsBuildContext,
  });
}

/// The renderer widget and wrapper parameters used to emit the widget class.
class ResolvedWidgetRenderer {
  /// The renderer widget reference as it should appear in generated code,
  /// optionally prefixed (e.g. `Box`, `mix.Box`, `RemixButton`).
  final String widgetReference;

  /// Parameters mirrored from the renderer widget's unnamed constructor,
  /// excluding `key`, `style`, and `styleSpec`.
  final List<ParameterSpec> parameters;

  const ResolvedWidgetRenderer({
    required this.widgetReference,
    required this.parameters,
  });
}
