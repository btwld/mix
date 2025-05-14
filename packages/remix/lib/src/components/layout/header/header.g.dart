// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [HeaderSpec].
mixin _$HeaderSpec on Spec<HeaderSpec> {
  static HeaderSpec from(MixData mix) {
    return mix.attributeOf<HeaderSpecAttribute>()?.resolve(mix) ??
        const HeaderSpec();
  }

  /// {@template header_spec_of}
  /// Retrieves the [HeaderSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [HeaderSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [HeaderSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final headerSpec = HeaderSpec.of(context);
  /// ```
  /// {@endtemplate}
  static HeaderSpec of(BuildContext context) {
    return _$HeaderSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [HeaderSpec] but with the given fields
  /// replaced with the new values.
  @override
  HeaderSpec copyWith({
    FlexBoxSpec? container,
    WidgetModifiersData? modifiers,
    FlexSpec? titleGroup,
    TextSpec? title,
    TextSpec? subtitle,
    AnimatedData? animated,
  }) {
    return HeaderSpec(
      container: container ?? _$this.container,
      modifiers: modifiers ?? _$this.modifiers,
      titleGroup: titleGroup ?? _$this.titleGroup,
      title: title ?? _$this.title,
      subtitle: subtitle ?? _$this.subtitle,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [HeaderSpec] and another [HeaderSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [HeaderSpec] is returned. When [t] is 1.0, the [other] [HeaderSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [HeaderSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [HeaderSpec] instance.
  ///
  /// The interpolation is performed on each property of the [HeaderSpec] using the appropriate
  /// interpolation method:
  /// - [FlexBoxSpec.lerp] for [container].
  /// - [FlexSpec.lerp] for [titleGroup].
  /// - [TextSpec.lerp] for [title] and [subtitle].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [HeaderSpec] is used. Otherwise, the value
  /// from the [other] [HeaderSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [HeaderSpec] configurations.
  @override
  HeaderSpec lerp(HeaderSpec? other, double t) {
    if (other == null) return _$this;

    return HeaderSpec(
      container: _$this.container.lerp(other.container, t),
      modifiers: other.modifiers,
      titleGroup: _$this.titleGroup.lerp(other.titleGroup, t),
      title: _$this.title.lerp(other.title, t),
      subtitle: _$this.subtitle.lerp(other.subtitle, t),
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [HeaderSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [HeaderSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.modifiers,
        _$this.titleGroup,
        _$this.title,
        _$this.subtitle,
        _$this.animated,
      ];

  HeaderSpec get _$this => this as HeaderSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(DiagnosticsProperty('titleGroup', _$this.titleGroup,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('title', _$this.title, defaultValue: null));
    properties.add(
        DiagnosticsProperty('subtitle', _$this.subtitle, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [HeaderSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [HeaderSpec].
///
/// Use this class to configure the attributes of a [HeaderSpec] and pass it to
/// the [HeaderSpec] constructor.
class HeaderSpecAttribute extends SpecAttribute<HeaderSpec>
    with Diagnosticable {
  final FlexBoxSpecAttribute? container;
  final FlexSpecAttribute? titleGroup;
  final TextSpecAttribute? title;
  final TextSpecAttribute? subtitle;

  const HeaderSpecAttribute({
    this.container,
    super.modifiers,
    this.titleGroup,
    this.title,
    this.subtitle,
    super.animated,
  });

  /// Resolves to [HeaderSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final headerSpec = HeaderSpecAttribute(...).resolve(mix);
  /// ```
  @override
  HeaderSpec resolve(MixData mix) {
    return HeaderSpec(
      container: container?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      titleGroup: titleGroup?.resolve(mix),
      title: title?.resolve(mix),
      subtitle: subtitle?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [HeaderSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [HeaderSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  HeaderSpecAttribute merge(HeaderSpecAttribute? other) {
    if (other == null) return this;

    return HeaderSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      titleGroup: titleGroup?.merge(other.titleGroup) ?? other.titleGroup,
      title: title?.merge(other.title) ?? other.title,
      subtitle: subtitle?.merge(other.subtitle) ?? other.subtitle,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [HeaderSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [HeaderSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        modifiers,
        titleGroup,
        title,
        subtitle,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('titleGroup', titleGroup, defaultValue: null));
    properties.add(DiagnosticsProperty('title', title, defaultValue: null));
    properties
        .add(DiagnosticsProperty('subtitle', subtitle, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [HeaderSpec] properties.
///
/// This class provides methods to set individual properties of a [HeaderSpec].
/// Use the methods of this class to configure specific properties of a [HeaderSpec].
class HeaderSpecUtility<T extends Attribute>
    extends SpecUtility<T, HeaderSpecAttribute> {
  /// Utility for defining [HeaderSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [HeaderSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [HeaderSpecAttribute.titleGroup]
  late final titleGroup = FlexSpecUtility((v) => only(titleGroup: v));

  /// Utility for defining [HeaderSpecAttribute.title]
  late final title = TextSpecUtility((v) => only(title: v));

  /// Utility for defining [HeaderSpecAttribute.subtitle]
  late final subtitle = TextSpecUtility((v) => only(subtitle: v));

  /// Utility for defining [HeaderSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  HeaderSpecUtility(super.builder, {super.mutable});

  HeaderSpecUtility<T> get chain =>
      HeaderSpecUtility(attributeBuilder, mutable: true);

  static HeaderSpecUtility<HeaderSpecAttribute> get self =>
      HeaderSpecUtility((v) => v);

  /// Returns a new [HeaderSpecAttribute] with the specified properties.
  @override
  T only({
    FlexBoxSpecAttribute? container,
    WidgetModifiersDataDto? modifiers,
    FlexSpecAttribute? titleGroup,
    TextSpecAttribute? title,
    TextSpecAttribute? subtitle,
    AnimatedDataDto? animated,
  }) {
    return builder(HeaderSpecAttribute(
      container: container,
      modifiers: modifiers,
      titleGroup: titleGroup,
      title: title,
      subtitle: subtitle,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [HeaderSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [HeaderSpec] specifications.
class HeaderSpecTween extends Tween<HeaderSpec?> {
  HeaderSpecTween({
    super.begin,
    super.end,
  });

  @override
  HeaderSpec lerp(double t) {
    if (begin == null && end == null) {
      return const HeaderSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
