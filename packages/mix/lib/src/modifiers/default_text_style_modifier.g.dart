// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_text_style_modifier.dart';

// **************************************************************************
// ModifierGenerator
// **************************************************************************

mixin _$DefaultTextStyleModifierMethods
    on WidgetModifier<DefaultTextStyleModifier>, Diagnosticable {
  int? get maxLines;
  TextOverflow get overflow;
  bool get softWrap;
  TextStyle get style;
  TextAlign? get textAlign;
  TextHeightBehavior? get textHeightBehavior;
  TextWidthBasis get textWidthBasis;

  @override
  DefaultTextStyleModifier copyWith({
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    TextStyle? style,
    TextAlign? textAlign,
    TextHeightBehavior? textHeightBehavior,
    TextWidthBasis? textWidthBasis,
  }) {
    return DefaultTextStyleModifier(
      maxLines: maxLines ?? this.maxLines,
      overflow: overflow ?? this.overflow,
      softWrap: softWrap ?? this.softWrap,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('maxLines', maxLines))
      ..add(EnumProperty<TextOverflow>('overflow', overflow))
      ..add(
        FlagProperty(
          'softWrap',
          value: softWrap,
          ifTrue: 'wrapping at word boundaries',
        ),
      )
      ..add(DiagnosticsProperty('style', style))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior))
      ..add(EnumProperty<TextWidthBasis>('textWidthBasis', textWidthBasis));
  }

  @override
  List<Object?> get props => [
    maxLines,
    overflow,
    softWrap,
    style,
    textAlign,
    textHeightBehavior,
    textWidthBasis,
  ];
}

class DefaultTextStyleModifierMix extends ModifierMix<DefaultTextStyleModifier>
    with Diagnosticable {
  final Prop<int>? maxLines;
  final Prop<TextOverflow>? overflow;
  final Prop<bool>? softWrap;
  final Prop<TextStyle>? style;
  final Prop<TextAlign>? textAlign;
  final Prop<TextHeightBehavior>? textHeightBehavior;
  final Prop<TextWidthBasis>? textWidthBasis;

  const DefaultTextStyleModifierMix.create({
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.style,
    this.textAlign,
    this.textHeightBehavior,
    this.textWidthBasis,
  });

  DefaultTextStyleModifierMix({
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    TextStyleMix? style,
    TextAlign? textAlign,
    TextHeightBehaviorMix? textHeightBehavior,
    TextWidthBasis? textWidthBasis,
  }) : this.create(
         maxLines: Prop.maybe(maxLines),
         overflow: Prop.maybe(overflow),
         softWrap: Prop.maybe(softWrap),
         style: Prop.maybeMix(style),
         textAlign: Prop.maybe(textAlign),
         textHeightBehavior: Prop.maybeMix(textHeightBehavior),
         textWidthBasis: Prop.maybe(textWidthBasis),
       );

  @override
  DefaultTextStyleModifier resolve(BuildContext context) {
    return DefaultTextStyleModifier(
      maxLines: MixOps.resolve(context, maxLines),
      overflow: MixOps.resolve(context, overflow),
      softWrap: MixOps.resolve(context, softWrap),
      style: MixOps.resolve(context, style),
      textAlign: MixOps.resolve(context, textAlign),
      textHeightBehavior: MixOps.resolve(context, textHeightBehavior),
      textWidthBasis: MixOps.resolve(context, textWidthBasis),
    );
  }

  @override
  DefaultTextStyleModifierMix merge(DefaultTextStyleModifierMix? other) {
    if (other == null) return this;

    return DefaultTextStyleModifierMix.create(
      maxLines: MixOps.merge(maxLines, other.maxLines),
      overflow: MixOps.merge(overflow, other.overflow),
      softWrap: MixOps.merge(softWrap, other.softWrap),
      style: MixOps.merge(style, other.style),
      textAlign: MixOps.merge(textAlign, other.textAlign),
      textHeightBehavior: MixOps.merge(
        textHeightBehavior,
        other.textHeightBehavior,
      ),
      textWidthBasis: MixOps.merge(textWidthBasis, other.textWidthBasis),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('maxLines', maxLines))
      ..add(DiagnosticsProperty('overflow', overflow))
      ..add(DiagnosticsProperty('softWrap', softWrap))
      ..add(DiagnosticsProperty('style', style))
      ..add(DiagnosticsProperty('textAlign', textAlign))
      ..add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior))
      ..add(DiagnosticsProperty('textWidthBasis', textWidthBasis));
  }

  @override
  List<Object?> get props => [
    maxLines,
    overflow,
    softWrap,
    style,
    textAlign,
    textHeightBehavior,
    textWidthBasis,
  ];
}
