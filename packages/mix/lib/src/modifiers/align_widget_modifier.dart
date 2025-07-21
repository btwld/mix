// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/utility.dart';

final class AlignModifierSpec extends Modifier<AlignModifierSpec>
    with Diagnosticable {
  final AlignmentGeometry? alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignModifierSpec({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  AlignModifierSpec copyWith({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return AlignModifierSpec(
      alignment: alignment ?? this.alignment,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  @override
  AlignModifierSpec lerp(AlignModifierSpec? other, double t) {
    if (other == null) return this;

    return AlignModifierSpec(
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

final class AlignModifierSpecUtility<T extends SpecUtility<Object?>>
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

class AlignModifierSpecAttribute
    extends ModifierSpecAttribute<AlignModifierSpec> {
  final Prop<AlignmentGeometry>? alignment;
  final Prop<double>? widthFactor;
  final Prop<double>? heightFactor;

  const AlignModifierSpecAttribute({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  AlignModifierSpec resolve(BuildContext context) {
    return AlignModifierSpec(
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
