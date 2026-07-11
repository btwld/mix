/// Model for `@MixWidget`-driven `StatelessWidget` generation.
///
/// Encapsulates the inputs the builder needs to emit the widget class.
///
/// The generator does all element-level inspection; this model is the
/// dependency surface the builder reads from — no analyzer types leak past
/// this boundary, which makes the builder unit-testable with a hand-rolled
/// [MixWidgetModel].
library;

/// One parameter forwarded through generated widget/call APIs.
class WidgetCallParam {
  /// The parameter name.
  final String name;

  /// Dart source code for the type, written to be visible from the annotated
  /// library (already resolved by `library_scope.dart` helpers).
  final String typeCode;

  /// Whether this parameter is positional in the generated constructor.
  /// Named parameters are emitted inside `{...}`.
  final bool isPositional;

  /// Whether the parameter is required (positional-required or named-required).
  final bool isRequired;

  /// Source code for a default value, if any (verbatim from the user's source).
  final String? defaultValueCode;

  const WidgetCallParam({
    required this.name,
    required this.typeCode,
    required this.isPositional,
    required this.isRequired,
    this.defaultValueCode,
  });
}

/// One type parameter forwarded from a styler `call<T>()` method.
class WidgetCallTypeParam {
  /// The type parameter name.
  final String name;

  /// Dart source code for the explicit bound, if one exists.
  final String? boundCode;

  const WidgetCallTypeParam({required this.name, this.boundCode});

  /// Code used in a generated class declaration.
  String get declarationCode =>
      boundCode == null ? name : '$name extends $boundCode';
}

/// One named constructor generated from an enum-valued factory parameter.
class WidgetVariantConstructor {
  /// The named constructor identifier (for example, `solid`).
  final String name;

  /// Dart source code for the enum value assigned by the constructor.
  ///
  /// The enum type is already resolved for the annotated library's import
  /// scope (for example, `variants.ButtonVariant.solid`).
  final String valueCode;

  /// Doc comment copied from the enum constant, including `///` markers.
  final String? doc;

  /// A source-safe `@Deprecated(...)` annotation, when the enum constant is
  /// deprecated.
  final String? deprecationCode;

  const WidgetVariantConstructor({
    required this.name,
    required this.valueCode,
    this.doc,
    this.deprecationCode,
  });
}

/// The complete shape of a generated `@MixWidget` class.
class MixWidgetModel {
  /// The generated `StatelessWidget` class name (e.g. `Card`).
  final String widgetName;

  /// The factory's identifier — variable name for variable-backed styles,
  /// function name for function-backed styles.
  final String factoryReference;

  /// `true` when the factory is a top-level function; `false` when it's a
  /// top-level variable.
  ///
  /// Drives whether `build()` emits `factory(args).call(...)` or
  /// `factory.call(...)`.
  final bool isFunctionFactory;

  /// Factory function parameters (empty for variable-backed styles), in
  /// declaration order.
  final List<WidgetCallParam> factoryParams;

  /// Styler `call()` parameters, excluding `Key? key`.
  ///
  /// [stylerCallForwardsKey] handles `key` separately. Ordering preserves
  /// positionals first, then named parameters.
  final List<WidgetCallParam> callParams;

  /// Type parameters declared by the styler `call()` method.
  final List<WidgetCallTypeParam> callTypeParams;

  /// `true` when the styler's `call()` declares a `Key? key` named parameter
  /// and the generated `build()` forwards `key: this.key`.
  final bool stylerCallForwardsKey;

  /// Doc comment carried over from the annotated element (with leading
  /// `///` markers intact), or `null` when the element has no doc.
  final String? doc;

  /// Factory parameter initialized by [variantConstructors], or `null` when
  /// this widget has no convention-derived variant constructors.
  final String? variantParamName;

  /// Named constructors derived from the enum values of [variantParamName].
  final List<WidgetVariantConstructor> variantConstructors;

  const MixWidgetModel({
    required this.widgetName,
    required this.factoryReference,
    required this.isFunctionFactory,
    required this.factoryParams,
    required this.callParams,
    this.callTypeParams = const [],
    required this.stylerCallForwardsKey,
    this.doc,
    this.variantParamName,
    this.variantConstructors = const [],
  });

  String _typeParameterSuffix(String Function(WidgetCallTypeParam) render) {
    if (callTypeParams.isEmpty) return '';

    return '<${callTypeParams.map(render).join(', ')}>';
  }

  /// All constructor parameters in source-group order: factory params first,
  /// then styler `call()` params.
  ///
  /// The builder applies Dart constructor syntax ordering when emitting code:
  /// all positional params first, then named params.
  List<WidgetCallParam> get allParams => [...factoryParams, ...callParams];

  /// Type parameter declaration suffix for the generated widget class.
  String get typeParameterDeclaration =>
      _typeParameterSuffix((p) => p.declarationCode);

  /// Type argument suffix for forwarding to the styler `call()` method.
  String get typeParameterInvocation => _typeParameterSuffix((p) => p.name);
}
