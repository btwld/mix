// ignore_for_file: camel_case_types, unused_import

/// Consolidated file for all deprecated items in the Mix package.
///
/// This file contains all deprecated classes, typedefs, and members
/// to make it easier to track and manage deprecations.
///
/// Items are organized by category and removal version.
///
/// ## Deprecation Schedule:
/// - v2.0.0: Core element types, context types, animation types
/// - v3.0.0: Theme/Scope types
///
/// ## Usage:
/// This file is automatically exported from the main mix.dart file.
/// All deprecated items remain available for backward compatibility.
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../attributes/animation/animated_config_dto.dart';
import '../attributes/animation/animation_config.dart';
import '../attributes/border/border_dto.dart';
import '../attributes/border/border_radius_dto.dart';
import '../attributes/border/shape_border_dto.dart';
import '../attributes/constraints/constraints_dto.dart';
import '../attributes/decoration/decoration_dto.dart';
import '../attributes/decoration/image/decoration_image_dto.dart';
import '../attributes/enum/enum_util.dart';
import '../attributes/gap/space_dto.dart';
import '../attributes/gradient/gradient_dto.dart';
import '../attributes/modifiers/widget_modifiers_config.dart';
import '../attributes/shadow/shadow_dto.dart';
import '../attributes/spacing/edge_insets_dto.dart';
import '../attributes/spacing/spacing_util.dart';
import '../attributes/strut_style/strut_style_dto.dart';
import '../attributes/text_height_behavior/text_height_behavior_dto.dart';
import '../attributes/text_style/text_style_dto.dart';
import '../core/factory/mix_context.dart';
import '../core/modifier.dart';
import '../core/spec.dart';
import '../core/widget_state/widget_state_controller.dart';
import '../internal/mix_error.dart';
import '../modifiers/align_widget_modifier.dart';
import '../modifiers/aspect_ratio_widget_modifier.dart';
import '../modifiers/clip_widget_modifier.dart';
import '../modifiers/flexible_widget_modifier.dart';
import '../modifiers/fractionally_sized_box_widget_modifier.dart';
import '../modifiers/intrinsic_widget_modifier.dart';
import '../modifiers/opacity_widget_modifier.dart';
import '../modifiers/padding_widget_modifier.dart';
import '../modifiers/rotated_box_widget_modifier.dart';
import '../modifiers/sized_box_widget_modifier.dart';
import '../modifiers/transform_widget_modifier.dart';
import '../modifiers/visibility_widget_modifier.dart';
import '../specs/image/image_spec.dart';
import '../theme/mix/mix_theme.dart';
import '../theme/tokens/mix_token.dart';
import '../variants/widget_state_variant.dart';
import 'mix_element.dart';

// =============================================================================
// THEME & SCOPE DEPRECATIONS (v3.0.0)
// =============================================================================

/// Deprecated: Use MixScope instead. Will be removed in v3.0.0
@Deprecated('Use MixScope instead. Will be removed in v3.0.0')
typedef MixTheme = MixScope;

/// Deprecated: Use MixScopeData instead. Will be removed in v3.0.0
@Deprecated('Use MixScopeData instead. Will be removed in v3.0.0')
typedef MixThemeData = MixScopeData;

// =============================================================================
// CORE ELEMENT DEPRECATIONS (v2.0.0)
// =============================================================================

/// Deprecated: Use StyleElement instead
@Deprecated('Use StyleElement instead')
typedef Attribute = StyleElement;

/// Deprecated: Use StyleAttribute instead
@Deprecated('Use StyleAttribute instead')
typedef StyledAttribute = SpecAttribute;

/// Deprecated: Use Mixable instead
@Deprecated('Use Mixable instead')
typedef Dto<Value> = Mix<Value>;

/// Deprecated: Use Mixable<Color> directly instead
@Deprecated('Use Mixable<Color> directly instead of ColorDto')
typedef ColorDto = Mix<Color>;

/// Deprecated: Use Mixable<Radius> directly instead
@Deprecated('Use Mixable<Radius> directly instead of RadiusDto')
typedef RadiusDto = Mix<Radius>;

// =============================================================================
// CONTEXT & DATA DEPRECATIONS (v2.0.0)
// =============================================================================

/// Deprecated: Use MixContext instead. This will be removed in version 2.0
@Deprecated('Use MixContext instead. This will be removed in version 2.0')
typedef MixData = MixContext;

