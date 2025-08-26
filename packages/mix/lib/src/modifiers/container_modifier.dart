import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../specs/box/box_mix.dart';
import '../specs/box/box_spec.dart';
import '../specs/box/box_widget.dart';

/// Modifier that wraps its child in a styled Container.
///
/// Wraps the child in a [Container] widget with the specified container styling.
final class ContainerModifier extends Modifier<ContainerModifier>
    with Diagnosticable {
  final BoxSpec spec;

  const ContainerModifier(this.spec);

  @override
  ContainerModifier copyWith({BoxSpec? spec}) {
    return ContainerModifier(spec ?? this.spec);
  }

  @override
  ContainerModifier lerp(ContainerModifier? other, double t) {
    if (other == null) return this;

    return ContainerModifier(MixOps.lerp(spec, other.spec, t)!);
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
    return createBoxSpecWidget(spec: spec, child: child);
  }
}

/// Mix class for applying container modifications.
///
/// This class allows for mixing and resolving container properties.
class ContainerModifierMix extends ModifierMix<ContainerModifier>
    with Diagnosticable {
  final BoxMix spec;

  const ContainerModifierMix(this.spec);

  @override
  ContainerModifier resolve(BuildContext context) {
    return ContainerModifier(spec.resolve(context));
  }

  @override
  ContainerModifierMix merge(ContainerModifierMix? other) {
    if (other == null) return this;

    return ContainerModifierMix(spec.merge(other.spec));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('spec', spec));
  }

  @override
  List<Object?> get props => [spec];
}

/// Utility class for applying container modifications.
///
/// Provides convenient methods for creating ContainerModifierMix instances.
class ContainerModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, ContainerModifierMix> {
  const ContainerModifierUtility(super.builder);

  T call(BoxMix spec) {
    return builder(ContainerModifierMix(spec));
  }

  T color(Color value) {
    return builder(ContainerModifierMix(BoxMix.color(value)));
  }

  T padding(EdgeInsetsGeometryMix value) {
    return builder(ContainerModifierMix(BoxMix.padding(value)));
  }

  T margin(EdgeInsetsGeometryMix value) {
    return builder(ContainerModifierMix(BoxMix.margin(value)));
  }
}