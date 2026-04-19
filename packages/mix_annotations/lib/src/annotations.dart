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

/// Generates a `StatelessWidget` wrapper around a Mix styler.
///
/// Applies to a top-level final styler instance or a top-level factory
/// function returning a styler. The generator mirrors the styler's `call(...)`
/// signature onto the wrapper's constructor, then dispatches to an inferred
/// built-in builder or a custom `MixWidgetBuilder` subclass to produce the
/// final widget.
///
/// ## How the styler's `call()` drives the wrapper
///
/// Every Mix styler exposes a `call(...)` method that returns a widget:
///
/// ```dart
/// Box call({Key? key, Widget? child});                        // BoxStyler
/// FlexBox call({Key? key, required List<Widget> children});   // FlexBoxStyler
/// StyledText call(String text);                               // TextStyler
/// ```
///
/// The generator uses that signature as the source of truth for the wrapper's
/// public API: each `call()` parameter becomes a parameter on the generated
/// wrapper's constructor (positional remains positional, named remains named),
/// and the generated `build(BuildContext)` forwards them to a
/// `MixWidgetBuilder.build(style, ...)` invocation.
///
/// ## Usage
///
/// ```dart
/// // Inferred: BoxStyler → BoxBuilder → Box
/// @MixWidget()
/// final cardStyle = BoxStyler().color(Colors.white).borderRounded(8);
///
/// // Custom builder
/// @MixWidget(widgetBuilder: GlassCardBuilder())
/// final popupStyle = BoxStyler();
/// ```
///
/// - [name] overrides the generated class name (defaults to the source name
///   with a trailing `Styler`/`Style` stripped, PascalCased).
/// - [styleable] when `true` adds a `style` parameter to the wrapper that is
///   merged with the base style at build time.
/// - [widgetBuilder] optionally selects a custom widget builder. Pass an
///   unprefixed zero-argument constructor call for a user-authored
///   `MixWidgetBuilder<TSpec>` subclass, such as `GlassCardBuilder()`. Built-in
///   Mix builders are inferred automatically when omitted (e.g.
///   `BoxSpec` → `BoxBuilder`), falling back to the call-return widget when no
///   default is known.
///
/// Typed as [Object] to keep this annotation package Flutter-free; the
/// generator validates the concrete type extends `MixWidgetBuilder`.
class MixWidget {
  final String? name;
  final bool styleable;
  final Object? widgetBuilder;

  const MixWidget({this.name, this.styleable = false, this.widgetBuilder});
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
