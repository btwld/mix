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
final class AlignModifier extends Modifier<AlignModifier> with Diagnosticable {
  final AlignmentGeometry? alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignModifier({this.alignment, this.widthFactor, this.heightFactor});

  @override
  AlignModifier copyWith({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AlignModifier(
      alignment: alignment ?? this.alignment,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  @override
  AlignModifier lerp(AlignModifier? other, double t) {
    if (other == null) return this;

    return AlignModifier(
      alignment: MixOps.lerp(alignment, other.alignment, t),
      widthFactor: MixOps.lerp(widthFactor, other.widthFactor, t),
      heightFactor: MixOps.lerp(heightFactor, other.heightFactor, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DoubleProperty('widthFactor', widthFactor))
      ..add(DoubleProperty('heightFactor', heightFactor));
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

/// Utility class for applying alignment modifications.
///
/// Provides convenient methods for creating AlignModifierMix instances.
final class AlignModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, AlignModifierMix> {
  const AlignModifierUtility(super.builder);
  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      AlignModifierMix(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }
}

/// Mix class for applying alignment modifications.
///
/// This class allows for mixing and resolving alignment properties.
class AlignModifierMix extends ModifierMix<AlignModifier> with Diagnosticable {
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;

  const AlignModifierMix.create({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  AlignModifierMix({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         widthFactor: Prop.maybe(widthFactor),
         heightFactor: Prop.maybe(heightFactor),
       );

  @override
  AlignModifier resolve(BuildContext context) {
    return AlignModifier(
      alignment: MixOps.resolve(context, alignment),
      widthFactor: MixOps.resolve(context, widthFactor),
      heightFactor: MixOps.resolve(context, heightFactor),
    );
  }

  @override
  AlignModifierMix merge(AlignModifierMix? other) {
    if (other == null) return this;

    return AlignModifierMix.create(
      alignment: MixOps.merge(alignment, other.alignment),
      widthFactor: MixOps.merge(widthFactor, other.widthFactor),
      heightFactor: MixOps.merge(heightFactor, other.heightFactor),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('widthFactor', widthFactor))
      ..add(DiagnosticsProperty('heightFactor', heightFactor));
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];
}
