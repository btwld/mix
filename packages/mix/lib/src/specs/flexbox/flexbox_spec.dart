import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import '../box/box_attribute.dart';
import '../box/box_spec.dart';
import '../flex/flex_attribute.dart';
import '../flex/flex_spec.dart';

final class FlexBoxSpec extends Spec<FlexBoxSpec> with Diagnosticable {
  final BoxSpec box;
  final FlexSpec flex;

  const FlexBoxSpec({BoxSpec? box, FlexSpec? flex})
    : box = box ?? const BoxSpec(),
      flex = flex ?? const FlexSpec();

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('box', box, defaultValue: null));
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
  }

  /// Creates a copy of this [FlexBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexBoxSpec copyWith({BoxSpec? box, FlexSpec? flex}) {
    return FlexBoxSpec(box: box ?? this.box, flex: flex ?? this.flex);
  }

  /// Linearly interpolates between this [FlexBoxSpec] and another [FlexBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexBoxSpec] is returned. When [t] is 1.0, the [other] [FlexBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexBoxSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [box].
  /// - [FlexSpec.lerp] for [flex].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexBoxSpec] configurations.
  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    if (other == null) return this;

    return FlexBoxSpec(
      box: box.lerp(other.box, t),
      flex: flex.lerp(other.flex, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [FlexBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpec] instances for equality.
  @override
  List<Object?> get props => [box, flex];
}

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
class FlexBoxSpecAttribute extends SpecAttribute<FlexBoxSpec>
    with Diagnosticable {
  final BoxSpecAttribute? $box;
  final FlexSpecAttribute? $flex;

  const FlexBoxSpecAttribute({
    BoxSpecAttribute? box,
    FlexSpecAttribute? flex,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $box = box,
       $flex = flex;

  /// Constructor that accepts a [FlexBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexBoxSpec] instances to [FlexBoxSpecAttribute].
  ///
  /// ```dart
  /// const spec = FlexBoxSpec(box: BoxSpec(...), flex: FlexSpec(...));
  /// final attr = FlexBoxSpecAttribute.value(spec);
  /// ```
  static FlexBoxSpecAttribute value(FlexBoxSpec spec) {
    return FlexBoxSpecAttribute(
      box: BoxSpecAttribute.maybeValue(spec.box),
      flex: FlexSpecAttribute.maybeValue(spec.flex),
    );
  }

  /// Constructor that accepts a nullable [FlexBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexBoxSpecAttribute.value].
  ///
  /// ```dart
  /// const FlexBoxSpec? spec = FlexBoxSpec(box: BoxSpec(...), flex: FlexSpec(...));
  /// final attr = FlexBoxSpecAttribute.maybeValue(spec); // Returns FlexBoxSpecAttribute or null
  /// ```
  static FlexBoxSpecAttribute? maybeValue(FlexBoxSpec? spec) {
    return spec != null ? FlexBoxSpecAttribute.value(spec) : null;
  }

  // Backward compatibility getters
  BoxSpecAttribute? get box => $box;
  FlexSpecAttribute? get flex => $flex;

  /// Resolves to [FlexBoxSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexBoxSpec = FlexBoxSpecAttribute(...).resolveSpec(context);
  /// ```
  @override
  FlexBoxSpec resolveSpec(BuildContext context) {
    return FlexBoxSpec(
      box: $box?.resolveSpec(context),
      flex: $flex?.resolveSpec(context),
    );
  }

  /// Merges the properties of this [FlexBoxSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexBoxSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexBoxSpecAttribute merge(FlexBoxSpecAttribute? other) {
    if (other == null) return this;

    return FlexBoxSpecAttribute(
      box: $box?.merge(other.$box) ?? other.$box,
      flex: $flex?.merge(other.$flex) ?? other.$flex,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('box', $box, defaultValue: null));
    properties.add(DiagnosticsProperty('flex', $flex, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [FlexBoxSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [$box, $flex];
}

/// Utility class for configuring [FlexBoxSpec] properties.
///
/// This class provides methods to set individual properties of a [FlexBoxSpec].
/// Use the methods of this class to configure specific properties of a [FlexBoxSpec].
class FlexBoxSpecUtility extends SpecUtility<FlexBoxSpec> {
  @override
  final FlexBoxSpecAttribute attribute;

  /// Utility for defining [FlexBoxSpecAttribute.box]
  late final box = BoxSpecAttribute();

  /// Utility for defining [FlexBoxSpecAttribute.box.alignment]
  late final alignment = box.alignment;

  /// Utility for defining [FlexBoxSpecAttribute.box.padding]
  late final padding = box.padding;

  /// Utility for defining [FlexBoxSpecAttribute.box.margin]
  late final margin = box.margin;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints]
  late final constraints = box.constraints;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints.minWidth]
  late final minWidth = box.minWidth;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints.maxWidth]
  late final maxWidth = box.maxWidth;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints.minHeight]
  late final minHeight = box.minHeight;

  /// Utility for defining [FlexBoxSpecAttribute.box.constraints.maxHeight]
  late final maxHeight = box.maxHeight;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration]
  late final decoration = box.decoration;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.color]
  late final color = box.color;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.border]
  late final border = box.border;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.border.directional]
  late final borderDirectional = box.borderDirectional;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.borderRadius]
  late final borderRadius = box.borderRadius;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.borderRadius.directional]
  late final borderRadiusDirectional = box.borderRadiusDirectional;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.gradient]
  late final gradient = box.gradient;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.gradient.sweep]
  late final sweepGradient = box.sweepGradient;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.gradient.radial]
  late final radialGradient = box.radialGradient;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.gradient.linear]
  late final linearGradient = box.linearGradient;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.boxShadows]
  late final shadows = box.shadows;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.boxShadow]
  late final shadow = box.shadow;

  /// Utility for defining [FlexBoxSpecAttribute.box.decoration.elevation]
  late final elevation = box.elevation;

  /// Utility for defining [FlexBoxSpecAttribute.box.shapeDecoration]
  late final shapeDecoration = box.shapeDecoration;

  /// Utility for defining [FlexBoxSpecAttribute.box.shape]
  late final shape = box.shape;

  /// Utility for defining [FlexBoxSpecAttribute.box.foregroundDecoration]
  late final foregroundDecoration = box.foregroundDecoration;

  /// Utility for defining [FlexBoxSpecAttribute.box.transform]
  late final transform = box.transform;

  /// Utility for defining [FlexBoxSpecAttribute.box.transformAlignment]
  late final transformAlignment = box.transformAlignment;

  /// Utility for defining [FlexBoxSpecAttribute.box.clipBehavior]
  late final clipBehavior = box.clipBehavior;

  /// Utility for defining [FlexBoxSpecAttribute.box.width]
  late final width = box.width;

  /// Utility for defining [FlexBoxSpecAttribute.box.height]
  late final height = box.height;

  /// Utility for defining [FlexBoxSpecAttribute.flex]
  late final flex = FlexSpecAttribute();

  FlexBoxSpecUtility({this.attribute = const FlexBoxSpecAttribute()});

  static FlexBoxSpecUtility get self => FlexBoxSpecUtility();

  FlexBoxSpecUtility build(FlexBoxSpecAttribute attribute) {
    return FlexBoxSpecUtility(attribute: this.attribute.merge(attribute));
  }
}
