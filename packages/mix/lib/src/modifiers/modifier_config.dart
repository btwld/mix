import 'package:flutter/widgets.dart';

import '../core/internal/compare_mixin.dart';
import '../core/modifier.dart';
import '../core/style.dart';
import '../properties/container/container_mix.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/painting/shadow_mix.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';
import '../specs/icon/icon_attribute.dart';
import '../specs/text/text_attribute.dart';
import 'align_modifier.dart';
import 'aspect_ratio_modifier.dart';
import 'container_modifier.dart';
import 'clip_modifier.dart';
import 'default_text_style_modifier.dart';
import 'flexible_modifier.dart';
import 'fractionally_sized_box_modifier.dart';
import 'icon_theme_modifier.dart';
import 'internal/reset_modifier.dart';
import 'intrinsic_modifier.dart';
import 'opacity_modifier.dart';
import 'padding_modifier.dart';
import 'rotated_box_modifier.dart';
import 'sized_box_modifier.dart';
import 'transform_modifier.dart';
import 'visibility_modifier.dart';

final class ModifierConfig with Equatable {
  final List<Type>? $orderOfModifiers;
  final List<ModifierMix>? $modifiers;

  const ModifierConfig({
    List<ModifierMix>? modifiers,
    List<Type>? orderOfModifiers,
  }) : $modifiers = modifiers,
       $orderOfModifiers = orderOfModifiers;

  factory ModifierConfig.modifier(ModifierMix value) {
    return ModifierConfig(modifiers: [value]);
  }

  factory ModifierConfig.modifiers(List<ModifierMix> value) {
    return ModifierConfig(modifiers: value);
  }

  factory ModifierConfig.orderOfModifiers(List<Type> value) {
    return ModifierConfig(orderOfModifiers: value);
  }
  factory ModifierConfig.reset() {
    return ModifierConfig.modifier(const ResetModifierMix());
  }

  factory ModifierConfig.opacity(double opacity) {
    return ModifierConfig.modifier(OpacityModifierMix(opacity: opacity));
  }

  factory ModifierConfig.aspectRatio(double aspectRatio) {
    return ModifierConfig.modifier(
      AspectRatioModifierMix(aspectRatio: aspectRatio),
    );
  }

