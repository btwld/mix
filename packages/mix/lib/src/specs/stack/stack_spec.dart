import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/modifier.dart';
import '../../core/widget_spec.dart';

final class StackWidgetSpec extends WidgetSpec<StackWidgetSpec> {
  final AlignmentGeometry? alignment;
  final StackFit? fit;
  final TextDirection? textDirection;
  final Clip? clipBehavior;

  const StackWidgetSpec({
    this.alignment,
    this.fit,
    this.textDirection,
    this.clipBehavior,
    super.animation,
    super.widgetModifiers,
    super.inherit,
  });

  /// Creates a copy of this [StackWidgetSpec] but with the given fields
  /// replaced with the new values.
  @override
  StackWidgetSpec copyWith({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return StackWidgetSpec(
      alignment: alignment ?? this.alignment,
      fit: fit ?? this.fit,
      textDirection: textDirection ?? this.textDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  /// Linearly interpolates between this [StackWidgetSpec] and another [StackWidgetSpec] based on the given parameter [t].
  @override
  StackWidgetSpec lerp(StackWidgetSpec? other, double t) {
    return StackWidgetSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      fit: MixOps.lerpSnap(fit, other?.fit, t),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
      // Meta fields: use confirmed policy other.field ?? this.field
      animation: other?.animation ?? animation,
      widgetModifiers: MixOps.lerp(widgetModifiers, other?.widgetModifiers, t),
      inherit: other?.inherit ?? inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(EnumProperty<StackFit>('fit', fit))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }

  /// The list of properties that constitute the state of this [StackWidgetSpec].
  @override
  List<Object?> get props => [
    ...super.props,
    alignment,
    fit,
    textDirection,
    clipBehavior,
  ];
}
