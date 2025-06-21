// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textfield.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [TextFieldSpec].
mixin _$TextFieldSpec on Spec<TextFieldSpec> {
  static TextFieldSpec from(MixContext mix) {
    return mix.attributeOf<TextFieldSpecAttribute>()?.resolve(mix) ??
        const TextFieldSpec();
  }

  /// {@template text_field_spec_of}
  /// Retrieves the [TextFieldSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [TextFieldSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [TextFieldSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final textFieldSpec = TextFieldSpec.of(context);
  /// ```
  /// {@endtemplate}
  static TextFieldSpec of(BuildContext context) {
    return ComputedStyle.specOf<TextFieldSpec>(context) ??
        const TextFieldSpec();
  }

  /// Creates a copy of this [TextFieldSpec] but with the given fields
  /// replaced with the new values.
  @override
  TextFieldSpec copyWith({
    TextStyle? style,
    Color? hintTextColor,
    TextAlign? textAlign,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Offset? cursorOffset,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    Brightness? keyboardAppearance,
    bool? cursorOpacityAnimates,
    double? spacing,
    FlexBoxSpec? container,
    TextSpec? helperText,
    AnimatedData? animated,
    WidgetModifiersConfig? modifiers,
  }) {
    return TextFieldSpec(
      style: style ?? _$this.style,
      hintTextColor: hintTextColor ?? _$this.hintTextColor,
      textAlign: textAlign ?? _$this.textAlign,
      cursorWidth: cursorWidth ?? _$this.cursorWidth,
      cursorHeight: cursorHeight ?? _$this.cursorHeight,
      cursorRadius: cursorRadius ?? _$this.cursorRadius,
      cursorColor: cursorColor ?? _$this.cursorColor,
      cursorOffset: cursorOffset ?? _$this.cursorOffset,
      selectionHeightStyle: selectionHeightStyle ?? _$this.selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? _$this.selectionWidthStyle,
      scrollPadding: scrollPadding ?? _$this.scrollPadding,
      keyboardAppearance: keyboardAppearance ?? _$this.keyboardAppearance,
      cursorOpacityAnimates:
          cursorOpacityAnimates ?? _$this.cursorOpacityAnimates,
      spacing: spacing ?? _$this.spacing,
      container: container ?? _$this.container,
      helperText: helperText ?? _$this.helperText,
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
  /// - [MixHelpers.lerpTextStyle] for [style].
  /// - [Color.lerp] for [hintTextColor] and [cursorColor].
  /// - [MixHelpers.lerpDouble] for [cursorWidth] and [cursorHeight] and [spacing].
  /// - [Radius.lerp] for [cursorRadius].
  /// - [Offset.lerp] for [cursorOffset].
  /// - [EdgeInsets.lerp] for [scrollPadding].
  /// - [FlexBoxSpec.lerp] for [container].
  /// - [TextSpec.lerp] for [helperText].
  /// For [textAlign] and [selectionHeightStyle] and [selectionWidthStyle] and [keyboardAppearance] and [cursorOpacityAnimates] and [animated] and [modifiers], the interpolation is performed using a step function.
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
      hintTextColor: Color.lerp(_$this.hintTextColor, other.hintTextColor, t),
      textAlign: t < 0.5 ? _$this.textAlign : other.textAlign,
      cursorWidth:
          MixHelpers.lerpDouble(_$this.cursorWidth, other.cursorWidth, t)!,
      cursorHeight:
          MixHelpers.lerpDouble(_$this.cursorHeight, other.cursorHeight, t),
      cursorRadius: Radius.lerp(_$this.cursorRadius, other.cursorRadius, t),
      cursorColor: Color.lerp(_$this.cursorColor, other.cursorColor, t),
      cursorOffset: Offset.lerp(_$this.cursorOffset, other.cursorOffset, t)!,
      selectionHeightStyle:
          t < 0.5 ? _$this.selectionHeightStyle : other.selectionHeightStyle,
      selectionWidthStyle:
          t < 0.5 ? _$this.selectionWidthStyle : other.selectionWidthStyle,
      scrollPadding:
          EdgeInsets.lerp(_$this.scrollPadding, other.scrollPadding, t)!,
      keyboardAppearance:
          t < 0.5 ? _$this.keyboardAppearance : other.keyboardAppearance,
      cursorOpacityAnimates:
          t < 0.5 ? _$this.cursorOpacityAnimates : other.cursorOpacityAnimates,
      spacing: MixHelpers.lerpDouble(_$this.spacing, other.spacing, t)!,
      container: _$this.container.lerp(other.container, t),
      helperText: _$this.helperText.lerp(other.helperText, t),
      animated: _$this.animated ?? other.animated,
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
        _$this.hintTextColor,
        _$this.textAlign,
        _$this.cursorWidth,
        _$this.cursorHeight,
        _$this.cursorRadius,
        _$this.cursorColor,
        _$this.cursorOffset,
        _$this.selectionHeightStyle,
        _$this.selectionWidthStyle,
        _$this.scrollPadding,
        _$this.keyboardAppearance,
        _$this.cursorOpacityAnimates,
        _$this.spacing,
        _$this.container,
        _$this.helperText,
        _$this.animated,
        _$this.modifiers,
      ];

  TextFieldSpec get _$this => this as TextFieldSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('style', _$this.style, defaultValue: null));
    properties.add(DiagnosticsProperty('hintTextColor', _$this.hintTextColor,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('textAlign', _$this.textAlign, defaultValue: null));
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
        'selectionHeightStyle', _$this.selectionHeightStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'selectionWidthStyle', _$this.selectionWidthStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty('scrollPadding', _$this.scrollPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'keyboardAppearance', _$this.keyboardAppearance,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'cursorOpacityAnimates', _$this.cursorOpacityAnimates,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('spacing', _$this.spacing, defaultValue: null));
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(DiagnosticsProperty('helperText', _$this.helperText,
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
  final ColorDto? hintTextColor;
  final TextAlign? textAlign;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final ColorDto? cursorColor;
  final Offset? cursorOffset;
  final BoxHeightStyle? selectionHeightStyle;
  final BoxWidthStyle? selectionWidthStyle;
  final EdgeInsetsDto? scrollPadding;
  final Brightness? keyboardAppearance;
  final bool? cursorOpacityAnimates;
  final double? spacing;
  final FlexBoxSpecAttribute? container;
  final TextSpecAttribute? helperText;

  const TextFieldSpecAttribute({
    this.style,
    this.hintTextColor,
    this.textAlign,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.cursorOffset,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.scrollPadding,
    this.keyboardAppearance,
    this.cursorOpacityAnimates,
    this.spacing,
    this.container,
    this.helperText,
    super.animated,
    super.modifiers,
  });

  /// Resolves to [TextFieldSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textFieldSpec = TextFieldSpecAttribute(...).resolve(mix);
  /// ```
  @override
  TextFieldSpec resolve(MixContext mix) {
    return TextFieldSpec(
      style: style?.resolve(mix),
      hintTextColor: hintTextColor?.resolve(mix),
      textAlign: textAlign,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor?.resolve(mix),
      cursorOffset: cursorOffset,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      scrollPadding: scrollPadding?.resolve(mix),
      keyboardAppearance: keyboardAppearance,
      cursorOpacityAnimates: cursorOpacityAnimates,
      spacing: spacing,
      container: container?.resolve(mix),
      helperText: helperText?.resolve(mix),
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
      hintTextColor:
          hintTextColor?.merge(other.hintTextColor) ?? other.hintTextColor,
      textAlign: other.textAlign ?? textAlign,
      cursorWidth: other.cursorWidth ?? cursorWidth,
      cursorHeight: other.cursorHeight ?? cursorHeight,
      cursorRadius: other.cursorRadius ?? cursorRadius,
      cursorColor: cursorColor?.merge(other.cursorColor) ?? other.cursorColor,
      cursorOffset: other.cursorOffset ?? cursorOffset,
      selectionHeightStyle: other.selectionHeightStyle ?? selectionHeightStyle,
      selectionWidthStyle: other.selectionWidthStyle ?? selectionWidthStyle,
      scrollPadding:
          scrollPadding?.merge(other.scrollPadding) ?? other.scrollPadding,
      keyboardAppearance: other.keyboardAppearance ?? keyboardAppearance,
      cursorOpacityAnimates:
          other.cursorOpacityAnimates ?? cursorOpacityAnimates,
      spacing: other.spacing ?? spacing,
      container: container?.merge(other.container) ?? other.container,
      helperText: helperText?.merge(other.helperText) ?? other.helperText,
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
        hintTextColor,
        textAlign,
        cursorWidth,
        cursorHeight,
        cursorRadius,
        cursorColor,
        cursorOffset,
        selectionHeightStyle,
        selectionWidthStyle,
        scrollPadding,
        keyboardAppearance,
        cursorOpacityAnimates,
        spacing,
        container,
        helperText,
        animated,
        modifiers,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty('hintTextColor', hintTextColor,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('textAlign', textAlign, defaultValue: null));
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
        'selectionHeightStyle', selectionHeightStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'selectionWidthStyle', selectionWidthStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty('scrollPadding', scrollPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty('keyboardAppearance', keyboardAppearance,
        defaultValue: null));
    properties.add(DiagnosticsProperty(
        'cursorOpacityAnimates', cursorOpacityAnimates,
        defaultValue: null));
    properties.add(DiagnosticsProperty('spacing', spacing, defaultValue: null));
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('helperText', helperText, defaultValue: null));
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
class TextFieldSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, TextFieldSpecAttribute> {
  /// Utility for defining [TextFieldSpecAttribute.style]
  late final style = TextStyleUtility((v) => only(style: v));

  /// Utility for defining [TextFieldSpecAttribute.hintTextColor]
  late final hintTextColor = ColorUtility((v) => only(hintTextColor: v));

  /// Utility for defining [TextFieldSpecAttribute.textAlign]
  late final textAlign = TextAlignUtility((v) => only(textAlign: v));

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

  /// Utility for defining [TextFieldSpecAttribute.selectionHeightStyle]
  late final selectionHeightStyle =
      BoxHeightStyleUtility((v) => only(selectionHeightStyle: v));

  /// Utility for defining [TextFieldSpecAttribute.selectionWidthStyle]
  late final selectionWidthStyle =
      BoxWidthStyleUtility((v) => only(selectionWidthStyle: v));

  /// Utility for defining [TextFieldSpecAttribute.scrollPadding]
  late final scrollPadding = EdgeInsetsUtility((v) => only(scrollPadding: v));

  /// Utility for defining [TextFieldSpecAttribute.keyboardAppearance]
  late final keyboardAppearance =
      BrightnessUtility((v) => only(keyboardAppearance: v));

  /// Utility for defining [TextFieldSpecAttribute.cursorOpacityAnimates]
  late final cursorOpacityAnimates =
      BoolUtility((v) => only(cursorOpacityAnimates: v));

  /// Utility for defining [TextFieldSpecAttribute.spacing]
  late final spacing = DoubleUtility((v) => only(spacing: v));

  /// Utility for defining [TextFieldSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [TextFieldSpecAttribute.helperText]
  late final helperText = TextSpecUtility((v) => only(helperText: v));

  /// Utility for defining [TextFieldSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  /// Utility for defining [TextFieldSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  TextFieldSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  TextFieldSpecUtility<T> get chain => TextFieldSpecUtility(attributeBuilder);

  static TextFieldSpecUtility<TextFieldSpecAttribute> get self =>
      TextFieldSpecUtility((v) => v);

  /// Returns a new [TextFieldSpecAttribute] with the specified properties.
  @override
  T only({
    TextStyleDto? style,
    ColorDto? hintTextColor,
    TextAlign? textAlign,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    ColorDto? cursorColor,
    Offset? cursorOffset,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsetsDto? scrollPadding,
    Brightness? keyboardAppearance,
    bool? cursorOpacityAnimates,
    double? spacing,
    FlexBoxSpecAttribute? container,
    TextSpecAttribute? helperText,
    AnimatedDataDto? animated,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return builder(TextFieldSpecAttribute(
      style: style,
      hintTextColor: hintTextColor,
      textAlign: textAlign,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      cursorOffset: cursorOffset,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      scrollPadding: scrollPadding,
      keyboardAppearance: keyboardAppearance,
      cursorOpacityAnimates: cursorOpacityAnimates,
      spacing: spacing,
      container: container,
      helperText: helperText,
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
