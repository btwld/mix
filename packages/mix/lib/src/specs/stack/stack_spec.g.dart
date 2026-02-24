// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$StackSpecMethods on Spec<StackSpec>, Diagnosticable {
  AlignmentGeometry? get alignment;
  StackFit? get fit;
  TextDirection? get textDirection;
  Clip? get clipBehavior;

  @override
  StackSpec copyWith({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
  }) {
    return StackSpec(
      alignment: alignment ?? this.alignment,
      fit: fit ?? this.fit,
      textDirection: textDirection ?? this.textDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  StackSpec lerp(StackSpec? other, double t) {
    return StackSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      fit: MixOps.lerpSnap(fit, other?.fit, t),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
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

  @override
  List<Object?> get props => [alignment, fit, textDirection, clipBehavior];
}
