/// Model for `@MixWidget`-driven `StatelessWidget` generation.
///
/// Encapsulates the inputs the builder needs to emit the widget class.
///
/// The generator does all element-level inspection; this model is the
/// dependency surface the builder reads from — no analyzer types leak past
/// this boundary, which makes the builder unit-testable with a hand-rolled
/// [MixWidgetModel].
library;

/// One parameter on the generated widget's constructor.
class MixWidgetParam {
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

  const MixWidgetParam({
    required this.name,
    required this.typeCode,
    required this.isPositional,
    required this.isRequired,
    this.defaultValueCode,
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
  final List<MixWidgetParam> factoryParams;

  /// Styler `call()` parameters, excluding `Key? key`.
  ///
  /// [stylerCallForwardsKey] handles `key` separately. Ordering preserves
  /// positionals first, then named parameters.
  final List<MixWidgetParam> callParams;

  /// `true` when the styler's `call()` declares a `Key? key` named parameter
  /// and the generated `build()` forwards `key: this.key`.
  final bool stylerCallForwardsKey;

  /// Doc comment carried over from the annotated element (with leading
  /// `///` markers intact), or `null` when the element has no doc.
  final String? doc;

  const MixWidgetModel({
    required this.widgetName,
    required this.factoryReference,
    required this.isFunctionFactory,
    required this.factoryParams,
    required this.callParams,
    required this.stylerCallForwardsKey,
    this.doc,
  });

  /// All constructor parameters in emission order: factory params first
  /// (mirrors the factory signature shape), then named call params.
  List<MixWidgetParam> get allParams => [...factoryParams, ...callParams];
}
