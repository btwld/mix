import 'package:flutter/foundation.dart';

import '../../core/spec.dart';
import '../../core/style.dart';
import '../../theme/tokens/mix_token.dart';
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

  /// Resolves a [token] reference and passes its value to [builder],
  /// merging the result inline at the current chain position.
  ///
  /// The token value flows through [builder] as a reference that preserves
  /// token identity through the styling pipeline. At resolve time, the
  /// token is resolved from [MixScope] and the concrete value is used.
  ///
  /// ```dart
  /// BoxStyler()
  ///     .useToken($primary, (color) => BoxStyler().color(color))
  ///     .useToken($spacing.md, (space) => BoxStyler().paddingAll(space));
  /// ```
  ST useToken<U>(MixToken<U> token, ST Function(U value) builder) {
    return merge(builder(token())) as ST;
  }
}
