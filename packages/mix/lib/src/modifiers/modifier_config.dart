import 'package:flutter/widgets.dart';

import '../core/internal/compare_mixin.dart';
import '../core/modifier.dart';
import '../core/style.dart';
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
/// Provides factory methods for creating and combining widget modifiers that can be
/// applied to widgets. Widget modifiers are applied in a specific order and can be
/// merged together using the Mix framework's accumulation strategy.
final class WidgetModifierConfig with Equatable {
  final List<Type>? $orderOfWidgetModifiers;
  final List<WidgetModifierMix>? $widgetModifiers;

  const WidgetModifierConfig({
    List<WidgetModifierMix>? widgetModifiers,
    List<Type>? orderOfWidgetModifiers,
  }) : $widgetModifiers = widgetModifiers,
       $orderOfWidgetModifiers = orderOfWidgetModifiers;

  factory WidgetModifierConfig.widgetModifier(WidgetModifierMix value) {
    return WidgetModifierConfig(widgetModifiers: [value]);
  }

  factory WidgetModifierConfig.widgetModifiers(List<WidgetModifierMix> value) {
    return WidgetModifierConfig(widgetModifiers: value);
  }

  factory WidgetModifierConfig.orderOfWidgetModifiers(List<Type> value) {
    return WidgetModifierConfig(orderOfWidgetModifiers: value);
  }
  factory WidgetModifierConfig.reset() {
    return WidgetModifierConfig.widgetModifier(const ResetModifierMix());
  }

  factory WidgetModifierConfig.opacity(double opacity) {
    return WidgetModifierConfig.widgetModifier(OpacityModifierMix(opacity: opacity));
  }

  factory WidgetModifierConfig.aspectRatio(double aspectRatio) {
    return WidgetModifierConfig.widgetModifier(
      AspectRatioModifierMix(aspectRatio: aspectRatio),
    );
  }

