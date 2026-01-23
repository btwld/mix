// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

mixin _$TextSpecMethods on Spec<TextSpec>, Diagnosticable {
  TextOverflow? get overflow;
  StrutStyle? get strutStyle;
  TextAlign? get textAlign;
  TextScaler? get textScaler;
  int? get maxLines;
  TextStyle? get style;
  TextWidthBasis? get textWidthBasis;
  TextHeightBehavior? get textHeightBehavior;
  TextDirection? get textDirection;
  bool? get softWrap;
  List<Directive<String>>? get textDirectives;
  Color? get selectionColor;
  String? get semanticsLabel;
  Locale? get locale;

  @override
  TextSpec copyWith({
    TextOverflow? overflow,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextScaler? textScaler,
    int? maxLines,
    TextStyle? style,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    TextDirection? textDirection,
    bool? softWrap,
    List<Directive<String>>? textDirectives,
    Color? selectionColor,
    String? semanticsLabel,
    Locale? locale,
  }) {
    return TextSpec(
      overflow: overflow ?? this.overflow,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textScaler: textScaler ?? this.textScaler,
      maxLines: maxLines ?? this.maxLines,
      style: style ?? this.style,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      textDirection: textDirection ?? this.textDirection,
      softWrap: softWrap ?? this.softWrap,
      textDirectives: textDirectives ?? this.textDirectives,
      selectionColor: selectionColor ?? this.selectionColor,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      locale: locale ?? this.locale,
    );
  }

  @override
  TextSpec lerp(TextSpec? other, double t) {
    return TextSpec(
      overflow: MixOps.lerpSnap(overflow, other?.overflow, t),
      strutStyle: MixOps.lerp(strutStyle, other?.strutStyle, t),
      textAlign: MixOps.lerpSnap(textAlign, other?.textAlign, t),
      textScaler: MixOps.lerpSnap(textScaler, other?.textScaler, t),
      maxLines: MixOps.lerp(maxLines, other?.maxLines, t),
      style: MixOps.lerp(style, other?.style, t),
      textWidthBasis: MixOps.lerpSnap(textWidthBasis, other?.textWidthBasis, t),
      textHeightBehavior: MixOps.lerpSnap(
        textHeightBehavior,
        other?.textHeightBehavior,
        t,
      ),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      softWrap: MixOps.lerpSnap(softWrap, other?.softWrap, t),
      textDirectives: MixOps.lerpSnap(textDirectives, other?.textDirectives, t),
      selectionColor: MixOps.lerp(selectionColor, other?.selectionColor, t),
      semanticsLabel: MixOps.lerpSnap(semanticsLabel, other?.semanticsLabel, t),
      locale: MixOps.lerpSnap(locale, other?.locale, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<TextOverflow>('overflow', overflow))
      ..add(DiagnosticsProperty('strutStyle', strutStyle))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(DiagnosticsProperty('textScaler', textScaler))
      ..add(IntProperty('maxLines', maxLines))
      ..add(DiagnosticsProperty('style', style))
      ..add(EnumProperty<TextWidthBasis>('textWidthBasis', textWidthBasis))
      ..add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(
        FlagProperty(
          'softWrap',
          value: softWrap,
          ifTrue: 'wrapping at word boundaries',
        ),
      )
      ..add(IterableProperty<Directive<String>>('directives', textDirectives))
      ..add(ColorProperty('selectionColor', selectionColor))
      ..add(StringProperty('semanticsLabel', semanticsLabel))
      ..add(DiagnosticsProperty('locale', locale));
  }

  @override
  List<Object?> get props => [
    overflow,
    strutStyle,
    textAlign,
    textScaler,
    maxLines,
    style,
    textWidthBasis,
    textHeightBehavior,
    textDirection,
    softWrap,
    textDirectives,
    selectionColor,
    semanticsLabel,
    locale,
  ];
}
