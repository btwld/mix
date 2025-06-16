// ignore_for_file: camel_case_types

import 'package:flutter/widgets.dart';

import '../attributes/enum/enum_util.dart';
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
import '../variants/widget_state_variant.dart';
import 'element.dart';
import 'modifier.dart';

extension ImageSpecUtilityDeprecationX<T extends StyleElement>
    on ImageSpecUtility<T> {
  @Deprecated(
    'To match Flutter naming conventions, use `colorBlendMode` instead.',
  )
  BlendModeUtility<T> get blendMode => colorBlendMode;
}

@Deprecated('Use `MixWidgetStateVariant` instead.')
typedef WidgetContextVariant = MixWidgetStateVariant;

@Deprecated('Use `OnFocusedVariant` instead.')
typedef OnFocusVariant = OnFocusedVariant;

@Deprecated('Use `OnNotVariant(OnDisabledVariant())` instead.')
class OnEnabledVariant extends OnDisabledVariant {
  const OnEnabledVariant();

  @override
  bool when(BuildContext context) => !super.when(context);
}

@Deprecated('Use `WidgetModifierSpec` instead.')
typedef WidgetModifier<T extends WidgetModifierSpec<T>> = WidgetModifierSpec<T>;

@Deprecated('Use `WidgetModifierSpecAttribute` instead.')
abstract class WidgetModifierAttribute<
        Self extends WidgetModifierSpecAttribute<Value>,
        Value extends WidgetModifierSpec<Value>>
    extends WidgetModifierSpecAttribute<Value> {
  const WidgetModifierAttribute();
}

// VisibilityUtility
@Deprecated('Use `VisibilityModifierUtility` instead.')
typedef VisibilityUtility = VisibilityModifierSpecUtility;

// OpacityUtility
@Deprecated('Use `OpacityModifierUtility` instead.')
typedef OpacityUtility = OpacityModifierSpecUtility;

// RotatedBoxWidgetUtility
@Deprecated('Use `RotatedBoxModifierUtility` instead.')
typedef RotatedBoxWidgetUtility = RotatedBoxModifierSpecUtility;

// AspectRatioUtility
@Deprecated('Use `AspectRatioModifierUtility` instead.')
typedef AspectRatioUtility = AspectRatioModifierSpecUtility;

// IntrinsicHeightWidgetUtility
@Deprecated('Use `IntrinsicHeightModifierUtility` instead.')
typedef IntrinsicHeightWidgetUtility = IntrinsicHeightModifierSpecUtility;

// IntrinsicWidthWidgetUtility
@Deprecated('Use `IntrinsicWidthModifierUtility` instead.')
typedef IntrinsicWidthWidgetUtility = IntrinsicWidthModifierSpecUtility;

// AlignWidgetUtility
@Deprecated('Use `AlignModifierUtility` instead.')
typedef AlignWidgetUtility = AlignModifierSpecUtility;

// TransformUtility
@Deprecated('Use `TransformModifierUtility` instead.')
typedef TransformUtility = TransformModifierSpecUtility;

@Deprecated('Use ClipRRectModifierSpecAttribute instead.')
typedef ClipRRectModifierAttribute = ClipRRectModifierSpecAttribute;

// ClipPath
@Deprecated('Use `ClipPathModifierSpecAttribute` instead.')
typedef ClipPathModifierAttribute = ClipPathModifierSpecAttribute;

// ClipOval
@Deprecated('Use `ClipOvalModifierSpecAttribute` instead.')
typedef ClipOvalModifierAttribute = ClipOvalModifierSpecAttribute;

// ClipRect
@Deprecated('Use `ClipRectModifierSpecAttribute` instead.')
typedef ClipRectModifierAttribute = ClipRectModifierSpecAttribute;

// ClipTriangle
@Deprecated('Use `ClipTriangleModifierSpecAttribute` instead.')
typedef ClipTriangleModifierAttribute = ClipTriangleModifierSpecAttribute;

