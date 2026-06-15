// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sized_box_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$SizedBoxModifier
    implements WidgetModifier<SizedBoxModifier>, Diagnosticable {
  double? get width;
  double? get height;

  @override
  Type get type => SizedBoxModifier;

  @override
  SizedBoxModifier copyWith({double? width, double? height}) {
    return SizedBoxModifier(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  SizedBoxModifier lerp(SizedBoxModifier? other, double t) {
    return SizedBoxModifier(
      width: MixOps.lerp(width, other?.width, t),
      height: MixOps.lerp(height, other?.height, t),
    );
  }

  @override
  List<Object?> get props => [width, height];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SizedBoxModifier &&
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
  Widget build(Widget child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height));
  }
}

class SizedBoxModifierMix extends ModifierMix<SizedBoxModifier>
    with Diagnosticable {
  final Prop<double>? width;
  final Prop<double>? height;

  const SizedBoxModifierMix.create({this.width, this.height});

  SizedBoxModifierMix({double? width, double? height})
    : this.create(width: Prop.maybe(width), height: Prop.maybe(height));

  @override
  SizedBoxModifier resolve(BuildContext context) {
    return SizedBoxModifier(
      width: MixOps.resolve(context, width),
      height: MixOps.resolve(context, height),
    );
  }

  @override
  SizedBoxModifierMix merge(SizedBoxModifierMix? other) {
    if (other == null) return this;

    return SizedBoxModifierMix.create(
      width: MixOps.merge(width, other.width),
      height: MixOps.merge(height, other.height),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('width', width))
      ..add(DiagnosticsProperty('height', height));
  }

  @override
  List<Object?> get props => [width, height];
}
