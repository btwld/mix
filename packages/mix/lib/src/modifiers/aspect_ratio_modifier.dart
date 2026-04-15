import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

part 'aspect_ratio_modifier.g.dart';

/// Modifier that constrains its child to a specific aspect ratio.
///
/// Wraps the child in an [AspectRatio] widget with the specified ratio.
@MixableModifier()
final class AspectRatioModifier extends WidgetModifier<AspectRatioModifier>
    with Diagnosticable, _$AspectRatioModifierMethods {
  @override
  final double aspectRatio;

  const AspectRatioModifier([double? aspectRatio])
    : aspectRatio = aspectRatio ?? 1.0;

  @override
  Widget build(Widget child) {
    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}

/// Utility class for applying aspect ratio modifications.
///
/// Provides convenient methods for creating AspectRatioModifierMix instances.
final class AspectRatioModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, AspectRatioModifierMix> {
  const AspectRatioModifierUtility(super.utilityBuilder);

  T call(double value) {
    return utilityBuilder(
      AspectRatioModifierMix.create(aspectRatio: Prop.value(value)),
    );
  }

  T token(MixToken<double> token) {
    return utilityBuilder(
      AspectRatioModifierMix.create(aspectRatio: Prop.token(token)),
    );
  }
}