@Deprecated('Use AnimationConfig instead. This will be removed in version 2.0')
typedef AnimatedData = AnimationConfig;

// =============================================================================
// WIDGET STATE DEPRECATIONS
// =============================================================================

/// Deprecated: Use WidgetStatesController instead
@Deprecated('Use WidgetStatesController instead')
typedef MixWidgetStateController = WidgetStatesController;

/// Deprecated: Use MixWidgetStateVariant instead
@Deprecated('Use MixWidgetStateVariant instead')
typedef WidgetContextVariant = MixWidgetStateVariant;

/// Deprecated: Use OnFocusedVariant instead
@Deprecated('Use OnFocusedVariant instead')
typedef OnFocusVariant = OnFocusedVariant;

// =============================================================================
// SPACING & LAYOUT DEPRECATIONS
// =============================================================================

/// Deprecated: Use SpaceDto instead
@Deprecated('Use SpaceDto instead')
typedef SpacingSideDto = SpaceDto;

// EdgeInsetsDto is a real class, not a deprecated typedef

/// Deprecated: Use EdgeInsetsGeometryUtility instead
@Deprecated('Use EdgeInsetsGeometryUtility instead')
typedef SpacingUtility<T extends SpecAttribute> = EdgeInsetsGeometryUtility<T>;

/// Deprecated: Use EdgeInsetsGeometryDto instead
@Deprecated('Use EdgeInsetsGeometryDto instead')
typedef SpacingDto = EdgeInsetsGeometryDto<EdgeInsetsGeometry>;

// =============================================================================
// EXTENSIONS & UTILITIES (from deprecation_notices.dart)
// =============================================================================

/// Deprecated extension for ImageSpec utility
extension ImageSpecUtilityDeprecationX<T extends SpecAttribute>
    on ImageSpecUtility<T> {
  @Deprecated(
    'To match Flutter naming conventions, use `colorBlendMode` instead.',
  )
  BlendModeUtility<T> get blendMode => colorBlendMode;
}

// =============================================================================
// MODIFIER DEPRECATIONS (from deprecation_notices.dart)
// =============================================================================

/// Deprecated: Use OnNotVariant(OnDisabledVariant()) instead
@Deprecated('Use OnNotVariant(OnDisabledVariant()) instead')
class OnEnabledVariant extends OnDisabledVariant {
  const OnEnabledVariant();

  @override
  bool when(BuildContext context) => !super.when(context);
}

/// Deprecated: Use WidgetModifierSpec instead
@Deprecated('Use WidgetModifierSpec instead')
typedef WidgetModifier<T extends WidgetModifierSpec<T>> = WidgetModifierSpec<T>;

/// Deprecated: Use WidgetModifierSpecAttribute instead
@Deprecated('Use WidgetModifierSpecAttribute instead')
abstract class WidgetModifierAttribute<
  Self extends WidgetModifierSpecAttribute<Value>,
  Value extends WidgetModifierSpec<Value>
>
    extends WidgetModifierSpecAttribute<Value> {
  const WidgetModifierAttribute();
}

// =============================================================================
// MODIFIER UTILITY DEPRECATIONS (from deprecation_notices.dart)
// =============================================================================

/// Deprecated: Use VisibilityModifierUtility instead
@Deprecated('Use VisibilityModifierUtility instead')
typedef VisibilityUtility = VisibilityModifierSpecUtility;

/// Deprecated: Use OpacityModifierUtility instead
@Deprecated('Use OpacityModifierUtility instead')
typedef OpacityUtility = OpacityModifierSpecUtility;

/// Deprecated: Use RotatedBoxModifierUtility instead
@Deprecated('Use RotatedBoxModifierUtility instead')
typedef RotatedBoxWidgetUtility = RotatedBoxModifierSpecUtility;

/// Deprecated: Use AspectRatioModifierUtility instead
@Deprecated('Use AspectRatioModifierUtility instead')
typedef AspectRatioUtility = AspectRatioModifierSpecUtility;

/// Deprecated: Use IntrinsicHeightModifierUtility instead
@Deprecated('Use IntrinsicHeightModifierUtility instead')
typedef IntrinsicHeightWidgetUtility = IntrinsicHeightModifierSpecUtility;

