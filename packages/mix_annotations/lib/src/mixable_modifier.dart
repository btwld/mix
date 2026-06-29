/// Annotation for generating WidgetModifier mixins and ModifierMix classes.
///
/// Annotate a class that mixes in the generated `_$T` modifier mixin to
/// generate the corresponding `ModifierMix` class with resolve, merge,
/// debugFillProperties, and props.
///
/// Example usage:
/// ```dart
/// @MixableModifier()
/// final class OpacityModifier with _$OpacityModifier {
///   @override
///   final double opacity;
///   const OpacityModifier([double? opacity]) : opacity = opacity ?? 1.0;
///   // build...
/// }
/// ```
///
/// This generates a `_$OpacityModifier` mixin with the full
/// `WidgetModifier`/`Spec`/`Diagnosticable` contract and the
/// `OpacityModifierMix` class in the `.g.dart` part file.
///
/// Set [lerp] to `false` to skip generation of the `lerp` method and implement
/// it manually on the modifier class. Useful when interpolation needs custom
/// semantics (e.g. snapping at a specific threshold, keeping a child visible
/// through a transition) that the generator's per-field lerp can't express.
///
/// Fields can opt into a Mix-typed setter with `@MixableField(setterType: ...)`
/// when the field's runtime type has no automatic Mix counterpart (for example
/// `List<BoxShadow>`). The generated `ModifierMix` constructor then accepts the
/// Mix type and wraps it with `Prop.maybeMix`:
/// ```dart
/// @MixableModifier()
/// final class BoxShadowsModifier with _$BoxShadowsModifier {
///   @MixableField(setterType: BoxShadowListMix)
///   @override
///   final List<BoxShadow> boxShadows;
///   // ...
/// }
/// ```
class MixableModifier {
  /// Whether to generate the `lerp` method. Defaults to `true`.
  ///
  /// When `false`, the host class must implement `lerp` itself.
  final bool lerp;

  const MixableModifier({this.lerp = true});
}

const mixableModifier = MixableModifier();
