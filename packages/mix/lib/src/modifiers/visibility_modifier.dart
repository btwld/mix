import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

part 'visibility_modifier.g.dart';

/// Modifier that controls the visibility of its child.
///
/// Wraps the child in a [Visibility] widget to show or hide it while maintaining layout space.
@MixableModifier()
final class VisibilityModifier extends WidgetModifier<VisibilityModifier>
    with Diagnosticable, _$VisibilityModifierMethods {
  /// Whether the child widget should be visible.
  @override
  final bool visible;
  const VisibilityModifier([bool? visible]) : visible = visible ?? true;

  @override
  Widget build(Widget child) {
    return Visibility(visible: visible, child: child);
  }
}

/// Utility class for applying visibility modifications.
///
/// Provides convenient methods for creating VisibilityModifierMix instances.
final class VisibilityModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, VisibilityModifierMix> {
  const VisibilityModifierUtility(super.utilityBuilder);

  /// Sets the visibility to true.
  T on() => call(true);

  /// Sets the visibility to false.
  T off() => call(false);

  /// Creates a [VisibilityModifierMix] with the specified visibility state.
  T call(bool value) =>
      utilityBuilder(VisibilityModifierMix.create(visible: Prop.value(value)));

  /// Creates a [VisibilityModifierMix] with the specified visibility token.
  T token(MixToken<bool> token) =>
      utilityBuilder(VisibilityModifierMix.create(visible: Prop.token(token)));
}
