/// Annotation for generating ModifierMix classes from WidgetModifier subclasses.
///
/// Annotate a class extending `WidgetModifier<T>` to generate the corresponding
/// `ModifierMix` class with resolve, merge, debugFillProperties, and props.
///
/// Example usage:
/// ```dart
/// @MixableModifier()
/// final class OpacityModifier extends WidgetModifier<OpacityModifier>
///     with Diagnosticable, _$OpacityModifierMethods {
///   @override
///   final double opacity;
///   const OpacityModifier([double? opacity]) : opacity = opacity ?? 1.0;
///   // build...
/// }
/// ```
///
/// This generates a `_$OpacityModifierMethods` mixin (with `copyWith`, `lerp`,
/// `debugFillProperties`, and `props`) and the `OpacityModifierMix` class in the
/// `.g.dart` part file.
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