/// Deprecated: Use IntrinsicWidthModifierUtility instead
@Deprecated('Use IntrinsicWidthModifierUtility instead')
typedef IntrinsicWidthWidgetUtility = IntrinsicWidthModifierSpecUtility;

/// Deprecated: Use AlignModifierUtility instead
@Deprecated('Use AlignModifierUtility instead')
typedef AlignWidgetUtility = AlignModifierSpecUtility;

/// Deprecated: Use TransformModifierUtility instead
@Deprecated('Use TransformModifierUtility instead')
typedef TransformUtility = TransformModifierSpecUtility;

// =============================================================================
// MODIFIER SPEC ATTRIBUTE DEPRECATIONS (from deprecation_notices.dart)
// =============================================================================

/// Deprecated: Use ClipRRectModifierSpecAttribute instead
@Deprecated('Use ClipRRectModifierSpecAttribute instead')
typedef ClipRRectModifierAttribute = ClipRRectModifierSpecAttribute;

/// Deprecated: Use ClipPathModifierSpecAttribute instead
@Deprecated('Use ClipPathModifierSpecAttribute instead')
typedef ClipPathModifierAttribute = ClipPathModifierSpecAttribute;

/// Deprecated: Use ClipOvalModifierSpecAttribute instead
@Deprecated('Use ClipOvalModifierSpecAttribute instead')
typedef ClipOvalModifierAttribute = ClipOvalModifierSpecAttribute;

/// Deprecated: Use ClipRectModifierSpecAttribute instead
@Deprecated('Use ClipRectModifierSpecAttribute instead')
typedef ClipRectModifierAttribute = ClipRectModifierSpecAttribute;

/// Deprecated: Use ClipTriangleModifierSpecAttribute instead
@Deprecated('Use ClipTriangleModifierSpecAttribute instead')
typedef ClipTriangleModifierAttribute = ClipTriangleModifierSpecAttribute;

/// Deprecated: Use AlignModifierSpecAttribute instead
@Deprecated('Use AlignModifierSpecAttribute instead')
typedef AlignModifierAttribute = AlignModifierSpecAttribute;

/// Deprecated: Use AspectRatioModifierSpecAttribute instead
@Deprecated('Use AspectRatioModifierSpecAttribute instead')
typedef AspectRatioModifierAttribute = AspectRatioModifierSpecAttribute;

/// Deprecated: Use FlexibleModifierSpecAttribute instead
@Deprecated('Use FlexibleModifierSpecAttribute instead')
typedef FlexibleModifierAttribute = FlexibleModifierSpecAttribute;

/// Deprecated: Use FractionallySizedBoxModifierSpecAttribute instead
@Deprecated('Use FractionallySizedBoxModifierSpecAttribute instead')
typedef FractionallySizedBoxModifierAttribute =
    FractionallySizedBoxModifierSpecAttribute;

/// Deprecated: Use IntrinsicHeightModifierSpecAttribute instead
@Deprecated('Use IntrinsicHeightModifierSpecAttribute instead')
typedef IntrinsicHeightModifierAttribute = IntrinsicHeightModifierSpecAttribute;

/// Deprecated: Use IntrinsicWidthModifierSpecAttribute instead
@Deprecated('Use IntrinsicWidthModifierSpecAttribute instead')
typedef IntrinsicWidthModifierAttribute = IntrinsicWidthModifierSpecAttribute;

/// Deprecated: Use OpacityModifierSpecAttribute instead
@Deprecated('Use OpacityModifierSpecAttribute instead')
typedef OpacityModifierAttribute = OpacityModifierSpecAttribute;

/// Deprecated: Use PaddingModifierSpecAttribute instead
@Deprecated('Use PaddingModifierSpecAttribute instead')
typedef PaddingModifierAttribute = PaddingModifierSpecAttribute;

/// Deprecated: Use RotatedBoxModifierSpecAttribute instead
@Deprecated('Use RotatedBoxModifierSpecAttribute instead')
typedef RotatedBoxModifierAttribute = RotatedBoxModifierSpecAttribute;

/// Deprecated: Use TransformModifierSpecAttribute instead
@Deprecated('Use TransformModifierSpecAttribute instead')
typedef TransformModifierAttribute = TransformModifierSpecAttribute;

