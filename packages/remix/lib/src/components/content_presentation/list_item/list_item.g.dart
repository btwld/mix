// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ListItemSpec].
mixin _$ListItemSpec on Spec<ListItemSpec> {
  static ListItemSpec from(MixContext mix) {
    return mix.attributeOf<ListItemSpecAttribute>()?.resolve(mix) ??
        const ListItemSpec();
  }

  /// {@template list_item_spec_of}
  /// Retrieves the [ListItemSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [ListItemSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [ListItemSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final listItemSpec = ListItemSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ListItemSpec of(BuildContext context) {
    return ComputedStyle.specOf<ListItemSpec>(context) ?? const ListItemSpec();
  }

  /// Creates a copy of this [ListItemSpec] but with the given fields
  /// replaced with the new values.
  @override
  ListItemSpec copyWith({
    FlexBoxSpec? container,
    FlexBoxSpec? titleSubtitleContainer,
    TextSpec? title,
    TextSpec? subtitle,
    WidgetModifiersConfig? modifiers,
    AnimatedData? animated,
  }) {
    return ListItemSpec(
      container: container ?? _$this.container,
      titleSubtitleContainer:
          titleSubtitleContainer ?? _$this.titleSubtitleContainer,
      title: title ?? _$this.title,
      subtitle: subtitle ?? _$this.subtitle,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [ListItemSpec] and another [ListItemSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ListItemSpec] is returned. When [t] is 1.0, the [other] [ListItemSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ListItemSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ListItemSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ListItemSpec] using the appropriate
  /// interpolation method:
  /// - [FlexBoxSpec.lerp] for [container] and [titleSubtitleContainer].
  /// - [TextSpec.lerp] for [title] and [subtitle].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ListItemSpec] is used. Otherwise, the value
  /// from the [other] [ListItemSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ListItemSpec] configurations.
  @override
  ListItemSpec lerp(ListItemSpec? other, double t) {
    if (other == null) return _$this;

    return ListItemSpec(
      container: _$this.container.lerp(other.container, t),
      titleSubtitleContainer:
          _$this.titleSubtitleContainer.lerp(other.titleSubtitleContainer, t),
      title: _$this.title.lerp(other.title, t),
      subtitle: _$this.subtitle.lerp(other.subtitle, t),
      modifiers: other.modifiers,
      animated: _$this.animated ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [ListItemSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ListItemSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.titleSubtitleContainer,
        _$this.title,
        _$this.subtitle,
        _$this.modifiers,
        _$this.animated,
      ];

  ListItemSpec get _$this => this as ListItemSpec;

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

/// Represents the attributes of a [ListItemSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ListItemSpec].
///
/// Use this class to configure the attributes of a [ListItemSpec] and pass it to
/// the [ListItemSpec] constructor.
class ListItemSpecAttribute extends SpecAttribute<ListItemSpec>
    with Diagnosticable {
  final FlexBoxSpecAttribute? container;
  final FlexBoxSpecAttribute? titleSubtitleContainer;
  final TextSpecAttribute? title;
  final TextSpecAttribute? subtitle;

  const ListItemSpecAttribute({
    this.container,
    this.titleSubtitleContainer,
    this.title,
    this.subtitle,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [ListItemSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final listItemSpec = ListItemSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ListItemSpec resolve(MixContext mix) {
    return ListItemSpec(
      container: container?.resolve(mix),
      titleSubtitleContainer: titleSubtitleContainer?.resolve(mix),
      title: title?.resolve(mix),
      subtitle: subtitle?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [ListItemSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ListItemSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ListItemSpecAttribute merge(ListItemSpecAttribute? other) {
    if (other == null) return this;

    return ListItemSpecAttribute(
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

  /// The list of properties that constitute the state of this [ListItemSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ListItemSpecAttribute] instances for equality.
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

/// Utility class for configuring [ListItemSpec] properties.
///
/// This class provides methods to set individual properties of a [ListItemSpec].
/// Use the methods of this class to configure specific properties of a [ListItemSpec].
class ListItemSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, ListItemSpecAttribute> {
  /// Utility for defining [ListItemSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [ListItemSpecAttribute.titleSubtitleContainer]
  late final titleSubtitleContainer =
      FlexBoxSpecUtility((v) => only(titleSubtitleContainer: v));

  /// Utility for defining [ListItemSpecAttribute.title]
  late final title = TextSpecUtility((v) => only(title: v));

  /// Utility for defining [ListItemSpecAttribute.subtitle]
  late final subtitle = TextSpecUtility((v) => only(subtitle: v));

  /// Utility for defining [ListItemSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [ListItemSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  ListItemSpecUtility(
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
  ListItemSpecUtility<T> get chain => ListItemSpecUtility(attributeBuilder);

  static ListItemSpecUtility<ListItemSpecAttribute> get self =>
      ListItemSpecUtility((v) => v);

  /// Returns a new [ListItemSpecAttribute] with the specified properties.
  @override
  T only({
    FlexBoxSpecAttribute? container,
    FlexBoxSpecAttribute? titleSubtitleContainer,
    TextSpecAttribute? title,
    TextSpecAttribute? subtitle,
    WidgetModifiersConfigDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(ListItemSpecAttribute(
      container: container,
      titleSubtitleContainer: titleSubtitleContainer,
      title: title,
      subtitle: subtitle,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [ListItemSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ListItemSpec] specifications.
class ListItemSpecTween extends Tween<ListItemSpec?> {
  ListItemSpecTween({
    super.begin,
    super.end,
  });

  @override
  ListItemSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ListItemSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
