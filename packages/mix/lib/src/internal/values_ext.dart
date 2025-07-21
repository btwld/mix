import 'package:flutter/material.dart';

extension DoubleExt on double {
  Radius toRadius() => Radius.circular(this);
}

extension Matrix4Ext on Matrix4 {
  /// Merge [other] into this matrix.
  Matrix4 merge(Matrix4? other) {
    if (other == null || other == this) return this;

    return clone()..multiply(other);
  }
}