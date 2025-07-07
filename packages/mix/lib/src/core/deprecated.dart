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

import '../attributes/enum/enum_util.dart';
import '../attributes/gap/space_dto.dart';
import '../attributes/spacing/edge_insets_dto.dart';
import '../attributes/spacing/spacing_util.dart';
import '../core/element.dart';
import '../core/factory/mix_context.dart';
import '../core/modifier.dart';
import '../core/spec.dart';
import '../core/widget_state/widget_state_controller.dart';
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

@Deprecated('Use MixToken instead')
typedef MixToken = MixableToken;

/// Deprecated: Use StyleAttribute instead
@Deprecated('Use StyleAttribute instead')
typedef StyledAttribute = SpecAttribute;

/// Deprecated: Use Mixable instead
@Deprecated('Use Mixable instead')
typedef Dto<Value> = Mixable<Value>;

/// Deprecated: Use Mixable<Color> directly instead
@Deprecated('Use Mixable<Color> directly instead of ColorDto')
typedef ColorDto = Mixable<Color>;

/// Deprecated: Use Mixable<Radius> directly instead
@Deprecated('Use Mixable<Radius> directly instead of RadiusDto')
typedef RadiusDto = Mixable<Radius>;

// =============================================================================
// CONTEXT & DATA DEPRECATIONS (v2.0.0)
// =============================================================================

/// Deprecated: Use MixContext instead. This will be removed in version 2.0
@Deprecated('Use MixContext instead. This will be removed in version 2.0')
typedef MixData = MixContext;

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

/// Deprecated extension for Color conversion
extension ColorExt on Color {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  ColorDto toDto() => switch (this) {
    // Preserve MaterialColor type
    MaterialColor() => Mixable<MaterialColor>.value(this as MaterialColor),
    // Convert other Color types to Mixable<Color>
    _ => Mixable.value(this),
  };
}

/// Deprecated extension for MaterialColor conversion - preserves MaterialColor type
extension MaterialColorExt on MaterialColor {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  Mixable<MaterialColor> toDto() => Mixable.value(this);
}

/// Deprecated extension for Radius conversion
extension RadiusExt on Radius {
  @Deprecated('Use Mixable.value(this) directly instead of toDto()')
  RadiusDto toDto() => Mixable.value(this);
}

/// Deprecated convenience factory functions for RadiusDto
class RadiusDto$ {
  @Deprecated('Use Mixable.value(Radius.zero) directly instead')
  static RadiusDto zero() => const Mixable.value(Radius.zero);

  @Deprecated('Use Mixable.value(Radius.circular(radius)) directly instead')
  static RadiusDto circular(double radius) =>
      Mixable.value(Radius.circular(radius));

  @Deprecated('Use Mixable.value(Radius.elliptical(x, y)) directly instead')
  static RadiusDto elliptical(double x, double y) =>
      Mixable.value(Radius.elliptical(x, y));

  @Deprecated('Use Mixable.value(value) directly instead')
  static RadiusDto fromValue(Radius value) => Mixable.value(value);
}
