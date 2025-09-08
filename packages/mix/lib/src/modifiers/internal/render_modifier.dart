// ignore_for_file: avoid-dynamic

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/modifier.dart';

/// Renders a widget with applied modifiers in the correct order.
@internal
class RenderModifiers extends StatelessWidget {
  /// Creates a widget that applies [widgetModifiers] to a [child] widget.
  const RenderModifiers({
    required this.child,
    required this.widgetModifiers,
    super.key,
  });

  /// Widget to which modifiers will be applied.
  final Widget child;

  /// List of modifiers to apply to the [child].
  final List<WidgetModifier> widgetModifiers;

  @override
  Widget build(BuildContext context) {
    return _RenderModifiers(modifiers: widgetModifiers.reversed, child: child);
  }
}

/// Internal widget that iteratively applies modifiers to a child widget.
class _RenderModifiers extends StatelessWidget {
  const _RenderModifiers({required this.child, required this.modifiers});

  /// Base widget to transform.
  final Widget child;

  /// Modifiers to apply in sequence.
  final Iterable<WidgetModifier> modifiers;

  @override
  Widget build(BuildContext context) {
    var current = child;

    // Apply each modifier in sequence
    for (final spec in modifiers) {
      current = spec.build(current);
    }

    return current;
  }
}
