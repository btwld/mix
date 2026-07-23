// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/style_widget.dart';
import '../box/box_widget.dart';
import '../wrap/wrap_spec.dart';
import 'wrapbox_spec.dart';

/// [WrapBox] combines Flutter's [Container] and [Wrap] with Mix styling.
///
/// Spike prototype — not exported from `mix.dart`. Mirrors [FlexBox] shape:
/// resolves a [WrapBoxSpec], builds a [Wrap], and optionally wraps with [Box].
class WrapBox extends StyleWidget<WrapBoxSpec> {
  const WrapBox({
    super.style = const IdentityStyle(WrapBoxSpec()),
    super.styleSpec,
    super.key,
    this.children = const <Widget>[],
  });

  /// Child widgets arranged in a wrapping flow layout.
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WrapBoxSpec spec) {
    final wrapWidget = _createWrapSpecWidget(
      // Nested field is `flow` — generator reserves `wrap` for modifiers.
      spec: spec.flow?.spec,
      children: children,
    );

    if (spec.box != null) {
      return Box(styleSpec: spec.box!, child: wrapWidget);
    }

    return wrapWidget;
  }
}

/// Creates a [Wrap] widget from a [WrapSpec] with defaults.
Wrap _createWrapSpecWidget({
  required WrapSpec? spec,
  List<Widget> children = const [],
}) {
  return Wrap(
    direction: spec?.direction ?? .horizontal,
    alignment: spec?.alignment ?? .start,
    spacing: spec?.spacing ?? 0.0,
    runAlignment: spec?.runAlignment ?? .start,
    runSpacing: spec?.runSpacing ?? 0.0,
    crossAxisAlignment: spec?.crossAxisAlignment ?? .start,
    textDirection: spec?.textDirection,
    verticalDirection: spec?.verticalDirection ?? .down,
    clipBehavior: spec?.clipBehavior ?? .none,
    children: children,
  );
}
