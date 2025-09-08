import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/modifier.dart';
import '../../core/style.dart';

/// A modifier specification that resets the style context.
final class ResetModifier extends WidgetModifier<ResetModifier> with Diagnosticable {
  const ResetModifier();

  @override
  ResetModifier copyWith() {
    return const ResetModifier();
  }

  @override
  ResetModifier lerp(ResetModifier? other, double t) {
    if (other == null) return this;

    return const ResetModifier();
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
class ResetModifierMix extends WidgetModifierMix<ResetModifier> with Diagnosticable {
  const ResetModifierMix();

  @override
  ResetModifier resolve(BuildContext context) {
    return const ResetModifier();
  }

  @override
  ResetModifierMix merge(ResetModifierMix? other) {
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
