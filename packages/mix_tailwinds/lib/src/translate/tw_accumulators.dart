/// Translator-side accumulators for values that merge across tokens.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/mix_schema.dart';

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

  List<double> toPayload() => toMatrix4().storage.toList(growable: false);
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

  JsonMap toPayload({required Color defaultColor}) {
    JsonMap side(double? width, Color? color) {
      final resolvedWidth = width ?? 0;
      return payloadBorderSide(
        color: color ?? defaultColor,
        width: resolvedWidth,
        style: resolvedWidth > 0 ? BorderStyle.solid : BorderStyle.none,
      );
    }

    return payloadBorder(
      top: (topWidth != null || topColor != null)
          ? side(topWidth, topColor)
          : null,
      right: (rightWidth != null || rightColor != null)
          ? side(rightWidth, rightColor)
          : null,
      bottom: (bottomWidth != null || bottomColor != null)
          ? side(bottomWidth, bottomColor)
          : null,
      left: (leftWidth != null || leftColor != null)
          ? side(leftWidth, leftColor)
          : null,
    );
  }
}
