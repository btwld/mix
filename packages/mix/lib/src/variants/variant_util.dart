import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/spec.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../core/variant.dart';

/// Utility class for creating variant attributes with context-based variants
@immutable
class OnContextVariantUtility<S extends Spec<S>, T extends SpecStyle<S>>
    extends MixUtility<T, VariantSpecAttribute<S>> {
  const OnContextVariantUtility(super.builder);

  /// Creates a variant attribute for the hover state
  VariantAttributeBuilder<S> get hover {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.hovered),
    );
  }

  /// Creates a variant attribute for the press state
  VariantAttributeBuilder<S> get press {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.pressed),
    );
  }

  /// Creates a variant attribute for the focus state
  VariantAttributeBuilder<S> get focus {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.focused),
    );
  }

  /// Creates a variant attribute for the disabled state
  VariantAttributeBuilder<S> get disabled {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.disabled),
    );
  }

  /// Creates a variant attribute for the selected state
  VariantAttributeBuilder<S> get selected {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.selected),
    );
  }

  /// Creates a variant attribute for the dragged state
  VariantAttributeBuilder<S> get dragged {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.dragged),
    );
  }

  /// Creates a variant attribute for the error state
  VariantAttributeBuilder<S> get error {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.error),
    );
  }

  /// Creates a variant attribute for dark mode
  VariantAttributeBuilder<S> get dark {
    return VariantAttributeBuilder(
      ContextVariant.platformBrightness(Brightness.dark),
    );
  }

  /// Creates a variant attribute for light mode
  VariantAttributeBuilder<S> get light {
    return VariantAttributeBuilder(
      ContextVariant.platformBrightness(Brightness.light),
    );
  }

  /// Creates a variant attribute for portrait orientation
  VariantAttributeBuilder<S> get portrait {
    return VariantAttributeBuilder(
      ContextVariant.orientation(Orientation.portrait),
    );
  }

  /// Creates a variant attribute for landscape orientation
  VariantAttributeBuilder<S> get landscape {
    return VariantAttributeBuilder(
      ContextVariant.orientation(Orientation.landscape),
    );
  }

  /// Creates a variant attribute for mobile size
  VariantAttributeBuilder<S> get mobile {
    return VariantAttributeBuilder(
      ContextVariant.size('mobile', (size) => size.width <= 767),
    );
  }

  /// Creates a variant attribute for tablet size
  VariantAttributeBuilder<S> get tablet {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'tablet',
        (size) => size.width > 767 && size.width <= 1279,
      ),
    );
  }

  /// Creates a variant attribute for desktop size
  VariantAttributeBuilder<S> get desktop {
    return VariantAttributeBuilder(
      ContextVariant.size('desktop', (size) => size.width > 1279),
    );
  }

  /// Creates a variant attribute for left-to-right direction
  VariantAttributeBuilder<S> get ltr {
    return VariantAttributeBuilder(ContextVariant.direction(TextDirection.ltr));
  }

  /// Creates a variant attribute for right-to-left direction
  VariantAttributeBuilder<S> get rtl {
    return VariantAttributeBuilder(ContextVariant.direction(TextDirection.rtl));
  }

  /// Creates a variant attribute for iOS platform
  VariantAttributeBuilder<S> get ios {
    return VariantAttributeBuilder(ContextVariant.platform(TargetPlatform.iOS));
  }

  /// Creates a variant attribute for Android platform
  VariantAttributeBuilder<S> get android {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.android),
    );
  }

  /// Creates a variant attribute for macOS platform
  VariantAttributeBuilder<S> get macos {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.macOS),
    );
  }

  /// Creates a variant attribute for Windows platform
  VariantAttributeBuilder<S> get windows {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.windows),
    );
  }

  /// Creates a variant attribute for Linux platform
  VariantAttributeBuilder<S> get linux {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.linux),
    );
  }

  /// Creates a variant attribute for Fuchsia platform
  VariantAttributeBuilder<S> get fuchsia {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.fuchsia),
    );
  }

  /// Creates a variant attribute for web platform
  VariantAttributeBuilder<S> get web {
    return VariantAttributeBuilder(ContextVariant.web());
  }

  /// Creates a variant attribute for the enabled state (opposite of disabled)
  VariantAttributeBuilder<S> get enabled {
    return VariantAttributeBuilder(
      MultiVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
    );
  }

  /// Creates a variant attribute for a breakpoint based on screen size
  VariantAttributeBuilder<S> breakpoint(Breakpoint breakpoint) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'breakpoint_${breakpoint.minWidth ?? 'null'}_${breakpoint.maxWidth ?? 'null'}',
        (size) => breakpoint.matches(size),
      ),
    );
  }

  /// Creates a variant attribute for a minimum width breakpoint
  VariantAttributeBuilder<S> minWidth(double width) {
    return VariantAttributeBuilder(
      ContextVariant.size('min_width_$width', (size) => size.width >= width),
    );
  }

  /// Creates a variant attribute for a maximum width breakpoint
  VariantAttributeBuilder<S> maxWidth(double width) {
    return VariantAttributeBuilder(
      ContextVariant.size('max_width_$width', (size) => size.width <= width),
    );
  }

  /// Creates a variant attribute for a width range breakpoint
  VariantAttributeBuilder<S> widthRange(double minWidth, double maxWidth) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'width_range_${minWidth}_$maxWidth',
        (size) => size.width >= minWidth && size.width <= maxWidth,
      ),
    );
  }

  /// Creates a variant attribute for a minimum height breakpoint
  VariantAttributeBuilder<S> minHeight(double height) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'min_height_$height',
        (size) => size.height >= height,
      ),
    );
  }

  /// Creates a variant attribute for a maximum height breakpoint
  VariantAttributeBuilder<S> maxHeight(double height) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'max_height_$height',
        (size) => size.height <= height,
      ),
    );
  }

  /// Creates a variant attribute for a height range breakpoint
  VariantAttributeBuilder<S> heightRange(double minHeight, double maxHeight) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'height_range_${minHeight}_$maxHeight',
        (size) => size.height >= minHeight && size.height <= maxHeight,
      ),
    );
  }
}

