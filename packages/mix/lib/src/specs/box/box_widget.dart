import 'package:flutter/widgets.dart';

import '../../core/factory/style_mix.dart';
import '../../core/styled_widget.dart';
import 'box_spec.dart';
import 'box_style.dart';

/// A [Container] equivalent widget for applying styles using Mix.
///
/// `Box` is a concrete implementation of [StyleWidget] that applies custom styles
/// to a single child widget using the styling capabilities inherited from
/// [StyleWidget]. It wraps the child in a `BoxSpecWidget`, which is responsible for
/// rendering the styled output.
///
/// The primary purpose of `Box` is to provide a flexible and reusable way to style
/// widgets without the need to repeatedly define common style properties. It leverages
/// the [Style] object to define the appearance and allows inheriting styles from
/// ancestor [StyleWidget]s in the widget tree.
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
class Box extends StyleWidget<BoxSpec> {
  const Box({
    super.style = const BoxStyle(),
    super.key,

    this.child,
    super.orderOfModifiers,
  });

  /// The child widget that will receive the styles.
  final Widget? child;

  @override
  Widget build(BuildContext context, ResolvedStyle<BoxSpec> resolved) {
    return Container(
      alignment: resolved.spec.alignment,
      padding: resolved.spec.padding,
      decoration: resolved.spec.decoration,
      foregroundDecoration: resolved.spec.foregroundDecoration,
      width: resolved.spec.width,
      height: resolved.spec.height,
      constraints: resolved.spec.constraints,
      margin: resolved.spec.margin,
      transform: resolved.spec.transform,
      transformAlignment: resolved.spec.transformAlignment,
      clipBehavior: resolved.spec.clipBehavior ?? Clip.none,
      child: child,
    );
  }
}
