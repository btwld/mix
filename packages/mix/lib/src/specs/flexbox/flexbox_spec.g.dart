// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexbox_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$FlexBoxSpec implements Spec<FlexBoxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get box;
  StyleSpec<FlexSpec>? get flex;

  @override
  Type get type => FlexBoxSpec;

  @override
  FlexBoxSpec copyWith({StyleSpec<BoxSpec>? box, StyleSpec<FlexSpec>? flex}) {
    return FlexBoxSpec(box: box ?? this.box, flex: flex ?? this.flex);
  }

  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    return FlexBoxSpec(
      box: box?.lerp(other?.box, t),
      flex: flex?.lerp(other?.flex, t),
    );
  }

  @override
  List<Object?> get props => [box, flex];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FlexBoxSpec &&
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
      ..add(DiagnosticsProperty('box', box))
      ..add(DiagnosticsProperty('flex', flex));
  }
}

@Deprecated(
  'Rename to `_\$FlexBoxSpec` and migrate the class declaration to `class FlexBoxSpec with _\$FlexBoxSpec`. The `_\$FlexBoxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$FlexBoxSpecMethods = _$FlexBoxSpec; // ignore: unused_element
