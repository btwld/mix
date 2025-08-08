import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../properties/painting/border_radius_mix.dart';

/// Modifier that clips its child to an oval shape.
///
/// Wraps the child in a [ClipOval] widget with the specified clipper and clip behavior.
final class ClipOvalModifier extends Modifier<ClipOvalModifier>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipOvalModifier({this.clipper, this.clipBehavior});

  /// Returns a copy with the specified fields replaced.
  @override
  ClipOvalModifier copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipOvalModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this and [other] using step interpolation.
  @override
  ClipOvalModifier lerp(ClipOvalModifier? other, double t) {
    if (other == null) return this;

    return ClipOvalModifier(
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

  /// The list of properties that constitute the state of this [ClipOvalModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipOvalModifier] instances for equality.
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

/// Attribute class for [ClipOvalModifier] with resolvable properties.
class ClipOvalModifierMix
    extends ModifierMix<ClipOvalModifier> {
  final Prop<CustomClipper<Rect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipOvalModifierMix.create({this.clipper, this.clipBehavior});

  ClipOvalModifierMix({CustomClipper<Rect>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipOvalModifier] using the provided [BuildContext].
  @override
  ClipOvalModifier resolve(BuildContext context) {
    return ClipOvalModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipOvalModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipOvalModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipOvalModifierMix merge(ClipOvalModifierMix? other) {
    if (other == null) return this;

    return ClipOvalModifierMix.create(
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
final class ClipRectModifier extends Modifier<ClipRectModifier>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipRectModifier({this.clipper, this.clipBehavior});

  /// Returns a copy with the specified fields replaced.
  @override
  ClipRectModifier copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRectModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this and [other] using step interpolation.
  @override
  ClipRectModifier lerp(ClipRectModifier? other, double t) {
    if (other == null) return this;

    return ClipRectModifier(
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

/// Attribute class for [ClipRectModifier] with resolvable properties.
class ClipRectModifierMix
    extends ModifierMix<ClipRectModifier> {
  final Prop<CustomClipper<Rect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipRectModifierMix.create({this.clipper, this.clipBehavior});

  ClipRectModifierMix({CustomClipper<Rect>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipRectModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipRectModifier = ClipRectModifierMix(...).resolve(mix);
  /// ```
  @override
  ClipRectModifier resolve(BuildContext context) {
    return ClipRectModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipRectModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipRectModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipRectModifierMix merge(ClipRectModifierMix? other) {
    if (other == null) return this;

    return ClipRectModifierMix.create(
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

final class ClipRRectModifier extends Modifier<ClipRRectModifier>
    with Diagnosticable {
  final BorderRadiusGeometry? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip? clipBehavior;

  const ClipRRectModifier({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });

  /// Creates a copy of this [ClipRRectModifier] but with the given fields
  /// replaced with the new values.
  @override
  ClipRRectModifier copyWith({
    BorderRadiusGeometry? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRRectModifier(
      borderRadius: borderRadius ?? this.borderRadius,
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipRRectModifier] and another [ClipRRectModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipRRectModifier] is returned. When [t] is 1.0, the [other] [ClipRRectModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipRRectModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipRRectModifier] instance.
  ///
  /// The interpolation is performed on each property of the [ClipRRectModifier] using the appropriate
  /// interpolation method:
  /// - [BorderRadiusGeometry.lerp] for [borderRadius].
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipRRectModifier] is used. Otherwise, the value
  /// from the [other] [ClipRRectModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipRRectModifier] configurations.
  @override
  ClipRRectModifier lerp(ClipRRectModifier? other, double t) {
    if (other == null) return this;

    return ClipRRectModifier(
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

  /// The list of properties that constitute the state of this [ClipRRectModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipRRectModifier] instances for equality.
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

/// Represents the attributes of a [ClipRRectModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipRRectModifier].
///
/// Use this class to configure the attributes of a [ClipRRectModifier] and pass it to
/// the [ClipRRectModifier] constructor.
class ClipRRectModifierMix
    extends ModifierMix<ClipRRectModifier> {
  final MixProp<BorderRadiusGeometry>? borderRadius;
  final Prop<CustomClipper<RRect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipRRectModifierMix.create({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });

  ClipRRectModifierMix({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) : this.create(
         borderRadius: MixProp.maybe(borderRadius),
         clipper: Prop.maybe(clipper),
         clipBehavior: Prop.maybe(clipBehavior),
       );

  /// Resolves to [ClipRRectModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipRRectModifier = ClipRRectModifierMix(...).resolve(mix);
  /// ```
  @override
  ClipRRectModifier resolve(BuildContext context) {
    return ClipRRectModifier(
      borderRadius: MixOps.resolve(context, borderRadius),
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipRRectModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipRRectModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipRRectModifierMix merge(ClipRRectModifierMix? other) {
    if (other == null) return this;

    return ClipRRectModifierMix.create(
      borderRadius: borderRadius.tryMerge(other.borderRadius),
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [borderRadius, clipper, clipBehavior];
}

final class ClipPathModifier extends Modifier<ClipPathModifier>
    with Diagnosticable {
  final CustomClipper<Path>? clipper;
  final Clip? clipBehavior;

  const ClipPathModifier({this.clipper, this.clipBehavior});

  /// Creates a copy of this [ClipPathModifier] but with the given fields
  /// replaced with the new values.
  @override
  ClipPathModifier copyWith({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipPathModifier(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipPathModifier] and another [ClipPathModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipPathModifier] is returned. When [t] is 1.0, the [other] [ClipPathModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipPathModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipPathModifier] instance.
  ///
  /// The interpolation is performed on each property of the [ClipPathModifier] using the appropriate
  /// interpolation method:
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipPathModifier] is used. Otherwise, the value
  /// from the [other] [ClipPathModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipPathModifier] configurations.
  @override
  ClipPathModifier lerp(ClipPathModifier? other, double t) {
    if (other == null) return this;

    return ClipPathModifier(
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

  /// The list of properties that constitute the state of this [ClipPathModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipPathModifier] instances for equality.
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

/// Represents the attributes of a [ClipPathModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipPathModifier].
///
/// Use this class to configure the attributes of a [ClipPathModifier] and pass it to
/// the [ClipPathModifier] constructor.
class ClipPathModifierMix
    extends ModifierMix<ClipPathModifier> {
  final Prop<CustomClipper<Path>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipPathModifierMix.create({this.clipper, this.clipBehavior});

  ClipPathModifierMix({CustomClipper<Path>? clipper, Clip? clipBehavior})
    : this.create(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipPathModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipPathModifier = ClipPathModifierMix(...).resolve(mix);
  /// ```
  @override
  ClipPathModifier resolve(BuildContext context) {
    return ClipPathModifier(
      clipper: MixOps.resolve(context, clipper),
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipPathModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipPathModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipPathModifierMix merge(ClipPathModifierMix? other) {
    if (other == null) return this;

    return ClipPathModifierMix.create(
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

final class ClipTriangleModifier
    extends Modifier<ClipTriangleModifier>
    with Diagnosticable {
  final Clip? clipBehavior;

  const ClipTriangleModifier({this.clipBehavior});

  /// Creates a copy of this [ClipTriangleModifier] but with the given fields
  /// replaced with the new values.
  @override
  ClipTriangleModifier copyWith({Clip? clipBehavior}) {
    return ClipTriangleModifier(
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipTriangleModifier] and another [ClipTriangleModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipTriangleModifier] is returned. When [t] is 1.0, the [other] [ClipTriangleModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipTriangleModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipTriangleModifier] instance.
  ///
  /// The interpolation is performed on each property of the [ClipTriangleModifier] using the appropriate
  /// interpolation method:
  /// For [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipTriangleModifier] is used. Otherwise, the value
  /// from the [other] [ClipTriangleModifier] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipTriangleModifier] configurations.
  @override
  ClipTriangleModifier lerp(ClipTriangleModifier? other, double t) {
    if (other == null) return this;

    return ClipTriangleModifier(
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

  /// The list of properties that constitute the state of this [ClipTriangleModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipTriangleModifier] instances for equality.
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

/// Represents the attributes of a [ClipTriangleModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipTriangleModifier].
///
/// Use this class to configure the attributes of a [ClipTriangleModifier] and pass it to
/// the [ClipTriangleModifier] constructor.
class ClipTriangleModifierMix
    extends ModifierMix<ClipTriangleModifier> {
  final Prop<Clip>? clipBehavior;

  const ClipTriangleModifierMix.create({this.clipBehavior});

  ClipTriangleModifierMix({Clip? clipBehavior})
    : this.create(clipBehavior: Prop.maybe(clipBehavior));

  /// Resolves to [ClipTriangleModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipTriangleModifier = ClipTriangleModifierMix(...).resolve(mix);
  /// ```
  @override
  ClipTriangleModifier resolve(BuildContext context) {
    return ClipTriangleModifier(
      clipBehavior: MixOps.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipTriangleModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipTriangleModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipTriangleModifierMix merge(ClipTriangleModifierMix? other) {
    if (other == null) return this;

    return ClipTriangleModifierMix.create(
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
