/// Models describing a `@MixWidget`-annotated target across codegen phases.
///
/// These types carry the resolved data from annotation parsing through
/// validation and emission. Each phase returns or consumes instances of
/// these models; no direct use of [Element] / [DartType] leaks into the
/// code emitter.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

/// Flags parsed from the `@MixWidget(...)` annotation arguments.
class MixWidgetConfig {
  final String? name;
  final bool styleable;

  const MixWidgetConfig({required this.name, required this.styleable});
}

/// A resolved `@MixWidget` target: a top-level styler declaration or factory.
class AnnotatedTarget {
  /// The declared name of the annotated element (variable or function name).
  final String sourceName;

  /// The concrete `Style<TSpec>` subtype of the target.
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

/// A single parameter mirrored from a styler's `call()` method (or a factory
/// function's parameter list) onto the generated wrapper widget.
class ParameterSpec {
  final String name;
  final DartType type;
  final String typeCode;
  final bool isNamed;
  final bool isRequiredNamed;
  final bool isRequiredPositional;
  final bool isOptionalPositional;
  final String? defaultValueCode;

  const ParameterSpec({
    required this.name,
    required this.type,
    required this.typeCode,
    required this.isNamed,
    required this.isRequiredNamed,
    required this.isRequiredPositional,
    required this.isOptionalPositional,
    required this.defaultValueCode,
  });

  factory ParameterSpec.fromParameter(FormalParameterElement parameter) {
    return ParameterSpec(
      name: parameter.name!,
      type: parameter.type,
      typeCode: parameter.type.getDisplayString(),
      isNamed: parameter.isNamed,
      isRequiredNamed: parameter.isRequiredNamed,
      isRequiredPositional: parameter.isRequiredPositional,
      isOptionalPositional: parameter.isOptionalPositional,
      defaultValueCode: parameter.defaultValueCode,
    );
  }
}

/// The shape of a styler's `call()` method — its return widget type plus the
/// public (non-reserved) parameters that are mirrored onto the generated
/// wrapper's constructor.
class CallSignature {
  final InterfaceType returnType;
  final List<ParameterSpec> parameters;

  const CallSignature({required this.returnType, required this.parameters});
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

/// The builder to dispatch through when emitting the widget class.
///
/// - [ResolvedBuilder.named] dispatches to a `const BuilderName().build(...)`
///   emission (either a Mix built-in inferred by spec or a user-authored
///   custom builder).
/// - [ResolvedBuilder.direct] emits the call-return widget constructor
///   directly (fallback for custom user widgets outside the built-in map).
sealed class ResolvedBuilder {
  const ResolvedBuilder();

  const factory ResolvedBuilder.named(String className) = NamedBuilder;
  const factory ResolvedBuilder.direct() = DirectBuilder;
}

/// Dispatch through a concrete `MixWidgetBuilder` subclass by name.
class NamedBuilder extends ResolvedBuilder {
  final String className;

  const NamedBuilder(this.className);
}

/// Fallback: emit the styler's `call()` return widget constructor directly.
class DirectBuilder extends ResolvedBuilder {
  const DirectBuilder();
}