/// Deprecated: Use SizedBoxModifierSpecAttribute instead
@Deprecated('Use SizedBoxModifierSpecAttribute instead')
typedef SizedBoxModifierAttribute = SizedBoxModifierSpecAttribute;

/// Deprecated: Use VisibilityModifierSpecAttribute instead
@Deprecated('Use VisibilityModifierSpecAttribute instead')
typedef VisibilityModifierAttribute = VisibilityModifierSpecAttribute;

// =============================================================================
// ADDITIONAL MODIFIER SPEC UTILITY DEPRECATIONS (from deprecation_notices.dart)
// =============================================================================

/// Deprecated: Use ClipPathModifierSpecUtility instead
@Deprecated('Use ClipPathModifierSpecUtility instead')
typedef ClipPathUtility = ClipPathModifierSpecUtility;

/// Deprecated: Use ClipRRectModifierSpecUtility instead
@Deprecated('Use ClipRRectModifierSpecUtility instead')
typedef ClipRRectUtility = ClipRRectModifierSpecUtility;

/// Deprecated: Use ClipOvalModifierSpecUtility instead
@Deprecated('Use ClipOvalModifierSpecUtility instead')
typedef ClipOvalUtility = ClipOvalModifierSpecUtility;

/// Deprecated: Use ClipRectModifierSpecUtility instead
@Deprecated('Use ClipRectModifierSpecUtility instead')
typedef ClipRectUtility = ClipRectModifierSpecUtility;

/// Deprecated: Use ClipTriangleModifierSpecUtility instead
@Deprecated('Use ClipTriangleModifierSpecUtility instead')
typedef ClipTriangleUtility = ClipTriangleModifierSpecUtility;

/// Deprecated: Use FlexibleModifierSpecUtility instead
@Deprecated('Use FlexibleModifierSpecUtility instead')
typedef FlexibleModifierUtility = FlexibleModifierSpecUtility;

/// Deprecated: Use FractionallySizedBoxModifierSpecUtility instead
@Deprecated('Use FractionallySizedBoxModifierSpecUtility instead')
typedef FractionallySizedBoxModifierUtility =
    FractionallySizedBoxModifierSpecUtility;

/// Deprecated: Use SizedBoxModifierSpecUtility instead
@Deprecated('Use SizedBoxModifierSpecUtility instead')
typedef SizedBoxModifierUtility = SizedBoxModifierSpecUtility;

/// Deprecated: Use PaddingModifierSpecUtility instead
@Deprecated('Use PaddingModifierSpecUtility instead')
typedef PaddingModifierUtility = PaddingModifierSpecUtility;

/// Deprecated: Use PaddingModifierSpec instead
@Deprecated('Use PaddingModifierSpec instead')
typedef PaddingSpec = PaddingModifierSpec;

// =============================================================================
// DEPRECATED EXTENSIONS
// =============================================================================

/// Deprecated extension for AnimationConfig conversion
extension AnimationConfigMixExtDeprecated on AnimationConfig {
  @Deprecated('Use AnimationConfigDto.value(this) directly instead of toDto()')
  AnimationConfigDto toDto() {
    return AnimationConfigDto(duration: duration, curve: curve, onEnd: onEnd);
  }
}

/// Deprecated extension for Color conversion
extension DeprecatedColorExt on Color {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  ColorDto toDto() => throw UnsupportedError(
    'ColorDto is deprecated. Use Prop<Color> instead.',
  );
}

/// Deprecated extension for MaterialColor conversion - preserves MaterialColor type
extension DeprecatedMaterialColorExt on MaterialColor {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  Mix<MaterialColor> toDto() => throw UnsupportedError(
    'Mix<MaterialColor> is deprecated. Use Prop<MaterialColor> instead.',
  );
}

/// Deprecated extension for Radius conversion
extension DeprecatedRadiusExt on Radius {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  RadiusDto toDto() => throw UnsupportedError(
    'RadiusDto is deprecated. Use Prop<Radius> instead.',
  );
}

// =============================================================================
// DEPRECATED EXTENSIONS - toDto() METHODS
// =============================================================================

/// Deprecated extension for Shadow conversion
extension DeprecatedShadowExt on Shadow {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  ShadowDto toDto() {
    return ShadowDto(blurRadius: blurRadius, color: color, offset: offset);
  }
}

