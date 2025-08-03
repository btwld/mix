import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/modifier.dart';
import '../../core/style.dart';

/// A decorator specification that resets the style context.
final class ResetWidgetDecorator extends WidgetDecorator<ResetWidgetDecorator>
    with Diagnosticable {
  const ResetWidgetDecorator();

  @override
  ResetWidgetDecorator copyWith() {
    return const ResetWidgetDecorator();
  }

  @override
  ResetWidgetDecorator lerp(ResetWidgetDecorator? other, double t) {
    if (other == null) return this;

    return const ResetWidgetDecorator();
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
class ResetWidgetDecoratorStyle extends WidgetDecoratorStyle<ResetWidgetDecorator>
    with Diagnosticable {
  const ResetWidgetDecoratorStyle();

  @override
  ResetWidgetDecorator resolve(BuildContext context) {
    return const ResetWidgetDecorator();
  }

  @override
  ResetWidgetDecoratorStyle merge(ResetWidgetDecoratorStyle? other) {
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
