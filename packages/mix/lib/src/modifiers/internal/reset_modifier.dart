
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/modifier.dart';
import '../../core/style.dart';

final class ResetModifierSpec extends Modifier<ResetModifierSpec>
    with Diagnosticable {
  const ResetModifierSpec();

  @override
  ResetModifierSpec copyWith() {
    return const ResetModifierSpec();
  }

  @override
  ResetModifierSpec lerp(ResetModifierSpec? other, double t) {
    if (other == null) return this;

    return const ResetModifierSpec();
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

class ResetModifierAttribute extends ModifierAttribute<ResetModifierSpec>
    with Diagnosticable {
  const ResetModifierAttribute();

  @override
  ResetModifierSpec resolve(BuildContext context) {
    return const ResetModifierSpec();
  }

  @override
  ResetModifierAttribute merge(ResetModifierAttribute? other) {
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
