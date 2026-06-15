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
class MixableModifier {
  /// Whether to generate the `lerp` method. Defaults to `true`.
  ///
  /// When `false`, the host class must implement `lerp` itself.
  final bool lerp;

  const MixableModifier({this.lerp = true});
}

const mixableModifier = MixableModifier();
