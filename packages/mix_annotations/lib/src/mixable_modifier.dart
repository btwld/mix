/// Annotation for generating ModifierMix classes from WidgetModifier subclasses.
///
/// Annotate a class extending `WidgetModifier<T>` to generate the corresponding
/// `ModifierMix` class with resolve, merge, debugFillProperties, and props.
///
/// Example usage:
/// ```dart
/// @MixableModifier()
/// final class OpacityModifier extends WidgetModifier<OpacityModifier>
///     with Diagnosticable {
///   final double opacity;
///   const OpacityModifier({double? opacity}) : opacity = opacity ?? 1.0;
///   // copyWith, lerp, build, props, debugFillProperties...
/// }
/// ```
///
/// This generates `OpacityModifierMix` in the `.g.dart` part file.
class MixableModifier {
  const MixableModifier();
}

const mixableModifier = MixableModifier();
