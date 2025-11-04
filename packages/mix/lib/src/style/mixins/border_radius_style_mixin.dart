import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../properties/painting/border_radius_mix.dart';
import 'decoration_style_mixin.dart';

/// Mixin that provides convenient border radius styling methods
mixin BorderRadiusStyleMixin<T extends Mix<Object?>>
    implements DecorationStyleMixin<T> {
  // Methods accepting Radius values (using existing factory constructors)

  /// Sets border radius for all corners.
  T borderRadiusAll(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.all(radius));
  }

  /// Sets border radius for the top corners.
  T borderRadiusTop(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.top(radius));
  }

  /// Sets border radius for the bottom corners.
  T borderRadiusBottom(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottom(radius));
  }

  /// Sets border radius for the left corners.
  T borderRadiusLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.left(radius));
  }

  /// Sets border radius for the right corners.
  T borderRadiusRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.right(radius));
  }

  /// Sets border radius for the top left corner.
  T borderRadiusTopLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(radius));
  }

  /// Sets border radius for the top right corner.
  T borderRadiusTopRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(radius));
  }

  /// Sets border radius for the bottom left corner.
  T borderRadiusBottomLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(radius));
  }

  /// Sets border radius for the bottom right corner.
  T borderRadiusBottomRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(radius));
  }

  // Directional methods (RTL-aware)

  /// Sets border radius for the top start corner (directional).
  T borderRadiusTopStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topStart(radius));
  }

  /// Sets border radius for the top end corner (directional).
  T borderRadiusTopEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topEnd(radius));
  }

  /// Sets border radius for the bottom start corner (directional).
  T borderRadiusBottomStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomStart(radius));
  }

  /// Sets border radius for the bottom end corner (directional).
  T borderRadiusBottomEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomEnd(radius));
  }

  // Rounded shortcuts - ALL corners

  /// Sets a uniform circular radius for all corners.
  T borderRounded(double radius) {
    return borderRadius(BorderRadiusGeometryMix.circular(radius));
  }

  // Rounded shortcuts - GROUPED corners

  /// Sets a circular radius for the top corners.
  T borderRoundedTop(double radius) {
    return borderRadius(BorderRadiusGeometryMix.top(Radius.circular(radius)));
  }

  /// Sets a circular radius for the bottom corners.
  T borderRoundedBottom(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottom(Radius.circular(radius)),
    );
  }

  /// Sets a circular radius for the left corners.
  T borderRoundedLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.left(Radius.circular(radius)));
  }

  /// Sets a circular radius for the right corners.
  T borderRoundedRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.right(Radius.circular(radius)));
  }

  // Rounded shortcuts - SINGLE corners

  /// Sets a circular radius for the top left corner.
  T borderRoundedTopLeft(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.topLeft(Radius.circular(radius)),
    );
  }

  /// Sets a circular radius for the top right corner.
  T borderRoundedTopRight(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.topRight(Radius.circular(radius)),
    );
  }

  /// Sets a circular radius for the bottom left corner.
  T borderRoundedBottomLeft(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottomLeft(Radius.circular(radius)),
    );
  }

  /// Sets a circular radius for the bottom right corner.
  T borderRoundedBottomRight(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottomRight(Radius.circular(radius)),
    );
  }

  // Rounded shortcuts - DIRECTIONAL (RTL-aware)

  /// Sets a circular radius for the top start corner (directional).
  T borderRoundedTopStart(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.topStart(Radius.circular(radius)),
    );
  }

  /// Sets a circular radius for the top end corner (directional).
  T borderRoundedTopEnd(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.topEnd(Radius.circular(radius)),
    );
  }

  /// Sets a circular radius for the bottom start corner (directional).
  T borderRoundedBottomStart(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottomStart(Radius.circular(radius)),
    );
  }

  /// Sets a circular radius for the bottom end corner (directional).
  T borderRoundedBottomEnd(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottomEnd(Radius.circular(radius)),
    );
  }
}