  factory ModifierConfig.clipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ModifierConfig.modifier(
      ClipOvalModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory ModifierConfig.clipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ModifierConfig.modifier(
      ClipRectModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory ModifierConfig.clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return ModifierConfig.modifier(
      ClipRRectModifierMix(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  factory ModifierConfig.clipPath({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return ModifierConfig.modifier(
      ClipPathModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory ModifierConfig.clipTriangle({Clip? clipBehavior}) {
    return ModifierConfig.modifier(
      ClipTriangleModifierMix(clipBehavior: clipBehavior),
    );
  }

  factory ModifierConfig.transform({Matrix4? transform, Alignment? alignment}) {
    return ModifierConfig.modifier(
      TransformModifierMix(transform: transform, alignment: alignment),
    );
  }

  /// Scale using tarnsform
  factory ModifierConfig.scale(
    double scale, {
    Alignment alignment = Alignment.center,
  }) {
    return ModifierConfig.transform(
      transform: Matrix4.diagonal3Values(scale, scale, 1.0),
      alignment: alignment,
    );
  }

  factory ModifierConfig.visibility(bool visible) {
    return ModifierConfig.modifier(VisibilityModifierMix(visible: visible));
  }

  factory ModifierConfig.align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return ModifierConfig.modifier(
      AlignModifierMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  factory ModifierConfig.padding(EdgeInsetsGeometryMix? padding) {
    return ModifierConfig.modifier(PaddingModifierMix(padding: padding));
  }

  factory ModifierConfig.sizedBox({double? width, double? height}) {
    return ModifierConfig.modifier(
      SizedBoxModifierMix(width: width, height: height),
    );
  }

  factory ModifierConfig.flexible({int? flex, FlexFit? fit}) {
    return ModifierConfig.modifier(FlexibleModifierMix(flex: flex, fit: fit));
  }

  factory ModifierConfig.rotatedBox(int quarterTurns) {
    return ModifierConfig.modifier(
      RotatedBoxModifierMix(quarterTurns: quarterTurns),
    );
  }

  factory ModifierConfig.intrinsicHeight() {
    return ModifierConfig.modifier(const IntrinsicHeightModifierMix());
  }

  factory ModifierConfig.intrinsicWidth() {
    return ModifierConfig.modifier(const IntrinsicWidthModifierMix());
  }

  factory ModifierConfig.fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return ModifierConfig.modifier(
      FractionallySizedBoxModifierMix(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  factory ModifierConfig.defaultTextStyle({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) {
    return ModifierConfig.modifier(
      DefaultTextStyleModifierMix(
        style: style,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      ),
    );
  }

  factory ModifierConfig.defaultText(TextMix textMix) {
    return ModifierConfig.modifier(
      DefaultTextStyleModifierMix.create(
        style: textMix.$style,
        textAlign: textMix.$textAlign,
        softWrap: textMix.$softWrap,
        overflow: textMix.$overflow,
        maxLines: textMix.$maxLines,
        textWidthBasis: textMix.$textWidthBasis,
        textHeightBehavior: textMix.$textHeightBehavior,
      ),
    );
  }

  factory ModifierConfig.defaultIcon(IconStyle iconMix) {
    return ModifierConfig.modifier(
      IconThemeModifierMix.create(
        color: iconMix.$color,
        size: iconMix.$size,
        fill: iconMix.$fill,
        weight: iconMix.$weight,
        grade: iconMix.$grade,
        opticalSize: iconMix.$opticalSize,
        shadows: iconMix.$shadows,
        applyTextScaling: iconMix.$applyTextScaling,
      ),
    );
  }

  factory ModifierConfig.iconTheme({
    Color? color,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    double? opacity,
    List<Shadow>? shadows,
    bool? applyTextScaling,
  }) {
    return ModifierConfig.modifier(
      IconThemeModifierMix(
        color: color,
        size: size,
        fill: fill,
        weight: weight,
        grade: grade,
        opticalSize: opticalSize,
        opacity: opacity,
        shadows: shadows?.map((shadow) => ShadowMix.value(shadow)).toList(),
        applyTextScaling: applyTextScaling,
      ),
    );
  }

  factory ModifierConfig.box(ContainerMix spec) {
    return ModifierConfig.modifier(ContainerModifierMix(spec));
  }

  void _mergeWithReset(
    Map<Object, ModifierMix> acc,
    Iterable<ModifierMix> list,
  ) {
    for (final m in list) {
      final key = m.mergeKey;
      if (key == ResetModifierMix().mergeKey) {
        acc.clear();
        continue;
      }
      acc[key] = acc[key]?.merge(m) ?? m;
    }
  }

  /// Orders modifiers according to the specified order or default order
  ///
  @visibleForTesting
  List<Modifier> reorderModifiers(List<Modifier> modifiers) {
    if (modifiers.isEmpty) return modifiers;

    final orderOfModifiers = {
      // Prioritize the order of modifiers provided by the user.
      ...?$orderOfModifiers,
      // Add the default order of modifiers.
      ..._defaultOrder,
      // Add any remaining modifiers that were not included in the order.
      ...modifiers.map((e) => e.runtimeType),
    }.toList();

    final orderedSpecs = <Modifier>[];

    for (final modifierType in orderOfModifiers) {
      // Find and add modifiers matching this type
      final modifier = modifiers
          .where((e) => e.runtimeType == modifierType)
          .firstOrNull;
      if (modifier != null) {
        orderedSpecs.add(modifier);
      }
    }

    return orderedSpecs;
  }

  ModifierConfig scale(double scale, {Alignment alignment = Alignment.center}) {
    return merge(ModifierConfig.scale(scale, alignment: alignment));
  }

  ModifierConfig opacity(double value) {
    return merge(ModifierConfig.opacity(value));
  }

  ModifierConfig aspectRatio(double value) {
    return merge(ModifierConfig.aspectRatio(value));
  }

  ModifierConfig clipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return merge(
      ModifierConfig.clipOval(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  ModifierConfig clipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return merge(
      ModifierConfig.clipRect(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  ModifierConfig modifiers(List<ModifierMix> value) {
    return merge(ModifierConfig.modifiers(value));
  }

  ModifierConfig clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      ModifierConfig.clipRRect(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  ModifierConfig clipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return merge(
      ModifierConfig.clipPath(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  ModifierConfig clipTriangle({Clip? clipBehavior}) {
    return merge(ModifierConfig.clipTriangle(clipBehavior: clipBehavior));
  }

  ModifierConfig transform({Matrix4? transform, Alignment? alignment}) {
    return merge(
      ModifierConfig.transform(transform: transform, alignment: alignment),
    );
  }

  ModifierConfig visibility(bool visible) {
    return merge(ModifierConfig.visibility(visible));
  }

  ModifierConfig align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return merge(
      ModifierConfig.align(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  ModifierConfig padding(EdgeInsetsGeometryMix? padding) {
    return merge(ModifierConfig.padding(padding));
  }

  ModifierConfig sizedBox({double? width, double? height}) {
    return merge(ModifierConfig.sizedBox(width: width, height: height));
  }

  ModifierConfig flexible({int? flex, FlexFit? fit}) {
    return merge(ModifierConfig.flexible(flex: flex, fit: fit));
  }

  ModifierConfig rotatedBox(int quarterTurns) {
    return merge(ModifierConfig.rotatedBox(quarterTurns));
  }

  ModifierConfig intrinsicHeight() {
    return merge(ModifierConfig.intrinsicHeight());
  }

  ModifierConfig intrinsicWidth() {
    return merge(ModifierConfig.intrinsicWidth());
  }

  ModifierConfig fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return merge(
      ModifierConfig.fractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  ModifierConfig defaultTextStyle({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) {
    return merge(
      ModifierConfig.defaultTextStyle(
        style: style,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      ),
    );
  }

  ModifierConfig defaultText(TextMix textMix) {
    return merge(ModifierConfig.defaultText(textMix));
  }

  ModifierConfig modifier(ModifierMix value) {
    return merge(ModifierConfig.modifier(value));
  }

  ModifierConfig orderOfModifiers(List<Type> value) {
    return merge(ModifierConfig.orderOfModifiers(value));
  }

  ModifierConfig merge(ModifierConfig? other) {
    if (other == null) return this;

    return ModifierConfig(
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      orderOfModifiers: (other.$orderOfModifiers?.isNotEmpty == true)
          ? other.$orderOfModifiers
          : $orderOfModifiers,
    );
  }

  @protected
  List<ModifierMix>? mergeModifierLists(
    List<ModifierMix>? current,
    List<ModifierMix>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List.of(other!);
    if (other == null) return List.of(current);

    final Map<Object, ModifierMix> merged = {};

    _mergeWithReset(merged, current);
    _mergeWithReset(merged, other);

    return merged.values.toList();
  }

  /// Resolves the modifiers into a properly ordered list ready for rendering.
  /// Its important to order the list before resolving to ensure the correct order of modifiers
  List<Modifier> resolve(BuildContext context) {
    if ($modifiers == null || $modifiers!.isEmpty) return [];

    // Resolve each modifier attribute to its corresponding modifier spec
    final resolvedModifiers = <Modifier>[];
    for (final attribute in $modifiers!) {
      final resolved = attribute.resolve(context);
      // Filter out reset specs so they never reach rendering
      if (resolved is! ResetModifier) {
        resolvedModifiers.add(resolved as Modifier);
      }
    }

    return reorderModifiers(resolvedModifiers);
  }

  @override
  List<Object?> get props => [$orderOfModifiers, $modifiers];
}

const _defaultOrder = [
  // === PHASE 1: CONTEXT & BEHAVIOR SETUP ===

  // 1. FlexibleModifier: Controls flex behavior when used inside Row, Column, or Flex widgets.
  // Applied first to establish how the widget participates in flex layouts.
  FlexibleModifier,

  // 2. VisibilityModifier: Controls overall visibility with early exit optimization.
  // If invisible, subsequent modifiers are skipped, improving performance.
  VisibilityModifier,

  // 3. IconThemeModifier: Provides default icon styling context to descendant Icon widgets.
  // Applied early to establish icon theme before any layout calculations.
  IconThemeModifier,

  // 4. DefaultTextStyleModifier: Provides default text styling context to descendant Text widgets.
  // Applied early alongside IconTheme to establish text theme context before layout.
  DefaultTextStyleModifier,

  // === PHASE 2: SIZE ESTABLISHMENT ===

  // 5. SizedBoxModifier: Explicitly sets widget dimensions with fixed constraints.
  // Applied early to establish concrete size before relative sizing adjustments.
  SizedBoxModifier,

  // 6. FractionallySizedBoxModifier: Sets size relative to parent dimensions.
  // Applied after explicit sizing to allow responsive scaling within constraints.
  FractionallySizedBoxModifier,

  // 7. IntrinsicHeightModifier: Adjusts height based on child's intrinsic content height.
  // Applied to allow content-driven height calculations before aspect ratio constraints.
  IntrinsicHeightModifier,

  // 8. IntrinsicWidthModifier: Adjusts width based on child's intrinsic content width.
  // Applied alongside intrinsic height for complete content-driven sizing.
  IntrinsicWidthModifier,

  // 9. AspectRatioModifier: Maintains aspect ratio within established size constraints.
  // Applied after all other sizing to preserve aspect ratio in final dimensions.
  AspectRatioModifier,

  // === PHASE 3: LAYOUT MODIFICATIONS ===

  // 10. RotatedBoxModifier: Rotates widget and changes its layout dimensions.
  // CRITICAL: Must come before AlignModifier because it changes layout space
  // (e.g., 200×100 widget becomes 100×200, affecting alignment calculations).
  RotatedBoxModifier,

  // 11. AlignModifier: Positions widget within its allocated space.
  // Applied after RotatedBox to align based on final layout dimensions.
  AlignModifier,

  // === PHASE 4: SPACING ===

  // 12. PaddingModifier: Adds spacing around the widget content.
  // Applied after layout positioning to add space without affecting layout calculations.
  PaddingModifier,

  // === PHASE 5: VISUAL-ONLY EFFECTS ===

  // 13. TransformModifier: Applies visual transformations (scale, rotate, translate).
  // IMPORTANT: Visual-only - doesn't affect layout space, unlike RotatedBoxModifier.
  TransformModifier,

  // 14. Clip Modifiers: Applies visual clipping in various shapes.
  // Applied near the end to clip the widget's final visual appearance.
  ClipOvalModifier,
  ClipRRectModifier,
  ClipPathModifier,
  ClipTriangleModifier,
  ClipRectModifier,

  // 15. OpacityModifier: Applies transparency as the final visual effect.
  // Always applied last to ensure optimal performance and correct visual layering.
  OpacityModifier,
];

final defaultModifier = {
  FlexibleModifier: FlexibleModifier(),
  VisibilityModifier: VisibilityModifier(),
  IconThemeModifier: IconThemeModifier(),
  DefaultTextStyleModifier: DefaultTextStyleModifier(),
  SizedBoxModifier: SizedBoxModifier(),
  FractionallySizedBoxModifier: FractionallySizedBoxModifier(),
  IntrinsicHeightModifier: IntrinsicHeightModifier(),
  IntrinsicWidthModifier: IntrinsicWidthModifier(),
  AspectRatioModifier: AspectRatioModifier(),
  RotatedBoxModifier: RotatedBoxModifier(),
  AlignModifier: AlignModifier(),
  PaddingModifier: PaddingModifier(),
  TransformModifier: TransformModifier(),
  ClipOvalModifier: ClipOvalModifier(),
  ClipRRectModifier: ClipRRectModifier(),
  ClipPathModifier: ClipPathModifier(),
  ClipTriangleModifier: ClipTriangleModifier(),
  OpacityModifier: OpacityModifier(),
};

class ModifierListTween extends Tween<List<Modifier>?> {
  ModifierListTween({super.begin, super.end});

  @override
  List<Modifier>? lerp(double t) {
    List<Modifier>? lerpedModifiers;
    if (end != null) {
      final thisModifiers = begin!;
      final otherModifiers = end!;

      // Create a map of modifiers by runtime type from the other list
      final thisModifierMap = <Type, Modifier>{};

      for (final modifier in thisModifiers) {
        thisModifierMap[modifier.runtimeType] = modifier;
      }

      // Lerp each modifier from this list with its matching type from other
      lerpedModifiers = [];
      for (final modifier in otherModifiers) {
        Modifier? thisModifier = thisModifierMap[modifier.runtimeType];
        thisModifier ??= defaultModifier[modifier.runtimeType] as Modifier?;

        if (thisModifier != null) {
          // Both have this modifier type, lerp them
          // We need to use dynamic dispatch here since lerp is type-specific
          final lerpedModifier = thisModifier.lerp(modifier, t) as Modifier;
          lerpedModifiers.add(lerpedModifier);
        } else {
          // Only this has the modifier, fade it out if t > 0.5

          if (t < 0.5) {
            lerpedModifiers.add(modifier);
          }
        }
      }
    }

    return lerpedModifiers;
  }
}
