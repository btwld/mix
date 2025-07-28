import 'package:flutter/material.dart';

/// Unified Data Transfer Object for Decoration types with merge capabilities.
///
/// This DTO can represent both BoxDecoration and ShapeDecoration without data loss,
/// tracking the origin type to make intelligent conversion decisions.
class DecorationDto {
  // Common properties
  final Color? color;
  final DecorationImage? image;
  final Gradient? gradient;
  final List<BoxShadow>?
  shadows; // 'shadows' for ShapeDecoration, 'boxShadow' for BoxDecoration

  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final BlendMode? backgroundBlendMode;
  final BoxShape? boxShape;

  // ShapeDecoration-specific
  final ShapeBorder? shapeBorder;

  // Metadata
  final DecorationType sourceType;

  const DecorationDto({
    this.color,
    this.image,
    this.gradient,
    this.shadows,
    this.border,
    this.borderRadius,
    this.backgroundBlendMode,
    this.boxShape,
    this.shapeBorder,
    required this.sourceType,
  });

  /// Creates a DecorationDto from a BoxDecoration
  factory DecorationDto.fromBoxDecoration(BoxDecoration decoration) {
    return DecorationDto(
      color: decoration.color,
      image: decoration.image,
      gradient: decoration.gradient,
      shadows: decoration.boxShadow,
      border: decoration.border,
      borderRadius: decoration.borderRadius,
      backgroundBlendMode: decoration.backgroundBlendMode,
      boxShape: decoration.shape,
      shapeBorder: null,
      sourceType: DecorationType.box,
    );
  }

  /// Creates a DecorationDto from a ShapeDecoration
  factory DecorationDto.fromShapeDecoration(ShapeDecoration decoration) {
    return DecorationDto(
      color: decoration.color,
      image: decoration.image,
      gradient: decoration.gradient,
      shadows: decoration.shadows,
      border: null,
      borderRadius: null,
      backgroundBlendMode: null,
      boxShape: null,
      shapeBorder: decoration.shape,
      sourceType: DecorationType.shape,
    );
  }

  /// Determines the target type when merging two DTOs
  static DecorationType _determineTargetType(DecorationDto a, DecorationDto b) {
    // If b has properties that only BoxDecoration supports, must use Box
    if (b.backgroundBlendMode != null) {
      return DecorationType.box;
    }

    // If b is ShapeDecoration with complex shapes, prefer Shape
    if (b.shapeBorder != null &&
        b.shapeBorder is! CircleBorder &&
        b.shapeBorder is! RoundedRectangleBorder &&
        b.shapeBorder is! BoxBorder) {
      return DecorationType.shape;
    }

    // If a has backgroundBlendMode and b doesn't override, stay Box
    if (a.backgroundBlendMode != null && b.sourceType != DecorationType.shape) {
      return DecorationType.box;
    }

    // Otherwise, prefer the type of b (later value takes precedence)
    return b.sourceType;
  }

  /// Checks if the border is uniform (all sides equal)
  bool get hasUniformBorder {
    if (border == null) return true;

    if (border is Border) {
      final b = border as Border;

      return b.isUniform;
    }

    if (border is BorderDirectional) {
      final b = border as BorderDirectional;

      // Check if all sides are equal
      return b.top == b.bottom && b.start == b.end;
    }

    return false;
  }

  /// Gets a uniform border side if the border is uniform
  BorderSide? get uniformBorderSide {
    if (!hasUniformBorder || border == null) return null;

    if (border is Border) {
      return (border as Border).top;
    }

    if (border is BorderDirectional) {
      return (border as BorderDirectional).top;
    }

    return null;
  }

  /// Converts to BoxDecoration if possible
  BoxDecoration? toBoxDecoration() {
    // If source was already BoxDecoration, return all properties
    if (sourceType == DecorationType.box) {
      return BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: shadows,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        shape: boxShape ?? BoxShape.rectangle,
      );
    }

    // Converting from ShapeDecoration
    if (shapeBorder == null) {
      return BoxDecoration(
        color: color,
        image: image,
        boxShadow: shadows,
        gradient: gradient,
      );
    }

    // Convert ShapeBorder to BoxDecoration properties
    BoxShape? shape;
    BorderRadiusGeometry? radius;
    BoxBorder? boxBorder;

    if (shapeBorder is CircleBorder) {
      shape = BoxShape.circle;
      final side = (shapeBorder as CircleBorder).side;
      if (side != BorderSide.none) {
        boxBorder = Border.all(
          color: side.color,
          width: side.width,
          style: side.style,
        );
      }
    } else if (shapeBorder is RoundedRectangleBorder) {
      shape = BoxShape.rectangle;
      final rrb = shapeBorder as RoundedRectangleBorder;
      radius = rrb.borderRadius;
      final side = rrb.side;
      if (side != BorderSide.none) {
        boxBorder = Border.all(
          color: side.color,
          width: side.width,
          style: side.style,
        );
      }
    } else if (shapeBorder is Border) {
      shape = BoxShape.rectangle;
      boxBorder = shapeBorder as Border;
    } else {
      // Cannot convert complex shapes to BoxDecoration
      return null;
    }

