// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ToastSpec].
mixin _$ToastSpec on Spec<ToastSpec> {
  static ToastSpec from(MixData mix) {
    return mix.attributeOf<ToastSpecAttribute>()?.resolve(mix) ??
        const ToastSpec();
  }

  /// {@template toast_spec_of}
  /// Retrieves the [ToastSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [ToastSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [ToastSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final toastSpec = ToastSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ToastSpec of(BuildContext context) {
    return _$ToastSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [ToastSpec] but with the given fields
  /// replaced with the new values.
  @override
  ToastSpec copyWith({
    FlexBoxSpec? container,
    FlexBoxSpec? titleSubtitleContainer,
    TextSpec? title,
    TextSpec? subtitle,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return ToastSpec(
      container: container ?? _$this.container,
      titleSubtitleContainer:
          titleSubtitleContainer ?? _$this.titleSubtitleContainer,
      title: title ?? _$this.title,
      subtitle: subtitle ?? _$this.subtitle,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [ToastSpec] and another [ToastSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ToastSpec] is returned. When [t] is 1.0, the [other] [ToastSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ToastSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ToastSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ToastSpec] using the appropriate
  /// interpolation method:
  /// - [FlexBoxSpec.lerp] for [container] and [titleSubtitleContainer].
  /// - [TextSpec.lerp] for [title] and [subtitle].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ToastSpec] is used. Otherwise, the value
  /// from the [other] [ToastSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ToastSpec] configurations.
  @override
  ToastSpec lerp(ToastSpec? other, double t) {
    if (other == null) return _$this;

    return ToastSpec(
      container: _$this.container.lerp(other.container, t),
      titleSubtitleContainer:
          _$this.titleSubtitleContainer.lerp(other.titleSubtitleContainer, t),
      title: _$this.title.lerp(other.title, t),
      subtitle: _$this.subtitle.lerp(other.subtitle, t),
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [ToastSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ToastSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.titleSubtitleContainer,
        _$this.title,
        _$this.subtitle,
        _$this.modifiers,
        _$this.animated,
      ];

  ToastSpec get _$this => this as ToastSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(DiagnosticsProperty(
        'titleSubtitleContainer', _$this.titleSubtitleContainer,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty('title', _$this.title, defaultValue: null));
    properties.add(
        DiagnosticsProperty('subtitle', _$this.subtitle, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [ToastSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ToastSpec].
///
/// Use this class to configure the attributes of a [ToastSpec] and pass it to
/// the [ToastSpec] constructor.
class ToastSpecAttribute extends SpecAttribute<ToastSpec> with Diagnosticable {
  final FlexBoxSpecAttribute? container;
  final FlexBoxSpecAttribute? titleSubtitleContainer;
  final TextSpecAttribute? title;
  final TextSpecAttribute? subtitle;

  const ToastSpecAttribute({
    this.container,
    this.titleSubtitleContainer,
    this.title,
    this.subtitle,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [ToastSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final toastSpec = ToastSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ToastSpec resolve(MixData mix) {
    return ToastSpec(
      container: container?.resolve(mix),
      titleSubtitleContainer: titleSubtitleContainer?.resolve(mix),
      title: title?.resolve(mix),
      subtitle: subtitle?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [ToastSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ToastSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ToastSpecAttribute merge(ToastSpecAttribute? other) {
    if (other == null) return this;

    return ToastSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      titleSubtitleContainer:
          titleSubtitleContainer?.merge(other.titleSubtitleContainer) ??
              other.titleSubtitleContainer,
      title: title?.merge(other.title) ?? other.title,
      subtitle: subtitle?.merge(other.subtitle) ?? other.subtitle,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [ToastSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ToastSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        titleSubtitleContainer,
        title,
        subtitle,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty(
        'titleSubtitleContainer', titleSubtitleContainer,
        defaultValue: null));
    properties.add(DiagnosticsProperty('title', title, defaultValue: null));
    properties
        .add(DiagnosticsProperty('subtitle', subtitle, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [ToastSpec] properties.
///
/// This class provides methods to set individual properties of a [ToastSpec].
/// Use the methods of this class to configure specific properties of a [ToastSpec].
class ToastSpecUtility<T extends Attribute>
    extends SpecUtility<T, ToastSpecAttribute> {
  /// Utility for defining [ToastSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [ToastSpecAttribute.titleSubtitleContainer]
  late final titleSubtitleContainer =
      FlexBoxSpecUtility((v) => only(titleSubtitleContainer: v));

  /// Utility for defining [ToastSpecAttribute.title]
  late final title = TextSpecUtility((v) => only(title: v));

  /// Utility for defining [ToastSpecAttribute.subtitle]
  late final subtitle = TextSpecUtility((v) => only(subtitle: v));

  /// Utility for defining [ToastSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [ToastSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  ToastSpecUtility(super.builder, {super.mutable});

  ToastSpecUtility<T> get chain =>
      ToastSpecUtility(attributeBuilder, mutable: true);

  static ToastSpecUtility<ToastSpecAttribute> get self =>
      ToastSpecUtility((v) => v);

  /// Returns a new [ToastSpecAttribute] with the specified properties.
  @override
  T only({
    FlexBoxSpecAttribute? container,
    FlexBoxSpecAttribute? titleSubtitleContainer,
    TextSpecAttribute? title,
    TextSpecAttribute? subtitle,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(ToastSpecAttribute(
      container: container,
      titleSubtitleContainer: titleSubtitleContainer,
      title: title,
      subtitle: subtitle,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [ToastSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ToastSpec] specifications.
class ToastSpecTween extends Tween<ToastSpec?> {
  ToastSpecTween({
    super.begin,
    super.end,
  });

  @override
  ToastSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ToastSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
