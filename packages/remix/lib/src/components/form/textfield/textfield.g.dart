// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textfield.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [TextFieldSpec].
mixin _$TextFieldSpec on Spec<TextFieldSpec> {
  static TextFieldSpec from(MixData mix) {
    return mix.attributeOf<TextFieldSpecAttribute>()?.resolve(mix) ??
        const TextFieldSpec();
  }

  /// {@template text_field_spec_of}
  /// Retrieves the [TextFieldSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [TextFieldSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [TextFieldSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final textFieldSpec = TextFieldSpec.of(context);
  /// ```
  /// {@endtemplate}
  static TextFieldSpec of(BuildContext context) {
    return _$TextFieldSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [TextFieldSpec] but with the given fields
  /// replaced with the new values.
  @override
  TextFieldSpec copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    StrutStyle? strutStyle,
    TextHeightBehavior? textHeightBehavior,
    TextWidthBasis? textWidthBasis,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Offset? cursorOffset,
    bool? paintCursorAboveText,
    Color? backgroundCursorColor,
    Color? selectionColor,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    Clip? clipBehavior,
    Brightness? keyboardAppearance,
    Color? autocorrectionTextRectColor,
    bool? cursorOpacityAnimates,
    FlexBoxSpec? outerContainer,
    FlexBoxSpec? container,
    TextStyle? hintTextStyle,
    TextSpec? helperText,
    IconSpec? icon,
    bool? floatingLabel,
    double? floatingLabelHeight,
    TextStyle? floatingLabelStyle,
    AnimatedData? animated,
    WidgetModifiersData? modifiers,
  }) {
    return TextFieldSpec(
      style: style ?? _$this.style,
      textAlign: textAlign ?? _$this.textAlign,
      strutStyle: strutStyle ?? _$this.strutStyle,
      textHeightBehavior: textHeightBehavior ?? _$this.textHeightBehavior,
      textWidthBasis: textWidthBasis ?? _$this.textWidthBasis,
      cursorWidth: cursorWidth ?? _$this.cursorWidth,
      cursorHeight: cursorHeight ?? _$this.cursorHeight,
      cursorRadius: cursorRadius ?? _$this.cursorRadius,
      cursorColor: cursorColor ?? _$this.cursorColor,
      cursorOffset: cursorOffset ?? _$this.cursorOffset,
      paintCursorAboveText: paintCursorAboveText ?? _$this.paintCursorAboveText,
      backgroundCursorColor:
          backgroundCursorColor ?? _$this.backgroundCursorColor,
      selectionColor: selectionColor ?? _$this.selectionColor,
      selectionHeightStyle: selectionHeightStyle ?? _$this.selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? _$this.selectionWidthStyle,
      scrollPadding: scrollPadding ?? _$this.scrollPadding,
      clipBehavior: clipBehavior ?? _$this.clipBehavior,
      keyboardAppearance: keyboardAppearance ?? _$this.keyboardAppearance,
      autocorrectionTextRectColor:
          autocorrectionTextRectColor ?? _$this.autocorrectionTextRectColor,
      cursorOpacityAnimates:
          cursorOpacityAnimates ?? _$this.cursorOpacityAnimates,
      outerContainer: outerContainer ?? _$this.outerContainer,
      container: container ?? _$this.container,
      hintTextStyle: hintTextStyle ?? _$this.hintTextStyle,
      helperText: helperText ?? _$this.helperText,
      icon: icon ?? _$this.icon,
      floatingLabel: floatingLabel ?? _$this.floatingLabel,
      floatingLabelHeight: floatingLabelHeight ?? _$this.floatingLabelHeight,
      floatingLabelStyle: floatingLabelStyle ?? _$this.floatingLabelStyle,
      animated: animated ?? _$this.animated,
      modifiers: modifiers ?? _$this.modifiers,
    );
  }

  /// Linearly interpolates between this [TextFieldSpec] and another [TextFieldSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [TextFieldSpec] is returned. When [t] is 1.0, the [other] [TextFieldSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [TextFieldSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [TextFieldSpec] instance.
  ///
  /// The interpolation is performed on each property of the [TextFieldSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpTextStyle] for [style] and [hintTextStyle] and [floatingLabelStyle].
  /// - [MixHelpers.lerpStrutStyle] for [strutStyle].
  /// - [MixHelpers.lerpDouble] for [cursorWidth] and [cursorHeight] and [floatingLabelHeight].
  /// - [Radius.lerp] for [cursorRadius].
  /// - [Color.lerp] for [cursorColor] and [backgroundCursorColor] and [selectionColor] and [autocorrectionTextRectColor].
  /// - [Offset.lerp] for [cursorOffset].
  /// - [EdgeInsets.lerp] for [scrollPadding].
  /// - [FlexBoxSpec.lerp] for [outerContainer] and [container].
  /// - [TextSpec.lerp] for [helperText].
  /// - [IconSpec.lerp] for [icon].
  /// For [textAlign] and [textHeightBehavior] and [textWidthBasis] and [paintCursorAboveText] and [selectionHeightStyle] and [selectionWidthStyle] and [clipBehavior] and [keyboardAppearance] and [cursorOpacityAnimates] and [floatingLabel] and [animated] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [TextFieldSpec] is used. Otherwise, the value
  /// from the [other] [TextFieldSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [TextFieldSpec] configurations.
  @override
  TextFieldSpec lerp(TextFieldSpec? other, double t) {
    if (other == null) return _$this;

    return TextFieldSpec(
      style: MixHelpers.lerpTextStyle(_$this.style, other.style, t)!,
      textAlign: t < 0.5 ? _$this.textAlign : other.textAlign,
      strutStyle:
          MixHelpers.lerpStrutStyle(_$this.strutStyle, other.strutStyle, t),
      textHeightBehavior:
          t < 0.5 ? _$this.textHeightBehavior : other.textHeightBehavior,
      textWidthBasis: t < 0.5 ? _$this.textWidthBasis : other.textWidthBasis,
      cursorWidth:
          MixHelpers.lerpDouble(_$this.cursorWidth, other.cursorWidth, t)!,
      cursorHeight:
          MixHelpers.lerpDouble(_$this.cursorHeight, other.cursorHeight, t),
      cursorRadius: Radius.lerp(_$this.cursorRadius, other.cursorRadius, t),
      cursorColor: Color.lerp(_$this.cursorColor, other.cursorColor, t)!,
      cursorOffset: Offset.lerp(_$this.cursorOffset, other.cursorOffset, t)!,
      paintCursorAboveText:
          t < 0.5 ? _$this.paintCursorAboveText : other.paintCursorAboveText,
      backgroundCursorColor: Color.lerp(
          _$this.backgroundCursorColor, other.backgroundCursorColor, t)!,
      selectionColor:
          Color.lerp(_$this.selectionColor, other.selectionColor, t),
      selectionHeightStyle:
          t < 0.5 ? _$this.selectionHeightStyle : other.selectionHeightStyle,
      selectionWidthStyle:
          t < 0.5 ? _$this.selectionWidthStyle : other.selectionWidthStyle,
      scrollPadding:
          EdgeInsets.lerp(_$this.scrollPadding, other.scrollPadding, t)!,
      clipBehavior: t < 0.5 ? _$this.clipBehavior : other.clipBehavior,
      keyboardAppearance:
          t < 0.5 ? _$this.keyboardAppearance : other.keyboardAppearance,
      autocorrectionTextRectColor: Color.lerp(
          _$this.autocorrectionTextRectColor,
          other.autocorrectionTextRectColor,
          t),
      cursorOpacityAnimates:
          t < 0.5 ? _$this.cursorOpacityAnimates : other.cursorOpacityAnimates,
      outerContainer: _$this.outerContainer.lerp(other.outerContainer, t),
      container: _$this.container.lerp(other.container, t),
      hintTextStyle: MixHelpers.lerpTextStyle(
          _$this.hintTextStyle, other.hintTextStyle, t),
      helperText: _$this.helperText.lerp(other.helperText, t),
      icon: _$this.icon.lerp(other.icon, t),
      floatingLabel: t < 0.5 ? _$this.floatingLabel : other.floatingLabel,
      floatingLabelHeight: MixHelpers.lerpDouble(
          _$this.floatingLabelHeight, other.floatingLabelHeight, t)!,
      floatingLabelStyle: MixHelpers.lerpTextStyle(
          _$this.floatingLabelStyle, other.floatingLabelStyle, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
      modifiers: other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [TextFieldSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextFieldSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.style,
        _$this.textAlign,
        _$this.strutStyle,
        _$this.textHeightBehavior,
        _$this.textWidthBasis,
        _$this.cursorWidth,
        _$this.cursorHeight,
        _$this.cursorRadius,
        _$this.cursorColor,
        _$this.cursorOffset,
        _$this.paintCursorAboveText,
        _$this.backgroundCursorColor,
        _$this.selectionColor,
        _$this.selectionHeightStyle,
        _$this.selectionWidthStyle,
        _$this.scrollPadding,
        _$this.clipBehavior,
        _$this.keyboardAppearance,
        _$this.autocorrectionTextRectColor,
        _$this.cursorOpacityAnimates,
        _$this.outerContainer,
        _$this.container,
        _$this.hintTextStyle,
        _$this.helperText,
        _$this.icon,
        _$this.floatingLabel,
        _$this.floatingLabelHeight,
        _$this.floatingLabelStyle,
        _$this.animated,
        _$this.modifiers,
      ];

  TextFieldSpec get _$this => this as TextFieldSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('style', _$this.style, defaultValue: null));
    properties.add(
        DiagnosticsProperty('textAlign', _$this.textAlign, defaultValue: null));
    properties.add(DiagnosticsProperty('strutStyle', _$this.strutStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'textHeightBehavior', _$this.textHeightBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty('textWidthBasis', _$this.textWidthBasis,
        defaultValue: null));
    properties.add(DiagnosticsProperty('cursorWidth', _$this.cursorWidth,
        defaultValue: null));
    properties.add(DiagnosticsProperty('cursorHeight', _$this.cursorHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty('cursorRadius', _$this.cursorRadius,
        defaultValue: null));
    properties.add(DiagnosticsProperty('cursorColor', _$this.cursorColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty('cursorOffset', _$this.cursorOffset,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'paintCursorAboveText', _$this.paintCursorAboveText,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'backgroundCursorColor', _$this.backgroundCursorColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty('selectionColor', _$this.selectionColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'selectionHeightStyle', _$this.selectionHeightStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'selectionWidthStyle', _$this.selectionWidthStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty('scrollPadding', _$this.scrollPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty('clipBehavior', _$this.clipBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'keyboardAppearance', _$this.keyboardAppearance,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'autocorrectionTextRectColor', _$this.autocorrectionTextRectColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'cursorOpacityAnimates', _$this.cursorOpacityAnimates,
        defaultValue: null));
    properties.add(DiagnosticsProperty('outerContainer', _$this.outerContainer,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(DiagnosticsProperty('hintTextStyle', _$this.hintTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty('helperText', _$this.helperText,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties.add(DiagnosticsProperty('floatingLabel', _$this.floatingLabel,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'floatingLabelHeight', _$this.floatingLabelHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'floatingLabelStyle', _$this.floatingLabelStyle,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
  }
}

/// Represents the attributes of a [TextFieldSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextFieldSpec].
///
/// Use this class to configure the attributes of a [TextFieldSpec] and pass it to
/// the [TextFieldSpec] constructor.
class TextFieldSpecAttribute extends SpecAttribute<TextFieldSpec>
    with Diagnosticable {
  final TextStyleDto? style;
  final TextAlign? textAlign;
  final StrutStyleDto? strutStyle;
  final TextHeightBehaviorDto? textHeightBehavior;
  final TextWidthBasis? textWidthBasis;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final ColorDto? cursorColor;
  final Offset? cursorOffset;
  final bool? paintCursorAboveText;
  final ColorDto? backgroundCursorColor;
  final ColorDto? selectionColor;
  final BoxHeightStyle? selectionHeightStyle;
  final BoxWidthStyle? selectionWidthStyle;
  final EdgeInsetsDto? scrollPadding;
  final Clip? clipBehavior;
  final Brightness? keyboardAppearance;
  final ColorDto? autocorrectionTextRectColor;
  final bool? cursorOpacityAnimates;
  final FlexBoxSpecAttribute? outerContainer;
  final FlexBoxSpecAttribute? container;
  final TextStyleDto? hintTextStyle;
  final TextSpecAttribute? helperText;
  final IconSpecAttribute? icon;
  final bool? floatingLabel;
  final double? floatingLabelHeight;
  final TextStyleDto? floatingLabelStyle;

  const TextFieldSpecAttribute({
    this.style,
    this.textAlign,
    this.strutStyle,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.cursorOffset,
    this.paintCursorAboveText,
    this.backgroundCursorColor,
    this.selectionColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.scrollPadding,
    this.clipBehavior,
    this.keyboardAppearance,
    this.autocorrectionTextRectColor,
    this.cursorOpacityAnimates,
    this.outerContainer,
    this.container,
    this.hintTextStyle,
    this.helperText,
    this.icon,
    this.floatingLabel,
    this.floatingLabelHeight,
    this.floatingLabelStyle,
    super.animated,
    super.modifiers,
  });

  /// Resolves to [TextFieldSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textFieldSpec = TextFieldSpecAttribute(...).resolve(mix);
  /// ```
  @override
  TextFieldSpec resolve(MixData mix) {
    return TextFieldSpec(
      style: style?.resolve(mix),
      textAlign: textAlign,
      strutStyle: strutStyle?.resolve(mix),
      textHeightBehavior: textHeightBehavior?.resolve(mix),
      textWidthBasis: textWidthBasis,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor?.resolve(mix),
      cursorOffset: cursorOffset,
      paintCursorAboveText: paintCursorAboveText,
      backgroundCursorColor: backgroundCursorColor?.resolve(mix),
      selectionColor: selectionColor?.resolve(mix),
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      scrollPadding: scrollPadding?.resolve(mix),
      clipBehavior: clipBehavior,
      keyboardAppearance: keyboardAppearance,
      autocorrectionTextRectColor: autocorrectionTextRectColor?.resolve(mix),
      cursorOpacityAnimates: cursorOpacityAnimates,
      outerContainer: outerContainer?.resolve(mix),
      container: container?.resolve(mix),
      hintTextStyle: hintTextStyle?.resolve(mix),
      helperText: helperText?.resolve(mix),
      icon: icon?.resolve(mix),
      floatingLabel: floatingLabel,
      floatingLabelHeight: floatingLabelHeight,
      floatingLabelStyle: floatingLabelStyle?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
    );
  }

  /// Merges the properties of this [TextFieldSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextFieldSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextFieldSpecAttribute merge(TextFieldSpecAttribute? other) {
    if (other == null) return this;

    return TextFieldSpecAttribute(
      style: style?.merge(other.style) ?? other.style,
      textAlign: other.textAlign ?? textAlign,
      strutStyle: strutStyle?.merge(other.strutStyle) ?? other.strutStyle,
      textHeightBehavior: textHeightBehavior?.merge(other.textHeightBehavior) ??
          other.textHeightBehavior,
      textWidthBasis: other.textWidthBasis ?? textWidthBasis,
      cursorWidth: other.cursorWidth ?? cursorWidth,
      cursorHeight: other.cursorHeight ?? cursorHeight,
      cursorRadius: other.cursorRadius ?? cursorRadius,
      cursorColor: cursorColor?.merge(other.cursorColor) ?? other.cursorColor,
      cursorOffset: other.cursorOffset ?? cursorOffset,
      paintCursorAboveText: other.paintCursorAboveText ?? paintCursorAboveText,
      backgroundCursorColor:
          backgroundCursorColor?.merge(other.backgroundCursorColor) ??
              other.backgroundCursorColor,
      selectionColor:
          selectionColor?.merge(other.selectionColor) ?? other.selectionColor,
      selectionHeightStyle: other.selectionHeightStyle ?? selectionHeightStyle,
      selectionWidthStyle: other.selectionWidthStyle ?? selectionWidthStyle,
      scrollPadding:
          scrollPadding?.merge(other.scrollPadding) ?? other.scrollPadding,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      keyboardAppearance: other.keyboardAppearance ?? keyboardAppearance,
      autocorrectionTextRectColor: autocorrectionTextRectColor
              ?.merge(other.autocorrectionTextRectColor) ??
          other.autocorrectionTextRectColor,
      cursorOpacityAnimates:
          other.cursorOpacityAnimates ?? cursorOpacityAnimates,
      outerContainer:
          outerContainer?.merge(other.outerContainer) ?? other.outerContainer,
      container: container?.merge(other.container) ?? other.container,
      hintTextStyle:
          hintTextStyle?.merge(other.hintTextStyle) ?? other.hintTextStyle,
      helperText: helperText?.merge(other.helperText) ?? other.helperText,
      icon: icon?.merge(other.icon) ?? other.icon,
      floatingLabel: other.floatingLabel ?? floatingLabel,
      floatingLabelHeight: other.floatingLabelHeight ?? floatingLabelHeight,
      floatingLabelStyle: floatingLabelStyle?.merge(other.floatingLabelStyle) ??
          other.floatingLabelStyle,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  /// The list of properties that constitute the state of this [TextFieldSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextFieldSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        style,
        textAlign,
        strutStyle,
        textHeightBehavior,
        textWidthBasis,
        cursorWidth,
        cursorHeight,
        cursorRadius,
        cursorColor,
        cursorOffset,
        paintCursorAboveText,
        backgroundCursorColor,
        selectionColor,
        selectionHeightStyle,
        selectionWidthStyle,
        scrollPadding,
        clipBehavior,
        keyboardAppearance,
        autocorrectionTextRectColor,
        cursorOpacityAnimates,
        outerContainer,
        container,
        hintTextStyle,
        helperText,
        icon,
        floatingLabel,
        floatingLabelHeight,
        floatingLabelStyle,
        animated,
        modifiers,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties
        .add(DiagnosticsProperty('textAlign', textAlign, defaultValue: null));
    properties
        .add(DiagnosticsProperty('strutStyle', strutStyle, defaultValue: null));
    properties.add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty('textWidthBasis', textWidthBasis,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('cursorWidth', cursorWidth, defaultValue: null));
    properties.add(
        DiagnosticsProperty('cursorHeight', cursorHeight, defaultValue: null));
    properties.add(
        DiagnosticsProperty('cursorRadius', cursorRadius, defaultValue: null));
    properties.add(
        DiagnosticsProperty('cursorColor', cursorColor, defaultValue: null));
    properties.add(
        DiagnosticsProperty('cursorOffset', cursorOffset, defaultValue: null));
    properties.add(DiagnosticsProperty(
        'paintCursorAboveText', paintCursorAboveText,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'backgroundCursorColor', backgroundCursorColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty('selectionColor', selectionColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'selectionHeightStyle', selectionHeightStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'selectionWidthStyle', selectionWidthStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty('scrollPadding', scrollPadding,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null));
    properties.add(DiagnosticsProperty('keyboardAppearance', keyboardAppearance,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'autocorrectionTextRectColor', autocorrectionTextRectColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'cursorOpacityAnimates', cursorOpacityAnimates,
        defaultValue: null));
    properties.add(DiagnosticsProperty('outerContainer', outerContainer,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('hintTextStyle', hintTextStyle,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('helperText', helperText, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties.add(DiagnosticsProperty('floatingLabel', floatingLabel,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'floatingLabelHeight', floatingLabelHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty('floatingLabelStyle', floatingLabelStyle,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
  }
}

/// Utility class for configuring [TextFieldSpec] properties.
///
/// This class provides methods to set individual properties of a [TextFieldSpec].
/// Use the methods of this class to configure specific properties of a [TextFieldSpec].
class TextFieldSpecUtility<T extends Attribute>
    extends SpecUtility<T, TextFieldSpecAttribute> {
  /// Utility for defining [TextFieldSpecAttribute.style]
  late final style = TextStyleUtility((v) => only(style: v));

  /// Utility for defining [TextFieldSpecAttribute.textAlign]
  late final textAlign = TextAlignUtility((v) => only(textAlign: v));

  /// Utility for defining [TextFieldSpecAttribute.strutStyle]
  late final strutStyle = StrutStyleUtility((v) => only(strutStyle: v));

  /// Utility for defining [TextFieldSpecAttribute.textHeightBehavior]
  late final textHeightBehavior =
      TextHeightBehaviorUtility((v) => only(textHeightBehavior: v));

  /// Utility for defining [TextFieldSpecAttribute.textWidthBasis]
  late final textWidthBasis =
      TextWidthBasisUtility((v) => only(textWidthBasis: v));

  /// Utility for defining [TextFieldSpecAttribute.cursorWidth]
  late final cursorWidth = DoubleUtility((v) => only(cursorWidth: v));

  /// Utility for defining [TextFieldSpecAttribute.cursorHeight]
  late final cursorHeight = DoubleUtility((v) => only(cursorHeight: v));

  /// Utility for defining [TextFieldSpecAttribute.cursorRadius]
  late final cursorRadius = RadiusUtility((v) => only(cursorRadius: v));

  /// Utility for defining [TextFieldSpecAttribute.cursorColor]
  late final cursorColor = ColorUtility((v) => only(cursorColor: v));

  /// Utility for defining [TextFieldSpecAttribute.cursorOffset]
  late final cursorOffset = OffsetUtility((v) => only(cursorOffset: v));

  /// Utility for defining [TextFieldSpecAttribute.paintCursorAboveText]
  late final paintCursorAboveText =
      BoolUtility((v) => only(paintCursorAboveText: v));

  /// Utility for defining [TextFieldSpecAttribute.backgroundCursorColor]
  late final backgroundCursorColor =
      ColorUtility((v) => only(backgroundCursorColor: v));

  /// Utility for defining [TextFieldSpecAttribute.selectionColor]
  late final selectionColor = ColorUtility((v) => only(selectionColor: v));

  /// Utility for defining [TextFieldSpecAttribute.selectionHeightStyle]
  late final selectionHeightStyle =
      BoxHeightStyleUtility((v) => only(selectionHeightStyle: v));

  /// Utility for defining [TextFieldSpecAttribute.selectionWidthStyle]
  late final selectionWidthStyle =
      BoxWidthStyleUtility((v) => only(selectionWidthStyle: v));

  /// Utility for defining [TextFieldSpecAttribute.scrollPadding]
  late final scrollPadding = EdgeInsetsUtility((v) => only(scrollPadding: v));

  /// Utility for defining [TextFieldSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility((v) => only(clipBehavior: v));

  /// Utility for defining [TextFieldSpecAttribute.keyboardAppearance]
  late final keyboardAppearance =
      BrightnessUtility((v) => only(keyboardAppearance: v));

  /// Utility for defining [TextFieldSpecAttribute.autocorrectionTextRectColor]
  late final autocorrectionTextRectColor =
      ColorUtility((v) => only(autocorrectionTextRectColor: v));

  /// Utility for defining [TextFieldSpecAttribute.cursorOpacityAnimates]
  late final cursorOpacityAnimates =
      BoolUtility((v) => only(cursorOpacityAnimates: v));

  /// Utility for defining [TextFieldSpecAttribute.outerContainer]
  late final outerContainer =
      FlexBoxSpecUtility((v) => only(outerContainer: v));

  /// Utility for defining [TextFieldSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [TextFieldSpecAttribute.hintTextStyle]
  late final hintTextStyle = TextStyleUtility((v) => only(hintTextStyle: v));

  /// Utility for defining [TextFieldSpecAttribute.helperText]
  late final helperText = TextSpecUtility((v) => only(helperText: v));

  /// Utility for defining [TextFieldSpecAttribute.icon]
  late final icon = IconSpecUtility((v) => only(icon: v));

  /// Utility for defining [TextFieldSpecAttribute.floatingLabel]
  late final floatingLabel = BoolUtility((v) => only(floatingLabel: v));

  /// Utility for defining [TextFieldSpecAttribute.floatingLabelHeight]
  late final floatingLabelHeight =
      DoubleUtility((v) => only(floatingLabelHeight: v));

  /// Utility for defining [TextFieldSpecAttribute.floatingLabelStyle]
  late final floatingLabelStyle =
      TextStyleUtility((v) => only(floatingLabelStyle: v));

  /// Utility for defining [TextFieldSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [TextFieldSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  TextFieldSpecUtility(super.builder, {super.mutable});

  TextFieldSpecUtility<T> get chain =>
      TextFieldSpecUtility(attributeBuilder, mutable: true);

  static TextFieldSpecUtility<TextFieldSpecAttribute> get self =>
      TextFieldSpecUtility((v) => v);

  /// Returns a new [TextFieldSpecAttribute] with the specified properties.
  @override
  T only({
    TextStyleDto? style,
    TextAlign? textAlign,
    StrutStyleDto? strutStyle,
    TextHeightBehaviorDto? textHeightBehavior,
    TextWidthBasis? textWidthBasis,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    ColorDto? cursorColor,
    Offset? cursorOffset,
    bool? paintCursorAboveText,
    ColorDto? backgroundCursorColor,
    ColorDto? selectionColor,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsetsDto? scrollPadding,
    Clip? clipBehavior,
    Brightness? keyboardAppearance,
    ColorDto? autocorrectionTextRectColor,
    bool? cursorOpacityAnimates,
    FlexBoxSpecAttribute? outerContainer,
    FlexBoxSpecAttribute? container,
    TextStyleDto? hintTextStyle,
    TextSpecAttribute? helperText,
    IconSpecAttribute? icon,
    bool? floatingLabel,
    double? floatingLabelHeight,
    TextStyleDto? floatingLabelStyle,
    AnimatedDataDto? animated,
    WidgetModifiersDataDto? modifiers,
  }) {
    return builder(TextFieldSpecAttribute(
      style: style,
      textAlign: textAlign,
      strutStyle: strutStyle,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      cursorOffset: cursorOffset,
      paintCursorAboveText: paintCursorAboveText,
      backgroundCursorColor: backgroundCursorColor,
      selectionColor: selectionColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      scrollPadding: scrollPadding,
      clipBehavior: clipBehavior,
      keyboardAppearance: keyboardAppearance,
      autocorrectionTextRectColor: autocorrectionTextRectColor,
      cursorOpacityAnimates: cursorOpacityAnimates,
      outerContainer: outerContainer,
      container: container,
      hintTextStyle: hintTextStyle,
      helperText: helperText,
      icon: icon,
      floatingLabel: floatingLabel,
      floatingLabelHeight: floatingLabelHeight,
      floatingLabelStyle: floatingLabelStyle,
      animated: animated,
      modifiers: modifiers,
    ));
  }
}

/// A tween that interpolates between two [TextFieldSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [TextFieldSpec] specifications.
class TextFieldSpecTween extends Tween<TextFieldSpec?> {
  TextFieldSpecTween({
    super.begin,
    super.end,
  });

  @override
  TextFieldSpec lerp(double t) {
    if (begin == null && end == null) {
      return const TextFieldSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
