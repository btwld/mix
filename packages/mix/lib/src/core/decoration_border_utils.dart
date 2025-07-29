import 'package:flutter/material.dart';

import 'prop.dart';
import '../properties/painting/border_mix.dart';

/// Simple utilities for validating decoration merging constraints
class DecorationBorderUtils {
  /// Checks if a BoxBorderMix has uniform borders (all sides equal)
  static bool hasUniformBorders(BoxBorderMix? border) {
    if (border == null) return true;

    if (border is BorderMix) {
      // Get all non-null sides
      final sides = [
        border.$top,
        border.$right,
        border.$bottom,
        border.$left,
      ].whereType<MixProp<BorderSide>>().toList();

      if (sides.isEmpty) return true;
      if (sides.length == 1) return true;

      // Check if all sides are equal by comparing with first
      final first = sides.first;

      return sides.every((side) => side == first);
    }

    if (border is BorderDirectionalMix) {
      // Get all non-null sides
      final sides = [
        border.$top,
        border.$bottom,
        border.$start,
        border.$end,
      ].whereType<MixProp<BorderSide>>().toList();

      if (sides.isEmpty) return true;
      if (sides.length == 1) return true;

      // Check if all sides are equal
      final first = sides.first;

      return sides.every((side) => side == first);
    }

    return false;
  }

  /// Gets the first non-null border side from a uniform border
  static MixProp<BorderSide>? getUniformBorderSide(BoxBorderMix? border) {
    if (border == null) return null;

    if (!hasUniformBorders(border)) {
      return null;
    }

    if (border is BorderMix) {
      return border.$top ?? border.$right ?? border.$bottom ?? border.$left;
    }

    if (border is BorderDirectionalMix) {
      return border.$top ?? border.$bottom ?? border.$start ?? border.$end;
    }

    return null;
  }
}
