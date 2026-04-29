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
/// function returning a styler. The generator resolves the styler's
/// `Style<TSpec>` spec, looks up `@MixWidgetRenderer` on that spec class to
/// find the renderer widget, then mirrors the renderer's constructor onto the
/// generated wrapper.
///
/// ## How wrapper parameters are chosen
///
/// The renderer widget's unnamed constructor is the source of truth. The
/// generator excludes `key`, `style`, and `styleSpec`, and mirrors every other
/// constructor parameter onto the generated wrapper. Function-backed
/// declarations also expose their public factory parameters, which shape the
/// generated base style.
///
/// ## Usage
///
/// ```dart
/// // BoxSpec is annotated with @MixWidgetRenderer(Box) inside package:mix.
/// @MixWidget()
/// final cardStyle = BoxStyler().color(Colors.white).borderRounded(8);
///
/// // For custom specs, declare the renderer once on the spec class:
/// @MixWidgetRenderer(RemixButton)
/// class RemixButtonSpec extends Spec<RemixButtonSpec> { /* ... */ }
///
/// @MixWidget()
/// RemixButtonStyle primaryButton({Color color = Colors.blue}) {
///   return RemixButtonStyle().color(color);
/// }
/// ```
///
/// - [name] overrides the generated class name (defaults to the source name
///   with a trailing `Styler`/`Style` stripped, PascalCased).
/// - Function-backed declarations expose their public parameters on the
///   wrapper constructor, so style inputs can be modeled explicitly in the
///   factory signature.
/// - The spec class must be annotated with [MixWidgetRenderer] so the
///   generator can locate the renderer widget. Specs without that annotation
///   produce a clear codegen error.
class MixWidget {
  final String? name;

  const MixWidget({this.name});
}

const mixWidget = MixWidget();

/// Declares the widget that renders a `Spec<TSpec>` for `@MixWidget` codegen.
///
/// Apply to a `Spec` subclass to register its renderer widget once. Any
/// `@MixWidget` declaration whose styler resolves to this spec then generates
/// a wrapper that delegates to [widget].
///
/// The renderer widget must:
/// - Have an unnamed constructor.
/// - Declare a `style:` named parameter assignable from the corresponding
///   `Style<TSpec>`.
/// - Be a Flutter `Widget` subtype.
///
/// `key`, `style`, and `styleSpec` are reserved on the renderer constructor;
/// every other parameter is mirrored onto the generated wrapper.
///
/// Example:
/// ```dart
/// @MixWidgetRenderer(Box)
/// final class BoxSpec extends Spec<BoxSpec> { /* ... */ }
/// ```
///
/// [widget] holds the renderer widget's [Type] literal. The generator reads it
/// via the analyzer's constant value API; no runtime reflection is involved.
class MixWidgetRenderer {
  /// The widget class that renders the annotated spec.
  final Type widget;

  const MixWidgetRenderer(this.widget);
}

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
