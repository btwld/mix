import 'package:flutter/widgets.dart';

import '../../core/element.dart';

// RadiusDto is now just a Mixable<Radius>
typedef RadiusDto = Mixable<Radius>;

// Extension for easy conversion
extension RadiusExt on Radius {
  RadiusDto toDto() => Mixable.value(this);
}

// Convenience factory functions
class RadiusDto$ {
  static RadiusDto zero() => const Mixable.value(Radius.zero);
  static RadiusDto circular(double radius) =>
      Mixable.value(Radius.circular(radius));
  static RadiusDto elliptical(double x, double y) =>
      Mixable.value(Radius.elliptical(x, y));
  static RadiusDto fromValue(Radius value) => Mixable.value(value);
}
