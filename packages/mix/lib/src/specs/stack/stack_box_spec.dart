import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import '../box/box_spec.dart';
import 'stack_spec.dart';

final class ZBoxSpec extends Spec<ZBoxSpec> with Diagnosticable {
  final BoxSpec box;
  final StackSpec stack;

  const ZBoxSpec({BoxSpec? box, StackSpec? stack})
    : box = box ?? const BoxSpec(),
      stack = stack ?? const StackSpec();

  static ZBoxSpec from(BuildContext context) {
    return maybeOf(context) ?? const ZBoxSpec();
  }

  /// Retrieves the [ZBoxSpec] from the nearest [ResolvedStyleProvider] ancestor.
  ///
  /// Returns null if no ancestor [ResolvedStyleProvider] is found.
  static ZBoxSpec? maybeOf(BuildContext context) {
    return ResolvedStyleProvider.of<ZBoxSpec>(context)?.spec;
  }

  /// {@template stack_box_spec_of}
  /// Retrieves the [ZBoxSpec] from the nearest [ResolvedStyleProvider] ancestor in the widget tree.
  ///
  /// This method uses [ResolvedStyleProvider.of] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [ZBoxSpec] changes, not when other specs change.
  /// If no ancestor [ResolvedStyleProvider] is found, this method returns an empty [ZBoxSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final stackBoxSpec = StackBoxSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ZBoxSpec of(BuildContext context) {
    return maybeOf(context) ?? const ZBoxSpec();
  }

  /// Creates a copy of this [ZBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  ZBoxSpec copyWith({BoxSpec? box, StackSpec? stack}) {
    return ZBoxSpec(box: box ?? this.box, stack: stack ?? this.stack);
  }

  /// Linearly interpolates between this [ZBoxSpec] and another [ZBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ZBoxSpec] is returned. When [t] is 1.0, the [other] [ZBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ZBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ZBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ZBoxSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [box].
  /// - [StackSpec.lerp] for [stack].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ZBoxSpec] configurations.
  @override
  ZBoxSpec lerp(ZBoxSpec? other, double t) {
    if (other == null) return this;

    return ZBoxSpec(
      box: box.lerp(other.box, t),
      stack: stack.lerp(other.stack, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('box', box, defaultValue: null));
    properties.add(DiagnosticsProperty('stack', stack, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [ZBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ZBoxSpec] instances for equality.
  @override
  List<Object?> get props => [box, stack];
}

/// Represents the attributes of a [ZBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ZBoxSpec].
///
/// Use this class to configure the attributes of a [ZBoxSpec] and pass it to
/// the [ZBoxSpec] constructor.
class StackBoxSpecAttribute extends SpecAttribute<ZBoxSpec>
    with Diagnosticable {
  final BoxSpecAttribute? box;
  final StackSpecAttribute? stack;

  const StackBoxSpecAttribute({this.box, this.stack});

  /// Constructor that accepts a [ZBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ZBoxSpec] instances to [StackBoxSpecAttribute].
  ///
  /// ```dart
  /// const spec = StackBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxSpecAttribute.value(spec);
  /// ```
  static StackBoxSpecAttribute value(ZBoxSpec spec) {
    return StackBoxSpecAttribute(
      box: BoxSpecAttribute.maybeValue(spec.box),
      stack: StackSpecAttribute.maybeValue(spec.stack),
    );
  }

  /// Constructor that accepts a nullable [ZBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackBoxSpecAttribute.value].
  ///
  /// ```dart
  /// const StackBoxSpec? spec = StackBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxSpecAttribute.maybeValue(spec); // Returns StackBoxSpecAttribute or null
  /// ```
  static StackBoxSpecAttribute? maybeValue(ZBoxSpec? spec) {
    return spec != null ? StackBoxSpecAttribute.value(spec) : null;
  }

  /// Resolves to [ZBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final stackBoxSpec = StackBoxSpecAttribute(...).resolve(context);
  /// ```
  @override
  ZBoxSpec resolve(BuildContext context) {
    return ZBoxSpec(box: box?.resolve(context), stack: stack?.resolve(context));
  }

  /// Merges the properties of this [StackBoxSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StackBoxSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StackBoxSpecAttribute merge(StackBoxSpecAttribute? other) {
    if (other == null) return this;

    return StackBoxSpecAttribute(
      box: box?.merge(other.box) ?? other.box,
      stack: stack?.merge(other.stack) ?? other.stack,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('box', box, defaultValue: null));
    properties.add(DiagnosticsProperty('stack', stack, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [StackBoxSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackBoxSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [box, stack];
}

/// Utility class for configuring [ZBoxSpec] properties.
///
/// This class provides methods to set individual properties of a [ZBoxSpec].
/// Use the methods of this class to configure specific properties of a [ZBoxSpec].
class StackBoxSpecUtility<T extends Attribute>
    extends SpecUtility<T, StackBoxSpecAttribute> {
  /// Utility for defining [StackBoxSpecAttribute.box]
  late final box = BoxSpecUtility((v) => only(box: v));

  /// Utility for defining [StackBoxSpecAttribute.box.alignment]
  late final alignment = box.alignment;

  /// Utility for defining [StackBoxSpecAttribute.box.padding]
  late final padding = box.padding;

  /// Utility for defining [StackBoxSpecAttribute.box.margin]
  late final margin = box.margin;

  /// Utility for defining [StackBoxSpecAttribute.box.constraints]
  late final constraints = box.constraints;

  /// Utility for defining [StackBoxSpecAttribute.box.constraints.minWidth]
  late final minWidth = box.constraints.minWidth;

  /// Utility for defining [StackBoxSpecAttribute.box.constraints.maxWidth]
  late final maxWidth = box.constraints.maxWidth;

  /// Utility for defining [StackBoxSpecAttribute.box.constraints.minHeight]
  late final minHeight = box.constraints.minHeight;

  /// Utility for defining [StackBoxSpecAttribute.box.constraints.maxHeight]
  late final maxHeight = box.constraints.maxHeight;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration]
  late final decoration = box.decoration;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.color]
  late final color = box.decoration.color;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.border]
  late final border = box.decoration.border;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.border.directional]
  late final borderDirectional = box.decoration.border.directional;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.borderRadius]
  late final borderRadius = box.decoration.borderRadius;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.borderRadius.directional]
  late final borderRadiusDirectional = box.decoration.borderRadius.directional;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.gradient]
  late final gradient = box.decoration.gradient;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.gradient.sweep]
  late final sweepGradient = box.decoration.gradient.sweep;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.gradient.radial]
  late final radialGradient = box.decoration.gradient.radial;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.gradient.linear]
  late final linearGradient = box.decoration.gradient.linear;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.boxShadows]
  late final shadows = box.decoration.boxShadows;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.boxShadow]
  late final shadow = box.decoration.boxShadow;

  /// Utility for defining [StackBoxSpecAttribute.box.decoration.elevation]
  late final elevation = box.decoration.elevation;

  /// Utility for defining [StackBoxSpecAttribute.box.shapeDecoration]
  late final shapeDecoration = box.shapeDecoration;

  /// Utility for defining [StackBoxSpecAttribute.box.shape]
  late final shape = box.shape;

  /// Utility for defining [StackBoxSpecAttribute.box.foregroundDecoration]
  late final foregroundDecoration = box.foregroundDecoration;

  /// Utility for defining [StackBoxSpecAttribute.box.transform]
  late final transform = box.transform;

  /// Utility for defining [StackBoxSpecAttribute.box.transformAlignment]
  late final transformAlignment = box.transformAlignment;

  /// Utility for defining [StackBoxSpecAttribute.box.clipBehavior]
  late final clipBehavior = box.clipBehavior;

  /// Utility for defining [StackBoxSpecAttribute.box.width]
  late final width = box.width;

  /// Utility for defining [StackBoxSpecAttribute.box.height]
  late final height = box.height;

  /// Utility for defining [StackBoxSpecAttribute.stack]
  late final stack = StackSpecUtility((v) => only(stack: v));

  StackBoxSpecUtility(super.attributeBuilder);

  static StackBoxSpecUtility<StackBoxSpecAttribute> get self =>
      StackBoxSpecUtility((v) => v);

  /// Returns a new [StackBoxSpecAttribute] with the specified properties.
  @override
  T only({BoxSpecAttribute? box, StackSpecAttribute? stack}) {
    return builder(StackBoxSpecAttribute(box: box, stack: stack));
  }
}

/// A tween that interpolates between two [ZBoxSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ZBoxSpec] specifications.
class StackBoxSpecTween extends Tween<ZBoxSpec?> {
  StackBoxSpecTween({super.begin, super.end});

  @override
  ZBoxSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ZBoxSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
