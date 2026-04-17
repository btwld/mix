import 'package:flutter/widgets.dart';

import 'spec.dart';
import 'style.dart';

/// Polymorphic mapping from a [Style] to a concrete Flutter [Widget].
///
/// Subclass this to describe how the `@MixWidget` code generator should
/// construct the underlying widget when a styler is consumed. Built-in
/// subclasses ([BoxBuilder], [RowBoxBuilder], [StyledTextBuilder], ...) ship
/// with Mix; users can subclass this for their own widgets and pass the
/// subclass to `@MixWidget(widgetBuilder: MyBuilder())`.
///
/// Typed on the [Spec] (not the styler) to match [StyleWidget]'s own contract:
/// any `Style<TSpec>` subtype — including custom stylers, merged styles, or
/// animated styles — flows through the same builder.
///
/// ## Relationship to the styler's `call()` method
///
/// Every Mix styler (`BoxStyler`, `FlexBoxStyler`, `TextStyler`, ...) exposes
/// a `call(...)` method that returns a widget, e.g.:
///
/// ```dart
/// Box call({Key? key, Widget? child});                        // BoxStyler
/// FlexBox call({Key? key, required List<Widget> children});   // FlexBoxStyler
/// StyledText call(String text);                               // TextStyler
/// StyledIcon call({Key? key, IconData? icon, String? semanticLabel});
/// ```
///
/// The `@MixWidget` generator inspects this `call(...)` signature, mirrors
/// its parameters onto the generated wrapper widget's constructor, and then
/// routes those parameters through this builder's [build] method at render
/// time. In other words: the styler's `call()` defines the *vocabulary* of
/// the wrapper, and [build] defines *how* to instantiate the final widget
/// given that vocabulary.
///
/// Concretely, for a styler whose `call()` is `Box call({Key? key, Widget? child})`,
/// the generator emits:
///
/// ```dart
/// @override
/// Widget build(BuildContext context) =>
///   const BoxBuilder().build(myStyle, key: key, child: child);
/// ```
///
/// ## Superset signature
///
/// [build] declares the *superset* of every named parameter any Mix styler's
/// `call()` might surface. Each subclass overrides [build] and uses only the
/// parameters relevant to its widget — unused parameters are ignored. The
/// generator only forwards the parameters the source styler's `call()`
/// actually exposes, so subclass overrides that omit irrelevant parameters
/// are never called with them.
///
/// Adding a new Mix widget with a new `call()` parameter requires extending
/// this base signature. The change is additive: existing subclasses keep
/// working because every parameter is optional.
abstract class MixWidgetBuilder<TSpec extends Spec<TSpec>> {
  const MixWidgetBuilder();

  /// Constructs the concrete widget for [style] using the call-time arguments
  /// surfaced by the source styler's `call(...)` method.
  ///
  /// See the class-level doc for how [key], [child], [children], [text], etc.
  /// correspond to each styler's `call()` signature. Subclasses should ignore
  /// parameters that don't apply to their widget.
  Widget build(
    Style<TSpec> style, {
    Key? key,
    Widget? child,
    List<Widget> children,
    String? text,
    IconData? icon,
    String? semanticLabel,
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  });
}
