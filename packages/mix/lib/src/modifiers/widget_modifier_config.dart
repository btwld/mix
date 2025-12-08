import 'package:flutter/widgets.dart';

import '../core/internal/compare_mixin.dart';
import '../core/style.dart';
import '../core/widget_modifier.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/painting/shadow_mix.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';
import '../specs/box/box_style.dart';
import '../specs/icon/icon_style.dart';
import '../specs/text/text_style.dart';
import 'align_modifier.dart';
import 'aspect_ratio_modifier.dart';
import 'box_modifier.dart';
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
import 'shader_mask_modifier.dart';
import 'sized_box_modifier.dart';
import 'transform_modifier.dart';
import 'visibility_modifier.dart';

/// Configuration for widget modifiers in the Mix framework.
///
/// Provides factory methods for creating and combining modifiers that can be
/// applied to widgets. Modifiers are applied in a specific order and can be
/// merged together using the Mix framework's accumulation strategy.
final class WidgetModifierConfig with Equatable {
  final List<Type>? $orderOfModifiers;
  final List<ModifierMix>? $modifiers;

  const WidgetModifierConfig({
    List<ModifierMix>? modifiers,
    List<Type>? orderOfModifiers,
  }) : $modifiers = modifiers,
       $orderOfModifiers = orderOfModifiers;

  factory WidgetModifierConfig.modifier(ModifierMix value) {
    return WidgetModifierConfig(modifiers: [value]);
  }

  factory WidgetModifierConfig.modifiers(List<ModifierMix> value) {
    return WidgetModifierConfig(modifiers: value);
  }

  factory WidgetModifierConfig.orderOfModifiers(List<Type> value) {
    return WidgetModifierConfig(orderOfModifiers: value);
  }
  factory WidgetModifierConfig.reset() {
    return WidgetModifierConfig.modifier(const ResetModifierMix());
  }

  factory WidgetModifierConfig.opacity(double opacity) {
    return WidgetModifierConfig.modifier(OpacityModifierMix(opacity: opacity));
  }

  factory WidgetModifierConfig.aspectRatio(double aspectRatio) {
    return WidgetModifierConfig.modifier(
      AspectRatioModifierMix(aspectRatio: aspectRatio),
    );
  }

