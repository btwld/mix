import 'package:flutter/widgets.dart';

import '../core/internal/compare_mixin.dart';
import '../core/style.dart';
import '../core/widget_modifier.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/painting/shadow_mix.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';
import '../specs/text/text_attribute.dart';
import 'align_modifier.dart';
import 'aspect_ratio_modifier.dart';
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

final class WidgetModifierConfig with Equatable {
  final List<Type>? $orderOfModifiers;
  final List<WidgetModifierMix>? $modifiers;

  const WidgetModifierConfig({
    List<WidgetModifierMix>? modifiers,
    List<Type>? orderOfModifiers,
  }) : $modifiers = modifiers,
       $orderOfModifiers = orderOfModifiers;

  factory WidgetModifierConfig.modifier(WidgetModifierMix value) {
    return WidgetModifierConfig(modifiers: [value]);
  }

  factory WidgetModifierConfig.modifiers(List<WidgetModifierMix> value) {
    return WidgetModifierConfig(modifiers: value);
  }

  factory WidgetModifierConfig.orderOfModifiers(List<Type> value) {
    return WidgetModifierConfig(orderOfModifiers: value);
  }

  factory WidgetModifierConfig.opacity(double opacity) {
    return WidgetModifierConfig.modifier(
      OpacityWidgetModifierMix(opacity: opacity),
    );
  }

  factory WidgetModifierConfig.aspectRatio(double aspectRatio) {
    return WidgetModifierConfig.modifier(
      AspectRatioWidgetModifierMix(aspectRatio: aspectRatio),
    );
  }

