// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blur_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$BlurModifier implements WidgetModifier<BlurModifier>, Diagnosticable {
  double get sigma;

  @override
  Type get type => BlurModifier;

  @override
  BlurModifier copyWith({double? sigma}) {
    return BlurModifier(sigma ?? this.sigma);
  }

  @override
  BlurModifier lerp(BlurModifier? other, double t) {
    return BlurModifier(MixOps.lerp(sigma, other?.sigma, t));
  }

  @override
  List<Object?> get props => [sigma];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlurModifier &&
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
    properties.add(DoubleProperty('sigma', sigma));
  }
}

class BlurModifierMix extends ModifierMix<BlurModifier> with Diagnosticable {
  final Prop<double>? sigma;

  const BlurModifierMix.create({this.sigma});

  BlurModifierMix({double? sigma}) : this.create(sigma: Prop.maybe(sigma));

  @override
  BlurModifier resolve(BuildContext context) {
    return BlurModifier(MixOps.resolve(context, sigma));
  }

  @override
  BlurModifierMix merge(BlurModifierMix? other) {
    if (other == null) return this;

    return BlurModifierMix.create(sigma: MixOps.merge(sigma, other.sigma));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('sigma', sigma));
  }

  @override
  List<Object?> get props => [sigma];
}
