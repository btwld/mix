/// Models describing a `@MixWidget`-annotated target across codegen phases.
///
/// These types carry the resolved data from annotation parsing through
/// validation and emission. Each phase returns or consumes instances of
/// these models; no direct use of [Element] / [DartType] leaks into the
/// code emitter.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../helpers/library_scope.dart' as library_scope;

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
      typeCode: library_scope.typeCode(
        parameter.type,
        visibleFrom: visibleFrom,
      ),
      isNamed: parameter.isNamed,
      isRequiredNamed: parameter.isRequiredNamed,
      isRequiredPositional: parameter.isRequiredPositional,
      defaultValueCode: parameter.defaultValueCode,
    );
  }
}

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