  factory WidgetModifierConfig.clipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.modifier(
      ClipOvalWidgetModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.modifier(
      ClipRectWidgetModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.modifier(
      ClipRRectWidgetModifierMix(
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
      ClipPathWidgetModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipTriangle({Clip? clipBehavior}) {
    return WidgetModifierConfig.modifier(
      ClipTriangleWidgetModifierMix(clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.transform({
    Matrix4? transform,
    Alignment? alignment,
  }) {
    return WidgetModifierConfig.modifier(
      TransformWidgetModifierMix(transform: transform, alignment: alignment),
    );
  }

  /// Scale using tarnsform
  factory WidgetModifierConfig.scale(
    double scale, {
    Alignment alignment = Alignment.center,
  }) {
    return WidgetModifierConfig.transform(
      transform: Matrix4.diagonal3Values(scale, scale, 1.0),
      alignment: alignment,
    );
  }

  factory WidgetModifierConfig.visibility(bool visible) {
    return WidgetModifierConfig.modifier(
      VisibilityWidgetModifierMix(visible: visible),
    );
  }

  factory WidgetModifierConfig.align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return WidgetModifierConfig.modifier(
      AlignWidgetModifierMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  factory WidgetModifierConfig.padding(EdgeInsetsGeometryMix? padding) {
    return WidgetModifierConfig.modifier(
      PaddingWidgetModifierMix(padding: padding),
    );
  }

  factory WidgetModifierConfig.sizedBox({double? width, double? height}) {
    return WidgetModifierConfig.modifier(
      SizedBoxWidgetModifierMix(width: width, height: height),
    );
  }

  factory WidgetModifierConfig.flexible({int? flex, FlexFit? fit}) {
    return WidgetModifierConfig.modifier(
      FlexibleWidgetModifierMix(flex: flex, fit: fit),
    );
  }

  factory WidgetModifierConfig.rotatedBox(int quarterTurns) {
    return WidgetModifierConfig.modifier(
      RotatedBoxWidgetModifierMix(quarterTurns: quarterTurns),
    );
  }

  factory WidgetModifierConfig.intrinsicHeight() {
    return WidgetModifierConfig.modifier(
      const IntrinsicHeightWidgetModifierMix(),
    );
  }

  factory WidgetModifierConfig.intrinsicWidth() {
    return WidgetModifierConfig.modifier(
      const IntrinsicWidthWidgetModifierMix(),
    );
  }

  factory WidgetModifierConfig.fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return WidgetModifierConfig.modifier(
      FractionallySizedBoxWidgetModifierMix(
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
      DefaultTextStyleWidgetModifierMix(
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

  factory WidgetModifierConfig.defaultText(TextMix textMix) {
    return WidgetModifierConfig.modifier(
      DefaultTextStyleWidgetModifierMix.create(
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
      IconThemeWidgetModifierMix(
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

  /// Orders modifiers according to the specified order or default order
  ///
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

  WidgetModifierConfig scale(
    double scale, {
    Alignment alignment = Alignment.center,
  }) {
    return merge(WidgetModifierConfig.scale(scale, alignment: alignment));
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

  WidgetModifierConfig modifiers(List<WidgetModifierMix> value) {
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
    return merge(
      WidgetModifierConfig.clipTriangle(clipBehavior: clipBehavior),
    );
  }

  WidgetModifierConfig transform({Matrix4? transform, Alignment? alignment}) {
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

  WidgetModifierConfig defaultText(TextMix textMix) {
    return merge(WidgetModifierConfig.defaultText(textMix));
  }

  WidgetModifierConfig modifier(WidgetModifierMix value) {
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
  List<WidgetModifierMix>? mergeModifierLists(
    List<WidgetModifierMix>? current,
    List<WidgetModifierMix>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List.of(other!);
    if (other == null) return List.of(current);

    final Map<Object, WidgetModifierMix> merged = {};

    // Add current modifiers
    for (final modifier in current) {
      merged[modifier.mergeKey] = modifier;
    }

    // Merge or add other modifiers
    for (final modifier in other) {
      final key = modifier.mergeKey;

      /// If the other modifiers is a reset, clear the merged map
      if (key == ResetWidgetModifierMix().mergeKey) {
        merged.clear();
        continue;
      }
      final existing = merged[key];
      merged[key] = existing != null ? existing.merge(modifier) : modifier;
    }

    return merged.values.toList();
  }

  /// Resolves the modifiers into a properly ordered list ready for rendering.
  /// Its important to order the list before resolving to ensure the correct order of modifiers
  List<WidgetModifier> resolve(BuildContext context) {
    if ($modifiers == null || $modifiers!.isEmpty) return [];

    // Resolve each modifier attribute to its corresponding modifier spec
    final resolvedModifiers = <WidgetModifier>[];
    for (final attribute in $modifiers!) {
      final resolved = attribute.resolve(context);
      resolvedModifiers.add(resolved as WidgetModifier);
    }

    return reorderModifiers(resolvedModifiers).cast();
  }

  @override
  List<Object?> get props => [$orderOfModifiers, $modifiers];
}

const _defaultOrder = [
  // === PHASE 1: CONTEXT & BEHAVIOR SETUP ===

  // 1. FlexibleWidgetModifier: Controls flex behavior when used inside Row, Column, or Flex widgets.
  // Applied first to establish how the widget participates in flex layouts.
  FlexibleWidgetModifier,

  // 2. VisibilityWidgetModifier: Controls overall visibility with early exit optimization.
  // If invisible, subsequent modifiers are skipped, improving performance.
  VisibilityWidgetModifier,

  // 3. IconThemeWidgetModifier: Provides default icon styling context to descendant Icon widgets.
  // Applied early to establish icon theme before any layout calculations.
  IconThemeWidgetModifier,

  // 4. DefaultTextStyleWidgetModifier: Provides default text styling context to descendant Text widgets.
  // Applied early alongside IconTheme to establish text theme context before layout.
  DefaultTextStyleWidgetModifier,

  // === PHASE 2: SIZE ESTABLISHMENT ===

  // 5. SizedBoxWidgetModifier: Explicitly sets widget dimensions with fixed constraints.
  // Applied early to establish concrete size before relative sizing adjustments.
  SizedBoxWidgetModifier,

  // 6. FractionallySizedBoxWidgetModifier: Sets size relative to parent dimensions.
  // Applied after explicit sizing to allow responsive scaling within constraints.
  FractionallySizedBoxWidgetModifier,

  // 7. IntrinsicHeightWidgetModifier: Adjusts height based on child's intrinsic content height.
  // Applied to allow content-driven height calculations before aspect ratio constraints.
  IntrinsicHeightWidgetModifier,

  // 8. IntrinsicWidthWidgetModifier: Adjusts width based on child's intrinsic content width.
  // Applied alongside intrinsic height for complete content-driven sizing.
  IntrinsicWidthWidgetModifier,

  // 9. AspectRatioWidgetModifier: Maintains aspect ratio within established size constraints.
  // Applied after all other sizing to preserve aspect ratio in final dimensions.
  AspectRatioWidgetModifier,

  // === PHASE 3: LAYOUT MODIFICATIONS ===

  // 10. RotatedBoxWidgetModifier: Rotates widget and changes its layout dimensions.
  // CRITICAL: Must come before AlignWidgetModifier because it changes layout space
  // (e.g., 200×100 widget becomes 100×200, affecting alignment calculations).
  RotatedBoxWidgetModifier,

  // 11. AlignWidgetModifier: Positions widget within its allocated space.
  // Applied after RotatedBox to align based on final layout dimensions.
  AlignWidgetModifier,

  // === PHASE 4: SPACING ===

  // 12. PaddingWidgetModifier: Adds spacing around the widget content.
  // Applied after layout positioning to add space without affecting layout calculations.
  PaddingWidgetModifier,

  // === PHASE 5: VISUAL-ONLY EFFECTS ===

  // 13. TransformWidgetModifier: Applies visual transformations (scale, rotate, translate).
  // IMPORTANT: Visual-only - doesn't affect layout space, unlike RotatedBoxWidgetModifier.
  TransformWidgetModifier,

  // 14. Clip Modifiers: Applies visual clipping in various shapes.
  // Applied near the end to clip the widget's final visual appearance.
  ClipOvalWidgetModifier,
  ClipRRectWidgetModifier,
  ClipPathWidgetModifier,
  ClipTriangleWidgetModifier,
  ClipRectWidgetModifier,

  // 15. OpacityWidgetModifier: Applies transparency as the final visual effect.
  // Always applied last to ensure optimal performance and correct visual layering.
  OpacityWidgetModifier,
];
