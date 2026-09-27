import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../properties/painting/border_radius_mix.dart';
import 'decoration_style_mixin.dart';

/// Mixin that provides convenient border radius styling methods
mixin BorderRadiusStyleMixin<T extends Mix<Object?>>
    implements DecorationStyleMixin<T> {
  // Methods accepting Radius values (using existing factory constructors)

  /// Sets border radius for all corners.
  @Deprecated(
    'Use borderRadius(.all(radius)) instead. borderRadiusAll will be removed in Mix 3.0.',
  )
  T borderRadiusAll(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.all(radius));
  }

  /// Sets border radius for the top corners.
  @Deprecated(
    'Use borderRadius(.top(radius)) instead. borderRadiusTop will be removed in Mix 3.0.',
  )
  T borderRadiusTop(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.top(radius));
  }

  /// Sets border radius for the bottom corners.
  @Deprecated(
    'Use borderRadius(.bottom(radius)) instead. borderRadiusBottom will be removed in Mix 3.0.',
  )
  T borderRadiusBottom(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottom(radius));
  }

  /// Sets border radius for the left corners.
  @Deprecated(
    'Use borderRadius(.left(radius)) instead. borderRadiusLeft will be removed in Mix 3.0.',
  )
  T borderRadiusLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.left(radius));
  }

  /// Sets border radius for the right corners.
  @Deprecated(
    'Use borderRadius(.right(radius)) instead. borderRadiusRight will be removed in Mix 3.0.',
  )
  T borderRadiusRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.right(radius));
  }

  /// Sets border radius for the top left corner.
  @Deprecated(
    'Use borderRadius(.topLeft(radius)) instead. borderRadiusTopLeft will be removed in Mix 3.0.',
  )
  T borderRadiusTopLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(radius));
  }

  /// Sets border radius for the top right corner.
  @Deprecated(
    'Use borderRadius(.topRight(radius)) instead. borderRadiusTopRight will be removed in Mix 3.0.',
  )
  T borderRadiusTopRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(radius));
  }

  /// Sets border radius for the bottom left corner.
  @Deprecated(
    'Use borderRadius(.bottomLeft(radius)) instead. borderRadiusBottomLeft will be removed in Mix 3.0.',
  )
  T borderRadiusBottomLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(radius));
  }

  /// Sets border radius for the bottom right corner.
  @Deprecated(
    'Use borderRadius(.bottomRight(radius)) instead. borderRadiusBottomRight will be removed in Mix 3.0.',
  )
  T borderRadiusBottomRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(radius));
  }

  // Directional methods (RTL-aware)

  /// Sets border radius for the top start corner (directional).
  @Deprecated(
    'Use borderRadius(.topStart(radius)) instead. borderRadiusTopStart will be removed in Mix 3.0.',
  )
  T borderRadiusTopStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topStart(radius));
  }

  /// Sets border radius for the top end corner (directional).
  @Deprecated(
    'Use borderRadius(.topEnd(radius)) instead. borderRadiusTopEnd will be removed in Mix 3.0.',
  )
  T borderRadiusTopEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topEnd(radius));
  }

  /// Sets border radius for the bottom start corner (directional).
  @Deprecated(
    'Use borderRadius(.bottomStart(radius)) instead. borderRadiusBottomStart will be removed in Mix 3.0.',
  )
  T borderRadiusBottomStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomStart(radius));
  }

  /// Sets border radius for the bottom end corner (directional).
  @Deprecated(
    'Use borderRadius(.bottomEnd(radius)) instead. borderRadiusBottomEnd will be removed in Mix 3.0.',
  )
  T borderRadiusBottomEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomEnd(radius));
  }

  // Rounded shortcuts - ALL corners

  /// Sets a uniform circular radius for all corners.
  @Deprecated(
    'Use borderRadius(.circular(radius)) instead. borderRounded will be removed in Mix 3.0.',
  )
  T borderRounded(double radius) {
    return borderRadius(BorderRadiusGeometryMix.circular(radius));
  }

  // Rounded shortcuts - GROUPED corners

  /// Sets a circular radius for the top corners.
  @Deprecated(
    'Use borderRadius(.top(.circular(radius))) instead. borderRoundedTop will be removed in Mix 3.0.',
  )
  T borderRoundedTop(double radius) {
    return borderRadius(BorderRadiusGeometryMix.top(.circular(radius)));
  }

  /// Sets a circular radius for the bottom corners.
  @Deprecated(
    'Use borderRadius(.bottom(.circular(radius))) instead. borderRoundedBottom will be removed in Mix 3.0.',
  )
  T borderRoundedBottom(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottom(.circular(radius)));
  }

  /// Sets a circular radius for the left corners.
  @Deprecated(
    'Use borderRadius(.left(.circular(radius))) instead. borderRoundedLeft will be removed in Mix 3.0.',
  )
  T borderRoundedLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.left(.circular(radius)));
  }

  /// Sets a circular radius for the right corners.
  @Deprecated(
    'Use borderRadius(.right(.circular(radius))) instead. borderRoundedRight will be removed in Mix 3.0.',
  )
  T borderRoundedRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.right(.circular(radius)));
  }

  // Rounded shortcuts - SINGLE corners

  /// Sets a circular radius for the top left corner.
  @Deprecated(
    'Use borderRadius(.topLeft(.circular(radius))) instead. borderRoundedTopLeft will be removed in Mix 3.0.',
  )
  T borderRoundedTopLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(.circular(radius)));
  }

  /// Sets a circular radius for the top right corner.
  @Deprecated(
    'Use borderRadius(.topRight(.circular(radius))) instead. borderRoundedTopRight will be removed in Mix 3.0.',
  )
  T borderRoundedTopRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(.circular(radius)));
  }

  /// Sets a circular radius for the bottom left corner.
  @Deprecated(
    'Use borderRadius(.bottomLeft(.circular(radius))) instead. borderRoundedBottomLeft will be removed in Mix 3.0.',
  )
  T borderRoundedBottomLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(.circular(radius)));
  }

  /// Sets a circular radius for the bottom right corner.
  @Deprecated(
    'Use borderRadius(.bottomRight(.circular(radius))) instead. borderRoundedBottomRight will be removed in Mix 3.0.',
  )
  T borderRoundedBottomRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(.circular(radius)));
  }

  // Rounded shortcuts - DIRECTIONAL (RTL-aware)

  /// Sets a circular radius for the top start corner (directional).
  @Deprecated(
    'Use borderRadius(.topStart(.circular(radius))) instead. borderRoundedTopStart will be removed in Mix 3.0.',
  )
  T borderRoundedTopStart(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topStart(.circular(radius)));
  }

  /// Sets a circular radius for the top end corner (directional).
  @Deprecated(
    'Use borderRadius(.topEnd(.circular(radius))) instead. borderRoundedTopEnd will be removed in Mix 3.0.',
  )
  T borderRoundedTopEnd(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topEnd(.circular(radius)));
  }

  /// Sets a circular radius for the bottom start corner (directional).
  @Deprecated(
    'Use borderRadius(.bottomStart(.circular(radius))) instead. borderRoundedBottomStart will be removed in Mix 3.0.',
  )
  T borderRoundedBottomStart(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomStart(.circular(radius)));
  }

  /// Sets a circular radius for the bottom end corner (directional).
  @Deprecated(
    'Use borderRadius(.bottomEnd(.circular(radius))) instead. borderRoundedBottomEnd will be removed in Mix 3.0.',
  )
  T borderRoundedBottomEnd(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomEnd(.circular(radius)));
  }
}
