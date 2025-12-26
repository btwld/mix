import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/style.dart' show VariantStyle;
import '../../core/style_spec.dart';
import '../../core/utility.dart';
import '../../core/utility_variant_mixin.dart';
import '../../core/utility_widget_state_variant_mixin.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../modifiers/widget_modifier_util.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'stackbox_spec.dart';
import 'stackbox_style.dart';

/// Provides mutable utility for stackbox styling with cascade notation support.
///
/// Combines box and stack styling capabilities. Supports the same API as [StackBoxStyler]
/// but maintains mutable internal state enabling fluid styling: `$stackbox..color.red()..width(100)`.
class StackBoxMutableStyler extends StyleMutableBuilder<StackBoxSpec>
    with
        UtilityVariantMixin<StackBoxStyler, StackBoxSpec>,
        UtilityWidgetStateVariantMixin<StackBoxStyler, StackBoxSpec> {
  late final padding = EdgeInsetsGeometryUtility<StackBoxStyler>(
    (prop) => mutable.merge(StackBoxStyler(padding: prop)),
  );

  late final margin = EdgeInsetsGeometryUtility<StackBoxStyler>(
    (prop) => mutable.merge(StackBoxStyler(margin: prop)),
  );

  late final constraints = BoxConstraintsUtility<StackBoxStyler>(
    (prop) => mutable.merge(StackBoxStyler(constraints: prop)),
  );

  late final decoration = DecorationUtility<StackBoxStyler>(
    (prop) => mutable.merge(StackBoxStyler(decoration: prop)),
  );

  @Deprecated(
    'Use StackBoxStyler().onHovered() and similar methods directly instead. '
    'This property was deprecated after Mix v2.0.0.',
  )
  late final on = OnContextVariantUtility<StackBoxSpec, StackBoxStyler>(
    (v) => mutable.variants([v]),
  );

  @Deprecated(
    'Use StackBoxStyler().wrap() method directly instead. '
    'This property was deprecated after Mix v2.0.0.',
  )
  late final wrap = WidgetModifierUtility(
    (prop) => mutable.wrap(WidgetModifierConfig(modifiers: [prop])),
  );

  /// Container decoration convenience accessors.
  late final border = decoration.box.border;
  late final borderRadius = decoration.box.borderRadius;
  late final color = decoration.box.color;
  late final gradient = decoration.box.gradient;
  late final shape = decoration.box.shape;

  /// Container constraint convenience accessors.
  late final width = constraints.width;
  late final height = constraints.height;
  late final minWidth = constraints.minWidth;
  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight = constraints.maxHeight;

  /// Container transformation utilities.
  late final transform = MixUtility<StackBoxStyler, Matrix4>(
    (prop) => mutable.merge(StackBoxStyler(transform: prop)),
  );
  late final transformAlignment = MixUtility<StackBoxStyler, AlignmentGeometry>(
    (prop) => mutable.merge(StackBoxStyler(transformAlignment: prop)),
  );
  late final clipBehavior = MixUtility<StackBoxStyler, Clip>(
    (prop) => mutable.merge(StackBoxStyler(clipBehavior: prop)),
  );

  late final alignment = MixUtility<StackBoxStyler, AlignmentGeometry>(
    (prop) => mutable.merge(StackBoxStyler(alignment: prop)),
  );

  /// Stack layout utilities.
  late final stackAlignment = MixUtility<StackBoxStyler, AlignmentGeometry>(
    (prop) => mutable.merge(StackBoxStyler(stackAlignment: prop)),
  );

  late final fit = MixUtility<StackBoxStyler, StackFit>(
    (prop) => mutable.merge(StackBoxStyler(fit: prop)),
  );

  late final textDirection = MixUtility<StackBoxStyler, TextDirection>(
    (prop) => mutable.merge(StackBoxStyler(textDirection: prop)),
  );

  late final stackClipBehavior = MixUtility<StackBoxStyler, Clip>(
    (prop) => mutable.merge(StackBoxStyler(stackClipBehavior: prop)),
  );

  /// Internal mutable state for accumulating stackbox styling properties.
  @override
  @protected
  late final StackBoxMutableState mutable;

  StackBoxMutableStyler([StackBoxStyler? attribute]) {
    mutable = StackBoxMutableState(attribute ?? const StackBoxStyler.create());
  }

  /// Applies animation configuration to the stackbox styling.
  StackBoxStyler animate(AnimationConfig animation) =>
      mutable.animate(animation);

  @override
  StackBoxStyler withVariant(Variant variant, StackBoxStyler style) {
    return mutable.variant(variant, style);
  }

  @override
  StackBoxStyler withVariants(List<VariantStyle<StackBoxSpec>> variants) {
    return mutable.variants(variants);
  }

  @override
  StackBoxMutableStyler merge(Style<StackBoxSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is StackBoxMutableStyler) {
      return StackBoxMutableStyler(mutable.merge(other.mutable.value));
    }
    if (other is StackBoxStyler) {
      return StackBoxMutableStyler(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StyleSpec<StackBoxSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  @override
  StackBoxStyler get currentValue => mutable.value;

  /// The accumulated [StackBoxStyler] with all applied styling properties.
  @override
  StackBoxStyler get value => mutable.value;
}

/// Mutable implementation of [StackBoxStyler] for efficient style accumulation.
///
/// Used internally by [StackBoxMutableStyler] to accumulate styling changes
/// without creating new instances for each modification.
class StackBoxMutableState extends StackBoxStyler
    with Mutable<StackBoxStyler, StackBoxSpec> {
  StackBoxMutableState(StackBoxStyler style) {
    value = style;
  }
}
