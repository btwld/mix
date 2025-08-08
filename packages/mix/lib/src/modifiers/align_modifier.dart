import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

/// Modifier that aligns its child within the available space.
///
/// Wraps the child in an [Align] widget with the specified alignment and size factors.
final class AlignWidgetModifier extends WidgetModifier<AlignWidgetModifier>
    with Diagnosticable {
  final AlignmentGeometry? alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignWidgetModifier({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  AlignWidgetModifier copyWith({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AlignWidgetModifier(
      alignment: alignment ?? this.alignment,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  @override
  AlignWidgetModifier lerp(AlignWidgetModifier? other, double t) {
    if (other == null) return this;

    return AlignWidgetModifier(
      alignment: MixOps.lerp(alignment, other.alignment, t),
      widthFactor: MixOps.lerp(widthFactor, other.widthFactor, t),
      heightFactor: MixOps.lerp(heightFactor, other.heightFactor, t),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];

  @override
  Widget build(Widget child) {
    return Align(
      alignment: alignment ?? Alignment.center,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

final class AlignWidgetModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, AlignWidgetModifierMix> {
  const AlignWidgetModifierUtility(super.builder);
  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      AlignWidgetModifierMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }
}

class AlignWidgetModifierMix extends WidgetModifierMix<AlignWidgetModifier> {
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;

  const AlignWidgetModifierMix.create({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  AlignWidgetModifierMix({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
       );

  @override
  AlignWidgetModifier resolve(BuildContext context) {
    return AlignWidgetModifier(
      alignment: MixOps.resolve(context, alignment),
      widthFactor: MixOps.resolve(context, widthFactor),
      heightFactor: MixOps.resolve(context, heightFactor),
    );
  }

  @override
  AlignWidgetModifierMix merge(AlignWidgetModifierMix? other) {
    if (other == null) return this;

    return AlignWidgetModifierMix.create(
      alignment: MixOps.merge(alignment, other.alignment),
      widthFactor: MixOps.merge(widthFactor, other.widthFactor),
      heightFactor: MixOps.merge(heightFactor, other.heightFactor),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];
}
