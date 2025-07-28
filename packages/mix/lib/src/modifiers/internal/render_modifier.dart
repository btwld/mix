// ignore_for_file: avoid-dynamic

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/modifier.dart';
import '../align_modifier.dart';
import '../aspect_ratio_modifier.dart';
import '../clip_modifier.dart';
import '../flexible_modifier.dart';
import '../fractionally_sized_box_modifier.dart';
import '../icon_theme_modifier.dart';
import '../intrinsic_modifier.dart';
import '../opacity_modifier.dart';
import '../padding_modifier.dart';
import '../rotated_box_modifier.dart';
import '../sized_box_modifier.dart';
import '../transform_modifier.dart';
import '../visibility_modifier.dart';

// Note: The default ordering of modifiers has been moved to ModifierConfig._defaultOrder

@internal
class RenderModifiers extends StatelessWidget {
  const RenderModifiers({
    required this.child,
    required this.modifiers,
    @Deprecated('Use ModifierConfig to specify ordering') List<Type>? orderOfModifiers,
    super.key,
  });

  final Widget child;
  final List<Modifier<dynamic>> modifiers;

  @override
  Widget build(BuildContext context) {
    return _RenderModifiers(
      modifiers: modifiers.reversed,
      child: child,
    );
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

// Note: The ordering logic has been moved to ModifierConfig.resolve()
// These methods are kept for backwards compatibility but are deprecated

@Deprecated('Use ModifierConfig.resolve() instead')
@visibleForTesting
List<Modifier<dynamic>> combineModifiers(
  List<Modifier<dynamic>> modifiers,
  List<Type> orderOfModifiers, {
  List<Type>? defaultOrder,
}) {
  return orderModifiers(
    orderOfModifiers,
    modifiers,
    defaultOrder: defaultOrder,
  );
}

@Deprecated('Use ModifierConfig.resolve() instead')
@visibleForTesting
List<Modifier<dynamic>> orderModifiers(
  List<Type> orderOfModifiers,
  List<Modifier<dynamic>> modifiers, {
  List<Type>? defaultOrder,
}) {
  // This implementation is kept for backwards compatibility
  // The actual ordering logic is now in ModifierConfig._orderModifiers
  final listOfModifiers = ({
    ...orderOfModifiers,
    ...defaultOrder ?? [],
    ...modifiers.map((e) => e.type),
  }).toList();

  final specs = <Modifier<dynamic>>[];

  for (final modifierType in listOfModifiers) {
    final modifier = modifiers.where((e) => e.type == modifierType).firstOrNull;
    if (modifier == null) continue;
    specs.add(modifier as Modifier<Modifier<dynamic>>);
  }

  return specs;
}
