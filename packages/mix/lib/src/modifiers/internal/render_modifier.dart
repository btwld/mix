// ignore_for_file: avoid-dynamic

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/modifier.dart';

// Note: The default ordering of modifiers has been moved to ModifierConfig._defaultOrder

@internal
class RenderModifiers extends StatelessWidget {
  const RenderModifiers({
    required this.child,
    required this.modifiers,
    @Deprecated('Use ModifierConfig to specify ordering')
    List<Type>? orderOfModifiers,
    super.key,
  });

  final Widget child;
  final List<Modifier<dynamic>> modifiers;

  @override
  Widget build(BuildContext context) {
    return _RenderModifiers(modifiers: modifiers.reversed, child: child);
  }
}

class _RenderModifiers extends StatelessWidget {
  const _RenderModifiers({required this.child, required this.modifiers});

  final Widget child;
  final Iterable<Modifier<dynamic>> modifiers;

  @override
  Widget build(BuildContext context) {
    var current = child;

    for (final spec in modifiers) {
      current = spec.build(current);
    }

    return current;
  }
}
