// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../attributes/border/border_radius_dto.dart';
import '../core/attribute.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

final class ClipOvalModifierSpec extends ModifierSpec<ClipOvalModifierSpec>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipOvalModifierSpec({this.clipper, this.clipBehavior});

  /// Creates a copy of this [ClipOvalModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  ClipOvalModifierSpec copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipOvalModifierSpec(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipOvalModifierSpec] and another [ClipOvalModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipOvalModifierSpec] is returned. When [t] is 1.0, the [other] [ClipOvalModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipOvalModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipOvalModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ClipOvalModifierSpec] using the appropriate
  /// interpolation method:
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipOvalModifierSpec] is used. Otherwise, the value
  /// from the [other] [ClipOvalModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipOvalModifierSpec] configurations.
  @override
  ClipOvalModifierSpec lerp(ClipOvalModifierSpec? other, double t) {
    if (other == null) return this;

    return ClipOvalModifierSpec(
      clipper: t < 0.5 ? clipper : other.clipper,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('clipper', clipper, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipOvalModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipOvalModifierSpec] instances for equality.
  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipOval(
      clipper: clipper,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );
  }
}

/// Represents the attributes of a [ClipOvalModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipOvalModifierSpec].
///
/// Use this class to configure the attributes of a [ClipOvalModifierSpec] and pass it to
/// the [ClipOvalModifierSpec] constructor.
class ClipOvalModifierSpecAttribute
    extends ModifierSpecAttribute<ClipOvalModifierSpec>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipOvalModifierSpecAttribute({this.clipper, this.clipBehavior});

  /// Resolves to [ClipOvalModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipOvalModifierSpec = ClipOvalModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ClipOvalModifierSpec resolve(BuildContext context) {
    return ClipOvalModifierSpec(clipper: clipper, clipBehavior: clipBehavior);
  }

  /// Merges the properties of this [ClipOvalModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipOvalModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipOvalModifierSpecAttribute merge(ClipOvalModifierSpecAttribute? other) {
    if (other == null) return this;

    return ClipOvalModifierSpecAttribute(
      clipper: other.clipper ?? clipper,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('clipper', clipper, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipOvalModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipOvalModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [clipper, clipBehavior];
}

/// A tween that interpolates between two [ClipOvalModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ClipOvalModifierSpec] specifications.
class ClipOvalModifierSpecTween extends Tween<ClipOvalModifierSpec?> {
  ClipOvalModifierSpecTween({super.begin, super.end});

  @override
  ClipOvalModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ClipOvalModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

final class ClipRectModifierSpec extends ModifierSpec<ClipRectModifierSpec>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipRectModifierSpec({this.clipper, this.clipBehavior});

  /// Creates a copy of this [ClipRectModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  ClipRectModifierSpec copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRectModifierSpec(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipRectModifierSpec] and another [ClipRectModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipRectModifierSpec] is returned. When [t] is 1.0, the [other] [ClipRectModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipRectModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipRectModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ClipRectModifierSpec] using the appropriate
  /// interpolation method:
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipRectModifierSpec] is used. Otherwise, the value
  /// from the [other] [ClipRectModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipRectModifierSpec] configurations.
  @override
  ClipRectModifierSpec lerp(ClipRectModifierSpec? other, double t) {
    if (other == null) return this;

    return ClipRectModifierSpec(
      clipper: t < 0.5 ? clipper : other.clipper,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('clipper', clipper, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipRectModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipRectModifierSpec] instances for equality.
  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipRect(
      clipper: clipper,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      child: child,
    );
  }
}

/// Represents the attributes of a [ClipRectModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipRectModifierSpec].
///
/// Use this class to configure the attributes of a [ClipRectModifierSpec] and pass it to
/// the [ClipRectModifierSpec] constructor.
class ClipRectModifierSpecAttribute
    extends ModifierSpecAttribute<ClipRectModifierSpec>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipRectModifierSpecAttribute({this.clipper, this.clipBehavior});

  /// Resolves to [ClipRectModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipRectModifierSpec = ClipRectModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ClipRectModifierSpec resolve(BuildContext context) {
    return ClipRectModifierSpec(clipper: clipper, clipBehavior: clipBehavior);
  }

  /// Merges the properties of this [ClipRectModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipRectModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipRectModifierSpecAttribute merge(ClipRectModifierSpecAttribute? other) {
    if (other == null) return this;

    return ClipRectModifierSpecAttribute(
      clipper: other.clipper ?? clipper,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('clipper', clipper, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipRectModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipRectModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [clipper, clipBehavior];
}

/// A tween that interpolates between two [ClipRectModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ClipRectModifierSpec] specifications.
class ClipRectModifierSpecTween extends Tween<ClipRectModifierSpec?> {
  ClipRectModifierSpecTween({super.begin, super.end});

  @override
  ClipRectModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ClipRectModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

final class ClipRRectModifierSpec extends ModifierSpec<ClipRRectModifierSpec>
    with Diagnosticable {
  final BorderRadiusGeometry? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip? clipBehavior;

  const ClipRRectModifierSpec({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });

  /// Creates a copy of this [ClipRRectModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  ClipRRectModifierSpec copyWith({
    BorderRadiusGeometry? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRRectModifierSpec(
      borderRadius: borderRadius ?? this.borderRadius,
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipRRectModifierSpec] and another [ClipRRectModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipRRectModifierSpec] is returned. When [t] is 1.0, the [other] [ClipRRectModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipRRectModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipRRectModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ClipRRectModifierSpec] using the appropriate
  /// interpolation method:
  /// - [BorderRadiusGeometry.lerp] for [borderRadius].
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipRRectModifierSpec] is used. Otherwise, the value
  /// from the [other] [ClipRRectModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipRRectModifierSpec] configurations.
  @override
  ClipRRectModifierSpec lerp(ClipRRectModifierSpec? other, double t) {
    if (other == null) return this;

    return ClipRRectModifierSpec(
      borderRadius: BorderRadiusGeometry.lerp(
        borderRadius,
        other.borderRadius,
        t,
      ),
      clipper: t < 0.5 ? clipper : other.clipper,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('borderRadius', borderRadius, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('clipper', clipper, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipRRectModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipRRectModifierSpec] instances for equality.
  @override
  List<Object?> get props => [borderRadius, clipper, clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      clipper: clipper,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );
  }
}

/// Represents the attributes of a [ClipRRectModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipRRectModifierSpec].
///
/// Use this class to configure the attributes of a [ClipRRectModifierSpec] and pass it to
/// the [ClipRRectModifierSpec] constructor.
class ClipRRectModifierSpecAttribute
    extends ModifierSpecAttribute<ClipRRectModifierSpec>
    with Diagnosticable {
  final BorderRadiusGeometryDto? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip? clipBehavior;

  const ClipRRectModifierSpecAttribute({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });

  /// Resolves to [ClipRRectModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipRRectModifierSpec = ClipRRectModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ClipRRectModifierSpec resolve(BuildContext context) {
    return ClipRRectModifierSpec(
      borderRadius: borderRadius?.resolve(context),
      clipper: clipper,
      clipBehavior: clipBehavior,
    );
  }

  /// Merges the properties of this [ClipRRectModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipRRectModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipRRectModifierSpecAttribute merge(ClipRRectModifierSpecAttribute? other) {
    if (other == null) return this;

    return ClipRRectModifierSpecAttribute(
      borderRadius:
          borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      clipper: other.clipper ?? clipper,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('borderRadius', borderRadius, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('clipper', clipper, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipRRectModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipRRectModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [borderRadius, clipper, clipBehavior];
}

/// A tween that interpolates between two [ClipRRectModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ClipRRectModifierSpec] specifications.
class ClipRRectModifierSpecTween extends Tween<ClipRRectModifierSpec?> {
  ClipRRectModifierSpecTween({super.begin, super.end});

  @override
  ClipRRectModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ClipRRectModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

final class ClipPathModifierSpec extends ModifierSpec<ClipPathModifierSpec>
    with Diagnosticable {
  final CustomClipper<Path>? clipper;
  final Clip? clipBehavior;

  const ClipPathModifierSpec({this.clipper, this.clipBehavior});

  /// Creates a copy of this [ClipPathModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  ClipPathModifierSpec copyWith({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipPathModifierSpec(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipPathModifierSpec] and another [ClipPathModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipPathModifierSpec] is returned. When [t] is 1.0, the [other] [ClipPathModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipPathModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipPathModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ClipPathModifierSpec] using the appropriate
  /// interpolation method:
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipPathModifierSpec] is used. Otherwise, the value
  /// from the [other] [ClipPathModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipPathModifierSpec] configurations.
  @override
  ClipPathModifierSpec lerp(ClipPathModifierSpec? other, double t) {
    if (other == null) return this;

    return ClipPathModifierSpec(
      clipper: t < 0.5 ? clipper : other.clipper,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('clipper', clipper, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipPathModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipPathModifierSpec] instances for equality.
  @override
  List<Object?> get props => [clipper, clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipPath(
      clipper: clipper,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );
  }
}

/// Represents the attributes of a [ClipPathModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipPathModifierSpec].
///
/// Use this class to configure the attributes of a [ClipPathModifierSpec] and pass it to
/// the [ClipPathModifierSpec] constructor.
class ClipPathModifierSpecAttribute
    extends ModifierSpecAttribute<ClipPathModifierSpec>
    with Diagnosticable {
  final CustomClipper<Path>? clipper;
  final Clip? clipBehavior;

  const ClipPathModifierSpecAttribute({this.clipper, this.clipBehavior});

  /// Resolves to [ClipPathModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipPathModifierSpec = ClipPathModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ClipPathModifierSpec resolve(BuildContext context) {
    return ClipPathModifierSpec(clipper: clipper, clipBehavior: clipBehavior);
  }

  /// Merges the properties of this [ClipPathModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipPathModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipPathModifierSpecAttribute merge(ClipPathModifierSpecAttribute? other) {
    if (other == null) return this;

    return ClipPathModifierSpecAttribute(
      clipper: other.clipper ?? clipper,
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('clipper', clipper, defaultValue: null));
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipPathModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipPathModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [clipper, clipBehavior];
}

/// A tween that interpolates between two [ClipPathModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ClipPathModifierSpec] specifications.
class ClipPathModifierSpecTween extends Tween<ClipPathModifierSpec?> {
  ClipPathModifierSpecTween({super.begin, super.end});

  @override
  ClipPathModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ClipPathModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

final class ClipTriangleModifierSpec
    extends ModifierSpec<ClipTriangleModifierSpec>
    with Diagnosticable {
  final Clip? clipBehavior;

  const ClipTriangleModifierSpec({this.clipBehavior});

  /// Creates a copy of this [ClipTriangleModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  ClipTriangleModifierSpec copyWith({Clip? clipBehavior}) {
    return ClipTriangleModifierSpec(
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipTriangleModifierSpec] and another [ClipTriangleModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipTriangleModifierSpec] is returned. When [t] is 1.0, the [other] [ClipTriangleModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipTriangleModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipTriangleModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ClipTriangleModifierSpec] using the appropriate
  /// interpolation method:
  /// For [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipTriangleModifierSpec] is used. Otherwise, the value
  /// from the [other] [ClipTriangleModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipTriangleModifierSpec] configurations.
  @override
  ClipTriangleModifierSpec lerp(ClipTriangleModifierSpec? other, double t) {
    if (other == null) return this;

    return ClipTriangleModifierSpec(
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipTriangleModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipTriangleModifierSpec] instances for equality.
  @override
  List<Object?> get props => [clipBehavior];

  @override
  Widget build(Widget child) {
    return ClipPath(
      clipper: const TriangleClipper(),
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );
  }
}

/// Represents the attributes of a [ClipTriangleModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipTriangleModifierSpec].
///
/// Use this class to configure the attributes of a [ClipTriangleModifierSpec] and pass it to
/// the [ClipTriangleModifierSpec] constructor.
class ClipTriangleModifierSpecAttribute
    extends ModifierSpecAttribute<ClipTriangleModifierSpec>
    with Diagnosticable {
  final Clip? clipBehavior;

  const ClipTriangleModifierSpecAttribute({this.clipBehavior});

  /// Resolves to [ClipTriangleModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipTriangleModifierSpec = ClipTriangleModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ClipTriangleModifierSpec resolve(BuildContext context) {
    return ClipTriangleModifierSpec(clipBehavior: clipBehavior);
  }

  /// Merges the properties of this [ClipTriangleModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipTriangleModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipTriangleModifierSpecAttribute merge(
    ClipTriangleModifierSpecAttribute? other,
  ) {
    if (other == null) return this;

    return ClipTriangleModifierSpecAttribute(
      clipBehavior: other.clipBehavior ?? clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipTriangleModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipTriangleModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [clipBehavior];
}

/// A tween that interpolates between two [ClipTriangleModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ClipTriangleModifierSpec] specifications.
class ClipTriangleModifierSpecTween extends Tween<ClipTriangleModifierSpec?> {
  ClipTriangleModifierSpecTween({super.begin, super.end});

  @override
  ClipTriangleModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ClipTriangleModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

class TriangleClipper extends CustomClipper<Path> {
  const TriangleClipper();
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

final class ClipPathModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, ClipPathModifierSpecAttribute> {
  const ClipPathModifierSpecUtility(super.builder);

  T call({CustomClipper<Path>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipPathModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }
}

final class ClipRRectModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, ClipRRectModifierSpecAttribute> {
  const ClipRRectModifierSpecUtility(super.builder);
  T call({
    BorderRadius? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return builder(
      ClipRRectModifierSpecAttribute(
        borderRadius: BorderRadiusGeometryDto.maybeValue(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }
}

final class ClipOvalModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, ClipOvalModifierSpecAttribute> {
  const ClipOvalModifierSpecUtility(super.builder);
  T call({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipOvalModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }
}

final class ClipRectModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, ClipRectModifierSpecAttribute> {
  const ClipRectModifierSpecUtility(super.builder);
  T call({CustomClipper<Rect>? clipper, Clip? clipBehavior}) {
    return builder(
      ClipRectModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      ),
    );
  }
}

final class ClipTriangleModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, ClipTriangleModifierSpecAttribute> {
  const ClipTriangleModifierSpecUtility(super.builder);
  T call({Clip? clipBehavior}) {
    return builder(
      ClipTriangleModifierSpecAttribute(clipBehavior: clipBehavior),
    );
  }
}
