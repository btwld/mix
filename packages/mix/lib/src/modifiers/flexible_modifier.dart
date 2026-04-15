import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';

/// Modifier that makes its child flexible within a flex layout.
///
/// Wraps the child in a [Flexible] widget with the specified flex and fit properties.
final class FlexibleModifier extends WidgetModifier<FlexibleModifier>
    with Diagnosticable {
  final int? flex;
  final FlexFit? fit;
  const FlexibleModifier({this.flex, this.fit});

  @override
  FlexibleModifier copyWith({int? flex, FlexFit? fit}) {
    return FlexibleModifier(flex: flex ?? this.flex, fit: fit ?? this.fit);
  }

  @override
  FlexibleModifier lerp(FlexibleModifier? other, double t) {
    if (other == null) return this;

    return FlexibleModifier(
      flex: MixOps.lerpSnap(flex, other.flex, t),
      fit: MixOps.lerpSnap(fit, other.fit, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('flex', flex))
      ..add(EnumProperty<FlexFit>('fit', fit));
  }

  @override
  List<Object?> get props => [flex, fit];

  @override
  Widget build(Widget child) {
    return Flexible(flex: flex ?? 1, fit: fit ?? .loose, child: child);
  }
}

/// Mix class for applying flexible modifications.
///
/// This class allows for mixing and resolving flexible properties.
class FlexibleModifierMix extends ModifierMix<FlexibleModifier>
    with Diagnosticable {
  final Prop<int>? flex;
  final Prop<FlexFit>? fit;

  const FlexibleModifierMix.create({this.flex, this.fit});

  FlexibleModifierMix({int? flex, FlexFit? fit})
    : this.create(flex: Prop.maybe(flex), fit: Prop.maybe(fit));

  @override
  FlexibleModifier resolve(BuildContext context) {
    return FlexibleModifier(
      flex: MixOps.resolve(context, flex),
      fit: MixOps.resolve(context, fit),
    );
  }

  @override
  FlexibleModifierMix merge(FlexibleModifierMix? other) {
    if (other == null) return this;

    return FlexibleModifierMix.create(
      flex: flex?.mergeProp(other.flex) ?? other.flex,
      fit: fit?.mergeProp(other.fit) ?? other.fit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('flex', flex))
      ..add(DiagnosticsProperty('fit', fit));
  }

  @override
  List<Object?> get props => [flex, fit];
}