/// Deprecated extension for List<Shadow> conversion
extension DeprecatedListShadowExt on List<Shadow> {
  @Deprecated('Use List<ShadowDto> directly instead of toDto()')
  List<ShadowDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for BoxShadow conversion
extension DeprecatedBoxShadowExt on BoxShadow {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BoxShadowDto toDto() {
    return BoxShadowDto(
      color: color,
      offset: offset,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }
}

/// Deprecated extension for List<BoxShadow> conversion
extension DeprecatedListBoxShadowExt on List<BoxShadow> {
  @Deprecated('Use List<BoxShadowDto> directly instead of toDto()')
  List<BoxShadowDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for Border conversion
extension DeprecatedBorderExt on Border {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BorderDto toDto() {
    return BorderDto(
      top: top.toDto(),
      bottom: bottom.toDto(),
      left: left.toDto(),
      right: right.toDto(),
    );
  }
}

/// Deprecated extension for List<Border> conversion
extension DeprecatedListBorderExt on List<Border> {
  @Deprecated('Use List<BorderDto> directly instead of toDto()')
  List<BorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for BorderDirectional conversion
extension DeprecatedBorderDirectionalExt on BorderDirectional {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BorderDirectionalDto toDto() {
    return BorderDirectionalDto(
      top: top.toDto(),
      bottom: bottom.toDto(),
      start: start.toDto(),
      end: end.toDto(),
    );
  }
}

/// Deprecated extension for List<BorderDirectional> conversion
extension DeprecatedListBorderDirectionalExt on List<BorderDirectional> {
  @Deprecated('Use List<BorderDirectionalDto> directly instead of toDto()')
  List<BorderDirectionalDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for BorderSide conversion
extension DeprecatedBorderSideExt on BorderSide {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BorderSideDto toDto() {
    return BorderSideDto(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }
}

/// Deprecated extension for List<BorderSide> conversion
extension DeprecatedListBorderSideExt on List<BorderSide> {
  @Deprecated('Use List<BorderSideDto> directly instead of toDto()')
  List<BorderSideDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for BoxBorder conversion
extension DeprecatedBoxBorderExt on BoxBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BoxBorderDto toDto() {
    final self = this;
    if (self is Border) {
      return BorderDto(
        top: self.top.toDto(),
        bottom: self.bottom.toDto(),
        left: self.left.toDto(),
        right: self.right.toDto(),
      );
    }
    if (self is BorderDirectional) {
      return BorderDirectionalDto(
        top: self.top.toDto(),
        bottom: self.bottom.toDto(),
        start: self.start.toDto(),
        end: self.end.toDto(),
      );
    }

    throw MixError.unsupportedTypeInDto(BoxBorder, [
      'Border',
      'BorderDirectional',
    ]);
  }
}

/// Deprecated extension for TextStyle conversion
extension DeprecatedTextStyleExt on TextStyle {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  TextStyleDto toDto() => TextStyleDto.value(this);
}

/// Deprecated extension for BoxConstraints conversion
extension DeprecatedBoxConstraintsExt on BoxConstraints {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BoxConstraintsDto toDto() {
    return BoxConstraintsDto(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }
}

/// Deprecated extension for List<BoxConstraints> conversion
extension DeprecatedListBoxConstraintsExt on List<BoxConstraints> {
  @Deprecated('Use List<BoxConstraintsDto> directly instead of toDto()')
  List<BoxConstraintsDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for BorderRadiusGeometry conversion
extension DeprecatedBorderRadiusGeometryExt on BorderRadiusGeometry {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BorderRadiusGeometryDto toDto() {
    final self = this;
    if (self is BorderRadius) {
      return BorderRadiusDto(
        topLeft: self.topLeft,
        topRight: self.topRight,
        bottomLeft: self.bottomLeft,
        bottomRight: self.bottomRight,
      );
    }
    if (self is BorderRadiusDirectional) {
      return BorderRadiusDirectionalDto(
        topStart: self.topStart,
        topEnd: self.topEnd,
        bottomStart: self.bottomStart,
        bottomEnd: self.bottomEnd,
      );
    }

