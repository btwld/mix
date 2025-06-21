// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'callout.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [CalloutSpec].
mixin _$CalloutSpec on Spec<CalloutSpec> {
  static CalloutSpec from(MixContext mix) {
    return mix.attributeOf<CalloutSpecAttribute>()?.resolve(mix) ??
        const CalloutSpec();
  }

  /// {@template callout_spec_of}
  /// Retrieves the [CalloutSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [CalloutSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [CalloutSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final calloutSpec = CalloutSpec.of(context);
  /// ```
  /// {@endtemplate}
  static CalloutSpec of(BuildContext context) {
    return ComputedStyle.specOf<CalloutSpec>(context) ?? const CalloutSpec();
  }

  /// Creates a copy of this [CalloutSpec] but with the given fields
  /// replaced with the new values.
  @override
  CalloutSpec copyWith({
    FlexBoxSpec? container,
    IconThemeData? icon,
    TextStyle? textStyle,
    WidgetModifiersConfig? modifiers,
    AnimatedData? animated,
  }) {
    return CalloutSpec(
      container: container ?? _$this.container,
      icon: icon ?? _$this.icon,
      textStyle: textStyle ?? _$this.textStyle,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// The list of properties that constitute the state of this [CalloutSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CalloutSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.icon,
        _$this.textStyle,
        _$this.modifiers,
        _$this.animated,
      ];

  CalloutSpec get _$this => this as CalloutSpec;
}

/// Represents the attributes of a [CalloutSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [CalloutSpec].
///
/// Use this class to configure the attributes of a [CalloutSpec] and pass it to
/// the [CalloutSpec] constructor.
class CalloutSpecAttribute extends SpecAttribute<CalloutSpec> {
  final FlexBoxSpecAttribute? container;
  final IconThemeDataDto? icon;
  final TextStyleDto? textStyle;

  const CalloutSpecAttribute({
    this.container,
    this.icon,
    this.textStyle,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [CalloutSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final calloutSpec = CalloutSpecAttribute(...).resolve(mix);
  /// ```
  @override
  CalloutSpec resolve(MixContext mix) {
    return CalloutSpec(
      container: container?.resolve(mix),
      icon: icon?.resolve(mix),
      textStyle: textStyle?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [CalloutSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [CalloutSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  CalloutSpecAttribute merge(CalloutSpecAttribute? other) {
    if (other == null) return this;

    return CalloutSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      icon: icon?.merge(other.icon) ?? other.icon,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [CalloutSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CalloutSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        icon,
        textStyle,
        modifiers,
        animated,
      ];
}

/// Utility class for configuring [CalloutSpec] properties.
///
/// This class provides methods to set individual properties of a [CalloutSpec].
/// Use the methods of this class to configure specific properties of a [CalloutSpec].
class CalloutSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, CalloutSpecAttribute> {
  /// Utility for defining [CalloutSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [CalloutSpecAttribute.icon]
  late final icon = IconThemeDataUtility((v) => only(icon: v));

  /// Utility for defining [CalloutSpecAttribute.textStyle]
  late final textStyle = TextStyleUtility((v) => only(textStyle: v));

  /// Utility for defining [CalloutSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [CalloutSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  CalloutSpecUtility(
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
  CalloutSpecUtility<T> get chain => CalloutSpecUtility(attributeBuilder);

  static CalloutSpecUtility<CalloutSpecAttribute> get self =>
      CalloutSpecUtility((v) => v);

  /// Returns a new [CalloutSpecAttribute] with the specified properties.
  @override
  T only({
    FlexBoxSpecAttribute? container,
    IconThemeDataDto? icon,
    TextStyleDto? textStyle,
    WidgetModifiersConfigDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(CalloutSpecAttribute(
      container: container,
      icon: icon,
      textStyle: textStyle,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [CalloutSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [CalloutSpec] specifications.
class CalloutSpecTween extends Tween<CalloutSpec?> {
  CalloutSpecTween({
    super.begin,
    super.end,
  });

  @override
  CalloutSpec lerp(double t) {
    if (begin == null && end == null) {
      return const CalloutSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
