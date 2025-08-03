import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../properties/painting/border_radius_mix.dart';

/// Decorator that clips its child to an oval shape.
///
/// Wraps the child in a [ClipOval] widget with the specified clipper and clip behavior.
final class ClipOvalWidgetDecorator extends WidgetDecorator<ClipOvalWidgetDecorator>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipOvalWidgetDecorator({this.clipper, this.clipBehavior});

  /// Returns a copy with the specified fields replaced.
  @override
  ClipOvalWidgetDecorator copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipOvalWidgetDecorator(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this and [other] using step interpolation.
  @override
  ClipOvalWidgetDecorator lerp(ClipOvalWidgetDecorator? other, double t) {
    if (other == null) return this;

    return ClipOvalWidgetDecorator(
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

  /// The list of properties that constitute the state of this [ClipOvalWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipOvalWidgetDecorator] instances for equality.
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

/// Attribute class for [ClipOvalWidgetDecorator] with resolvable properties.
class ClipOvalWidgetDecoratorStyle extends WidgetDecoratorStyle<ClipOvalWidgetDecorator> {
  final Prop<CustomClipper<Rect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipOvalWidgetDecoratorStyle.raw({this.clipper, this.clipBehavior});

  ClipOvalWidgetDecoratorStyle({CustomClipper<Rect>? clipper, Clip? clipBehavior})
    : this.raw(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipOvalWidgetDecorator] using the provided [BuildContext].
  @override
  ClipOvalWidgetDecorator resolve(BuildContext context) {
    return ClipOvalWidgetDecorator(
      clipper: MixHelpers.resolve(context, clipper),
      clipBehavior: MixHelpers.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipOvalWidgetDecoratorStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipOvalWidgetDecoratorStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipOvalWidgetDecoratorStyle merge(ClipOvalWidgetDecoratorStyle? other) {
    if (other == null) return this;

    return ClipOvalWidgetDecoratorStyle.raw(
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

/// Decorator that clips its child to a rectangular shape.
///
/// Wraps the child in a [ClipRect] widget with the specified clipper and clip behavior.
final class ClipRectWidgetDecorator extends WidgetDecorator<ClipRectWidgetDecorator>
    with Diagnosticable {
  final CustomClipper<Rect>? clipper;
  final Clip? clipBehavior;

  const ClipRectWidgetDecorator({this.clipper, this.clipBehavior});

  /// Returns a copy with the specified fields replaced.
  @override
  ClipRectWidgetDecorator copyWith({
    CustomClipper<Rect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRectWidgetDecorator(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this and [other] using step interpolation.
  @override
  ClipRectWidgetDecorator lerp(ClipRectWidgetDecorator? other, double t) {
    if (other == null) return this;

    return ClipRectWidgetDecorator(
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

/// Attribute class for [ClipRectWidgetDecorator] with resolvable properties.
class ClipRectWidgetDecoratorStyle extends WidgetDecoratorStyle<ClipRectWidgetDecorator> {
  final Prop<CustomClipper<Rect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipRectWidgetDecoratorStyle.raw({this.clipper, this.clipBehavior});

  ClipRectWidgetDecoratorStyle({CustomClipper<Rect>? clipper, Clip? clipBehavior})
    : this.raw(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipRectWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipRectModifier = ClipRectWidgetDecoratorStyle(...).resolve(mix);
  /// ```
  @override
  ClipRectWidgetDecorator resolve(BuildContext context) {
    return ClipRectWidgetDecorator(
      clipper: MixHelpers.resolve(context, clipper),
      clipBehavior: MixHelpers.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipRectWidgetDecoratorStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipRectWidgetDecoratorStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipRectWidgetDecoratorStyle merge(ClipRectWidgetDecoratorStyle? other) {
    if (other == null) return this;

    return ClipRectWidgetDecoratorStyle.raw(
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

final class ClipRRectWidgetDecorator extends WidgetDecorator<ClipRRectWidgetDecorator>
    with Diagnosticable {
  final BorderRadiusGeometry? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip? clipBehavior;

  const ClipRRectWidgetDecorator({this.borderRadius, this.clipper, this.clipBehavior});

  /// Creates a copy of this [ClipRRectWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  ClipRRectWidgetDecorator copyWith({
    BorderRadiusGeometry? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipRRectWidgetDecorator(
      borderRadius: borderRadius ?? this.borderRadius,
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipRRectWidgetDecorator] and another [ClipRRectWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipRRectWidgetDecorator] is returned. When [t] is 1.0, the [other] [ClipRRectWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipRRectWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipRRectWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [ClipRRectWidgetDecorator] using the appropriate
  /// interpolation method:
  /// - [BorderRadiusGeometry.lerp] for [borderRadius].
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipRRectWidgetDecorator] is used. Otherwise, the value
  /// from the [other] [ClipRRectWidgetDecorator] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipRRectWidgetDecorator] configurations.
  @override
  ClipRRectWidgetDecorator lerp(ClipRRectWidgetDecorator? other, double t) {
    if (other == null) return this;

    return ClipRRectWidgetDecorator(
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

  /// The list of properties that constitute the state of this [ClipRRectWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipRRectWidgetDecorator] instances for equality.
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

/// Represents the attributes of a [ClipRRectWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipRRectWidgetDecorator].
///
/// Use this class to configure the attributes of a [ClipRRectWidgetDecorator] and pass it to
/// the [ClipRRectWidgetDecorator] constructor.
class ClipRRectWidgetDecoratorStyle
    extends WidgetDecoratorStyle<ClipRRectWidgetDecorator> {
  final MixProp<BorderRadiusGeometry>? borderRadius;
  final Prop<CustomClipper<RRect>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipRRectWidgetDecoratorStyle.raw({
    this.borderRadius,
    this.clipper,
    this.clipBehavior,
  });

  ClipRRectWidgetDecoratorStyle({
    BorderRadiusGeometryMix? borderRadius,
    CustomClipper<RRect>? clipper,
    Clip? clipBehavior,
  }) : this.raw(
         borderRadius: MixProp.maybe(borderRadius),
         clipper: Prop.maybe(clipper),
         clipBehavior: Prop.maybe(clipBehavior),
       );

  /// Resolves to [ClipRRectWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipRRectDecorator = ClipRRectWidgetDecoratorStyle(...).resolve(mix);
  /// ```
  @override
  ClipRRectWidgetDecorator resolve(BuildContext context) {
    return ClipRRectWidgetDecorator(
      borderRadius: MixHelpers.resolve(context, borderRadius),
      clipper: MixHelpers.resolve(context, clipper),
      clipBehavior: MixHelpers.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipRRectWidgetDecoratorStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipRRectWidgetDecoratorStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipRRectWidgetDecoratorStyle merge(ClipRRectWidgetDecoratorStyle? other) {
    if (other == null) return this;

    return ClipRRectWidgetDecoratorStyle.raw(
      borderRadius: borderRadius.tryMerge(other.borderRadius),
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [borderRadius, clipper, clipBehavior];
}

final class ClipPathWidgetDecorator extends WidgetDecorator<ClipPathWidgetDecorator>
    with Diagnosticable {
  final CustomClipper<Path>? clipper;
  final Clip? clipBehavior;

  const ClipPathWidgetDecorator({this.clipper, this.clipBehavior});

  /// Creates a copy of this [ClipPathWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  ClipPathWidgetDecorator copyWith({
    CustomClipper<Path>? clipper,
    Clip? clipBehavior,
  }) {
    return ClipPathWidgetDecorator(
      clipper: clipper ?? this.clipper,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipPathWidgetDecorator] and another [ClipPathWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipPathWidgetDecorator] is returned. When [t] is 1.0, the [other] [ClipPathWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipPathWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipPathWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [ClipPathWidgetDecorator] using the appropriate
  /// interpolation method:
  /// For [clipper] and [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipPathWidgetDecorator] is used. Otherwise, the value
  /// from the [other] [ClipPathWidgetDecorator] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipPathWidgetDecorator] configurations.
  @override
  ClipPathWidgetDecorator lerp(ClipPathWidgetDecorator? other, double t) {
    if (other == null) return this;

    return ClipPathWidgetDecorator(
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

  /// The list of properties that constitute the state of this [ClipPathWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipPathWidgetDecorator] instances for equality.
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

/// Represents the attributes of a [ClipPathWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipPathWidgetDecorator].
///
/// Use this class to configure the attributes of a [ClipPathWidgetDecorator] and pass it to
/// the [ClipPathWidgetDecorator] constructor.
class ClipPathWidgetDecoratorStyle extends WidgetDecoratorStyle<ClipPathWidgetDecorator> {
  final Prop<CustomClipper<Path>>? clipper;
  final Prop<Clip>? clipBehavior;

  const ClipPathWidgetDecoratorStyle.raw({this.clipper, this.clipBehavior});

  ClipPathWidgetDecoratorStyle({CustomClipper<Path>? clipper, Clip? clipBehavior})
    : this.raw(
        clipper: Prop.maybe(clipper),
        clipBehavior: Prop.maybe(clipBehavior),
      );

  /// Resolves to [ClipPathWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipPathDecorator = ClipPathWidgetDecoratorStyle(...).resolve(mix);
  /// ```
  @override
  ClipPathWidgetDecorator resolve(BuildContext context) {
    return ClipPathWidgetDecorator(
      clipper: MixHelpers.resolve(context, clipper),
      clipBehavior: MixHelpers.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipPathWidgetDecoratorStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipPathWidgetDecoratorStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipPathWidgetDecoratorStyle merge(ClipPathWidgetDecoratorStyle? other) {
    if (other == null) return this;

    return ClipPathWidgetDecoratorStyle.raw(
      clipper: clipper.tryMerge(other.clipper),
      clipBehavior: clipBehavior.tryMerge(other.clipBehavior),
    );
  }

  @override
  List<Object?> get props => [clipper, clipBehavior];
}

final class ClipTriangleWidgetDecorator extends WidgetDecorator<ClipTriangleWidgetDecorator>
    with Diagnosticable {
  final Clip? clipBehavior;

  const ClipTriangleWidgetDecorator({this.clipBehavior});

  /// Creates a copy of this [ClipTriangleWidgetDecorator] but with the given fields
  /// replaced with the new values.
  @override
  ClipTriangleWidgetDecorator copyWith({Clip? clipBehavior}) {
    return ClipTriangleWidgetDecorator(
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [ClipTriangleWidgetDecorator] and another [ClipTriangleWidgetDecorator] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ClipTriangleWidgetDecorator] is returned. When [t] is 1.0, the [other] [ClipTriangleWidgetDecorator] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ClipTriangleWidgetDecorator] is returned.
  ///
  /// If [other] is null, this method returns the current [ClipTriangleWidgetDecorator] instance.
  ///
  /// The interpolation is performed on each property of the [ClipTriangleWidgetDecorator] using the appropriate
  /// interpolation method:
  /// For [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ClipTriangleWidgetDecorator] is used. Otherwise, the value
  /// from the [other] [ClipTriangleWidgetDecorator] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ClipTriangleWidgetDecorator] configurations.
  @override
  ClipTriangleWidgetDecorator lerp(ClipTriangleWidgetDecorator? other, double t) {
    if (other == null) return this;

    return ClipTriangleWidgetDecorator(
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

  /// The list of properties that constitute the state of this [ClipTriangleWidgetDecorator].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ClipTriangleWidgetDecorator] instances for equality.
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

/// Represents the attributes of a [ClipTriangleWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ClipTriangleWidgetDecorator].
///
/// Use this class to configure the attributes of a [ClipTriangleWidgetDecorator] and pass it to
/// the [ClipTriangleWidgetDecorator] constructor.
class ClipTriangleWidgetDecoratorStyle
    extends WidgetDecoratorStyle<ClipTriangleWidgetDecorator> {
  final Prop<Clip>? clipBehavior;

  const ClipTriangleWidgetDecoratorStyle.raw({this.clipBehavior});

  ClipTriangleWidgetDecoratorStyle({Clip? clipBehavior})
    : this.raw(clipBehavior: Prop.maybe(clipBehavior));

  /// Resolves to [ClipTriangleWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final clipTriangleDecorator = ClipTriangleWidgetDecoratorStyle(...).resolve(mix);
  /// ```
  @override
  ClipTriangleWidgetDecorator resolve(BuildContext context) {
    return ClipTriangleWidgetDecorator(
      clipBehavior: MixHelpers.resolve(context, clipBehavior),
    );
  }

  /// Merges the properties of this [ClipTriangleWidgetDecoratorStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ClipTriangleWidgetDecoratorStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ClipTriangleWidgetDecoratorStyle merge(ClipTriangleWidgetDecoratorStyle? other) {
    if (other == null) return this;

    return ClipTriangleWidgetDecoratorStyle.raw(
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
