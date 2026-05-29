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
class MixableModifier {
  const MixableModifier();
}

const mixableModifier = MixableModifier();
