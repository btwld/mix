// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_style.dart';

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$TextStylerMixin on Style<TextSpec>, Diagnosticable {
  Prop<Locale>? get $locale;
  Prop<int>? get $maxLines;
  Prop<TextOverflow>? get $overflow;
  Prop<Color>? get $selectionColor;
  Prop<String>? get $semanticsLabel;
  Prop<bool>? get $softWrap;
  Prop<StrutStyle>? get $strutStyle;
  Prop<TextStyle>? get $style;
  Prop<TextAlign>? get $textAlign;
  Prop<TextDirection>? get $textDirection;
  List<Directive<String>>? get $textDirectives;
  Prop<TextHeightBehavior>? get $textHeightBehavior;
  Prop<TextScaler>? get $textScaler;
  Prop<TextWidthBasis>? get $textWidthBasis;

  /// Sets the locale.
  TextStyler locale(Locale value) {
    return merge(TextStyler(locale: value));
  }

  /// Sets the maxLines.
  TextStyler maxLines(int value) {
    return merge(TextStyler(maxLines: value));
  }

  /// Sets the overflow.
  TextStyler overflow(TextOverflow value) {
    return merge(TextStyler(overflow: value));
  }

  /// Sets the selectionColor.
  TextStyler selectionColor(Color value) {
    return merge(TextStyler(selectionColor: value));
  }

  /// Sets the semanticsLabel.
  TextStyler semanticsLabel(String value) {
    return merge(TextStyler(semanticsLabel: value));
  }

  /// Sets the softWrap.
  TextStyler softWrap(bool value) {
    return merge(TextStyler(softWrap: value));
  }

  /// Sets the strutStyle.
  TextStyler strutStyle(StrutStyleMix value) {
    return merge(TextStyler(strutStyle: value));
  }

  /// Sets the style.
  TextStyler style(TextStyleMix value) {
    return merge(TextStyler(style: value));
  }

  /// Sets the textAlign.
  TextStyler textAlign(TextAlign value) {
    return merge(TextStyler(textAlign: value));
  }

  /// Sets the textDirection.
  TextStyler textDirection(TextDirection value) {
    return merge(TextStyler(textDirection: value));
  }

  /// Sets the textHeightBehavior.
  TextStyler textHeightBehavior(TextHeightBehaviorMix value) {
    return merge(TextStyler(textHeightBehavior: value));
  }

  /// Sets the textScaler.
  TextStyler textScaler(TextScaler value) {
    return merge(TextStyler(textScaler: value));
  }

  /// Sets the textWidthBasis.
  TextStyler textWidthBasis(TextWidthBasis value) {
    return merge(TextStyler(textWidthBasis: value));
  }

  /// Sets the animation configuration.
  TextStyler animate(AnimationConfig value) {
    return merge(TextStyler(animation: value));
  }

  /// Sets the style variants.
  TextStyler variants(List<VariantStyle<TextSpec>> value) {
    return merge(TextStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  TextStyler wrap(WidgetModifierConfig value) {
    return merge(TextStyler(modifier: value));
  }

  /// Merges with another [TextStyler].
  @override
  TextStyler merge(TextStyler? other) {
    return TextStyler.create(
      locale: MixOps.merge($locale, other?.$locale),
      maxLines: MixOps.merge($maxLines, other?.$maxLines),
      overflow: MixOps.merge($overflow, other?.$overflow),
      selectionColor: MixOps.merge($selectionColor, other?.$selectionColor),
      semanticsLabel: MixOps.merge($semanticsLabel, other?.$semanticsLabel),
      softWrap: MixOps.merge($softWrap, other?.$softWrap),
      strutStyle: MixOps.merge($strutStyle, other?.$strutStyle),
      style: MixOps.merge($style, other?.$style),
      textAlign: MixOps.merge($textAlign, other?.$textAlign),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      textDirectives: MixOps.mergeList($textDirectives, other?.$textDirectives),
      textHeightBehavior: MixOps.merge(
        $textHeightBehavior,
        other?.$textHeightBehavior,
      ),
      textScaler: MixOps.merge($textScaler, other?.$textScaler),
      textWidthBasis: MixOps.merge($textWidthBasis, other?.$textWidthBasis),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<TextSpec>] using context.
  @override
  StyleSpec<TextSpec> resolve(BuildContext context) {
    final spec = TextSpec(
      locale: MixOps.resolve(context, $locale),
      maxLines: MixOps.resolve(context, $maxLines),
      overflow: MixOps.resolve(context, $overflow),
      selectionColor: MixOps.resolve(context, $selectionColor),
      semanticsLabel: MixOps.resolve(context, $semanticsLabel),
      softWrap: MixOps.resolve(context, $softWrap),
      strutStyle: MixOps.resolve(context, $strutStyle),
      style: MixOps.resolve(context, $style),
      textAlign: MixOps.resolve(context, $textAlign),
      textDirection: MixOps.resolve(context, $textDirection),
      textDirectives: $textDirectives,
      textHeightBehavior: MixOps.resolve(context, $textHeightBehavior),
      textScaler: MixOps.resolve(context, $textScaler),
      textWidthBasis: MixOps.resolve(context, $textWidthBasis),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('locale', $locale))
      ..add(DiagnosticsProperty('maxLines', $maxLines))
      ..add(DiagnosticsProperty('overflow', $overflow))
      ..add(DiagnosticsProperty('selectionColor', $selectionColor))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('softWrap', $softWrap))
      ..add(DiagnosticsProperty('strutStyle', $strutStyle))
      ..add(DiagnosticsProperty('style', $style))
      ..add(DiagnosticsProperty('textAlign', $textAlign))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('directives', $textDirectives))
      ..add(DiagnosticsProperty('textHeightBehavior', $textHeightBehavior))
      ..add(DiagnosticsProperty('textScaler', $textScaler))
      ..add(DiagnosticsProperty('textWidthBasis', $textWidthBasis));
  }

  @override
  List<Object?> get props => [
    $locale,
    $maxLines,
    $overflow,
    $selectionColor,
    $semanticsLabel,
    $softWrap,
    $strutStyle,
    $style,
    $textAlign,
    $textDirection,
    $textDirectives,
    $textHeightBehavior,
    $textScaler,
    $textWidthBasis,
    $animation,
    $modifier,
    $variants,
  ];
}
