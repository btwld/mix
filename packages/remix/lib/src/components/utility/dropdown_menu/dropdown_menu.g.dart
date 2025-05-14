// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown_menu.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [DropdownMenuSpec].
mixin _$DropdownMenuSpec on Spec<DropdownMenuSpec> {
  static DropdownMenuSpec from(MixData mix) {
    return mix.attributeOf<DropdownMenuSpecAttribute>()?.resolve(mix) ??
        const DropdownMenuSpec();
  }

  /// {@template dropdown_menu_spec_of}
  /// Retrieves the [DropdownMenuSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [DropdownMenuSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [DropdownMenuSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final dropdownMenuSpec = DropdownMenuSpec.of(context);
  /// ```
  /// {@endtemplate}
  static DropdownMenuSpec of(BuildContext context) {
    return _$DropdownMenuSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [DropdownMenuSpec] but with the given fields
  /// replaced with the new values.
  @override
  DropdownMenuSpec copyWith({
    DropdownMenuContainerSpec? menu,
    DropdownMenuItemSpec? item,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return DropdownMenuSpec(
      menu: menu ?? _$this.menu,
      item: item ?? _$this.item,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [DropdownMenuSpec] and another [DropdownMenuSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DropdownMenuSpec] is returned. When [t] is 1.0, the [other] [DropdownMenuSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DropdownMenuSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [DropdownMenuSpec] instance.
  ///
  /// The interpolation is performed on each property of the [DropdownMenuSpec] using the appropriate
  /// interpolation method:
  /// - [DropdownMenuContainerSpec.lerp] for [menu].
  /// - [DropdownMenuItemSpec.lerp] for [item].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DropdownMenuSpec] is used. Otherwise, the value
  /// from the [other] [DropdownMenuSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DropdownMenuSpec] configurations.
  @override
  DropdownMenuSpec lerp(DropdownMenuSpec? other, double t) {
    if (other == null) return _$this;

    return DropdownMenuSpec(
      menu: _$this.menu.lerp(other.menu, t),
      item: _$this.item.lerp(other.item, t),
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [DropdownMenuSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DropdownMenuSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.menu,
        _$this.item,
        _$this.modifiers,
        _$this.animated,
      ];

  DropdownMenuSpec get _$this => this as DropdownMenuSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('menu', _$this.menu, defaultValue: null));
    properties
        .add(DiagnosticsProperty('item', _$this.item, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [DropdownMenuSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DropdownMenuSpec].
///
/// Use this class to configure the attributes of a [DropdownMenuSpec] and pass it to
/// the [DropdownMenuSpec] constructor.
class DropdownMenuSpecAttribute extends SpecAttribute<DropdownMenuSpec>
    with Diagnosticable {
  final DropdownMenuContainerSpecAttribute? menu;
  final DropdownMenuItemSpecAttribute? item;

  const DropdownMenuSpecAttribute({
    this.menu,
    this.item,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [DropdownMenuSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final dropdownMenuSpec = DropdownMenuSpecAttribute(...).resolve(mix);
  /// ```
  @override
  DropdownMenuSpec resolve(MixData mix) {
    return DropdownMenuSpec(
      menu: menu?.resolve(mix),
      item: item?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [DropdownMenuSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DropdownMenuSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DropdownMenuSpecAttribute merge(DropdownMenuSpecAttribute? other) {
    if (other == null) return this;

    return DropdownMenuSpecAttribute(
      menu: menu?.merge(other.menu) ?? other.menu,
      item: item?.merge(other.item) ?? other.item,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [DropdownMenuSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DropdownMenuSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        menu,
        item,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('menu', menu, defaultValue: null));
    properties.add(DiagnosticsProperty('item', item, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [DropdownMenuSpec] properties.
///
/// This class provides methods to set individual properties of a [DropdownMenuSpec].
/// Use the methods of this class to configure specific properties of a [DropdownMenuSpec].
class DropdownMenuSpecUtility<T extends Attribute>
    extends SpecUtility<T, DropdownMenuSpecAttribute> {
  /// Utility for defining [DropdownMenuSpecAttribute.menu]
  late final menu = DropdownMenuContainerSpecUtility((v) => only(menu: v));

  /// Utility for defining [DropdownMenuSpecAttribute.item]
  late final item = DropdownMenuItemSpecUtility((v) => only(item: v));

  /// Utility for defining [DropdownMenuSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [DropdownMenuSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  DropdownMenuSpecUtility(super.builder, {super.mutable});

  DropdownMenuSpecUtility<T> get chain =>
      DropdownMenuSpecUtility(attributeBuilder, mutable: true);

  static DropdownMenuSpecUtility<DropdownMenuSpecAttribute> get self =>
      DropdownMenuSpecUtility((v) => v);

  /// Returns a new [DropdownMenuSpecAttribute] with the specified properties.
  @override
  T only({
    DropdownMenuContainerSpecAttribute? menu,
    DropdownMenuItemSpecAttribute? item,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(DropdownMenuSpecAttribute(
      menu: menu,
      item: item,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [DropdownMenuSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [DropdownMenuSpec] specifications.
class DropdownMenuSpecTween extends Tween<DropdownMenuSpec?> {
  DropdownMenuSpecTween({
    super.begin,
    super.end,
  });

  @override
  DropdownMenuSpec lerp(double t) {
    if (begin == null && end == null) {
      return const DropdownMenuSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

/// A mixin that provides spec functionality for [DropdownMenuContainerSpec].
mixin _$DropdownMenuContainerSpec on Spec<DropdownMenuContainerSpec> {
  static DropdownMenuContainerSpec from(MixData mix) {
    return mix
            .attributeOf<DropdownMenuContainerSpecAttribute>()
            ?.resolve(mix) ??
        const DropdownMenuContainerSpec();
  }

  /// {@template dropdown_menu_container_spec_of}
  /// Retrieves the [DropdownMenuContainerSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [DropdownMenuContainerSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [DropdownMenuContainerSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final dropdownMenuContainerSpec = DropdownMenuContainerSpec.of(context);
  /// ```
  /// {@endtemplate}
  static DropdownMenuContainerSpec of(BuildContext context) {
    return _$DropdownMenuContainerSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [DropdownMenuContainerSpec] but with the given fields
  /// replaced with the new values.
  @override
  DropdownMenuContainerSpec copyWith({
    FlexBoxSpec? container,
    bool? autoWidth,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return DropdownMenuContainerSpec(
      container: container ?? _$this.container,
      autoWidth: autoWidth ?? _$this.autoWidth,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [DropdownMenuContainerSpec] and another [DropdownMenuContainerSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DropdownMenuContainerSpec] is returned. When [t] is 1.0, the [other] [DropdownMenuContainerSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DropdownMenuContainerSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [DropdownMenuContainerSpec] instance.
  ///
  /// The interpolation is performed on each property of the [DropdownMenuContainerSpec] using the appropriate
  /// interpolation method:
  /// - [FlexBoxSpec.lerp] for [container].
  /// For [autoWidth] and [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DropdownMenuContainerSpec] is used. Otherwise, the value
  /// from the [other] [DropdownMenuContainerSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DropdownMenuContainerSpec] configurations.
  @override
  DropdownMenuContainerSpec lerp(DropdownMenuContainerSpec? other, double t) {
    if (other == null) return _$this;

    return DropdownMenuContainerSpec(
      container: _$this.container.lerp(other.container, t),
      autoWidth: t < 0.5 ? _$this.autoWidth : other.autoWidth,
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [DropdownMenuContainerSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DropdownMenuContainerSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.container,
        _$this.autoWidth,
        _$this.modifiers,
        _$this.animated,
      ];

  DropdownMenuContainerSpec get _$this => this as DropdownMenuContainerSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(
        DiagnosticsProperty('autoWidth', _$this.autoWidth, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [DropdownMenuContainerSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DropdownMenuContainerSpec].
///
/// Use this class to configure the attributes of a [DropdownMenuContainerSpec] and pass it to
/// the [DropdownMenuContainerSpec] constructor.
class DropdownMenuContainerSpecAttribute
    extends SpecAttribute<DropdownMenuContainerSpec> with Diagnosticable {
  final FlexBoxSpecAttribute? container;
  final bool? autoWidth;

  const DropdownMenuContainerSpecAttribute({
    this.container,
    this.autoWidth,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [DropdownMenuContainerSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final dropdownMenuContainerSpec = DropdownMenuContainerSpecAttribute(...).resolve(mix);
  /// ```
  @override
  DropdownMenuContainerSpec resolve(MixData mix) {
    return DropdownMenuContainerSpec(
      container: container?.resolve(mix),
      autoWidth: autoWidth,
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [DropdownMenuContainerSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DropdownMenuContainerSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DropdownMenuContainerSpecAttribute merge(
      DropdownMenuContainerSpecAttribute? other) {
    if (other == null) return this;

    return DropdownMenuContainerSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      autoWidth: other.autoWidth ?? autoWidth,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [DropdownMenuContainerSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DropdownMenuContainerSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        container,
        autoWidth,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('autoWidth', autoWidth, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [DropdownMenuContainerSpec] properties.
///
/// This class provides methods to set individual properties of a [DropdownMenuContainerSpec].
/// Use the methods of this class to configure specific properties of a [DropdownMenuContainerSpec].
class DropdownMenuContainerSpecUtility<T extends Attribute>
    extends SpecUtility<T, DropdownMenuContainerSpecAttribute> {
  /// Utility for defining [DropdownMenuContainerSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [DropdownMenuContainerSpecAttribute.autoWidth]
  late final autoWidth = BoolUtility((v) => only(autoWidth: v));

  /// Utility for defining [DropdownMenuContainerSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [DropdownMenuContainerSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  DropdownMenuContainerSpecUtility(super.builder, {super.mutable});

  DropdownMenuContainerSpecUtility<T> get chain =>
      DropdownMenuContainerSpecUtility(attributeBuilder, mutable: true);

  static DropdownMenuContainerSpecUtility<DropdownMenuContainerSpecAttribute>
      get self => DropdownMenuContainerSpecUtility((v) => v);

  /// Returns a new [DropdownMenuContainerSpecAttribute] with the specified properties.
  @override
  T only({
    FlexBoxSpecAttribute? container,
    bool? autoWidth,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(DropdownMenuContainerSpecAttribute(
      container: container,
      autoWidth: autoWidth,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [DropdownMenuContainerSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [DropdownMenuContainerSpec] specifications.
class DropdownMenuContainerSpecTween extends Tween<DropdownMenuContainerSpec?> {
  DropdownMenuContainerSpecTween({
    super.begin,
    super.end,
  });

  @override
  DropdownMenuContainerSpec lerp(double t) {
    if (begin == null && end == null) {
      return const DropdownMenuContainerSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

/// A mixin that provides spec functionality for [DropdownMenuItemSpec].
mixin _$DropdownMenuItemSpec on Spec<DropdownMenuItemSpec> {
  static DropdownMenuItemSpec from(MixData mix) {
    return mix.attributeOf<DropdownMenuItemSpecAttribute>()?.resolve(mix) ??
        const DropdownMenuItemSpec();
  }

  /// {@template dropdown_menu_item_spec_of}
  /// Retrieves the [DropdownMenuItemSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [DropdownMenuItemSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [DropdownMenuItemSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final dropdownMenuItemSpec = DropdownMenuItemSpec.of(context);
  /// ```
  /// {@endtemplate}
  static DropdownMenuItemSpec of(BuildContext context) {
    return _$DropdownMenuItemSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [DropdownMenuItemSpec] but with the given fields
  /// replaced with the new values.
  @override
  DropdownMenuItemSpec copyWith({
    IconSpec? icon,
    TextSpec? text,
    FlexBoxSpec? container,
    WidgetModifiersData? modifiers,
    AnimatedData? animated,
  }) {
    return DropdownMenuItemSpec(
      icon: icon ?? _$this.icon,
      text: text ?? _$this.text,
      container: container ?? _$this.container,
      modifiers: modifiers ?? _$this.modifiers,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [DropdownMenuItemSpec] and another [DropdownMenuItemSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [DropdownMenuItemSpec] is returned. When [t] is 1.0, the [other] [DropdownMenuItemSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [DropdownMenuItemSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [DropdownMenuItemSpec] instance.
  ///
  /// The interpolation is performed on each property of the [DropdownMenuItemSpec] using the appropriate
  /// interpolation method:
  /// - [IconSpec.lerp] for [icon].
  /// - [TextSpec.lerp] for [text].
  /// - [FlexBoxSpec.lerp] for [container].
  /// For [modifiers] and [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [DropdownMenuItemSpec] is used. Otherwise, the value
  /// from the [other] [DropdownMenuItemSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [DropdownMenuItemSpec] configurations.
  @override
  DropdownMenuItemSpec lerp(DropdownMenuItemSpec? other, double t) {
    if (other == null) return _$this;

    return DropdownMenuItemSpec(
      icon: _$this.icon.lerp(other.icon, t),
      text: _$this.text.lerp(other.text, t),
      container: _$this.container.lerp(other.container, t),
      modifiers: other.modifiers,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }

  /// The list of properties that constitute the state of this [DropdownMenuItemSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DropdownMenuItemSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.icon,
        _$this.text,
        _$this.container,
        _$this.modifiers,
        _$this.animated,
      ];

  DropdownMenuItemSpec get _$this => this as DropdownMenuItemSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('icon', _$this.icon, defaultValue: null));
    properties
        .add(DiagnosticsProperty('text', _$this.text, defaultValue: null));
    properties.add(
        DiagnosticsProperty('container', _$this.container, defaultValue: null));
    properties.add(
        DiagnosticsProperty('modifiers', _$this.modifiers, defaultValue: null));
    properties.add(
        DiagnosticsProperty('animated', _$this.animated, defaultValue: null));
  }
}

/// Represents the attributes of a [DropdownMenuItemSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [DropdownMenuItemSpec].
///
/// Use this class to configure the attributes of a [DropdownMenuItemSpec] and pass it to
/// the [DropdownMenuItemSpec] constructor.
class DropdownMenuItemSpecAttribute extends SpecAttribute<DropdownMenuItemSpec>
    with Diagnosticable {
  final IconSpecAttribute? icon;
  final TextSpecAttribute? text;
  final FlexBoxSpecAttribute? container;

  const DropdownMenuItemSpecAttribute({
    this.icon,
    this.text,
    this.container,
    super.modifiers,
    super.animated,
  });

  /// Resolves to [DropdownMenuItemSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final dropdownMenuItemSpec = DropdownMenuItemSpecAttribute(...).resolve(mix);
  /// ```
  @override
  DropdownMenuItemSpec resolve(MixData mix) {
    return DropdownMenuItemSpec(
      icon: icon?.resolve(mix),
      text: text?.resolve(mix),
      container: container?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [DropdownMenuItemSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DropdownMenuItemSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DropdownMenuItemSpecAttribute merge(DropdownMenuItemSpecAttribute? other) {
    if (other == null) return this;

    return DropdownMenuItemSpecAttribute(
      icon: icon?.merge(other.icon) ?? other.icon,
      text: text?.merge(other.text) ?? other.text,
      container: container?.merge(other.container) ?? other.container,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [DropdownMenuItemSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DropdownMenuItemSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        icon,
        text,
        container,
        modifiers,
        animated,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties.add(DiagnosticsProperty('text', text, defaultValue: null));
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
  }
}

/// Utility class for configuring [DropdownMenuItemSpec] properties.
///
/// This class provides methods to set individual properties of a [DropdownMenuItemSpec].
/// Use the methods of this class to configure specific properties of a [DropdownMenuItemSpec].
class DropdownMenuItemSpecUtility<T extends Attribute>
    extends SpecUtility<T, DropdownMenuItemSpecAttribute> {
  /// Utility for defining [DropdownMenuItemSpecAttribute.icon]
  late final icon = IconSpecUtility((v) => only(icon: v));

  /// Utility for defining [DropdownMenuItemSpecAttribute.text]
  late final text = TextSpecUtility((v) => only(text: v));

  /// Utility for defining [DropdownMenuItemSpecAttribute.container]
  late final container = FlexBoxSpecUtility((v) => only(container: v));

  /// Utility for defining [DropdownMenuItemSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  /// Utility for defining [DropdownMenuItemSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  DropdownMenuItemSpecUtility(super.builder, {super.mutable});

  DropdownMenuItemSpecUtility<T> get chain =>
      DropdownMenuItemSpecUtility(attributeBuilder, mutable: true);

  static DropdownMenuItemSpecUtility<DropdownMenuItemSpecAttribute> get self =>
      DropdownMenuItemSpecUtility((v) => v);

  /// Returns a new [DropdownMenuItemSpecAttribute] with the specified properties.
  @override
  T only({
    IconSpecAttribute? icon,
    TextSpecAttribute? text,
    FlexBoxSpecAttribute? container,
    WidgetModifiersDataDto? modifiers,
    AnimatedDataDto? animated,
  }) {
    return builder(DropdownMenuItemSpecAttribute(
      icon: icon,
      text: text,
      container: container,
      modifiers: modifiers,
      animated: animated,
    ));
  }
}

/// A tween that interpolates between two [DropdownMenuItemSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [DropdownMenuItemSpec] specifications.
class DropdownMenuItemSpecTween extends Tween<DropdownMenuItemSpec?> {
  DropdownMenuItemSpecTween({
    super.begin,
    super.end,
  });

  @override
  DropdownMenuItemSpec lerp(double t) {
    if (begin == null && end == null) {
      return const DropdownMenuItemSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