    return BoxDecoration(
      color: color,
      image: image,
      border: boxBorder,
      borderRadius: radius,
      boxShadow: shadows,
      gradient: gradient,
      shape: shape ?? BoxShape.rectangle,
    );
  }

  /// Converts to ShapeDecoration if possible
  ShapeDecoration? toShapeDecoration() {
    // If source was already ShapeDecoration, return all properties
    if (sourceType == DecorationType.shape && shapeBorder != null) {
      return ShapeDecoration(
        color: color,
        image: image,
        gradient: gradient,
        shadows: shadows,
        shape: shapeBorder!,
      );
    }

    // Converting from BoxDecoration - must check constraints
    if (backgroundBlendMode != null) {
      // ShapeDecoration doesn't support backgroundBlendMode
      throw ArgumentError(
        'Cannot convert BoxDecoration with backgroundBlendMode to ShapeDecoration. '
        'ShapeDecoration does not support backgroundBlendMode.',
      );
    }

    // Determine ShapeBorder from BoxDecoration properties
    ShapeBorder? shape;

    if (boxShape == BoxShape.circle) {
      if (border != null && !hasUniformBorder) {
        throw ArgumentError(
          'Cannot convert BoxDecoration with non-uniform borders to CircleBorder. '
          'All border sides must be identical.',
        );
      }
      shape = CircleBorder(side: uniformBorderSide ?? BorderSide.none);
    } else {
      // Rectangle shape
      if (borderRadius != null) {
        if (border != null && !hasUniformBorder) {
          throw ArgumentError(
            'Cannot convert BoxDecoration with non-uniform borders and borderRadius to ShapeDecoration. '
            'All border sides must be identical when using borderRadius.',
          );
        }
        shape = RoundedRectangleBorder(
          side: uniformBorderSide ?? BorderSide.none,
          borderRadius: borderRadius!,
        );
      } else if (border != null) {
        // No borderRadius, can use the full border
        shape = border!;
      } else {
        // Default rectangle with no border
        shape = const RoundedRectangleBorder();
      }
    }

    return ShapeDecoration(
      color: color,
      image: image,
      gradient: gradient,
      shadows: shadows,
      shape: shape,
    );
  }

  /// Merges two DecorationDto instances with intelligent handling of type differences
  DecorationDto merge(DecorationDto? other) {
    if (other == null) return this;

    // Determine the target type based on merge rules
    final targetType = _determineTargetType(this, other);

    // Merge common properties (always safe)
    final mergedColor = other.color ?? color;
    final mergedImage = other.image ?? image;
    final mergedGradient = other.gradient ?? gradient;
    final mergedShadows = other.shadows ?? shadows;

    // Handle type-specific merging
    if (targetType == DecorationType.box) {
      // Merging to BoxDecoration
      return DecorationDto(
        color: mergedColor,
        image: mergedImage,
        gradient: mergedGradient,
        shadows: mergedShadows,
        border: other.border ?? border,
        borderRadius: other.borderRadius ?? borderRadius,
        backgroundBlendMode: other.backgroundBlendMode ?? backgroundBlendMode,
        boxShape: other.boxShape ?? boxShape,
        shapeBorder: null,
        sourceType: DecorationType.box,
      );
    } // Merging to ShapeDecoration
    // Need to convert BoxDecoration properties if present
    ShapeBorder? mergedShape;

    if (other.shapeBorder != null) {
      mergedShape = other.shapeBorder;
    } else if (shapeBorder != null) {
      mergedShape = shapeBorder;
    } else {
      // Need to create ShapeBorder from Box properties
      final dto = DecorationDto(
        border: other.border ?? border,
        borderRadius: other.borderRadius ?? borderRadius,
        boxShape: other.boxShape ?? boxShape,
        sourceType: DecorationType.box,
      );

      // This will throw if conversion is not possible
      final shapeDecoration = dto.toShapeDecoration();
      mergedShape = shapeDecoration?.shape;
    }

    return DecorationDto(
      color: mergedColor,
      image: mergedImage,
      gradient: mergedGradient,
      shadows: mergedShadows,
      border: null,
      borderRadius: null,
      backgroundBlendMode: null,
      boxShape: null,
      shapeBorder: mergedShape,
      sourceType: DecorationType.shape,
    );
  }
}

/// Enum to track the source decoration type
enum DecorationType { box, shape }
