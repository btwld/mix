import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/layout/edge_insets_geometry_mix.dart';
import '../properties/painting/decoration_mix.dart';
import '../specs/box/box_spec.dart';
import '../specs/box/box_style.dart';
import '../specs/box/box_widget.dart';

/// Modifier that wraps its child in a styled Container using BoxSpec styling.
///
/// Wraps the child in a [Container] widget with the specified box styling.
final class BoxModifier extends WidgetModifier<BoxModifier>
    with Diagnosticable {
  final BoxSpec spec;

  const BoxModifier(this.spec);

  @override
  BoxModifier copyWith({BoxSpec? spec}) {
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
    return Box(spec: spec, child: child);
  }
}

/// Mix class for applying box (Container) modifications.
///
/// This class allows for mixing and resolving BoxSpec-based properties.
class BoxModifierMix extends ModifierMix<BoxModifier> with Diagnosticable {
  final BoxStyler spec;

  const BoxModifierMix(this.spec);

  @override
  BoxModifier resolve(BuildContext context) {
    final widgetSpec = spec.resolve(context);

    return BoxModifier(widgetSpec.spec);
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
  const BoxModifierUtility(super.utilityBuilder);

  T call(BoxStyler spec) {
    return utilityBuilder(BoxModifierMix(spec));
  }

  T color(Color value) {
    return utilityBuilder(
      BoxModifierMix(BoxStyler(decoration: DecorationMix.color(value))),
    );
  }

  T padding(EdgeInsetsGeometryMix value) {
    return utilityBuilder(BoxModifierMix(BoxStyler(padding: value)));
  }

  T margin(EdgeInsetsGeometryMix value) {
    return utilityBuilder(BoxModifierMix(BoxStyler(margin: value)));
  }
}
