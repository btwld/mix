// ignore_for_file: avoid-dynamic

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/modifier.dart';

/// Renders a widget with applied modifiers in the correct order.
@internal
class RenderModifiers extends StatelessWidget {
  /// Creates a widget that applies [modifiers] to a [child] widget.
  const RenderModifiers({
    required this.child,
    required this.modifiers,
    @Deprecated('Use ModifierConfig to specify ordering')
    List<Type>? orderOfModifiers,
    super.key,
  });

  /// Widget to which modifiers will be applied.
  final Widget child;
  
  /// List of modifiers to apply to the [child].
  final List<Modifier<dynamic>> modifiers;

  @override
  Widget build(BuildContext context) {
    return _RenderModifiers(modifiers: modifiers.reversed, child: child);
  }
}

/// Internal widget that iteratively applies modifiers to a child widget.
class _RenderModifiers extends StatelessWidget {
  const _RenderModifiers({required this.child, required this.modifiers});

  /// Base widget to transform.
  final Widget child;
  
  /// Modifiers to apply in sequence.
  final Iterable<Modifier<dynamic>> modifiers;

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
