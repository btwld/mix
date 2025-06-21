// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accordion.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [AccordionSpec].
mixin _$AccordionSpec on Spec<AccordionSpec> {
  static AccordionSpec from(MixContext mix) {
    return mix.attributeOf<AccordionSpecAttribute>()?.resolve(mix) ??
        const AccordionSpec();
  }

  /// {@template accordion_spec_of}
  /// Retrieves the [AccordionSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [AccordionSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [AccordionSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final accordionSpec = AccordionSpec.of(context);
  /// ```
  /// {@endtemplate}
  static AccordionSpec of(BuildContext context) {
    return ComputedStyle.specOf<AccordionSpec>(context) ??
        const AccordionSpec();
  }

  /// Creates a copy of this [AccordionSpec] but with the given fields
  /// replaced with the new values.
  @override
  AccordionSpec copyWith({
    BoxSpec? itemContainer,
    BoxSpec? contentContainer,
    FlexBoxSpec? headerContainer,
    IconThemeData? leadingIcon,
    IconSpec? trailingIcon,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    AnimatedData? animated,
  }) {
    return AccordionSpec(
      itemContainer: itemContainer ?? _$this.itemContainer,
      contentContainer: contentContainer ?? _$this.contentContainer,
      headerContainer: headerContainer ?? _$this.headerContainer,
      leadingIcon: leadingIcon ?? _$this.leadingIcon,
      trailingIcon: trailingIcon ?? _$this.trailingIcon,
      titleStyle: titleStyle ?? _$this.titleStyle,
      contentStyle: contentStyle ?? _$this.contentStyle,
      animated: animated ?? _$this.animated,
    );
  }

  /// The list of properties that constitute the state of this [AccordionSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AccordionSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.itemContainer,
        _$this.contentContainer,
        _$this.headerContainer,
        _$this.leadingIcon,
        _$this.trailingIcon,
        _$this.titleStyle,
        _$this.contentStyle,
        _$this.animated,
      ];

  AccordionSpec get _$this => this as AccordionSpec;
}

/// Represents the attributes of a [AccordionSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [AccordionSpec].
///
/// Use this class to configure the attributes of a [AccordionSpec] and pass it to
/// the [AccordionSpec] constructor.
class AccordionSpecAttribute extends SpecAttribute<AccordionSpec> {
  final BoxSpecAttribute? itemContainer;
  final BoxSpecAttribute? contentContainer;
  final FlexBoxSpecAttribute? headerContainer;
  final IconThemeDataDto? leadingIcon;
  final IconSpecAttribute? trailingIcon;
  final TextStyleDto? titleStyle;
  final TextStyleDto? contentStyle;

  const AccordionSpecAttribute({
    this.itemContainer,
    this.contentContainer,
    this.headerContainer,
    this.leadingIcon,
    this.trailingIcon,
    this.titleStyle,
    this.contentStyle,
    super.animated,
  });

  /// Resolves to [AccordionSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final accordionSpec = AccordionSpecAttribute(...).resolve(mix);
  /// ```
  @override
  AccordionSpec resolve(MixContext mix) {
    return AccordionSpec(
      itemContainer: itemContainer?.resolve(mix),
      contentContainer: contentContainer?.resolve(mix),
      headerContainer: headerContainer?.resolve(mix),
      leadingIcon: leadingIcon?.resolve(mix),
      trailingIcon: trailingIcon?.resolve(mix),
      titleStyle: titleStyle?.resolve(mix),
      contentStyle: contentStyle?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [AccordionSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [AccordionSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  AccordionSpecAttribute merge(AccordionSpecAttribute? other) {
    if (other == null) return this;

    return AccordionSpecAttribute(
      itemContainer:
          itemContainer?.merge(other.itemContainer) ?? other.itemContainer,
      contentContainer: contentContainer?.merge(other.contentContainer) ??
          other.contentContainer,
      headerContainer: headerContainer?.merge(other.headerContainer) ??
          other.headerContainer,
      leadingIcon: leadingIcon?.merge(other.leadingIcon) ?? other.leadingIcon,
      trailingIcon:
          trailingIcon?.merge(other.trailingIcon) ?? other.trailingIcon,
      titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      contentStyle:
          contentStyle?.merge(other.contentStyle) ?? other.contentStyle,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [AccordionSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AccordionSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        itemContainer,
        contentContainer,
        headerContainer,
        leadingIcon,
        trailingIcon,
        titleStyle,
        contentStyle,
        animated,
      ];
}

/// Utility class for configuring [AccordionSpec] properties.
///
/// This class provides methods to set individual properties of a [AccordionSpec].
/// Use the methods of this class to configure specific properties of a [AccordionSpec].
class AccordionSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, AccordionSpecAttribute> {
  /// Utility for defining [AccordionSpecAttribute.itemContainer]
  late final itemContainer = BoxSpecUtility((v) => only(itemContainer: v));

  /// Utility for defining [AccordionSpecAttribute.contentContainer]
  late final contentContainer =
      BoxSpecUtility((v) => only(contentContainer: v));

  /// Utility for defining [AccordionSpecAttribute.headerContainer]
  late final headerContainer =
      FlexBoxSpecUtility((v) => only(headerContainer: v));

  /// Utility for defining [AccordionSpecAttribute.leadingIcon]
  late final leadingIcon = IconThemeDataUtility((v) => only(leadingIcon: v));

  /// Utility for defining [AccordionSpecAttribute.trailingIcon]
  late final trailingIcon = IconSpecUtility((v) => only(trailingIcon: v));

  /// Utility for defining [AccordionSpecAttribute.titleStyle]
  late final titleStyle = TextStyleUtility((v) => only(titleStyle: v));

  /// Utility for defining [AccordionSpecAttribute.contentStyle]
  late final contentStyle = TextStyleUtility((v) => only(contentStyle: v));

  /// Utility for defining [AccordionSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  AccordionSpecUtility(
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
  AccordionSpecUtility<T> get chain => AccordionSpecUtility(attributeBuilder);

  static AccordionSpecUtility<AccordionSpecAttribute> get self =>
      AccordionSpecUtility((v) => v);

  /// Returns a new [AccordionSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? itemContainer,
    BoxSpecAttribute? contentContainer,
    FlexBoxSpecAttribute? headerContainer,
    IconThemeDataDto? leadingIcon,
    IconSpecAttribute? trailingIcon,
    TextStyleDto? titleStyle,
    TextStyleDto? contentStyle,
    AnimatedDataDto? animated,
  }) {
    return builder(AccordionSpecAttribute(
      itemContainer: itemContainer,
      contentContainer: contentContainer,
      headerContainer: headerContainer,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      titleStyle: titleStyle,
      contentStyle: contentStyle,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [AccordionSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [AccordionSpec] specifications.
class AccordionSpecTween extends Tween<AccordionSpec?> {
  AccordionSpecTween({
    super.begin,
    super.end,
  });

  @override
  AccordionSpec lerp(double t) {
    if (begin == null && end == null) {
      return const AccordionSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