    throw MixError.unsupportedTypeInDto(BorderRadiusGeometry, [
      'BorderRadius',
      'BorderRadiusDirectional',
    ]);
  }
}

/// Deprecated extension for BorderRadius conversion
extension DeprecatedBorderRadiusExt on BorderRadius {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BorderRadiusDto toDto() {
    return BorderRadiusDto(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }
}

/// Deprecated extension for List<BorderRadius> conversion
extension DeprecatedListBorderRadiusExt on List<BorderRadius> {
  @Deprecated('Use List<BorderRadiusDto> directly instead of toDto()')
  List<BorderRadiusDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for BorderRadiusDirectional conversion
extension DeprecatedBorderRadiusDirectionalExt on BorderRadiusDirectional {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BorderRadiusDirectionalDto toDto() {
    return BorderRadiusDirectionalDto(
      topStart: topStart,
      topEnd: topEnd,
      bottomStart: bottomStart,
      bottomEnd: bottomEnd,
    );
  }
}

/// Deprecated extension for List<BorderRadiusDirectional> conversion
extension DeprecatedListBorderRadiusDirectionalExt
    on List<BorderRadiusDirectional> {
  @Deprecated(
    'Use List<BorderRadiusDirectionalDto> directly instead of toDto()',
  )
  List<BorderRadiusDirectionalDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for Decoration conversion
extension DeprecatedDecorationExt on Decoration {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  DecorationDto toDto() {
    final self = this;
    if (self is BoxDecoration) return self.toDto();
    if (self is ShapeDecoration) return self.toDto();

    throw MixError.unsupportedTypeInDto(Decoration, [
      'BoxDecoration',
      'ShapeDecoration',
    ]);
  }
}

/// Deprecated extension for BoxDecoration conversion
extension DeprecatedBoxDecorationExt on BoxDecoration {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BoxDecorationDto toDto() {
    return BoxDecorationDto(
      border: border?.toDto(),
      borderRadius: borderRadius?.toDto(),
      shape: shape,
      backgroundBlendMode: backgroundBlendMode,
      color: color,
      image: image?.toDto(),
      gradient: gradient?.toDto(),
      boxShadow: boxShadow?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Deprecated extension for List<BoxDecoration> conversion
extension DeprecatedListBoxDecorationExt on List<BoxDecoration> {
  @Deprecated('Use List<BoxDecorationDto> directly instead of toDto()')
  List<BoxDecorationDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for ShapeDecoration conversion
extension DeprecatedShapeDecorationExt on ShapeDecoration {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  ShapeDecorationDto toDto() {
    return ShapeDecorationDto(
      shape: shape.toDto(),
      color: color,
      image: image?.toDto(),
      gradient: gradient?.toDto(),
      shadows: shadows?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Deprecated extension for List<ShapeDecoration> conversion
extension DeprecatedListShapeDecorationExt on List<ShapeDecoration> {
  @Deprecated('Use List<ShapeDecorationDto> directly instead of toDto()')
  List<ShapeDecorationDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for EdgeInsetsGeometry conversion
extension DeprecatedEdgeInsetsGeometryExt on EdgeInsetsGeometry {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  EdgeInsetsGeometryDto toDto() {
    final self = this;
    if (self is EdgeInsetsDirectional) {
      return EdgeInsetsDirectionalDto(
        top: self.top,
        bottom: self.bottom,
        start: self.start,
        end: self.end,
      );
    }
    if (self is EdgeInsets) {
      return EdgeInsetsDto(
        top: self.top,
        bottom: self.bottom,
        left: self.left,
        right: self.right,
      );
    }

    throw MixError.unsupportedTypeInDto(EdgeInsetsGeometry, [
      'EdgeInsetsDirectional',
      'EdgeInsets',
    ]);
  }
}

/// Deprecated extension for DecorationImage conversion
extension DecorationImageMixExtDeprecated on DecorationImage {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  DecorationImageDto toDto() {
    return DecorationImageDto(
      image: image,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      repeat: repeat,
      filterQuality: filterQuality,
      invertColors: invertColors,
      isAntiAlias: isAntiAlias,
    );
  }
}

/// Deprecated extension for List<DecorationImage> conversion
extension ListDecorationImageMixExtDeprecated on List<DecorationImage> {
  @Deprecated('Use List<DecorationImageDto> directly instead of toDto()')
  List<DecorationImageDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for Gradient conversion
extension GradientExtDeprecated on Gradient {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  GradientDto toDto() {
    final self = this;
    if (self is LinearGradient) return (self).toDto();
    if (self is RadialGradient) return (self).toDto();
    if (self is SweepGradient) return (self).toDto();

    throw MixError.unsupportedTypeInDto(Gradient, [
      'LinearGradient',
      'RadialGradient',
      'SweepGradient',
    ]);
  }
}

/// Deprecated extension for LinearGradient conversion
extension LinearGradientMixExtDeprecated on LinearGradient {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  LinearGradientDto toDto() {
    return LinearGradientDto(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }
}

/// Deprecated extension for RadialGradient conversion
extension RadialGradientMixExtDeprecated on RadialGradient {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  RadialGradientDto toDto() {
    return RadialGradientDto(
      center: center,
      radius: radius,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }
}

/// Deprecated extension for SweepGradient conversion
extension SweepGradientMixExtDeprecated on SweepGradient {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  SweepGradientDto toDto() {
    return SweepGradientDto(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }
}

/// Deprecated extension for StrutStyle conversion
extension DeprecatedStrutStyleExt on StrutStyle {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  StrutStyleDto toDto() => StrutStyleDto.value(this);
}

/// Deprecated extension for TextHeightBehavior conversion
extension DeprecatedTextHeightBehaviorExt on TextHeightBehavior {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  TextHeightBehaviorDto toDto() {
    return TextHeightBehaviorDto(
      applyHeightToFirstAscent: applyHeightToFirstAscent,
      applyHeightToLastDescent: applyHeightToLastDescent,
      leadingDistribution: leadingDistribution,
    );
  }
}

/// Deprecated extension for List<TextHeightBehavior> conversion
extension DeprecatedListTextHeightBehaviorExt on List<TextHeightBehavior> {
  @Deprecated('Use List<TextHeightBehaviorDto> directly instead of toDto()')
  List<TextHeightBehaviorDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for ShapeBorder conversion
extension DeprecatedShapeBorderExt on ShapeBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  ShapeBorderDto toDto() {
    final self = this;
    if (self is BeveledRectangleBorder) {
      return BeveledRectangleBorderDto(
        borderRadius: self.borderRadius.toDto(),
        side: self.side.toDto(),
      );
    }
    if (self is CircleBorder) {
      return CircleBorderDto(
        side: self.side.toDto(),
        eccentricity: self.eccentricity,
      );
    }
    if (self is ContinuousRectangleBorder) {
      return ContinuousRectangleBorderDto(
        borderRadius: self.borderRadius.toDto(),
        side: self.side.toDto(),
      );
    }
    if (self is LinearBorder) {
      return LinearBorderDto(
        side: self.side.toDto(),
        start: self.start?.toDto(),
        end: self.end?.toDto(),
        top: self.top?.toDto(),
        bottom: self.bottom?.toDto(),
      );
    }
    if (self is RoundedRectangleBorder) {
      return RoundedRectangleBorderDto(
        borderRadius: self.borderRadius.toDto(),
        side: self.side.toDto(),
      );
    }
    if (self is StadiumBorder) {
      return StadiumBorderDto(side: self.side.toDto());
    }
    if (self is StarBorder) {
      return StarBorderDto(
        side: self.side.toDto(),
        points: self.points,
        innerRadiusRatio: self.innerRadiusRatio,
        pointRounding: self.pointRounding,
        valleyRounding: self.valleyRounding,
        rotation: self.rotation,
        squash: self.squash,
      );
    }
    if (self is MixOutlinedBorder) return (self).toDto();

    throw FlutterError.fromParts([
      ErrorSummary('Unsupported ShapeBorder type.'),
      ErrorDescription(
        'If you are trying to create a custom ShapeBorder, it must extend MixOutlinedBorder. '
        'Otherwise, use a built-in Mix shape such as BeveledRectangleBorder, CircleBorder, '
        'ContinuousRectangleBorder, LinearBorder, RoundedRectangleBorder, StadiumBorder, or StarBorder.',
      ),
      ErrorHint(
        'Custom ShapeBorders that do not extend MixOutlinedBorder will not work with Mix.',
      ),
      DiagnosticsProperty<ShapeBorder>('The unsupported ShapeBorder was', this),
    ]);
  }
}

/// Deprecated extension for RoundedRectangleBorder conversion
extension DeprecatedRoundedRectangleBorderExt on RoundedRectangleBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  RoundedRectangleBorderDto toDto() {
    return RoundedRectangleBorderDto(
      borderRadius: borderRadius.toDto(),
      side: side.toDto(),
    );
  }
}

/// Deprecated extension for List<RoundedRectangleBorder> conversion
extension DeprecatedListRoundedRectangleBorderExt
    on List<RoundedRectangleBorder> {
  @Deprecated('Use List<RoundedRectangleBorderDto> directly instead of toDto()')
  List<RoundedRectangleBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for BeveledRectangleBorder conversion
extension BeveledRectangleBorderMixExtDeprecated on BeveledRectangleBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  BeveledRectangleBorderDto toDto() {
    return BeveledRectangleBorderDto(
      borderRadius: borderRadius.toDto(),
      side: side.toDto(),
    );
  }
}

/// Deprecated extension for List<BeveledRectangleBorder> conversion
extension ListBeveledRectangleBorderMixExtDeprecated
    on List<BeveledRectangleBorder> {
  @Deprecated('Use List<BeveledRectangleBorderDto> directly instead of toDto()')
  List<BeveledRectangleBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for ContinuousRectangleBorder conversion
extension ContinuousRectangleBorderMixExtDeprecated
    on ContinuousRectangleBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  ContinuousRectangleBorderDto toDto() {
    return ContinuousRectangleBorderDto(
      borderRadius: borderRadius.toDto(),
      side: side.toDto(),
    );
  }
}

/// Deprecated extension for List<ContinuousRectangleBorder> conversion
extension ListContinuousRectangleBorderMixExtDeprecated
    on List<ContinuousRectangleBorder> {
  @Deprecated(
    'Use List<ContinuousRectangleBorderDto> directly instead of toDto()',
  )
  List<ContinuousRectangleBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for CircleBorder conversion
extension CircleBorderMixExtDeprecated on CircleBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  CircleBorderDto toDto() {
    return CircleBorderDto(side: side.toDto(), eccentricity: eccentricity);
  }
}

/// Deprecated extension for List<CircleBorder> conversion
extension ListCircleBorderMixExtDeprecated on List<CircleBorder> {
  @Deprecated('Use List<CircleBorderDto> directly instead of toDto()')
  List<CircleBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for StarBorder conversion
extension StarBorderMixExtDeprecated on StarBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  StarBorderDto toDto() {
    return StarBorderDto(
      side: side.toDto(),
      points: points,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      rotation: rotation,
      squash: squash,
    );
  }
}

/// Deprecated extension for List<StarBorder> conversion
extension ListStarBorderMixExtDeprecated on List<StarBorder> {
  @Deprecated('Use List<StarBorderDto> directly instead of toDto()')
  List<StarBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for LinearBorder conversion
extension LinearBorderMixExtDeprecated on LinearBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  LinearBorderDto toDto() {
    return LinearBorderDto(
      side: side.toDto(),
      start: start?.toDto(),
      end: end?.toDto(),
      top: top?.toDto(),
      bottom: bottom?.toDto(),
    );
  }
}

/// Deprecated extension for List<LinearBorder> conversion
extension ListLinearBorderMixExtDeprecated on List<LinearBorder> {
  @Deprecated('Use List<LinearBorderDto> directly instead of toDto()')
  List<LinearBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for LinearBorderEdge conversion
extension LinearBorderEdgeMixExtDeprecated on LinearBorderEdge {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  LinearBorderEdgeDto toDto() {
    return LinearBorderEdgeDto(size: size, alignment: alignment);
  }
}

/// Deprecated extension for List<LinearBorderEdge> conversion
extension ListLinearBorderEdgeMixExtDeprecated on List<LinearBorderEdge> {
  @Deprecated('Use List<LinearBorderEdgeDto> directly instead of toDto()')
  List<LinearBorderEdgeDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Deprecated extension for StadiumBorder conversion
extension StadiumBorderMixExtDeprecated on StadiumBorder {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  StadiumBorderDto toDto() {
    return StadiumBorderDto(side: side.toDto());
  }
}

/// Deprecated extension for List<StadiumBorder> conversion
extension ListStadiumBorderMixExtDeprecated on List<StadiumBorder> {
  @Deprecated('Use List<StadiumBorderDto> directly instead of toDto()')
  List<StadiumBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

@Deprecated(
  'Use WidgetModifiersConfig instead. This will be removed in version 2.0',
)
typedef WidgetModifiersData = WidgetModifiersConfig;