  factory WidgetModifierConfig.clipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.modifier(
      ClipOvalModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.modifier(
      ClipRectModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.modifier(
      ClipRRectModifierMix(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  factory WidgetModifierConfig.clipPath({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.modifier(
      ClipPathModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipTriangle({Clip? clipBehavior}) {
    return WidgetModifierConfig.modifier(
      ClipTriangleModifierMix(clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.transform({
    Matrix4? transform,
    Alignment alignment = Alignment.center,
  }) {
    return WidgetModifierConfig.modifier(
      TransformModifierMix(transform: transform, alignment: alignment),
    );
  }

  factory WidgetModifierConfig.shaderMask({
    required ShaderCallbackBuilder shaderCallback,
    BlendMode blendMode = BlendMode.modulate,
  }) {
    return WidgetModifierConfig.modifier(
      ShaderMaskModifierMix(
        shaderCallback: shaderCallback.callback,
        blendMode: blendMode,
      ),
    );
  }

  /// Scale using transform.
  factory WidgetModifierConfig.scale({
    required double x,
    required double y,
    Alignment alignment = Alignment.center,
  }) {
    return WidgetModifierConfig.modifier(
      ScaleModifierMix(x: x, y: y, alignment: alignment),
    );
  }

  factory WidgetModifierConfig.rotate({
    required double radians,
    Alignment alignment = Alignment.center,
  }) {
    return WidgetModifierConfig.modifier(
      RotateModifierMix(radians: radians, alignment: alignment),
    );
  }

  factory WidgetModifierConfig.translate({
    required double x,
    required double y,
  }) {
    return WidgetModifierConfig.modifier(TranslateModifierMix(x: x, y: y));
  }

  factory WidgetModifierConfig.skew({
    required double skewX,
    required double skewY,
    Alignment alignment = Alignment.center,
  }) {
    return WidgetModifierConfig.modifier(
      SkewModifierMix(skewX: skewX, skewY: skewY, alignment: alignment),
    );
  }

  factory WidgetModifierConfig.visibility(bool visible) {
    return WidgetModifierConfig.modifier(
      VisibilityModifierMix(visible: visible),
    );
  }

  factory WidgetModifierConfig.align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return WidgetModifierConfig.modifier(
      AlignModifierMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  factory WidgetModifierConfig.padding(EdgeInsetsGeometryMix? padding) {
    return WidgetModifierConfig.modifier(PaddingModifierMix(padding: padding));
  }

  factory WidgetModifierConfig.sizedBox({double? width, double? height}) {
    return WidgetModifierConfig.modifier(
      SizedBoxModifierMix(width: width, height: height),
    );
  }

  factory WidgetModifierConfig.flexible({int? flex, FlexFit? fit}) {
    return WidgetModifierConfig.modifier(
      FlexibleModifierMix(flex: flex, fit: fit),
    );
  }

  factory WidgetModifierConfig.rotatedBox(int quarterTurns) {
    return WidgetModifierConfig.modifier(
      RotatedBoxModifierMix(quarterTurns: quarterTurns),
    );
  }

  factory WidgetModifierConfig.intrinsicHeight() {
    return WidgetModifierConfig.modifier(const IntrinsicHeightModifierMix());
  }

  factory WidgetModifierConfig.intrinsicWidth() {
    return WidgetModifierConfig.modifier(const IntrinsicWidthModifierMix());
  }

  factory WidgetModifierConfig.fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return WidgetModifierConfig.modifier(
      FractionallySizedBoxModifierMix(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  factory WidgetModifierConfig.defaultTextStyle({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) {
    return WidgetModifierConfig.modifier(
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

  factory WidgetModifierConfig.defaultText(TextStyler textMix) {
    return WidgetModifierConfig.modifier(
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

  factory WidgetModifierConfig.defaultIcon(IconStyler iconMix) {
    return WidgetModifierConfig.modifier(
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

  factory WidgetModifierConfig.iconTheme({
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
    return WidgetModifierConfig.modifier(
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

  factory WidgetModifierConfig.box(BoxStyler spec) {
    return WidgetModifierConfig.modifier(BoxModifierMix(spec));
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

  WidgetModifierConfig translate({required double x, required double y}) {
    return merge(WidgetModifierConfig.translate(x: x, y: y));
  }

  WidgetModifierConfig rotate({
    required double radians,
    Alignment alignment = Alignment.center,
  }) {
    return merge(
      WidgetModifierConfig.rotate(radians: radians, alignment: alignment),
    );
  }

  /// Orders modifiers according to the specified order or default order.
  @visibleForTesting
  List<WidgetModifier> reorderModifiers(List<WidgetModifier> modifiers) {
    if (modifiers.isEmpty) return modifiers;

    final orderOfModifiers = {
      // Prioritize the order of modifiers provided by the user.
      ...?$orderOfModifiers,
      // Add the default order of modifiers.
      ..._defaultOrder,
      // Add any remaining modifiers that were not included in the order.
      ...modifiers.map((e) => e.runtimeType),
    }.toList();

    final orderedSpecs = <WidgetModifier>[];

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

  WidgetModifierConfig shaderMask({
    required ShaderCallbackBuilder shaderCallback,
    BlendMode blendMode = BlendMode.modulate,
  }) {
    return merge(
      WidgetModifierConfig.shaderMask(
        shaderCallback: shaderCallback,
        blendMode: blendMode,
      ),
    );
  }

  WidgetModifierConfig scale(
    double x,
    double y, {
    Alignment alignment = Alignment.center,
  }) {
    return merge(WidgetModifierConfig.scale(x: x, y: y, alignment: alignment));
  }

  WidgetModifierConfig opacity(double value) {
    return merge(WidgetModifierConfig.opacity(value));
  }

  WidgetModifierConfig aspectRatio(double value) {
    return merge(WidgetModifierConfig.aspectRatio(value));
  }

  WidgetModifierConfig clipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      WidgetModifierConfig.clipOval(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  WidgetModifierConfig clipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      WidgetModifierConfig.clipRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  WidgetModifierConfig modifiers(List<ModifierMix> value) {
    return merge(WidgetModifierConfig.modifiers(value));
  }

  WidgetModifierConfig clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      WidgetModifierConfig.clipRRect(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  WidgetModifierConfig clipPath({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return merge(
      WidgetModifierConfig.clipPath(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }

  WidgetModifierConfig clipTriangle({Clip? clipBehavior}) {
    return merge(WidgetModifierConfig.clipTriangle(clipBehavior: clipBehavior));
  }

  WidgetModifierConfig transform({
    Matrix4? transform,
    Alignment alignment = Alignment.center,
  }) {
    return merge(
      WidgetModifierConfig.transform(
        transform: transform,
        alignment: alignment,
      ),
    );
  }

  WidgetModifierConfig visibility(bool visible) {
    return merge(WidgetModifierConfig.visibility(visible));
  }

  WidgetModifierConfig align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return merge(
      WidgetModifierConfig.align(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  WidgetModifierConfig padding(EdgeInsetsGeometryMix? padding) {
    return merge(WidgetModifierConfig.padding(padding));
  }

  WidgetModifierConfig sizedBox({double? width, double? height}) {
    return merge(WidgetModifierConfig.sizedBox(width: width, height: height));
  }

  WidgetModifierConfig flexible({int? flex, FlexFit? fit}) {
    return merge(WidgetModifierConfig.flexible(flex: flex, fit: fit));
  }

  WidgetModifierConfig rotatedBox(int quarterTurns) {
    return merge(WidgetModifierConfig.rotatedBox(quarterTurns));
  }

  WidgetModifierConfig intrinsicHeight() {
    return merge(WidgetModifierConfig.intrinsicHeight());
  }

  WidgetModifierConfig intrinsicWidth() {
    return merge(WidgetModifierConfig.intrinsicWidth());
  }

  WidgetModifierConfig fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return merge(
      WidgetModifierConfig.fractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }

  WidgetModifierConfig defaultTextStyle({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) {
    return merge(
      WidgetModifierConfig.defaultTextStyle(
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

  WidgetModifierConfig defaultText(TextStyler textMix) {
    return merge(WidgetModifierConfig.defaultText(textMix));
  }

  WidgetModifierConfig modifier(ModifierMix value) {
    return merge(WidgetModifierConfig.modifier(value));
  }

  WidgetModifierConfig orderOfModifiers(List<Type> value) {
    return merge(WidgetModifierConfig.orderOfModifiers(value));
  }

  WidgetModifierConfig merge(WidgetModifierConfig? other) {
    if (other == null) return this;

    return WidgetModifierConfig(
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
  ///
  /// It's important to order the list before resolving to ensure the correct order of modifiers.
  List<WidgetModifier> resolve(BuildContext context) {
    if ($modifiers == null || $modifiers!.isEmpty) return [];

    // Resolve each modifier attribute to its corresponding modifier spec
    final resolvedModifiers = <WidgetModifier>[];
    for (final attribute in $modifiers!) {
      final resolved = attribute.resolve(context);
      // Filter out reset specs so they never reach rendering
      if (resolved is! ResetModifier) {
        resolvedModifiers.add(resolved as WidgetModifier);
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
  ScaleModifier,
  RotateModifier,
  TranslateModifier,
  SkewModifier,

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

  // 16. ShaderMaskModifier: Applies a shader mask to the widget.
  // Applied last to ensure the shader mask is applied to the widget.
  ShaderMaskModifier,
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
  ScaleModifier: ScaleModifier(),
  RotateModifier: RotateModifier(),
  TranslateModifier: TranslateModifier(),
  SkewModifier: SkewModifier(),
  ClipOvalModifier: ClipOvalModifier(),
  ClipRRectModifier: ClipRRectModifier(),
  ClipPathModifier: ClipPathModifier(),
  ClipTriangleModifier: ClipTriangleModifier(),
  OpacityModifier: OpacityModifier(),
};

class ModifierListTween extends Tween<List<WidgetModifier>?> {
  ModifierListTween({super.begin, super.end});

  @override
  List<WidgetModifier>? lerp(double t) {
    List<WidgetModifier>? lerpedModifiers;
    if (end != null) {
      final thisModifiers = begin!;
      final otherModifiers = end!;

      // Create a map of modifiers by runtime type from the other list
      final thisModifierMap = <Type, WidgetModifier>{};

      for (final modifier in thisModifiers) {
        thisModifierMap[modifier.runtimeType] = modifier;
      }

      // Lerp each modifier from this list with its matching type from other
      lerpedModifiers = [];
      for (final modifier in otherModifiers) {
        WidgetModifier? thisModifier = thisModifierMap[modifier.runtimeType];
        thisModifier ??=
            defaultModifier[modifier.runtimeType] as WidgetModifier?;

        if (thisModifier != null) {
          // Both have this modifier type, lerp them
          // We need to use dynamic dispatch here since lerp is type-specific
          final lerpedModifier =
              thisModifier.lerp(modifier, t) as WidgetModifier;
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
