import 'package:flutter/material.dart';

import '../../core/element.dart';

// ColorDto is now just a Mixable<Color>
typedef ColorDto = Mixable<Color>;

// Extension for easy conversion
extension ColorExt on Color {
  ColorDto toDto() => Mixable.value(this);
}
