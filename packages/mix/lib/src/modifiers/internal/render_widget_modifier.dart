// ignore_for_file: avoid-dynamic

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/factory/mix_data.dart';
import '../../core/modifier.dart';
import '../../core/spec.dart';
import '../../theme/mix/mix_theme.dart';
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
    this.modifiers = const [],
    this.mix,
    required this.orderOfModifiers,
    super.key,
  });

  final Widget child;

  /// TODO: remove this parameter in the future
  final MixContext? mix;
  final List<Type> orderOfModifiers;
  final List<WidgetModifierSpec<dynamic>> modifiers;

  @override
  Widget build(BuildContext context) {
    return _RenderModifiers(
      modifiers: combineModifiers(mix, modifiers, orderOfModifiers).reversed,
      child: child,
    );
  }
}

class _RenderModifiers extends StatelessWidget {
  const _RenderModifiers({required this.child, required this.modifiers});

  final Widget child;
  final Iterable<WidgetModifierSpec<dynamic>> modifiers;

  @override
  Widget build(BuildContext context) {
    var current = child;

    for (final spec in modifiers) {
      current = spec.build(current);
    }

    return current;
  }
}

class RenderAnimatedModifiers extends StatelessWidget {
  const RenderAnimatedModifiers({
    super.key,
    this.modifiers = const [],
    required this.child,
    required this.duration,

    /// TODO: Remove this parameter in the future
    this.mix,
    required this.orderOfModifiers,
    this.curve = Curves.linear,
    this.onEnd,
  });

  final Widget child;
  final MixContext? mix;
  final List<Type> orderOfModifiers;
  final List<WidgetModifierSpec<dynamic>> modifiers;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    return _RenderAnimatedModifiers(
      modifiers: combineModifiers(
        mix,
        modifiers,
        orderOfModifiers,
        defaultOrder: MixTheme.maybeOf(context)?.defaultOrderOfModifiers,
      ).reversed.toList(),
      duration: duration,
      curve: curve,
      onEnd: onEnd,
      child: child,
    );
  }
}

class _RenderAnimatedModifiers extends ImplicitlyAnimatedWidget {
  const _RenderAnimatedModifiers({
    //TODO Should be required in the next version
    this.modifiers = const [],
    required this.child,
    required super.duration,
    super.curve = Curves.linear,
    super.onEnd,
  });

  final Widget child;
  final List<WidgetModifierSpec<dynamic>> modifiers;

  @override
  _RenderAnimatedModifiersState createState() =>
      _RenderAnimatedModifiersState();
}

class _RenderAnimatedModifiersState
    extends AnimatedWidgetBaseState<_RenderAnimatedModifiers> {
  final Map<Type, ModifierSpecTween> _specs = {};

  Iterable<Type> _typeOfModifiers = [];

  @override
  void initState() {
    super.initState();
    updateTypeOfAppliedModifiers();
  }

  @override
  void didUpdateWidget(covariant _RenderAnimatedModifiers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.modifiers, widget.modifiers)) {
      updateTypeOfAppliedModifiers();
      cleanUpSpecs();
    }
  }

  updateTypeOfAppliedModifiers() {
    _typeOfModifiers = widget.modifiers.map((e) => e.runtimeType);
  }

  Map<Type, ModifierSpecTween> cleanUpSpecs() {
    final difference = _specs.keys
        .toSet()
        .difference(widget.modifiers.map((e) => e.runtimeType).toSet());

    if (difference.isNotEmpty) {
      for (var e in difference) {
        _specs.remove(e);
      }
    }

    return _specs;
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    updateModifiersSpecs(visitor);
  }

  void updateModifiersSpecs(TweenVisitor<dynamic> visitor) {
    for (final spec in widget.modifiers) {
      final specType = spec.runtimeType;
      final previousSpec = _specs[specType];
      _specs[specType] = visitor(
        previousSpec,
        spec,
        (dynamic value) =>
            ModifierSpecTween(begin: value as WidgetModifierSpec),
      ) as ModifierSpecTween;
    }
  }

  @override
  Widget build(BuildContext context) {
    var current = widget.child;

    for (final modifier in _typeOfModifiers) {
      final evaluatedSpec = _specs[modifier]!.evaluate(animation);
      current = evaluatedSpec.build(current);
    }

    return current;
  }
}

class RenderSpecModifiers extends StatelessWidget {
  const RenderSpecModifiers({
    required this.orderOfModifiers,
    required this.child,
    required this.spec,
    super.key,
  });

  final Widget child;
  final List<Type> orderOfModifiers;
  final Spec spec;

  @override
  Widget build(BuildContext context) {
    final modifiers = spec.modifiers?.value ?? [];

    return spec.isAnimated
        ? RenderAnimatedModifiers(
            modifiers: modifiers,
            duration: spec.animated!.duration,
            orderOfModifiers: orderOfModifiers,
            curve: spec.animated!.curve,
            onEnd: spec.animated!.onEnd,
            child: child,
          )
        : RenderModifiers(
            modifiers: modifiers,
            orderOfModifiers: orderOfModifiers,
            child: child,
          );
  }
}

class ModifierSpecTween extends Tween<WidgetModifierSpec> {
  /// Creates an [EdgeInsetsGeometry] tween.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as an [WidgetModifierSpec]
  ModifierSpecTween({super.begin, super.end});

  /// Returns the value this variable has at the given animation clock value.
  @override
  WidgetModifierSpec lerp(double t) =>
      WidgetModifierSpec.lerpValue(begin, end, t)!;
}

List<Type> _normalizeOrderedTypes(MixContext? mix, List<Type>? orderedTypes) {
  orderedTypes ??= [];
  if (mix == null) return orderedTypes;

  final modifierAttributes = mix.whereType<WidgetModifierSpecAttribute>();

  final specs = [...orderedTypes];

  for (int i = 0; i < orderedTypes.length; i++) {
    final type = orderedTypes[i];
    // Resolve the modifier and replace the attribute type with the spec type.
    final modifier =
        modifierAttributes.where((e) => e.runtimeType == type).firstOrNull;
    if (modifier != null) {
      specs[i] = modifier.resolve(mix).runtimeType;
    }
  }

  return specs;
}

@visibleForTesting
List<WidgetModifierSpec<dynamic>> combineModifiers(
  MixContext? mix,
  List<WidgetModifierSpec<dynamic>> modifiers,
  List<Type> orderOfModifiers, {
  List<Type>? defaultOrder,
}) {
  final normalizedModifiers = _normalizeOrderedTypes(mix, orderOfModifiers);

  final mergedModifiers = [...modifiers];

  if (mix != null) {
    mergedModifiers.addAll(mix.modifiers);
  }

  return orderModifiers(
    normalizedModifiers,
    mergedModifiers,
    defaultOrder: defaultOrder,
  );
}

@visibleForTesting
List<WidgetModifierSpec<dynamic>> orderModifiers(
  List<Type> orderOfModifiers,
  List<WidgetModifierSpec<dynamic>> modifiers, {
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

  final specs = <WidgetModifierSpec<dynamic>>[];

  for (final modifierType in listOfModifiers) {
    // Resolve the modifier and add it to the list of specs.
    final modifier = modifiers.where((e) => e.type == modifierType).firstOrNull;
    if (modifier == null) continue;
    // ignore: avoid-unnecessary-type-casts
    specs.add(modifier as WidgetModifierSpec<WidgetModifierSpec<dynamic>>);
  }

  return specs;
}
