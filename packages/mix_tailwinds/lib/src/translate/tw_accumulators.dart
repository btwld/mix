/// Translator-side accumulators for values that merge across tokens.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final class TransformAccum {
  double? scale;
  double? rotateDeg;
  double? translateX;
  double? translateY;
  bool needsIdentity = false;

  bool get hasAnyTransform =>
      needsIdentity ||
      scale != null ||
      rotateDeg != null ||
      translateX != null ||
      translateY != null;

  void inheritUnsetFrom(TransformAccum base) {
    scale ??= base.scale;
    rotateDeg ??= base.rotateDeg;
    translateX ??= base.translateX;
    translateY ??= base.translateY;
  }

  Matrix4 toMatrix4() {
    var matrix = Matrix4.identity();
    if (translateX != null || translateY != null) {
      matrix = matrix.multiplied(
        Matrix4.translationValues(translateX ?? 0, translateY ?? 0, 0),
      );
    }
    if (rotateDeg != null) {
      matrix = matrix.multiplied(Matrix4.rotationZ(rotateDeg! * math.pi / 180));
    }
    if (scale != null) {
      matrix = matrix.multiplied(Matrix4.diagonal3Values(scale!, scale!, 1));
    }

    return matrix;
  }
}

final class BorderAccum {
  double? topWidth;
  double? rightWidth;
  double? bottomWidth;
  double? leftWidth;
  Color? topColor;
  Color? rightColor;
  Color? bottomColor;
  Color? leftColor;

  bool get hasStructure =>
      topWidth != null ||
      rightWidth != null ||
      bottomWidth != null ||
      leftWidth != null ||
      topColor != null ||
      rightColor != null ||
      bottomColor != null ||
      leftColor != null;

  void setAll(double width) {
    topWidth = width;
    rightWidth = width;
    bottomWidth = width;
    leftWidth = width;
  }

  void setHorizontal(double width) {
    leftWidth = width;
    rightWidth = width;
  }

  void setVertical(double width) {
    topWidth = width;
    bottomWidth = width;
  }

  void setColor(Color color, String root) {
    switch (root) {
      case 'border':
        topColor = color;
        rightColor = color;
        bottomColor = color;
        leftColor = color;
      case 'border-t':
        topColor = color;
      case 'border-r':
        rightColor = color;
      case 'border-b':
        bottomColor = color;
      case 'border-l':
        leftColor = color;
      case 'border-x':
        leftColor = color;
        rightColor = color;
      case 'border-y':
        topColor = color;
        bottomColor = color;
    }
  }

  void inheritUnsetFrom(BorderAccum base) {
    topWidth ??= base.topWidth;
    rightWidth ??= base.rightWidth;
    bottomWidth ??= base.bottomWidth;
    leftWidth ??= base.leftWidth;
    topColor ??= base.topColor;
    rightColor ??= base.rightColor;
    bottomColor ??= base.bottomColor;
    leftColor ??= base.leftColor;
  }

  BorderMix? toMix({required Color defaultColor}) {
    BorderSideMix? side(double? width, Color? color) {
      if (width == null && color == null) return null;
      final resolvedWidth = width ?? 0;
      return BorderSideMix(
        color: color ?? defaultColor,
        width: resolvedWidth,
        style: resolvedWidth > 0 ? BorderStyle.solid : BorderStyle.none,
      );
    }

    final top = side(topWidth, topColor);
    final right = side(rightWidth, rightColor);
    final bottom = side(bottomWidth, bottomColor);
    final left = side(leftWidth, leftColor);
    if (top == null && right == null && bottom == null && left == null) {
      return null;
    }

    return BorderMix(top: top, right: right, bottom: bottom, left: left);
  }
}
