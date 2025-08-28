import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

/// Modifier that controls the visibility of its child.
///
/// Wraps the child in a [Visibility] widget to show or hide it while maintaining layout space.
final class VisibilityModifier extends Modifier<VisibilityModifier>
    with Diagnosticable {
  /// Whether the child widget should be visible.
  final bool visible;
  const VisibilityModifier([bool? visible]) : visible = visible ?? true;

  @override
  VisibilityModifier copyWith({bool? visible}) {
    return VisibilityModifier(visible ?? this.visible);
  }

  @override
  VisibilityModifier lerp(VisibilityModifier? other, double t) {
    if (other == null) return this;

    return VisibilityModifier(MixOps.lerpSnap(visible, other.visible, t));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty(
        'visible',
        value: visible,
        ifTrue: 'visible',
        ifFalse: 'hidden',
      ),
    );
  }

  @override
  List<Object?> get props => [visible];

  @override
  Widget build(Widget child) {
    return Visibility(visible: visible, child: child);
  }
}

/// Mix class for applying visibility modifications.
///
/// This class allows for mixing and resolving visibility properties.
class VisibilityModifierMix extends ModifierMix<VisibilityModifier>
    with Diagnosticable {
  /// Whether the child widget should be visible.
  final Prop<bool>? visible;

  const VisibilityModifierMix.create({this.visible});

  VisibilityModifierMix({bool? visible})
    : this.create(visible: Prop.maybe(visible));

  @override
  VisibilityModifier resolve(BuildContext context) {
    return VisibilityModifier(visible?.resolveProp(context));
  }

  @override
  VisibilityModifierMix merge(VisibilityModifierMix? other) {
    if (other == null) return this;

    return VisibilityModifierMix.create(
      visible: visible?.mergeProp(other.visible) ?? other.visible,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible));
  }

  @override
  List<Object?> get props => [visible];
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
