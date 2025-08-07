import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/widget_modifier.dart';
import '../properties/painting/border_radius_mix.dart';

/// Modifier that clips its child to an oval shape.
///
/// Wraps the child in a [ClipOval] widget with the specified clipper and clip behavior.
final class ClipOvalWidgetModifier
    extends WidgetModifier<ClipOvalWidgetModifier>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipOvalWidgetModifier({this.clipper, this.clipBehavior});

  /// Returns a copy with the specified fields replaced.
  @override
  ClipOvalWidgetModifier copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipOvalWidgetModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this and [other] using step interpolation.
  @override
  ClipOvalWidgetModifier lerp(ClipOvalWidgetModifier? other, double t) {
    if (other == null) return this;

    return ClipOvalWidgetModifier(
      clipper: MixOps.lerpSnap(clipper, other.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t),
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

  /// The list of properties that constitute the state of this [ClipOvalWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipOvalWidgetModifier] instances for equality.
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

/// Attribute class for [ClipOvalWidgetModifier] with resolvable properties.
class ClipOvalWidgetModifierMix
    extends WidgetModifierMix<ClipOvalWidgetModifier> {
  final Prop<CustomClipper<Rect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipOvalWidgetModifierMix.create({this.clipper, this.clipBehavior});

  ClipOvalWidgetModifierMix({CustomClipper<Rect>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipOvalWidgetModifier] using the provided [BuildContext].
  @override
  ClipOvalWidgetModifier resolve(BuildContext context) {
    return ClipOvalWidgetModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipOvalWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipOvalWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipOvalWidgetModifierMix merge(ClipOvalWidgetModifierMix? other) {
    if (other == null) return this;

    return ClipOvalWidgetModifierMix.create(
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

/// Modifier that clips its child to a rectangular shape.
///
/// Wraps the child in a [ClipRect] widget with the specified clipper and clip behavior.
final class ClipRectWidgetModifier
    extends WidgetModifier<ClipRectWidgetModifier>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipRectWidgetModifier({this.clipper, this.clipBehavior});

  /// Returns a copy with the specified fields replaced.
  @override
  ClipRectWidgetModifier copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRectWidgetModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this and [other] using step interpolation.
  @override
  ClipRectWidgetModifier lerp(ClipRectWidgetModifier? other, double t) {
    if (other == null) return this;

    return ClipRectWidgetModifier(
      clipper: MixOps.lerpSnap(clipper, other.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t),
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

  /// Properties used for equality comparison.
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

/// Attribute class for [ClipRectWidgetModifier] with resolvable properties.
class ClipRectWidgetModifierMix
    extends WidgetModifierMix<ClipRectWidgetModifier> {
  final Prop<CustomClipper<Rect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipRectWidgetModifierMix.create({this.clipper, this.clipBehavior});

  ClipRectWidgetModifierMix({CustomClipper<Rect>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipRectWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipRectWidgetModifier = ClipRectWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  ClipRectWidgetModifier resolve(BuildContext context) {
    return ClipRectWidgetModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipRectWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipRectWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipRectWidgetModifierMix merge(ClipRectWidgetModifierMix? other) {
    if (other == null) return this;

    return ClipRectWidgetModifierMix.create(
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

final class ClipRRectWidgetModifier
    extends WidgetModifier<ClipRRectWidgetModifier>
    with Diagnosticable {
  final BorderRadiusGeometry? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip? clipBehavior;

  const ClipRRectWidgetModifier({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });

  /// Creates a copy of this [ClipRRectWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  ClipRRectWidgetModifier copyWith({
    BorderRadiusGeometry? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRRectWidgetModifier(
      borderRadius: borderRadius ?? this.borderRadius,
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipRRectWidgetModifier] and another [ClipRRectWidgetModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipRRectWidgetModifier] is returned. When [t] is 1.0, the [other] [ClipRRectWidgetModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipRRectWidgetModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipRRectWidgetModifier] instance.
  ///
  /// The interpolation is performed on each property of the [ClipRRectWidgetModifier] using the appropriate
  /// interpolation method:
  /// - [BorderRadiusGeometry.lerp] for [borderRadius].
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipRRectWidgetModifier] is used. Otherwise, the value
  /// from the [other] [ClipRRectWidgetModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipRRectWidgetModifier] configurations.
  @override
  ClipRRectWidgetModifier lerp(ClipRRectWidgetModifier? other, double t) {
    if (other == null) return this;

    return ClipRRectWidgetModifier(
      borderRadius: MixOps.lerp(borderRadius, other.borderRadius, t),
      clipper: MixOps.lerpSnap(clipper, other.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t),
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

  /// The list of properties that constitute the state of this [ClipRRectWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipRRectWidgetModifier] instances for equality.
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

/// Represents the attributes of a [ClipRRectWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipRRectWidgetModifier].
///
/// Use this class to configure the attributes of a [ClipRRectWidgetModifier] and pass it to
/// the [ClipRRectWidgetModifier] constructor.
class ClipRRectWidgetModifierMix
    extends WidgetModifierMix<ClipRRectWidgetModifier> {
  final MixProp<BorderRadiusGeometry>? borderRadius;
  final Prop<CustomClipper<RRect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipRRectWidgetModifierMix.create({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });

  ClipRRectWidgetModifierMix({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) : this.create(
         borderRadius: MixProp.maybe(borderRadius),
         clipper: Prop.maybe(clipper),
         clipBehavior: Prop.maybe(clipBehavior),
       );

  /// Resolves to [ClipRRectWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipRRectWidgetModifier = ClipRRectWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  ClipRRectWidgetModifier resolve(BuildContext context) {
    return ClipRRectWidgetModifier(
      borderRadius: MixOps.resolve(context, borderRadius),
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipRRectWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipRRectWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipRRectWidgetModifierMix merge(ClipRRectWidgetModifierMix? other) {
    if (other == null) return this;

    return ClipRRectWidgetModifierMix.create(
      borderRadius: borderRadius.tryMerge(other.borderRadius),
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [borderRadius, clipper, clipBehavior];
}

final class ClipPathWidgetModifier
    extends WidgetModifier<ClipPathWidgetModifier>
    with Diagnosticable {
  final CustomClipper<Path>? clipper;
  final Clip? clipBehavior;

  const ClipPathWidgetModifier({this.clipper, this.clipBehavior});

  /// Creates a copy of this [ClipPathWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  ClipPathWidgetModifier copyWith({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipPathWidgetModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipPathWidgetModifier] and another [ClipPathWidgetModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipPathWidgetModifier] is returned. When [t] is 1.0, the [other] [ClipPathWidgetModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipPathWidgetModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipPathWidgetModifier] instance.
  ///
  /// The interpolation is performed on each property of the [ClipPathWidgetModifier] using the appropriate
  /// interpolation method:
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipPathWidgetModifier] is used. Otherwise, the value
  /// from the [other] [ClipPathWidgetModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipPathWidgetModifier] configurations.
  @override
  ClipPathWidgetModifier lerp(ClipPathWidgetModifier? other, double t) {
    if (other == null) return this;

    return ClipPathWidgetModifier(
      clipper: MixOps.lerpSnap(clipper, other.clipper, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t),
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

  /// The list of properties that constitute the state of this [ClipPathWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipPathWidgetModifier] instances for equality.
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

/// Represents the attributes of a [ClipPathWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipPathWidgetModifier].
///
/// Use this class to configure the attributes of a [ClipPathWidgetModifier] and pass it to
/// the [ClipPathWidgetModifier] constructor.
class ClipPathWidgetModifierMix
    extends WidgetModifierMix<ClipPathWidgetModifier> {
  final Prop<CustomClipper<Path>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipPathWidgetModifierMix.create({this.clipper, this.clipBehavior});

  ClipPathWidgetModifierMix({CustomClipper<Path>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipPathWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipPathWidgetModifier = ClipPathWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  ClipPathWidgetModifier resolve(BuildContext context) {
    return ClipPathWidgetModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipPathWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipPathWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipPathWidgetModifierMix merge(ClipPathWidgetModifierMix? other) {
    if (other == null) return this;

    return ClipPathWidgetModifierMix.create(
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

final class ClipTriangleWidgetModifier
    extends WidgetModifier<ClipTriangleWidgetModifier>
    with Diagnosticable {
  final Clip? clipBehavior;

  const ClipTriangleWidgetModifier({this.clipBehavior});

  /// Creates a copy of this [ClipTriangleWidgetModifier] but with the given fields
  /// replaced with the new values.
  @override
  ClipTriangleWidgetModifier copyWith({Clip? clipBehavior}) {
    return ClipTriangleWidgetModifier(
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipTriangleWidgetModifier] and another [ClipTriangleWidgetModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipTriangleWidgetModifier] is returned. When [t] is 1.0, the [other] [ClipTriangleWidgetModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipTriangleWidgetModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipTriangleWidgetModifier] instance.
  ///
  /// The interpolation is performed on each property of the [ClipTriangleWidgetModifier] using the appropriate
  /// interpolation method:
  /// For [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipTriangleWidgetModifier] is used. Otherwise, the value
  /// from the [other] [ClipTriangleWidgetModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipTriangleWidgetModifier] configurations.
  @override
  ClipTriangleWidgetModifier lerp(
    ClipTriangleWidgetModifier? other,
    double t,
  ) {
    if (other == null) return this;

    return ClipTriangleWidgetModifier(
      clipBehavior: MixOps.lerpSnap(clipBehavior, other.clipBehavior, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// The list of properties that constitute the state of this [ClipTriangleWidgetModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipTriangleWidgetModifier] instances for equality.
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

/// Represents the attributes of a [ClipTriangleWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipTriangleWidgetModifier].
///
/// Use this class to configure the attributes of a [ClipTriangleWidgetModifier] and pass it to
/// the [ClipTriangleWidgetModifier] constructor.
class ClipTriangleWidgetModifierMix
    extends WidgetModifierMix<ClipTriangleWidgetModifier> {
  final Prop<Clip>? clipBehavior;

  const ClipTriangleWidgetModifierMix.create({this.clipBehavior});

  ClipTriangleWidgetModifierMix({Clip? clipBehavior})
    : this.create(clipBehavior: Prop.maybe(clipBehavior));

  /// Resolves to [ClipTriangleWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipTriangleWidgetModifier = ClipTriangleWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  ClipTriangleWidgetModifier resolve(BuildContext context) {
    return ClipTriangleWidgetModifier(
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipTriangleWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipTriangleWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipTriangleWidgetModifierMix merge(ClipTriangleWidgetModifierMix? other) {
    if (other == null) return this;

    return ClipTriangleWidgetModifierMix.create(
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipBehavior];
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
