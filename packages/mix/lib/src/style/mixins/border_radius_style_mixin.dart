import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../properties/painting/border_radius_mix.dart';
import 'decoration_style_mixin.dart';

/// Mixin that provides convenient border radius styling methods
mixin BorderRadiusStyleMixin<T extends Mix<Object?>> implements DecorationStyleMixin<T> {
  // Methods accepting Radius values (using existing factory constructors)

  T borderRadiusAll(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.all(radius));
  }

  T borderRadiusTop(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.top(radius));
  }

  T borderRadiusBottom(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottom(radius));
  }

  T borderRadiusLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.left(radius));
  }

  T borderRadiusRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.right(radius));
  }

  T borderRadiusTopLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(radius));
  }

  T borderRadiusTopRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(radius));
  }

  T borderRadiusBottomLeft(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(radius));
  }

  T borderRadiusBottomRight(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(radius));
  }

  // Directional methods (RTL-aware)

  T borderRadiusTopStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topStart(radius));
  }

  T borderRadiusTopEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.topEnd(radius));
  }

  T borderRadiusBottomStart(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomStart(radius));
  }

  T borderRadiusBottomEnd(Radius radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomEnd(radius));
  }

  // Rounded shortcuts - ALL corners
  T borderRounded(double radius) {
    return borderRadius(BorderRadiusGeometryMix.circular(radius));
  }

  // Rounded shortcuts - GROUPED corners

  T borderRoundedTop(double radius) {
    return borderRadius(BorderRadiusGeometryMix.top(Radius.circular(radius)));
  }

  T borderRoundedBottom(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottom(Radius.circular(radius)),
    );
  }

  T borderRoundedLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.left(Radius.circular(radius)));
  }

  T borderRoundedRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.right(Radius.circular(radius)));
  }

  // Rounded shortcuts - SINGLE corners

  T borderRoundedTopLeft(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.topLeft(Radius.circular(radius)),
    );
  }

  T borderRoundedTopRight(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.topRight(Radius.circular(radius)),
    );
  }

  T borderRoundedBottomLeft(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottomLeft(Radius.circular(radius)),
    );
  }

  T borderRoundedBottomRight(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottomRight(Radius.circular(radius)),
    );
  }

  // Rounded shortcuts - DIRECTIONAL (RTL-aware)

  T borderRoundedTopStart(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.topStart(Radius.circular(radius)),
    );
  }

  T borderRoundedTopEnd(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.topEnd(Radius.circular(radius)),
    );
  }

  T borderRoundedBottomStart(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottomStart(Radius.circular(radius)),
    );
  }

  T borderRoundedBottomEnd(double radius) {
    return borderRadius(
      BorderRadiusGeometryMix.bottomEnd(Radius.circular(radius)),
    );
  }
}