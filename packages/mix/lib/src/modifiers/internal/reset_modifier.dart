import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/modifier.dart';
import '../../core/style.dart';

/// A modifier specification that resets the style context.
final class ResetModifierSpec extends WidgetDecorator<ResetModifierSpec>
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

/// An attribute that resets the modifier context.
class ResetModifierAttribute extends WidgetDecoratorStyle<ResetModifierSpec>
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
