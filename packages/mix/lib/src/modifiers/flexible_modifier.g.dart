// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexible_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$FlexibleModifier
    implements WidgetModifier<FlexibleModifier>, Diagnosticable {
  int? get flex;
  FlexFit? get fit;

  @override
  Type get type => FlexibleModifier;

  @override
  FlexibleModifier copyWith({int? flex, FlexFit? fit}) {
    return FlexibleModifier(flex: flex ?? this.flex, fit: fit ?? this.fit);
  }

  @override
  List<Object?> get props => [flex, fit];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FlexibleModifier &&
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
      ..add(IntProperty('flex', flex))
      ..add(EnumProperty<FlexFit>('fit', fit));
  }
}

class FlexibleModifierMix extends ModifierMix<FlexibleModifier>
    with Diagnosticable {
  final Prop<int>? flex;
  final Prop<FlexFit>? fit;

  const FlexibleModifierMix.create({this.flex, this.fit});

  FlexibleModifierMix({int? flex, FlexFit? fit})
    : this.create(flex: Prop.maybe(flex), fit: Prop.maybe(fit));

  @override
  FlexibleModifier resolve(BuildContext context) {
    return FlexibleModifier(
      flex: MixOps.resolve(context, flex),
      fit: MixOps.resolve(context, fit),
    );
  }

  @override
  FlexibleModifierMix merge(FlexibleModifierMix? other) {
    if (other == null) return this;

    return FlexibleModifierMix.create(
      flex: MixOps.merge(flex, other.flex),
      fit: MixOps.merge(fit, other.fit),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('flex', flex))
      ..add(DiagnosticsProperty('fit', fit));
  }

  @override
  List<Object?> get props => [flex, fit];
}
