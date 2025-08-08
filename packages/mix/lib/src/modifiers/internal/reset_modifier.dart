import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/modifier.dart';
import '../../core/style.dart';

/// A modifier specification that resets the style context.
final class ResetWidgetModifier extends WidgetModifier<ResetWidgetModifier>
    with Diagnosticable {
  const ResetWidgetModifier();

  @override
  ResetWidgetModifier copyWith() {
    return const ResetWidgetModifier();
  }

  @override
  ResetWidgetModifier lerp(ResetWidgetModifier? other, double t) {
    if (other == null) return this;

    return const ResetWidgetModifier();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return child;
  }
}

/// An attribute that resets the modifier context.
class ResetWidgetModifierMix extends WidgetModifierMix<ResetWidgetModifier>
    with Diagnosticable {
  const ResetWidgetModifierMix();

  @override
  ResetWidgetModifier resolve(BuildContext context) {
    return const ResetWidgetModifier();
  }

  @override
  ResetWidgetModifierMix merge(ResetWidgetModifierMix? other) {
    if (other == null) return this;

    return other;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [];
}
