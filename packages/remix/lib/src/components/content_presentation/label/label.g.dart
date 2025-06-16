// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [LabelSpec].
mixin _$LabelSpec on Spec<LabelSpec> {
  static LabelSpec from(MixContext mix) {
    return mix.attributeOf<LabelSpecAttribute>()?.resolve(mix) ??
        const LabelSpec();
  }

  /// {@template label_spec_of}
  /// Retrieves the [LabelSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [LabelSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [LabelSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final labelSpec = LabelSpec.of(context);
  /// ```
  /// {@endtemplate}
  static LabelSpec of(BuildContext context) {
    return ComputedStyle.specOf<LabelSpec>(context) ?? const LabelSpec();
  }

  /// Creates a copy of this [LabelSpec] but with the given fields
  /// replaced with the new values.
  @override
  LabelSpec copyWith({
    double? spacing,
    IconSpec? icon,
    TextSpec? label,
    WidgetModifiersConfig? modifiers,
    AnimatedData? animated,
  }) {
    return LabelSpec(
      spacing: spacing ?? _$this.spacing,
      icon: icon ?? _$this.icon,
      label: label ?? _$this.label,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [LabelSpec] and another [LabelSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [LabelSpec] is returned. When [t] is 1.0, the [other] [LabelSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [LabelSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [LabelSpec] instance.
  ///
  /// The interpolation is performed on each property of the [LabelSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [spacing].
  /// - [IconSpec.lerp] for [icon].
  /// - [TextSpec.lerp] for [label].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [LabelSpec] is used. Otherwise, the value
  /// from the [other] [LabelSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [LabelSpec] configurations.
  @override
  LabelSpec lerp(LabelSpec? other, double t) {
    if (other == null) return _$this;

    return LabelSpec(
      spacing: MixHelpers.lerpDouble(_$this.spacing, other.spacing, t)!,
      icon: _$this.icon.lerp(other.icon, t),
      label: _$this.label.lerp(other.label, t),
      modifiers: other.modifiers,
      animated: _$this.animated ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [LabelSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [LabelSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.spacing,
        _$this.icon,
        _$this.label,
        _$this.modifiers,
        _$this.animated,
      ];

  LabelSpec get _$this => this as LabelSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('spacing', _$this.spacing, defaultValue: null));
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties
        .add(DiagnosticsProperty('label', _$this.label, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [LabelSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [LabelSpec].
///
/// Use this class to configure the attributes of a [LabelSpec] and pass it to
/// the [LabelSpec] constructor.
class LabelSpecAttribute extends SpecAttribute<LabelSpec> with Diagnosticable {
  final double? spacing;
  final IconSpecAttribute? icon;
  final TextSpecAttribute? label;

  const LabelSpecAttribute({
    this.spacing,
    this.icon,
    this.label,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [LabelSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final labelSpec = LabelSpecAttribute(...).resolve(mix);
  /// ```
  @override
  LabelSpec resolve(MixContext mix) {
    return LabelSpec(
      spacing: spacing,
      icon: icon?.resolve(mix),
      label: label?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [LabelSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [LabelSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  LabelSpecAttribute merge(LabelSpecAttribute? other) {
    if (other == null) return this;

    return LabelSpecAttribute(
      spacing: other.spacing ?? spacing,
      icon: icon?.merge(other.icon) ?? other.icon,
      label: label?.merge(other.label) ?? other.label,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [LabelSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [LabelSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        spacing,
        icon,
        label,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('spacing', spacing, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [LabelSpec] properties.
///
/// This class provides methods to set individual properties of a [LabelSpec].
/// Use the methods of this class to configure specific properties of a [LabelSpec].
class LabelSpecUtility<T extends StyleElement>
    extends SpecUtility<T, LabelSpecAttribute> {
  /// Utility for defining [LabelSpecAttribute.spacing]
  late final spacing = DoubleUtility((v) => only(spacing: v));

  /// Utility for defining [LabelSpecAttribute.icon]
  late final icon = IconSpecUtility((v) => only(icon: v));

  /// Utility for defining [LabelSpecAttribute.label]
  late final label = TextSpecUtility((v) => only(label: v));

  /// Utility for defining [LabelSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [LabelSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  LabelSpecUtility(
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
  LabelSpecUtility<T> get chain => LabelSpecUtility(attributeBuilder);

  static LabelSpecUtility<LabelSpecAttribute> get self =>
      LabelSpecUtility((v) => v);

  /// Returns a new [LabelSpecAttribute] with the specified properties.
  @override
  T only({
    double? spacing,
    IconSpecAttribute? icon,
    TextSpecAttribute? label,
    WidgetModifiersConfigDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(LabelSpecAttribute(
      spacing: spacing,
      icon: icon,
      label: label,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [LabelSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [LabelSpec] specifications.
class LabelSpecTween extends Tween<LabelSpec?> {
  LabelSpecTween({
    super.begin,
    super.end,
  });

  @override
  LabelSpec lerp(double t) {
    if (begin == null && end == null) {
      return const LabelSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
