import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/animated/animated_data_dto.dart';
import '../../attributes/animated/animated_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/gap/space_dto.dart';
import '../../attributes/gap/spacing_util.dart';
import '../../attributes/modifiers/widget_modifiers_data.dart';
import '../../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import 'flex_widget.dart';

part 'flex_spec.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipAttribute)
final class FlexSpec extends Spec<FlexSpec> with _$FlexSpec, Diagnosticable {
  @MixableField(
    utilities: [
      MixableFieldUtility(
        properties: [
          (path: 'horizontal', alias: 'row'),
          (path: 'vertical', alias: 'column'),
        ],
      ),
    ],
  )
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final Clip? clipBehavior;

  @Deprecated(
    'Use spacing instead. '
    'The gap property has been replaced with spacing for better naming consistency. '
    'This property will be removed in v2.0.0.\n',
  )
  @MixableField(
    dto: MixableFieldType(type: SpaceDto),
    utilities: [MixableFieldUtility(type: FlexSpacingUtility)],
  )
  final double? gap;

  @MixableField(
    dto: MixableFieldType(type: SpaceDto),
    utilities: [MixableFieldUtility(type: FlexSpacingUtility)],
  )
  final double? spacing;

  static const of = _$FlexSpec.of;

  static const from = _$FlexSpec.from;

  const FlexSpec({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.direction,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    double? spacing,
    @Deprecated(
      'Use spacing instead. '
      'The gap property has been replaced with spacing for better naming consistency. '
      'This property will be removed in v2.0.0.\n',
    )
    double? gap,
    super.animated,
    super.modifiers,
  })  : spacing = spacing ?? gap,
        gap = gap ?? spacing;

  Widget call({List<Widget> children = const [], required Axis direction}) {
    return isAnimated
        ? AnimatedFlexSpecWidget(
            spec: this,
            direction: direction,
            curve: animated!.curve,
            duration: animated!.duration,
            children: children,
          )
        : FlexSpecWidget(
            spec: this,
            direction: direction,
            children: children,
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
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
  final SpaceDto? spacing;

  const FlexSpecAttribute({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.direction,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    SpaceDto? spacing,
    @Deprecated(
      'Use spacing instead. '
      'The gap property has been replaced with spacing for better naming consistency. '
      'This property will be removed in v2.0.0.\n',
    )
    SpaceDto? gap,
    super.animated,
    super.modifiers,
  }) : spacing = spacing ?? gap;

  @Deprecated(
    'Use spacing instead. '
    'The gap property has been replaced with spacing for better naming consistency. '
    'This property will be removed in v2.0.0.\n',
  )
  SpaceDto? get gap => spacing;

  /// Resolves to [FlexSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexSpec = FlexSpecAttribute(...).resolve(mix);
  /// ```
  @override
  FlexSpec resolve(MixData mix) {
    return FlexSpec(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      direction: direction,
      textDirection: textDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
      modifiers: modifiers?.resolve(mix),
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
      spacing: spacing?.merge(other.spacing) ?? other.spacing,
      animated: animated?.merge(other.animated) ?? other.animated,
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
      'crossAxisAlignment',
      crossAxisAlignment,
      defaultValue: null,
    ));
    properties.add(DiagnosticsProperty(
      'mainAxisAlignment',
      mainAxisAlignment,
      defaultValue: null,
    ));
    properties.add(
      DiagnosticsProperty('mainAxisSize', mainAxisSize, defaultValue: null),
    );
    properties.add(DiagnosticsProperty(
      'verticalDirection',
      verticalDirection,
      defaultValue: null,
    ));
    properties
        .add(DiagnosticsProperty('direction', direction, defaultValue: null));
    properties.add(DiagnosticsProperty(
      'textDirection',
      textDirection,
      defaultValue: null,
    ));
    properties.add(
      DiagnosticsProperty('textBaseline', textBaseline, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('spacing', spacing, defaultValue: null));
    properties
        .add(DiagnosticsProperty('animated', animated, defaultValue: null));
    properties
        .add(DiagnosticsProperty('modifiers', modifiers, defaultValue: null));
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
        spacing,
        animated,
        modifiers,
      ];
}

extension FlexSpecUtilityExt<T extends Attribute> on FlexSpecUtility<T> {
  /// Utility for defining [FlexSpecAttribute.gap]
  @Deprecated(
    'Use spacing instead. '
    'The gap property has been replaced with spacing for better naming consistency. '
    'This property will be removed in v2.0.0.\n',
  )
  FlexSpacingUtility<T> get gap => FlexSpacingUtility((v) => only(spacing: v));
}
