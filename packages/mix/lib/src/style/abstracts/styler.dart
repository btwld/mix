import 'package:flutter/foundation.dart';

import '../../core/spec.dart';
import '../../core/style.dart';
import '../mixins/animation_style_mixin.dart';
import '../mixins/variant_style_mixin.dart';
import '../mixins/widget_modifier_style_mixin.dart';
import '../mixins/widget_state_variant_mixin.dart';

abstract class MixStyler<ST extends Style<SP>, SP extends Spec<SP>>
    extends Style<SP>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<ST, SP>,
        VariantStyleMixin<ST, SP>,
        WidgetStateVariantMixin<ST, SP>,
        AnimationStyleMixin<ST, SP> {
  const MixStyler({
    required super.variants,
    required super.modifier,
    required super.animation,
  });
}
