// ignore_for_file: avoid-dynamic

import 'package:flutter/material.dart';

import '../../core/modifier.dart';
import '../align_widget_modifier.dart';
import '../aspect_ratio_widget_modifier.dart';
import '../clip_widget_modifier.dart';
import '../flexible_widget_modifier.dart';
import '../fractionally_sized_box_widget_modifier.dart';
import '../intrinsic_widget_modifier.dart';
import '../opacity_widget_modifier.dart';
import '../padding_widget_modifier.dart';
import '../rotated_box_widget_modifier.dart';
import '../sized_box_widget_modifier.dart';
import '../transform_widget_modifier.dart';
import '../visibility_widget_modifier.dart';

const _defaultOrder = [
  // 1. FlexibleModifier: When the widget is used inside a Row, Column, or Flex widget, it will
  // automatically adjust its size to fill the available space. This modifier is applied first to
  // ensure that the widget is not affected by any other modifiers.
  FlexibleModifierSpec,

  // 2. VisibilityModifier: Controls overall visibility. If the widget is set to be invisible,
  // none of the subsequent decorations are processed, providing an early exit and optimizing performance.
  VisibilityModifierSpec,

  // 3. SizedBoxModifier: Explicitly sets the size of the widget before any other transformations are applied.
  // This ensures that the widget occupies a predetermined space, which is crucial for layouts that require exact dimensions.
  SizedBoxModifierSpec,

  // 4. FractionallySizedBoxModifier: Adjusts the widget's size relative to its parent's size,
  // allowing for responsive layouts that scale with the parent widget. This modifier is applied after
  // explicit sizing to refine the widget's dimensions based on available space.
  FractionallySizedBoxModifierSpec,

  // 5. AlignModifier: Aligns the widget within its allocated space, which is especially important
  // for positioning the widget correctly before applying any transformations that could affect its position.
  // Alignment is based on the size constraints established by previous modifiers.
  AlignModifierSpec,

  // 6. IntrinsicHeightModifier: Adjusts the widget's height to fit its child's intrinsic height,
  // ensuring that the widget does not force its children to conform to an unnatural height. This is particularly
  // useful for widgets that should size themselves based on content.
  IntrinsicHeightModifierSpec,

  // 7. IntrinsicWidthModifier: Similar to the IntrinsicHeightModifier, this adjusts the widget's width
  // to its child's intrinsic width. This modifier allows for content-driven width adjustments, making it ideal
  // for widgets that need to wrap their content tightly.
  IntrinsicWidthModifierSpec,

  // 8. AspectRatioModifier: Maintains the widget's aspect ratio after sizing adjustments.
  // This modifier ensures that the widget scales correctly within its given aspect ratio constraints,
  // which is critical for preserving the visual integrity of images and other aspect-sensitive content.
  AspectRatioModifierSpec,

  // 9. TransformModifier: Applies arbitrary transformations, such as rotation, scaling, and translation.
  // Transformations are applied after all sizing and positioning adjustments to modify the widget's appearance
  // and position in more complex ways without altering the logical layout.
  TransformModifierSpec,

  // 10. PaddingModifier: Adds padding or empty space around a widget. Padding is applied after all
  // sizing adjustments to ensure that the widget's contents are not affected by the padding.
  PaddingModifierSpec,

  // 11. RotatedBoxModifier: Rotates the widget by a given angle. This modifier is applied after all sizing
  // and positioning adjustments to ensure that the widget's contents will be rotated correctly.
  RotatedBoxModifierSpec,

  // 12. Clip Modifiers: Applies clipping in various shapes to the transformed widget, shaping the final appearance.
  // Clipping is one of the last steps to ensure it is applied to the widget's final size, position, and transformation state.
  ClipOvalModifierSpec,
  ClipRRectModifierSpec,
  ClipPathModifierSpec,
  ClipTriangleModifierSpec,
  ClipRectModifierSpec,

  // 13. OpacityModifier: Modifies the widget's opacity as the final decoration step. Applying opacity last ensures
  // that it does not influence the layout or transformations, serving purely as a visual effect to alter the transparency
  // of the widget and its decorations.
  OpacityModifierSpec,
];

class RenderModifiers extends StatelessWidget {
  const RenderModifiers({
    required this.child,
    required this.modifiers,
    required this.orderOfModifiers,
    super.key,
  });

  final Widget child;
  final List<Type> orderOfModifiers;
  final List<ModifierSpec<dynamic>> modifiers;

  @override
  Widget build(BuildContext context) {
    return _RenderModifiers(
      modifiers: combineModifiers(modifiers, orderOfModifiers).reversed,
      child: child,
    );
  }
}

class _RenderModifiers extends StatelessWidget {
  const _RenderModifiers({required this.child, required this.modifiers});

  final Widget child;
  final Iterable<ModifierSpec<dynamic>> modifiers;

  @override
  Widget build(BuildContext context) {
    var current = child;

    for (final spec in modifiers) {
      current = spec.build(current);
    }

    return current;
  }
}

// RenderSpecModifiers has been removed - use RenderModifiers directly

class ModifierSpecTween extends Tween<ModifierSpec> {
  /// Creates an [EdgeInsetsGeometry] tween.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as an [ModifierSpec]
  ModifierSpecTween({super.begin, super.end});

  /// Returns the value this variable has at the given animation clock value.
  @override
  ModifierSpec lerp(double t) => ModifierSpec.lerpValue(begin, end, t)!;
}

@visibleForTesting
List<ModifierSpec<dynamic>> combineModifiers(
  List<ModifierSpec<dynamic>> modifiers,
  List<Type> orderOfModifiers, {
  List<Type>? defaultOrder,
}) {
  return orderModifiers(
    orderOfModifiers,
    modifiers,
    defaultOrder: defaultOrder,
  );
}

@visibleForTesting
List<ModifierSpec<dynamic>> orderModifiers(
  List<Type> orderOfModifiers,
  List<ModifierSpec<dynamic>> modifiers, {
  List<Type>? defaultOrder,
}) {
  final listOfModifiers = ({
    // Prioritize the order of modifiers provided by the user.
    ...orderOfModifiers,
    // Add the default order of modifiers.
    ...defaultOrder ?? _defaultOrder,
    // Add any remaining modifiers that were not included in the order.
    ...modifiers.map((e) => e.type),
  }).toList();

  final specs = <ModifierSpec<dynamic>>[];

  for (final modifierType in listOfModifiers) {
    // Resolve the modifier and add it to the list of specs.
    final modifier = modifiers.where((e) => e.type == modifierType).firstOrNull;
    if (modifier == null) continue;
    // ignore: avoid-unnecessary-type-casts
    specs.add(modifier as ModifierSpec<ModifierSpec<dynamic>>);
  }

  return specs;
}
