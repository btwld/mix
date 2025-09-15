import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/style_spec.dart';
import '../../core/utility.dart';
import '../../core/utility_variant_mixin.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../modifiers/widget_modifier_util.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'flexbox_spec.dart';
import 'flexbox_style.dart';

/// Provides mutable utility for flexbox styling with cascade notation support.
///
/// Combines box and flex styling capabilities. Supports the same API as [FlexBoxStyler]
/// but maintains mutable internal state enabling fluid styling: `$flexbox..color.red()..width(100)`.
class FlexBoxMutableStyler extends StyleMutableBuilder<FlexBoxSpec>
    with UtilityVariantMixin<FlexBoxSpec, FlexBoxStyler> {
  late final padding = EdgeInsetsGeometryUtility<FlexBoxStyler>(
    (prop) => mutable.merge(FlexBoxStyler(padding: prop)),
  );

  late final margin = EdgeInsetsGeometryUtility<FlexBoxStyler>(
    (prop) => mutable.merge(FlexBoxStyler(margin: prop)),
  );

  late final constraints = BoxConstraintsUtility<FlexBoxStyler>(
    (prop) => mutable.merge(FlexBoxStyler(constraints: prop)),
  );

  late final decoration = DecorationUtility<FlexBoxStyler>(
    (prop) => mutable.merge(FlexBoxStyler(decoration: prop)),
  );

  @Deprecated(
    'Use direct methods like \$flexbox.onHovered() instead. '
    'Note: Returns FlexBoxStyle for consistency with other utility methods like animate().',
  )
  late final on = OnContextVariantUtility<FlexBoxSpec, FlexBoxStyler>(
    (v) => mutable.variants([v]),
  );

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
  late final transform = MixUtility<FlexBoxStyler, Matrix4>(
    (prop) => mutable.merge(FlexBoxStyler(transform: prop)),
  );
  late final transformAlignment = MixUtility<FlexBoxStyler, AlignmentGeometry>(
    (prop) => mutable.merge(FlexBoxStyler(transformAlignment: prop)),
  );
  late final clipBehavior = MixUtility<FlexBoxStyler, Clip>(
    (prop) => mutable.merge(FlexBoxStyler(clipBehavior: prop)),
  );

  late final alignment = MixUtility<FlexBoxStyler, AlignmentGeometry>(
    (prop) => mutable.merge(FlexBoxStyler(alignment: prop)),
  );

  /// Flex layout utilities.
  late final direction = MixUtility<FlexBoxStyler, Axis>(
    (prop) => mutable.merge(FlexBoxStyler(direction: prop)),
  );

  late final mainAxisAlignment = MixUtility<FlexBoxStyler, MainAxisAlignment>(
    (prop) => mutable.merge(FlexBoxStyler(mainAxisAlignment: prop)),
  );

  late final crossAxisAlignment = MixUtility<FlexBoxStyler, CrossAxisAlignment>(
    (prop) => mutable.merge(FlexBoxStyler(crossAxisAlignment: prop)),
  );

  late final mainAxisSize = MixUtility<FlexBoxStyler, MainAxisSize>(
    (prop) => mutable.merge(FlexBoxStyler(mainAxisSize: prop)),
  );

  late final verticalDirection = MixUtility<FlexBoxStyler, VerticalDirection>(
    (prop) => mutable.merge(FlexBoxStyler(verticalDirection: prop)),
  );

  late final flexTextDirection = MixUtility<FlexBoxStyler, TextDirection>(
    (prop) => mutable.merge(FlexBoxStyler(textDirection: prop)),
  );

  late final textBaseline = MixUtility<FlexBoxStyler, TextBaseline>(
    (prop) => mutable.merge(FlexBoxStyler(textBaseline: prop)),
  );

  late final flexClipBehavior = MixUtility<FlexBoxStyler, Clip>(
    (prop) => mutable.merge(FlexBoxStyler(flexClipBehavior: prop)),
  );

  /// Internal mutable state for accumulating flexbox styling properties.
  @override
  @protected
  late final FlexBoxMutableState mutable;

  FlexBoxMutableStyler([FlexBoxStyler? attribute]) {
    mutable = FlexBoxMutableState(attribute ?? const FlexBoxStyler.create());
  }

  /// Sets the spacing between children in the flex layout.
  FlexBoxStyler spacing(double v) => mutable.merge(FlexBoxStyler(spacing: v));

  /// Sets the gap between children in the flex layout.
  /// @deprecated Use spacing instead.
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexBoxStyler gap(double v) => mutable.merge(FlexBoxStyler(spacing: v));

  /// Applies animation configuration to the flexbox styling.
  FlexBoxStyler animate(AnimationConfig animation) =>
      mutable.animate(animation);

  @override
  FlexBoxStyler withVariants(List<Variant<FlexBoxSpec>> variants) {
    return mutable.variants(variants);
  }

  @override
  FlexBoxMutableStyler merge(Style<FlexBoxSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is FlexBoxMutableStyler) {
      return FlexBoxMutableStyler(mutable.merge(other.mutable.value));
    }
    if (other is FlexBoxStyler) {
      return FlexBoxMutableStyler(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StyleSpec<FlexBoxSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  @override
  FlexBoxStyler get currentValue => mutable.value;

  /// The accumulated [FlexBoxStyler] with all applied styling properties.
  @override
  FlexBoxStyler get value => mutable.value;
}

/// Mutable implementation of [FlexBoxStyler] for efficient style accumulation.
///
/// Used internally by [FlexBoxMutableStyler] to accumulate styling changes
/// without creating new instances for each modification.
class FlexBoxMutableState extends FlexBoxStyler
    with Mutable<FlexBoxSpec, FlexBoxStyler> {
  FlexBoxMutableState(FlexBoxStyler style) {
    value = style;
  }
}
