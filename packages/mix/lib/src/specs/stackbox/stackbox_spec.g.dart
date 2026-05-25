// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stackbox_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$StackBoxSpec implements Spec<StackBoxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get box;
  StyleSpec<StackSpec>? get stack;

  @override
  Type get type => StackBoxSpec;

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
  List<Object?> get props => [box, stack];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StackBoxSpec &&
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
      ..add(DiagnosticsProperty('stack', stack));
  }
}

@Deprecated(
  'Rename to `_\$StackBoxSpec` and migrate the class declaration to `class StackBoxSpec with _\$StackBoxSpec`. The `_\$StackBoxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$StackBoxSpecMethods = _$StackBoxSpec; // ignore: unused_element
