import 'generator_flags.dart';

/// Annotation for configuring generated methods and components for Spec classes.
///
/// [methods] specifies generated methods within the annotated class.
/// [components] specifies external generated code like utility classes or extensions.
class MixableSpec {
  final int methods;
  final int components;
  final List<Type> extraStylerMixins;

  const MixableSpec({
    this.methods = GeneratedSpecMethods.all,
    this.components = GeneratedSpecComponents.all,
    this.extraStylerMixins = const [],
  });
}

const mixableSpec = MixableSpec();

/// Annotation for configuring generated mixin for Styler classes.
///
/// [methods] specifies which methods to generate in the mixin.
///
/// The generated mixin includes:
/// - Abstract getters for `$`-prefixed fields
/// - Setter methods for each field
/// - `merge()` method for combining styles
/// - `resolve()` method for resolving to StyleSpec
/// - `debugFillProperties()` for diagnostics
/// - `props` getter for equality comparison
///
/// Example usage:
/// ```dart
/// @MixableStyler()
/// class BoxStyler extends Style<BoxSpec>
///     with Diagnosticable, ..., _$BoxStylerMixin {
///   final Prop<AlignmentGeometry>? $alignment;
///   // ... fields and constructors
/// }
/// ```
class MixableStyler {
  /// Flags indicating which methods to generate in the mixin.
  final int methods;

  const MixableStyler({this.methods = GeneratedStylerMethods.all});
}

const mixableStyler = MixableStyler();

/// Annotation for configuring individual fields in Styler classes.
///
/// [ignoreSetter] when true, no setter method will be generated for this field.
/// [setterType] optionally overrides the parameter type for the generated setter.
///
/// Example usage:
/// ```dart
/// @MixableField(ignoreSetter: true)
/// final Prop<Matrix4>? $transform;
///
/// @MixableField(setterType: List<ShadowMix>)
/// final Prop<List<Shadow>>? $shadows;
/// ```
class MixableField {
  /// Whether to skip generating a setter for this field.
  final bool ignoreSetter;

  /// Optional type override for the setter parameter.
  /// If not specified, the type is inferred from the field's `Prop<T>` type argument.
  final Type? setterType;

  const MixableField({this.ignoreSetter = false, this.setterType});
}

/// Annotation that drives generation of a `StatelessWidget` wrapper for a
/// `Style<S>` factory.
///
/// Apply to a top-level variable whose static type extends `Style<S>`, or to
/// a top-level function whose return type extends `Style<S>`. The generated
/// widget's constructor mirrors the factory's parameters plus the styler's
/// `call()` method parameters, and its `build()` delegates to that styler's
/// `call()`.
///
/// Example — variable-backed:
/// ```dart
/// @MixWidget()
/// final cardStyle = BoxStyler().paddingAll(16).borderRounded(12);
/// // Generates `class Card extends StatelessWidget { ... }`.
/// ```
///
/// Example — function-backed with factory parameters:
/// ```dart
/// @MixWidget()
/// BoxStyler badgeStyle({Color? color}) =>
///     BoxStyler().color(color ?? const Color(0xFF006ADC));
/// // Generates `class Badge extends StatelessWidget` whose constructor takes
/// // `color` (factory param) plus `child` (from `BoxStyler.call`).
/// ```
///
/// Requires the annotated element's name to be `lowerCamelCase` ending in
/// `Style` (for example, `cardStyle`, `primaryButtonStyle`, or
/// `_internalCardStyle`). The generator strips a trailing `Style` and
/// uppercases the first character to derive the widget class name. Names that
/// don't match this shape are rejected; use [name] to override entirely.
class MixWidget {
  /// Optional override for the generated widget's class name. When `null`,
  /// the name is derived from the annotated element's name.
  final String? name;

  const MixWidget({this.name});
}

const mixWidget = MixWidget();

/// Annotation for configuring generated mixin for Mix classes.
///
/// [methods] specifies which methods to generate in the mixin.
///
/// The generated mixin includes:
/// - `merge()` method for combining Mix instances
/// - `resolve()` method for resolving to the target type
/// - `debugFillProperties()` for diagnostics
/// - `props` getter for equality comparison
///
/// Example usage:
/// ```dart
/// @Mixable()
/// final class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>
///     with DefaultValue<BoxConstraints>, Diagnosticable, _$BoxConstraintsMixMixin {
///   final Prop<double>? $minWidth;
///   final Prop<double>? $maxWidth;
///   // ... fields and constructors
/// }
/// ```
class Mixable {
  /// Flags indicating which methods to generate in the mixin.
  final int methods;

  /// The name of the target type to resolve to.
  /// If not specified, it will be inferred from the supertype's type argument.
  final String? resolveToType;

  const Mixable({this.methods = GeneratedMixMethods.all, this.resolveToType});
}

const mixable = Mixable();
