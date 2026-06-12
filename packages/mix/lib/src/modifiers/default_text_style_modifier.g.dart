// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_text_style_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$DefaultTextStyleModifier
    implements WidgetModifier<DefaultTextStyleModifier>, Diagnosticable {
  TextStyle get style;
  TextAlign? get textAlign;
  bool get softWrap;
  TextOverflow get overflow;
  int? get maxLines;
  TextWidthBasis get textWidthBasis;
  TextHeightBehavior? get textHeightBehavior;

  @override
  Type get type => DefaultTextStyleModifier;

  @override
  DefaultTextStyleModifier copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return DefaultTextStyleModifier(
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

  @override
  List<Object?> get props => [
    style,
    textAlign,
    softWrap,
    overflow,
    maxLines,
    textWidthBasis,
    textHeightBehavior,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DefaultTextStyleModifier &&
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
      ..add(DiagnosticsProperty('style', style))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(
        FlagProperty(
          'softWrap',
          value: softWrap,
          ifTrue: 'wrapping at word boundaries',
        ),
      )
      ..add(EnumProperty<TextOverflow>('overflow', overflow))
      ..add(IntProperty('maxLines', maxLines))
      ..add(EnumProperty<TextWidthBasis>('textWidthBasis', textWidthBasis))
      ..add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior));
  }
}

class DefaultTextStyleModifierMix extends ModifierMix<DefaultTextStyleModifier>
    with Diagnosticable {
  final Prop<TextStyle>? style;
  final Prop<TextAlign>? textAlign;
  final Prop<bool>? softWrap;
  final Prop<TextOverflow>? overflow;
  final Prop<int>? maxLines;
  final Prop<TextWidthBasis>? textWidthBasis;
  final Prop<TextHeightBehavior>? textHeightBehavior;

  const DefaultTextStyleModifierMix.create({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  DefaultTextStyleModifierMix({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) : this.create(
         style: Prop.maybeMix(style),
         textAlign: Prop.maybe(textAlign),
         softWrap: Prop.maybe(softWrap),
         overflow: Prop.maybe(overflow),
         maxLines: Prop.maybe(maxLines),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: Prop.maybeMix(textHeightBehavior),
       );

  @override
  DefaultTextStyleModifier resolve(BuildContext context) {
    return DefaultTextStyleModifier(
      style: MixOps.resolve(context, style),
      textAlign: MixOps.resolve(context, textAlign),
      softWrap: MixOps.resolve(context, softWrap),
      overflow: MixOps.resolve(context, overflow),
      maxLines: MixOps.resolve(context, maxLines),
      textWidthBasis: MixOps.resolve(context, textWidthBasis),
      textHeightBehavior: MixOps.resolve(context, textHeightBehavior),
    );
  }

  @override
  DefaultTextStyleModifierMix merge(DefaultTextStyleModifierMix? other) {
    if (other == null) return this;

    return DefaultTextStyleModifierMix.create(
      style: MixOps.merge(style, other.style),
      textAlign: MixOps.merge(textAlign, other.textAlign),
      softWrap: MixOps.merge(softWrap, other.softWrap),
      overflow: MixOps.merge(overflow, other.overflow),
      maxLines: MixOps.merge(maxLines, other.maxLines),
      textWidthBasis: MixOps.merge(textWidthBasis, other.textWidthBasis),
      textHeightBehavior: MixOps.merge(
        textHeightBehavior,
        other.textHeightBehavior,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('style', style))
      ..add(DiagnosticsProperty('textAlign', textAlign))
      ..add(DiagnosticsProperty('softWrap', softWrap))
      ..add(DiagnosticsProperty('overflow', overflow))
      ..add(DiagnosticsProperty('maxLines', maxLines))
      ..add(DiagnosticsProperty('textWidthBasis', textWidthBasis))
      ..add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior));
  }

  @override
  List<Object?> get props => [
    style,
    textAlign,
    softWrap,
    overflow,
    maxLines,
    textWidthBasis,
    textHeightBehavior,
  ];
}