/// Builder class for creating variant-based styling attributes.
///
/// This class wraps a [Variant] and provides methods to create
/// [VariantSpecAttribute] instances with styling rules that apply
/// when the variant condition is met.
@immutable
class VariantAttributeBuilder<T extends Spec<T>> {
  /// The variant condition that determines when styling should apply
  final Variant variant;

  /// Creates a new [VariantAttributeBuilder] with the given [variant]
  const VariantAttributeBuilder(this.variant);

  /// Creates a [VariantSpecAttribute] that applies the given styling elements
  /// when this variant's condition is met.
  ///
  /// Supports both single and multiple style elements:
  /// ```dart
  /// // Single attribute
  /// final hoverStyle = $on.hover($box.color.blue());
  ///
  /// // Multiple attributes
  /// final darkStyle = $on.dark(
  ///   $box.color.white(),
  ///   $text.style.color.black(),
  /// );
  /// ```
  VariantSpecAttribute<MultiSpec> call([
    StyleElement? p1,
    StyleElement? p2,
    StyleElement? p3,
    StyleElement? p4,
    StyleElement? p5,
    StyleElement? p6,
    StyleElement? p7,
    StyleElement? p8,
    StyleElement? p9,
    StyleElement? p10,
  ]) {
    final elements = [
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
      p10,
    ].whereType<StyleElement>().toList();

    if (elements.isEmpty) {
      throw ArgumentError('At least one StyleElement must be provided');
    }

    // Create a Style to contain the elements
    final style = Style.create(elements);

    return VariantSpecAttribute(variant, style);
  }

  @override
  String toString() => 'VariantAttributeBuilder($variant)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantAttributeBuilder &&
          runtimeType == other.runtimeType &&
          variant == other.variant;

  @override
  int get hashCode => variant.hashCode;
}
