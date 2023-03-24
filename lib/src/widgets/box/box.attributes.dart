import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../attributes/attribute.dart';
import '../../helpers/dto/border.dto.dart';
import '../../helpers/dto/border_radius.dto.dart';
import '../../helpers/dto/box_shadow.dto.dart';
import '../../helpers/dto/color.dto.dart';
import '../../helpers/dto/double.dto.dart';
import '../../helpers/dto/edge_insets.dto.dart';
import '../../helpers/extensions.dart';
import '../../helpers/mergeable_map.dart';
import 'box.decorator.dart';

class BoxAttributes extends WidgetAttributes {
  final EdgeInsetsDto? margin;
  final EdgeInsetsDto? padding;
  final AlignmentGeometry? alignment;
  final DoubleDto? height;
  final DoubleDto? width;
  // Decoration
  final ColorDto? color;
  final BorderDto? border;
  final BorderRadiusDto? borderRadius;
  final List<BoxShadowDto>? boxShadow;
  final Matrix4? transform;

  // Constraints
  final DoubleDto? maxHeight;
  final DoubleDto? minHeight;
  final DoubleDto? maxWidth;
  final DoubleDto? minWidth;
  final BoxShape? shape;
  final Gradient? gradient;

  final MergeableMap<BoxDecoratorAttribute>? decorators;

  const BoxAttributes({
    this.margin,
    this.padding,
    this.alignment,
    this.border,
    this.borderRadius,
    this.color,
    this.boxShadow,
    this.height,
    this.width,
    this.maxHeight,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
    this.shape,
    this.transform,
    this.gradient,
    this.decorators,
  });

  BoxAttributes copyWith({
    EdgeInsetsDto? margin,
    EdgeInsetsDto? padding,
    AlignmentGeometry? alignment,
    ColorDto? color,
    BorderDto? border,
    BorderRadiusDto? borderRadius,
    List<BoxShadowDto>? boxShadow,
    Matrix4? transform,
    DoubleDto? height,
    DoubleDto? width,
    DoubleDto? maxHeight,
    DoubleDto? minHeight,
    DoubleDto? maxWidth,
    DoubleDto? minWidth,
    BoxShape? shape,
    Gradient? gradient,
    MergeableMap<BoxDecoratorAttribute>? decorators,
  }) {
    return BoxAttributes(
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      alignment: alignment ?? this.alignment,
      height: height ?? this.height,
      width: width ?? this.width,
      color: color ?? this.color,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      transform: transform ?? this.transform,
      maxHeight: maxHeight ?? this.maxHeight,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
      shape: shape ?? this.shape,
      gradient: gradient ?? this.gradient,
      decorators: decorators ?? this.decorators,
    );
  }

  @override
  BoxAttributes merge(BoxAttributes? other) {
    if (other == null) return this;

    return copyWith(
      // Mergeble values
      border: border?.merge(other.border) ?? other.border,
      borderRadius:
          borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      boxShadow: boxShadow?.merge(other.boxShadow) ?? other.boxShadow,
      margin: margin?.merge(other.margin) ?? other.margin,
      padding: padding?.merge(other.padding) ?? other.padding,
      transform: transform?.merge(other.transform) ?? other.transform,
      // Override values
      alignment: other.alignment,
      color: other.color,
      height: other.height,
      maxHeight: other.maxHeight,
      minHeight: other.minHeight,
      width: other.width,
      maxWidth: other.maxWidth,
      minWidth: other.minWidth,
      shape: other.shape,
      gradient: other.gradient,
      decorators:
          decorators != null ? other.decorators?.merge(decorators) : decorators,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoxAttributes &&
        other.margin == margin &&
        other.padding == padding &&
        other.alignment == alignment &&
        other.height == height &&
        other.width == width &&
        other.color == color &&
        other.border == border &&
        other.borderRadius == borderRadius &&
        listEquals(other.boxShadow, boxShadow) &&
        other.transform == transform &&
        other.maxHeight == maxHeight &&
        other.minHeight == minHeight &&
        other.maxWidth == maxWidth &&
        other.minWidth == minWidth &&
        other.shape == shape &&
        other.gradient == gradient &&
        other.decorators == decorators;
  }

  @override
  int get hashCode {
    return margin.hashCode ^
        padding.hashCode ^
        alignment.hashCode ^
        height.hashCode ^
        width.hashCode ^
        color.hashCode ^
        border.hashCode ^
        borderRadius.hashCode ^
        boxShadow.hashCode ^
        transform.hashCode ^
        maxHeight.hashCode ^
        minHeight.hashCode ^
        maxWidth.hashCode ^
        minWidth.hashCode ^
        shape.hashCode ^
        gradient.hashCode ^
        decorators.hashCode;
  }

  @override
  String toString() {
    return 'BoxAttributes(margin: $margin, padding: $padding, alignment: $alignment, height: $height, width: $width, color: $color, border: $border, borderRadius: $borderRadius, boxShadow: $boxShadow, transform: $transform, maxHeight: $maxHeight, minHeight: $minHeight, maxWidth: $maxWidth, minWidth: $minWidth, shape: $shape, gradient: $gradient, decorators: $decorators)';
  }
}
