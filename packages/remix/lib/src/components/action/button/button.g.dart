// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ButtonSpec].
mixin _$ButtonSpec on Spec<ButtonSpec> {
  static ButtonSpec from(MixContext mix) {
    return mix.attributeOf<ButtonSpecAttribute>()?.resolve(mix) ??
        const ButtonSpec();
  }

  /// {@template button_spec_of}
  /// Retrieves the [ButtonSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [ButtonSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [ButtonSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final buttonSpec = ButtonSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ButtonSpec of(BuildContext context) {
    return ComputedStyle.specOf<ButtonSpec>(context) ?? const ButtonSpec();
  }

  /// Creates a copy of this [ButtonSpec] but with the given fields
  /// replaced with the new values.
  @override
  ButtonSpec copyWith({
    BoxSpec? container,
    IconThemeData? icon,
    TextStyle? textStyle,
    WidgetModifiersConfig? modifiers,
    SpinnerSpec? spinner,
    AnimatedData? animated,
  }) {
    return ButtonSpec(
      container: container ?? _$this.container,
      icon: icon ?? _$this.icon,
      textStyle: textStyle ?? _$this.textStyle,
      modifiers: modifiers ?? _$this.modifiers,
      spinner: spinner ?? _$this.spinner,
      animated: animated ?? _$this.animated,
    );
  }

  /// The list of properties that constitute the state of this [ButtonSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ButtonSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.icon,
        _$this.textStyle,
        _$this.modifiers,
        _$this.spinner,
        _$this.animated,
      ];

  ButtonSpec get _$this => this as ButtonSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties.add(
        DiagnosticsProperty('textStyle', _$this.textStyle, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('spinner', _$this.spinner, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [ButtonSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ButtonSpec].
///
/// Use this class to configure the attributes of a [ButtonSpec] and pass it to
/// the [ButtonSpec] constructor.
class ButtonSpecAttribute extends SpecAttribute<ButtonSpec>
    with Diagnosticable {
  final BoxSpecAttribute? container;
  final IconThemeDataDto? icon;
  final TextStyleDto? textStyle;
  final SpinnerSpecAttribute? spinner;

  const ButtonSpecAttribute({
    this.container,
    this.icon,
    this.textStyle,
    super.modifiers,
    this.spinner,
    super.animated,
  });

  /// Resolves to [ButtonSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final buttonSpec = ButtonSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ButtonSpec resolve(MixContext mix) {
    return ButtonSpec(
      container: container?.resolve(mix),
      icon: icon?.resolve(mix),
      textStyle: textStyle?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      spinner: spinner?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [ButtonSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ButtonSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ButtonSpecAttribute merge(ButtonSpecAttribute? other) {
    if (other == null) return this;

    return ButtonSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      icon: icon?.merge(other.icon) ?? other.icon,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      spinner: spinner?.merge(other.spinner) ?? other.spinner,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [ButtonSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ButtonSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        icon,
        textStyle,
        modifiers,
        spinner,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties
        .add(DiagnosticsProperty('textStyle', textStyle, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties.add(DiagnosticsProperty('spinner', spinner, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [ButtonSpec] properties.
///
/// This class provides methods to set individual properties of a [ButtonSpec].
/// Use the methods of this class to configure specific properties of a [ButtonSpec].
class ButtonSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, ButtonSpecAttribute> {
  /// Utility for defining [ButtonSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [ButtonSpecAttribute.icon]
  late final icon = IconThemeDataUtility((v) => only(icon: v));

  /// Utility for defining [ButtonSpecAttribute.textStyle]
  late final textStyle = TextStyleUtility((v) => only(textStyle: v));

  /// Utility for defining [ButtonSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [ButtonSpecAttribute.spinner]
  late final spinner = SpinnerSpecUtility((v) => only(spinner: v));

  /// Utility for defining [ButtonSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  ButtonSpecUtility(
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
  ButtonSpecUtility<T> get chain => ButtonSpecUtility(attributeBuilder);

  static ButtonSpecUtility<ButtonSpecAttribute> get self =>
      ButtonSpecUtility((v) => v);

  /// Returns a new [ButtonSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    IconThemeDataDto? icon,
    TextStyleDto? textStyle,
    WidgetModifiersConfigDto? modifiers,
    SpinnerSpecAttribute? spinner,
    AnimatedDataDto? animated,
  }) {
    return builder(ButtonSpecAttribute(
      container: container,
      icon: icon,
      textStyle: textStyle,
      modifiers: modifiers,
      spinner: spinner,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [ButtonSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ButtonSpec] specifications.
class ButtonSpecTween extends Tween<ButtonSpec?> {
  ButtonSpecTween({
    super.begin,
    super.end,
  });

  @override
  ButtonSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ButtonSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
