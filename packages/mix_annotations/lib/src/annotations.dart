import 'generator_flags.dart';

/// Annotation for configuring generated methods and components for Spec classes.
///
/// [methods] specifies generated methods within the annotated class.
/// [components] specifies external generated code like utility classes or extensions.
class MixableSpec {
  final int methods;
  final int components;

  const MixableSpec({
    this.methods = GeneratedSpecMethods.all,
    this.components = GeneratedSpecComponents.all,
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
/// - `call()` method for widget creation (optional)
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

enum MixWidgetBuilderKind {
  box,
  text,
  flexBox,
  rowBox,
  columnBox,
  icon,
  image,
  stackBox,
}

class MixWidgetBuilder {
  final MixWidgetBuilderKind kind;

  const MixWidgetBuilder.box() : kind = MixWidgetBuilderKind.box;
  const MixWidgetBuilder.text() : kind = MixWidgetBuilderKind.text;
  const MixWidgetBuilder.flexBox() : kind = MixWidgetBuilderKind.flexBox;
  const MixWidgetBuilder.rowBox() : kind = MixWidgetBuilderKind.rowBox;
  const MixWidgetBuilder.columnBox() : kind = MixWidgetBuilderKind.columnBox;
  const MixWidgetBuilder.icon() : kind = MixWidgetBuilderKind.icon;
  const MixWidgetBuilder.image() : kind = MixWidgetBuilderKind.image;
  const MixWidgetBuilder.stackBox() : kind = MixWidgetBuilderKind.stackBox;
}

class MixWidget {
  final String? name;
  final bool styleable;
  final MixWidgetBuilder? widgetBuilder;

  const MixWidget({
    this.name,
    this.styleable = false,
    this.widgetBuilder,
  });
}

const mixWidget = MixWidget();

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
/// @MixableField(setterType: 'List<Shadow>')
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
