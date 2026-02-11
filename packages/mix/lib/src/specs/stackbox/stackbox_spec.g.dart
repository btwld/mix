// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stackbox_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$StackBoxSpecMethods on Spec<StackBoxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get box;
  StyleSpec<StackSpec>? get stack;

  @override
  StackBoxSpec copyWith({
    StyleSpec<BoxSpec>? box,
    StyleSpec<StackSpec>? stack,
  }) {
    return StackBoxSpec(box: box ?? this.box, stack: stack ?? this.stack);
  }

  @override
  StackBoxSpec lerp(StackBoxSpec? other, double t) {
    return StackBoxSpec(
      box: box?.lerp(other?.box, t),
      stack: stack?.lerp(other?.stack, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', box))
      ..add(DiagnosticsProperty('stack', stack));
  }

  @override
  List<Object?> get props => [box, stack];
}
