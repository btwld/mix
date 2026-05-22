// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$StackSpec implements Spec<StackSpec>, Diagnosticable {
  AlignmentGeometry? get alignment;
  StackFit? get fit;
  TextDirection? get textDirection;
  Clip? get clipBehavior;

  @override
  Type get type => StackSpec;

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
  List<Object?> get props => [alignment, fit, textDirection, clipBehavior];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StackSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(EnumProperty<StackFit>('fit', fit))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

@Deprecated(
  'Rename to `_\$StackSpec` and migrate the class declaration to `class StackSpec with _\$StackSpec`. The `_\$StackSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$StackSpecMethods = _$StackSpec; // ignore: unused_element
