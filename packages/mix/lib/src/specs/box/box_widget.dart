import 'package:flutter/widgets.dart';

import '../../core/animated_spec_widget.dart';
import '../../core/spec_widget.dart';
import '../../core/styled_widget.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import 'box_spec.dart';

/// A [Container] equivalent widget for applying styles using Mix.
///
/// `Box` is a concrete implementation of [StyledWidget] that applies custom styles
/// to a single child widget using the styling capabilities inherited from
/// [StyledWidget]. It wraps the child in a `BoxSpecWidget`, which is responsible for
/// rendering the styled output.
///
/// The primary purpose of `Box` is to provide a flexible and reusable way to style
/// widgets without the need to repeatedly define common style properties. It leverages
/// the [Style] object to define the appearance and allows inheriting styles from
/// ancestor [StyledWidget]s in the widget tree.
///
/// ## Inheriting Styles
///
/// If the [inherit] property is set to `true`, `Box` will merge its defined style with
/// the style from the nearest [MixProvider] ancestor in the widget tree. This is
/// useful for cascading styles down the widget tree.
///
/// ## Performance Considerations
///
/// While `Box` provides a convenient way to style widgets, be mindful of the
/// performance implications of using complex styles and deep inheritance trees.
/// Overuse of style inheritance can lead to increased widget rebuilds and might
/// affect the performance of your application.
///
/// See also:
/// * [Style], which defines the visual properties to be applied.
/// * [BoxSpecWidget], which is used internally by `Box` to render the styled widget.
/// * [Container], which is the Flutter equivalent widget.
class Box extends StyledWidget {
  const Box({
    super.style,
    super.key,
    super.inherit,
    this.child,
    super.orderOfModifiers = const [],
  });

  /// The child widget that will receive the styles.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // Apply styling from StyledWidget to a BoxSpecWidget.
    // This method uses `SpecBuilder` to get the `MixData` and then applies it to `BoxSpecWidget`,
    // effectively styling the [child].
    return SpecBuilder(
      inherit: inherit,
      style: style,
      orderOfModifiers: orderOfModifiers,
      builder: (context) {
        final spec = BoxSpec.of(context);

        return BoxSpecWidget(
          spec: spec,
          orderOfModifiers: orderOfModifiers,
          child: child,
        );
      },
    );
  }
}

class BoxSpecWidget extends SpecWidget<BoxSpec> {
  const BoxSpecWidget({
    super.spec,
    super.key,
    this.child,
    this.orderOfModifiers = const [],
  });

  final Widget? child;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context) {
    return RenderSpecModifiers(
      spec: spec ?? const BoxSpec(),
      orderOfModifiers: orderOfModifiers,
      child: Container(
        alignment: spec?.alignment,
        padding: spec?.padding,
        decoration: spec?.decoration,
        foregroundDecoration: spec?.foregroundDecoration,
        width: spec?.width,
        height: spec?.height,
        constraints: spec?.constraints,
        margin: spec?.margin,
        transform: spec?.transform,
        transformAlignment: spec?.transformAlignment,
        clipBehavior: spec?.clipBehavior ?? Clip.none,
        child: child,
      ),
    );
  }
}

class AnimatedBoxSpecWidget extends ImplicitlyAnimatedSpecWidget<BoxSpec> {
  const AnimatedBoxSpecWidget({
    required super.spec,
    super.key,
    this.child,
    required super.duration,
    super.curve = Curves.linear,
    super.onEnd,
    this.orderOfModifiers = const [],
  });

  final Widget? child;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context, BoxSpec animatedSpec) {
    return BoxSpecWidget(
      spec: animatedSpec,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  }
}
