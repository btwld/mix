import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/container/container_mix.dart';
import '../properties/container/container_spec.dart';

/// Modifier that wraps its child in a styled Container.
///
/// Wraps the child in a [Container] widget with the specified container styling.
final class BoxModifier extends Modifier<BoxModifier>
    with Diagnosticable {
  final ContainerSpec spec;

  const BoxModifier(this.spec);

  @override
  BoxModifier copyWith({ContainerSpec? spec}) {
    return BoxModifier(spec ?? this.spec);
  }

  @override
  BoxModifier lerp(BoxModifier? other, double t) {
    if (other == null) return this;

    return BoxModifier(MixOps.lerp(spec, other.spec, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('spec', spec));
  }

  @override
  List<Object?> get props => [spec];

  @override
  Widget build(Widget child) {
    return spec(child: child);
  }
}

/// Mix class for applying box modifications.
///
/// This class allows for mixing and resolving box container properties.
class BoxModifierMix extends ModifierMix<BoxModifier>
    with Diagnosticable {
  final ContainerMix spec;

  const BoxModifierMix(this.spec);

  @override
  BoxModifier resolve(BuildContext context) {
    return BoxModifier(spec.resolve(context));
  }

  @override
  BoxModifierMix merge(BoxModifierMix? other) {
    if (other == null) return this;

    return BoxModifierMix(spec.merge(other.spec));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('spec', spec));
  }

  @override
  List<Object?> get props => [spec];
}

/// Utility class for applying box modifications.
///
/// Provides convenient methods for creating BoxModifierMix instances.
class BoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, BoxModifierMix> {
  const BoxModifierUtility(super.builder);

  T call(ContainerMix spec) {
    return builder(BoxModifierMix(spec));
  }

  T color(Color value) {
    return builder(BoxModifierMix(ContainerMix.color(value)));
  }

  T padding(EdgeInsetsGeometryMix value) {
    return builder(BoxModifierMix(ContainerMix.padding(value)));
  }

  T margin(EdgeInsetsGeometryMix value) {
    return builder(BoxModifierMix(ContainerMix.margin(value)));
  }
}