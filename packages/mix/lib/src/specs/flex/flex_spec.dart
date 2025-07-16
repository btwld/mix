import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/enum/enum_util.dart';
import '../../attributes/gap/gap_util.dart';
import '../../attributes/gap/space_dto.dart';
import '../../attributes/modifiers/widget_modifiers_config.dart';
import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/factory/mix_context.dart';
import '../../core/factory/style_mix.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';

final class FlexSpec extends Spec<FlexSpec> with Diagnosticable {
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final Clip? clipBehavior;
  final double? gap;

  const FlexSpec({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.direction,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    this.gap,
    super.modifiers,
  });
  static FlexSpec from(MixContext mix) {
    return mix.attributeOf<FlexSpecAttribute>()?.resolve(mix) ??
        const FlexSpec();
  }

  /// {@template flex_spec_of}
  /// Retrieves the [FlexSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [FlexSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [FlexSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final flexSpec = FlexSpec.of(context);
  /// ```
  /// {@endtemplate}
  static FlexSpec of(BuildContext context) {
    return ComputedStyle.specOf(context) ?? const FlexSpec();
  }


  /// Creates a copy of this [FlexSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexSpec copyWith({
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    Axis? direction,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? gap,
    WidgetModifiersConfig? modifiers,
  }) {
    return FlexSpec(
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      direction: direction ?? this.direction,
      textDirection: textDirection ?? this.textDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      gap: gap ?? this.gap,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  /// Linearly interpolates between this [FlexSpec] and another [FlexSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexSpec] is returned. When [t] is 1.0, the [other] [FlexSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [gap].
  /// For [crossAxisAlignment] and [mainAxisAlignment] and [mainAxisSize] and [verticalDirection] and [direction] and [textDirection] and [textBaseline] and [clipBehavior] and [modifiers], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [FlexSpec] is used. Otherwise, the value
  /// from the [other] [FlexSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexSpec] configurations.
  @override
  FlexSpec lerp(FlexSpec? other, double t) {
    if (other == null) return this;

    return FlexSpec(
      crossAxisAlignment: t < 0.5
          ? crossAxisAlignment
          : other.crossAxisAlignment,
      mainAxisAlignment: t < 0.5 ? mainAxisAlignment : other.mainAxisAlignment,
      mainAxisSize: t < 0.5 ? mainAxisSize : other.mainAxisSize,
      verticalDirection: t < 0.5 ? verticalDirection : other.verticalDirection,
      direction: t < 0.5 ? direction : other.direction,
      textDirection: t < 0.5 ? textDirection : other.textDirection,
      textBaseline: t < 0.5 ? textBaseline : other.textBaseline,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      gap: MixHelpers.lerpDouble(gap, other.gap, t),
      modifiers: other.modifiers,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty(
        'crossAxisAlignment',
        crossAxisAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'mainAxisAlignment',
        mainAxisAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('mainAxisSize', mainAxisSize, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'verticalDirection',
        verticalDirection,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('direction', direction, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textDirection', textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textBaseline', textBaseline, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('gap', gap, defaultValue: null));
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [FlexSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexSpec] instances for equality.
  @override
  List<Object?> get props => [
    crossAxisAlignment,
    mainAxisAlignment,
    mainAxisSize,
    verticalDirection,
    direction,
    textDirection,
    textBaseline,
    clipBehavior,
    gap,
    modifiers,
  ];
}

/// Represents the attributes of a [FlexSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexSpec].
///
/// Use this class to configure the attributes of a [FlexSpec] and pass it to
/// the [FlexSpec] constructor.
class FlexSpecAttribute extends SpecAttribute<FlexSpec> with Diagnosticable {
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final Axis? direction;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final Clip? clipBehavior;
  final SpaceDto? gap;

  const FlexSpecAttribute({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.direction,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    this.gap,
    super.modifiers,
  });

  const FlexSpecAttribute.props({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.direction,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    this.gap,
    super.modifiers,
  });

  /// Constructor that accepts a [FlexSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexSpec] instances to [FlexSpecAttribute].
  ///
  /// ```dart
  /// const spec = FlexSpec(direction: Axis.horizontal, mainAxisAlignment: MainAxisAlignment.center);
  /// final attr = FlexSpecAttribute.value(spec);
  /// ```
  static FlexSpecAttribute value(FlexSpec spec) {
    return FlexSpecAttribute(
      crossAxisAlignment: spec.crossAxisAlignment,
      mainAxisAlignment: spec.mainAxisAlignment,
      mainAxisSize: spec.mainAxisSize,
      verticalDirection: spec.verticalDirection,
      direction: spec.direction,
      textDirection: spec.textDirection,
      textBaseline: spec.textBaseline,
      clipBehavior: spec.clipBehavior,
      gap: SpaceDto.maybeValue(spec.gap),
      modifiers: WidgetModifiersConfigDto.maybeValue(spec.modifiers),
    );
  }

  /// Constructor that accepts a nullable [FlexSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexSpecAttribute.value].
  ///
  /// ```dart
  /// const FlexSpec? spec = FlexSpec(direction: Axis.horizontal, mainAxisAlignment: MainAxisAlignment.center);
  /// final attr = FlexSpecAttribute.maybeValue(spec); // Returns FlexSpecAttribute or null
  /// ```
  static FlexSpecAttribute? maybeValue(FlexSpec? spec) {
    return spec != null ? FlexSpecAttribute.value(spec) : null;
  }

  /// Resolves to [FlexSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexSpec = FlexSpecAttribute(...).resolve(mix);
  /// ```
  @override
  FlexSpec resolve(MixContext context) {
    return FlexSpec(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      direction: direction,
      textDirection: textDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      gap: gap?.resolve(context),
      modifiers: modifiers?.resolve(context),
    );
  }

  /// Merges the properties of this [FlexSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexSpecAttribute merge(FlexSpecAttribute? other) {
    if (other == null) return this;

    return FlexSpecAttribute(
      crossAxisAlignment: other.crossAxisAlignment ?? crossAxisAlignment,
      mainAxisAlignment: other.mainAxisAlignment ?? mainAxisAlignment,
      mainAxisSize: other.mainAxisSize ?? mainAxisSize,
      verticalDirection: other.verticalDirection ?? verticalDirection,
      direction: other.direction ?? direction,
      textDirection: other.textDirection ?? textDirection,
      textBaseline: other.textBaseline ?? textBaseline,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      gap: gap?.merge(other.gap) ?? other.gap,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty(
        'crossAxisAlignment',
        crossAxisAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'mainAxisAlignment',
        mainAxisAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('mainAxisSize', mainAxisSize, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'verticalDirection',
        verticalDirection,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('direction', direction, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textDirection', textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textBaseline', textBaseline, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('gap', gap, defaultValue: null));
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [FlexSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
    crossAxisAlignment,
    mainAxisAlignment,
    mainAxisSize,
    verticalDirection,
    direction,
    textDirection,
    textBaseline,
    clipBehavior,
    gap,
    modifiers,
  ];
}

/// Utility class for configuring [FlexSpec] properties.
///
/// This class provides methods to set individual properties of a [FlexSpec].
/// Use the methods of this class to configure specific properties of a [FlexSpec].
class FlexSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, FlexSpecAttribute> {
  /// Utility for defining [FlexSpecAttribute.crossAxisAlignment]
  late final crossAxisAlignment = CrossAxisAlignmentUtility(
    (v) => only(crossAxisAlignment: v),
  );

  /// Utility for defining [FlexSpecAttribute.mainAxisAlignment]
  late final mainAxisAlignment = MainAxisAlignmentUtility(
    (v) => only(mainAxisAlignment: v),
  );

  /// Utility for defining [FlexSpecAttribute.mainAxisSize]
  late final mainAxisSize = MainAxisSizeUtility((v) => only(mainAxisSize: v));

  /// Utility for defining [FlexSpecAttribute.verticalDirection]
  late final verticalDirection = VerticalDirectionUtility(
    (v) => only(verticalDirection: v),
  );

  /// Utility for defining [FlexSpecAttribute.direction]
  late final direction = AxisUtility((v) => only(direction: v));

  /// Utility for defining [FlexSpecAttribute.direction.horizontal]
  late final row = direction.horizontal;

  /// Utility for defining [FlexSpecAttribute.direction.vertical]
  late final column = direction.vertical;

  /// Utility for defining [FlexSpecAttribute.textDirection]
  late final textDirection = TextDirectionUtility(
    (v) => only(textDirection: v),
  );

  /// Utility for defining [FlexSpecAttribute.textBaseline]
  late final textBaseline = TextBaselineUtility((v) => only(textBaseline: v));

  /// Utility for defining [FlexSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility((v) => only(clipBehavior: v));

  /// Utility for defining [FlexSpecAttribute.gap]
  late final gap = GapUtility((v) => only(gap: v));


  /// Utility for defining [FlexSpecAttribute.modifiers]
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  FlexSpecUtility(super.attributeBuilder);

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  FlexSpecUtility<T> get chain => FlexSpecUtility(attributeBuilder);

  static FlexSpecUtility<FlexSpecAttribute> get self =>
      FlexSpecUtility((v) => v);

  /// Returns a new [FlexSpecAttribute] with the specified properties.
  @override
  T only({
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    Axis? direction,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    SpaceDto? gap,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return builder(
      FlexSpecAttribute(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        verticalDirection: verticalDirection,
        direction: direction,
        textDirection: textDirection,
        textBaseline: textBaseline,
        clipBehavior: clipBehavior,
        gap: gap,
        modifiers: modifiers,
      ),
    );
  }
}

/// A tween that interpolates between two [FlexSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [FlexSpec] specifications.
class FlexSpecTween extends Tween<FlexSpec?> {
  FlexSpecTween({super.begin, super.end});

  @override
  FlexSpec lerp(double t) {
    if (begin == null && end == null) {
      return const FlexSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
