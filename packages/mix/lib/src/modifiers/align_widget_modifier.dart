// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/utility.dart';

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
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      widthFactor: MixHelpers.lerpDouble(widthFactor, other.widthFactor, t),
      heightFactor: MixHelpers.lerpDouble(heightFactor, other.heightFactor, t),
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

final class AlignModifierSpecUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, AlignModifierSpecAttribute> {
  const AlignModifierSpecUtility(super.builder);
  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      AlignModifierSpecAttribute(
        alignment: Prop.maybe(alignment),
        widthFactor: Prop.maybe(widthFactor),
        heightFactor: Prop.maybe(heightFactor),
      ),
    );
  }
}

class AlignModifierSpecAttribute extends ModifierAttribute<AlignModifier> {
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;

  const AlignModifierSpecAttribute({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  AlignModifier resolve(BuildContext context) {
    return AlignModifier(
      alignment: MixHelpers.resolve(context, alignment),
      widthFactor: MixHelpers.resolve(context, widthFactor),
      heightFactor: MixHelpers.resolve(context, heightFactor),
    );
  }

  @override
  AlignModifierSpecAttribute merge(AlignModifierSpecAttribute? other) {
    if (other == null) return this;

    return AlignModifierSpecAttribute(
      alignment: MixHelpers.merge(alignment, other.alignment),
      widthFactor: MixHelpers.merge(widthFactor, other.widthFactor),
      heightFactor: MixHelpers.merge(heightFactor, other.heightFactor),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];
}
