// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../mix.dart';

final class AlignModifierSpec extends ModifierSpec<AlignModifierSpec>
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('widthFactor', widthFactor, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('heightFactor', heightFactor, defaultValue: null),
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

final class AlignModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, AlignModifierSpecAttribute> {
  const AlignModifierSpecUtility(super.builder);
  T call({
    AlignmentGeometry? alignment,
    double? widthFactor,
    double? heightFactor,
  }) {
    return builder(
      AlignModifierSpecAttribute(
        alignment: alignment,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
      ),
    );
  }
}

class AlignModifierSpecAttribute
    extends ModifierSpecAttribute<AlignModifierSpec>
    with Diagnosticable {
  final AlignmentGeometry? alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignModifierSpecAttribute({
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  AlignModifierSpec resolve(BuildContext context) {
    return AlignModifierSpec(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
    );
  }

  @override
  AlignModifierSpecAttribute merge(AlignModifierSpecAttribute? other) {
    if (other == null) return this;

    return AlignModifierSpecAttribute(
      alignment: other.alignment ?? alignment,
      widthFactor: other.widthFactor ?? widthFactor,
      heightFactor: other.heightFactor ?? heightFactor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('widthFactor', widthFactor, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('heightFactor', heightFactor, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [alignment, widthFactor, heightFactor];
}