// Align
@Deprecated('Use `AlignModifierSpecAttribute` instead.')
typedef AlignModifierAttribute = AlignModifierSpecAttribute;

// AspectRatio
@Deprecated('Use `AspectRatioModifierSpecAttribute` instead.')
typedef AspectRatioModifierAttribute = AspectRatioModifierSpecAttribute;

// Flexible
@Deprecated('Use `FlexibleModifierSpecAttribute` instead.')
typedef FlexibleModifierAttribute = FlexibleModifierSpecAttribute;

// FractionallySizedBox
@Deprecated('Use `FractionallySizedBoxModifierSpecAttribute` instead.')
typedef FractionallySizedBoxModifierAttribute
    = FractionallySizedBoxModifierSpecAttribute;

// IntrinsicHeight
@Deprecated('Use `IntrinsicHeightModifierSpecAttribute` instead.')
typedef IntrinsicHeightModifierAttribute = IntrinsicHeightModifierSpecAttribute;

// IntrinsicWidth
@Deprecated('Use `IntrinsicWidthModifierSpecAttribute` instead.')
typedef IntrinsicWidthModifierAttribute = IntrinsicWidthModifierSpecAttribute;

// Opacity
@Deprecated('Use `OpacityModifierSpecAttribute` instead.')
typedef OpacityModifierAttribute = OpacityModifierSpecAttribute;

// Padding
@Deprecated('Use `PaddingModifierSpecAttribute` instead.')
typedef PaddingModifierAttribute = PaddingModifierSpecAttribute;

// RotatedBox
@Deprecated('Use `RotatedBoxModifierSpecAttribute` instead.')
typedef RotatedBoxModifierAttribute = RotatedBoxModifierSpecAttribute;

// Transform
@Deprecated('Use `TransformModifierSpecAttribute` instead.')
typedef TransformModifierAttribute = TransformModifierSpecAttribute;

// SizedBox
@Deprecated('Use `SizedBoxModifierSpecAttribute` instead.')
typedef SizedBoxModifierAttribute = SizedBoxModifierSpecAttribute;

// Visibility
@Deprecated('Use `VisibilityModifierSpecAttribute` instead.')
typedef VisibilityModifierAttribute = VisibilityModifierSpecAttribute;

@Deprecated('Use `ClipPathModifierSpecUtility` instead.')
typedef ClipPathUtility = ClipPathModifierSpecUtility;

@Deprecated('Use `ClipRRectModifierSpecUtility` instead.')
typedef ClipRRectUtility = ClipRRectModifierSpecUtility;

@Deprecated('Use `ClipOvalModifierSpecUtility` instead.')
typedef ClipOvalUtility = ClipOvalModifierSpecUtility;

@Deprecated('Use `ClipRectModifierSpecUtility` instead.')
typedef ClipRectUtility = ClipRectModifierSpecUtility;

@Deprecated('Use `ClipTriangleModifierSpecUtility` instead.')
typedef ClipTriangleUtility = ClipTriangleModifierSpecUtility;

@Deprecated('Use `FlexibleModifierSpecUtility` instead.')
typedef FlexibleModifierUtility = FlexibleModifierSpecUtility;

@Deprecated('Use `FractionallySizedBoxModifierSpecUtility` instead.')
typedef FractionallySizedBoxModifierUtility
    = FractionallySizedBoxModifierSpecUtility;

@Deprecated('Use `SizedBoxModifierSpecUtility` instead.')
typedef SizedBoxModifierUtility = SizedBoxModifierSpecUtility;

@Deprecated('Use `PaddingModifierSpecUtility` instead.')
typedef PaddingModifierUtility = PaddingModifierSpecUtility;

// PaddingSpec
@Deprecated('Use `PaddingModifierSpec` instead.')
typedef PaddingSpec = PaddingModifierSpec;
