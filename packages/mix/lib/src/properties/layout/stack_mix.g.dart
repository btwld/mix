// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$StackMixMixin on Mix<StackSpec>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<Clip>? get $clipBehavior;
  Prop<StackFit>? get $fit;
  Prop<TextDirection>? get $textDirection;

  @override
  StackMix merge(StackMix? other) {
    return StackMix.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      fit: MixOps.merge($fit, other?.$fit),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
    );
  }

  @override
  StackSpec resolve(BuildContext context) {
    return StackSpec(
      alignment: MixOps.resolve(context, $alignment),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      fit: MixOps.resolve(context, $fit),
      textDirection: MixOps.resolve(context, $textDirection),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('textDirection', $textDirection));
  }

  @override
  List<Object?> get props => [$alignment, $clipBehavior, $fit, $textDirection];
}
