import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';

/// Modifier that constrains its child to a specific size.
///
/// Wraps the child in a [SizedBox] widget with the specified width and height.
final class SizedBoxModifier extends Modifier<SizedBoxModifier>
    with Diagnosticable {
  final double? width;
  final double? height;

  const SizedBoxModifier({this.width, this.height});

  @override
  SizedBoxModifier copyWith({double? width, double? height}) {
    return SizedBoxModifier(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  SizedBoxModifier lerp(SizedBoxModifier? other, double t) {
    if (other == null) return this;

    return SizedBoxModifier(
      width: MixOps.lerp(width, other.width, t),
      height: MixOps.lerp(height, other.height, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height));
  }

  @override
  List<Object?> get props => [width, height];

  @override
  Widget build(Widget child) {
    return SizedBox(width: width, height: height, child: child);
  }
}

/// Utility class for applying sized box modifications.
///
/// Provides convenient methods for creating SizedBoxModifierMix instances.
final class SizedBoxModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, SizedBoxModifierMix> {
  const SizedBoxModifierUtility(super.builder);

  T width(double v) => only(width: v);

  T height(double v) => only(height: v);

  /// Creates a square-sized box with the same width and height
  T square(double size) => only(width: size, height: size);

  T only({double? width, double? height}) =>
      builder(SizedBoxModifierMix(width: width, height: height));

  T call({double? width, double? height}) {
    return only(width: width, height: height);
  }

  /// Utility for defining [SizedBoxModifierMix.width] and [SizedBoxModifierMix.height]
  /// from [Size]
  T as(Size size) => call(width: size.width, height: size.height);
}

/// Mix class for applying sized box modifications.
///
/// This class allows for mixing and resolving sized box properties.
class SizedBoxModifierMix
    extends ModifierMix<SizedBoxModifier>
    with Diagnosticable {
  final Prop<double>? width;
  final Prop<double>? height;

  const SizedBoxModifierMix.create({this.width, this.height});

  SizedBoxModifierMix({double? width, double? height})
    : this.create(width: Prop.maybe(width), height: Prop.maybe(height));

  @override
  SizedBoxModifier resolve(BuildContext context) {
    return SizedBoxModifier(
      width: MixOps.resolve(context, width),
      height: MixOps.resolve(context, height),
    );
  }

  @override
  SizedBoxModifierMix merge(SizedBoxModifierMix? other) {
    if (other == null) return this;

    return SizedBoxModifierMix.create(
      width: MixOps.merge(width, other.width),
      height: MixOps.merge(height, other.height),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('width', width))
      ..add(DiagnosticsProperty('height', height));
  }

  @override
  List<Object?> get props => [width, height];
}
