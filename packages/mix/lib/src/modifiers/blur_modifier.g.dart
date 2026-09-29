// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blur_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$BlurModifier implements WidgetModifier<BlurModifier>, Diagnosticable {
  double get sigma;
  TileMode get tileMode;

  @override
  Type get type => BlurModifier;

  @override
  BlurModifier copyWith({double? sigma, TileMode? tileMode}) {
    return BlurModifier(sigma ?? this.sigma, tileMode ?? this.tileMode);
  }

  @override
  BlurModifier lerp(BlurModifier? other, double t) {
    return BlurModifier(
      MixOps.lerp(sigma, other?.sigma, t),
      MixOps.lerpSnap(tileMode, other?.tileMode, t),
    );
  }

  @override
  List<Object?> get props => [sigma, tileMode];

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
    properties
      ..add(DoubleProperty('sigma', sigma))
      ..add(DiagnosticsProperty('tileMode', tileMode));
  }
}

class BlurModifierMix extends ModifierMix<BlurModifier> with Diagnosticable {
  final Prop<double>? sigma;
  final Prop<TileMode>? tileMode;

  const BlurModifierMix.create({this.sigma, this.tileMode});

  BlurModifierMix({double? sigma, TileMode? tileMode})
    : this.create(sigma: Prop.maybe(sigma), tileMode: Prop.maybe(tileMode));

  @override
  BlurModifier resolve(BuildContext context) {
    return BlurModifier(
      MixOps.resolve(context, sigma),
      MixOps.resolve(context, tileMode),
    );
  }

  @override
  BlurModifierMix merge(BlurModifierMix? other) {
    if (other == null) return this;

    return BlurModifierMix.create(
      sigma: MixOps.merge(sigma, other.sigma),
      tileMode: MixOps.merge(tileMode, other.tileMode),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('sigma', sigma))
      ..add(DiagnosticsProperty('tileMode', tileMode));
  }

  @override
  List<Object?> get props => [sigma, tileMode];
}