  factory WidgetModifierConfig.clipOval({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.widgetModifier(
      ClipOvalModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipRect({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.widgetModifier(
      ClipRectModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipRRect({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return WidgetModifierConfig.widgetModifier(
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
    return WidgetModifierConfig.widgetModifier(
      ClipPathModifierMix(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.clipTriangle({Clip? clipBehavior}) {
    return WidgetModifierConfig.widgetModifier(
      ClipTriangleModifierMix(clipBehavior: clipBehavior),
    );
  }

  factory WidgetModifierConfig.transform({
    Matrix4? transform,
    Alignment alignment = Alignment.center,
  }) {
    return WidgetModifierConfig.widgetModifier(
      TransformModifierMix(transform: transform, alignment: alignment),
    );
  }

  factory WidgetModifierConfig.shaderMask({
    required ShaderCallbackBuilder shaderCallback,
    BlendMode blendMode = BlendMode.modulate,
  }) {
    return WidgetModifierConfig.widgetModifier(
      ShaderMaskModifierMix(
        shaderCallback: shaderCallback.callback,
        blendMode: blendMode,
      ),
    );
  }

  /// Scale using transform.
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
    return WidgetModifierConfig.widgetModifier(VisibilityModifierMix(visible: visible));
  }

  factory WidgetModifierConfig.align({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return WidgetModifierConfig.widgetModifier(
      AlignModifierMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }

  factory WidgetModifierConfig.padding(EdgeInsetsGeometryMix? padding) {
    return WidgetModifierConfig.widgetModifier(PaddingModifierMix(padding: padding));
  }

  factory WidgetModifierConfig.sizedBox({double? width, double? height}) {
    return WidgetModifierConfig.widgetModifier(
      SizedBoxModifierMix(width: width, height: height),
    );
  }

  factory WidgetModifierConfig.flexible({int? flex, FlexFit? fit}) {
    return WidgetModifierConfig.widgetModifier(FlexibleModifierMix(flex: flex, fit: fit));
  }

  factory WidgetModifierConfig.rotatedBox(int quarterTurns) {
    return WidgetModifierConfig.widgetModifier(
      RotatedBoxModifierMix(quarterTurns: quarterTurns),
    );
  }

  factory WidgetModifierConfig.intrinsicHeight() {
    return WidgetModifierConfig.widgetModifier(const IntrinsicHeightModifierMix());
  }

  factory WidgetModifierConfig.intrinsicWidth() {
    return WidgetModifierConfig.widgetModifier(const IntrinsicWidthModifierMix());
  }

  factory WidgetModifierConfig.fractionallySizedBox({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return WidgetModifierConfig.widgetModifier(
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
    return WidgetModifierConfig.widgetModifier(
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
    return WidgetModifierConfig.widgetModifier(
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
    return WidgetModifierConfig.widgetModifier(
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
    return WidgetModifierConfig.widgetModifier(
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
    return WidgetModifierConfig.widgetModifier(BoxModifierMix(spec));
  }

  void _mergeWithReset(
    Map<Object, WidgetModifierMix> acc,
    Iterable<WidgetModifierMix> list,
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

  /// Orders widget modifiers according to the specified order or default order.
  @visibleForTesting
  List<WidgetModifier> reorderWidgetModifiers(List<WidgetModifier> widgetModifiers) {
    if (widgetModifiers.isEmpty) return widgetModifiers;

    final orderOfWidgetModifiers = {
      // Prioritize the order of widget modifiers provided by the user.
      ...?$orderOfWidgetModifiers,
      // Add the default order of widget modifiers.
      ..._defaultOrder,
      // Add any remaining widget modifiers that were not included in the order.
      ...widgetModifiers.map((e) => e.runtimeType),
    }.toList();

    final orderedSpecs = <WidgetModifier>[];

    for (final widgetModifierType in orderOfWidgetModifiers) {
      // Find and add widget modifiers matching this type
      final widgetModifier = widgetModifiers
          .where((e) => e.runtimeType == widgetModifierType)
          .firstOrNull;
      if (widgetModifier != null) {
        orderedSpecs.add(widgetModifier);
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

  WidgetModifierConfig scale(double scale, {Alignment alignment = Alignment.center}) {
    return merge(WidgetModifierConfig.scale(scale, alignment: alignment));
  }

  WidgetModifierConfig opacity(double value) {
    return merge(WidgetModifierConfig.opacity(value));
  }

  WidgetModifierConfig aspectRatio(double value) {
    return merge(WidgetModifierConfig.aspectRatio(value));
  }

  WidgetModifierConfig clipOval({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return merge(
      WidgetModifierConfig.clipOval(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  WidgetModifierConfig clipRect({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return merge(
      WidgetModifierConfig.clipRect(clipper: clipper, clipBehavior: clipBehavior),
    );
  }

  WidgetModifierConfig widgetModifiers(List<WidgetModifierMix> value) {
    return merge(WidgetModifierConfig.widgetModifiers(value));
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

  WidgetModifierConfig clipPath({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return merge(
      WidgetModifierConfig.clipPath(clipper: clipper, clipBehavior: clipBehavior),
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
      WidgetModifierConfig.transform(transform: transform, alignment: alignment),
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

  WidgetModifierConfig widgetModifier(WidgetModifierMix value) {
    return merge(WidgetModifierConfig.widgetModifier(value));
  }

  WidgetModifierConfig orderOfWidgetModifiers(List<Type> value) {
    return merge(WidgetModifierConfig.orderOfWidgetModifiers(value));
  }

  WidgetModifierConfig merge(WidgetModifierConfig? other) {
    if (other == null) return this;

    return WidgetModifierConfig(
      widgetModifiers: mergeWidgetModifierLists($widgetModifiers, other.$widgetModifiers),
      orderOfWidgetModifiers: (other.$orderOfWidgetModifiers?.isNotEmpty == true)
          ? other.$orderOfWidgetModifiers
          : $orderOfWidgetModifiers,
    );
  }

  @protected
  List<WidgetModifierMix>? mergeWidgetModifierLists(
    List<WidgetModifierMix>? current,
    List<WidgetModifierMix>? other,
  ) {
    if (current == null && other == null) return null;
    if (current == null) return List.of(other!);
    if (other == null) return List.of(current);

    final Map<Object, WidgetModifierMix> merged = {};

    _mergeWithReset(merged, current);
    _mergeWithReset(merged, other);

    return merged.values.toList();
  }

  /// Resolves the widget modifiers into a properly ordered list ready for rendering.
  ///
  /// It's important to order the list before resolving to ensure the correct order of widget modifiers.
  List<WidgetModifier> resolve(BuildContext context) {
    if ($widgetModifiers == null || $widgetModifiers!.isEmpty) return [];

    // Resolve each widget modifier attribute to its corresponding widget modifier spec
    final resolvedWidgetModifiers = <WidgetModifier>[];
    for (final attribute in $widgetModifiers!) {
      final resolved = attribute.resolve(context);
      // Filter out reset specs so they never reach rendering
      if (resolved is! ResetModifier) {
        resolvedWidgetModifiers.add(resolved as WidgetModifier);
      }
    }

    return reorderWidgetModifiers(resolvedWidgetModifiers);
  }

  @override
  List<Object?> get props => [$orderOfWidgetModifiers, $widgetModifiers];
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

  // 16. ShaderMaskModifier: Applies a shader mask to the widget.
  // Applied last to ensure the shader mask is applied to the widget.
  ShaderMaskModifier,
];

final defaultWidgetModifier = {
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

class WidgetModifierListTween extends Tween<List<WidgetModifier>?> {
  WidgetModifierListTween({super.begin, super.end});

  @override
  List<WidgetModifier>? lerp(double t) {
    List<WidgetModifier>? lerpedWidgetModifiers;
    if (end != null) {
      final thisWidgetModifiers = begin!;
      final otherWidgetModifiers = end!;

      // Create a map of widget modifiers by runtime type from the other list
      final thisWidgetModifierMap = <Type, WidgetModifier>{};

      for (final widgetModifier in thisWidgetModifiers) {
        thisWidgetModifierMap[widgetModifier.runtimeType] = widgetModifier;
      }

      // Lerp each widget modifier from this list with its matching type from other
      lerpedWidgetModifiers = [];
      for (final widgetModifier in otherWidgetModifiers) {
        WidgetModifier? thisWidgetModifier = thisWidgetModifierMap[widgetModifier.runtimeType];
        thisWidgetModifier ??= defaultWidgetModifier[widgetModifier.runtimeType] as WidgetModifier?;

        if (thisWidgetModifier != null) {
          // Both have this widget modifier type, lerp them
          // We need to use dynamic dispatch here since lerp is type-specific
          final lerpedWidgetModifier = thisWidgetModifier.lerp(widgetModifier, t) as WidgetModifier;
          lerpedWidgetModifiers.add(lerpedWidgetModifier);
        } else {
          // Only this has the widget modifier, fade it out if t > 0.5

          if (t < 0.5) {
            lerpedWidgetModifiers.add(widgetModifier);
          }
        }
      }
    }

    return lerpedWidgetModifiers;
  }
}
