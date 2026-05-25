// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$BoxSpec implements Spec<BoxSpec>, Diagnosticable {
  AlignmentGeometry? get alignment;
  EdgeInsetsGeometry? get padding;
  EdgeInsetsGeometry? get margin;
  BoxConstraints? get constraints;
  Decoration? get decoration;
  Decoration? get foregroundDecoration;
  Matrix4? get transform;
  AlignmentGeometry? get transformAlignment;
  Clip? get clipBehavior;

  @override
  Type get type => BoxSpec;

  @override
  BoxSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
  }) {
    return BoxSpec(
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      constraints: constraints ?? this.constraints,
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  BoxSpec lerp(BoxSpec? other, double t) {
    return BoxSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      padding: MixOps.lerp(padding, other?.padding, t),
      margin: MixOps.lerp(margin, other?.margin, t),
      constraints: MixOps.lerp(constraints, other?.constraints, t),
      decoration: MixOps.lerp(decoration, other?.decoration, t),
      foregroundDecoration: MixOps.lerp(
        foregroundDecoration,
        other?.foregroundDecoration,
        t,
      ),
      transform: MixOps.lerp(transform, other?.transform, t),
      transformAlignment: MixOps.lerp(
        transformAlignment,
        other?.transformAlignment,
        t,
      ),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [
    alignment,
    padding,
    margin,
    constraints,
    decoration,
    foregroundDecoration,
    transform,
    transformAlignment,
    clipBehavior,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BoxSpec &&
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
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('margin', margin))
      ..add(DiagnosticsProperty('constraints', constraints))
      ..add(DiagnosticsProperty('decoration', decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', foregroundDecoration))
      ..add(DiagnosticsProperty('transform', transform))
      ..add(DiagnosticsProperty('transformAlignment', transformAlignment))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

@Deprecated(
  'Rename to `_\$BoxSpec` and migrate the class declaration to `class BoxSpec with _\$BoxSpec`. The `_\$BoxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$BoxSpecMethods = _$BoxSpec; // ignore: unused_element
