import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

/// Modifier that sizes its child to a fraction of the available space.
///
/// Wraps the child in a [FractionallySizedBox] widget with the specified factors.
final class FractionallySizedBoxModifier
    extends WidgetModifier<FractionallySizedBoxModifier>
    with Diagnosticable {
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry alignment;

  const FractionallySizedBoxModifier({
    this.widthFactor,
    this.heightFactor,
    AlignmentGeometry? alignment,
  }) : alignment = alignment ?? Alignment.center;

  @override
  FractionallySizedBoxModifier copyWith({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return FractionallySizedBoxModifier(
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  FractionallySizedBoxModifier lerp(
    FractionallySizedBoxModifier? other,
    double t,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxModifier(
      widthFactor: MixOps.lerp(widthFactor, other.widthFactor, t),
      heightFactor: MixOps.lerp(heightFactor, other.heightFactor, t),
      alignment: MixOps.lerp(alignment, other.alignment, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('widthFactor', widthFactor))
      ..add(DoubleProperty('heightFactor', heightFactor))
      ..add(DiagnosticsProperty('alignment', alignment));
  }

  @override
  List<Object?> get props => [widthFactor, heightFactor, alignment];

  @override
  Widget build(Widget child) {
    return FractionallySizedBox(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

/// Mix class for applying fractionally sized box modifications.
///
/// This class allows for mixing and resolving fractionally sized box properties.
class FractionallySizedBoxModifierMix
    extends WidgetModifierMix<FractionallySizedBoxModifier> {
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;
  final Prop<AlignmentGeometry>? alignment;

  const FractionallySizedBoxModifierMix.create({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });

  FractionallySizedBoxModifierMix({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) : this.create(
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
         alignment: Prop.maybe(alignment),
       );

  @override
  FractionallySizedBoxModifier resolve(BuildContext context) {
    return FractionallySizedBoxModifier(
      widthFactor: MixOps.resolve(context, widthFactor),
      heightFactor: MixOps.resolve(context, heightFactor),
      alignment: MixOps.resolve(context, alignment),
    );
  }

  @override
  FractionallySizedBoxModifierMix merge(
    FractionallySizedBoxModifierMix? other,
  ) {
    if (other == null) return this;

    return FractionallySizedBoxModifierMix.create(
      widthFactor: MixOps.merge(widthFactor, other.widthFactor),
      heightFactor: MixOps.merge(heightFactor, other.heightFactor),
      alignment: MixOps.merge(alignment, other.alignment),
    );
  }

  @override
  List<Object?> get props => [widthFactor, heightFactor, alignment];
}

/// Utility class for applying fractionally sized box modifications.
///
/// Provides convenient methods for creating FractionallySizedBoxModifierMix instances.
final class FractionallySizedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, FractionallySizedBoxModifierMix> {
  const FractionallySizedBoxModifierUtility(super.utilityBuilder);

  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return utilityBuilder(
      FractionallySizedBoxModifierMix(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        alignment: alignment,
      ),
    );
  }
}
