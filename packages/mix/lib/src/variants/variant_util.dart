import 'package:flutter/material.dart';

import '../core/attribute.dart';
import '../core/deprecated.dart';
import '../core/spec.dart';
import '../core/style_mix.dart';
import '../core/variant.dart';

/// Utility class for creating variant attributes with context-based variants
@immutable
class OnContextVariantUtility {
  static const self = OnContextVariantUtility();

  const OnContextVariantUtility();

  /// Creates a variant attribute for the hover state
  VariantAttributeBuilder get hover {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.hovered),
    );
  }

  /// Creates a variant attribute for the press state
  VariantAttributeBuilder get press {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.pressed),
    );
  }

  /// Creates a variant attribute for the focus state
  VariantAttributeBuilder get focus {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.focused),
    );
  }

  /// Creates a variant attribute for the disabled state
  VariantAttributeBuilder get disabled {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.disabled),
    );
  }

  /// Creates a variant attribute for the selected state
  VariantAttributeBuilder get selected {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.selected),
    );
  }

  /// Creates a variant attribute for the dragged state
  VariantAttributeBuilder get dragged {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.dragged),
    );
  }

  /// Creates a variant attribute for the error state
  VariantAttributeBuilder get error {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.error),
    );
  }

  /// Creates a variant attribute for dark mode
  VariantAttributeBuilder get dark {
    return VariantAttributeBuilder(
      ContextVariant.platformBrightness(Brightness.dark),
    );
  }

  /// Creates a variant attribute for light mode
  VariantAttributeBuilder get light {
    return VariantAttributeBuilder(
      ContextVariant.platformBrightness(Brightness.light),
    );
  }

  /// Creates a variant attribute for portrait orientation
  VariantAttributeBuilder get portrait {
    return VariantAttributeBuilder(
      ContextVariant.orientation(Orientation.portrait),
    );
  }

  /// Creates a variant attribute for landscape orientation
  VariantAttributeBuilder get landscape {
    return VariantAttributeBuilder(
      ContextVariant.orientation(Orientation.landscape),
    );
  }

  /// Creates a variant attribute for mobile size
  VariantAttributeBuilder get mobile {
    return VariantAttributeBuilder(
      ContextVariant.size('mobile', (size) => size.width <= 767),
    );
  }

  /// Creates a variant attribute for tablet size
  VariantAttributeBuilder get tablet {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'tablet',
        (size) => size.width > 767 && size.width <= 1279,
      ),
    );
  }

  /// Creates a variant attribute for desktop size
  VariantAttributeBuilder get desktop {
    return VariantAttributeBuilder(
      ContextVariant.size('desktop', (size) => size.width > 1279),
    );
  }

  /// Creates a variant attribute for left-to-right direction
  VariantAttributeBuilder get ltr {
    return VariantAttributeBuilder(ContextVariant.direction(TextDirection.ltr));
  }

  /// Creates a variant attribute for right-to-left direction
  VariantAttributeBuilder get rtl {
    return VariantAttributeBuilder(ContextVariant.direction(TextDirection.rtl));
  }

  /// Creates a variant attribute for iOS platform
  VariantAttributeBuilder get ios {
    return VariantAttributeBuilder(ContextVariant.platform(TargetPlatform.iOS));
  }

  /// Creates a variant attribute for Android platform
  VariantAttributeBuilder get android {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.android),
    );
  }

  /// Creates a variant attribute for macOS platform
  VariantAttributeBuilder get macos {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.macOS),
    );
  }

  /// Creates a variant attribute for Windows platform
  VariantAttributeBuilder get windows {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.windows),
    );
  }

  /// Creates a variant attribute for Linux platform
  VariantAttributeBuilder get linux {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.linux),
    );
  }

  /// Creates a variant attribute for Fuchsia platform
  VariantAttributeBuilder get fuchsia {
    return VariantAttributeBuilder(
      ContextVariant.platform(TargetPlatform.fuchsia),
    );
  }

  /// Creates a variant attribute for web platform
  VariantAttributeBuilder get web {
    return VariantAttributeBuilder(ContextVariant.web());
  }

  /// Creates a variant attribute for the enabled state (opposite of disabled)
  VariantAttributeBuilder get enabled {
    return VariantAttributeBuilder(
      MultiVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
    );
  }

  /// Creates a variant attribute for a breakpoint based on screen size
  VariantAttributeBuilder breakpoint(Breakpoint breakpoint) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'breakpoint_${breakpoint.minWidth}_${breakpoint.maxWidth}',
        (size) => breakpoint.matches(size),
      ),
    );
  }

  /// Creates a variant attribute for a minimum width breakpoint
  VariantAttributeBuilder minWidth(double width) {
    return VariantAttributeBuilder(
      ContextVariant.size('min_width_$width', (size) => size.width >= width),
    );
  }

  /// Creates a variant attribute for a maximum width breakpoint
  VariantAttributeBuilder maxWidth(double width) {
    return VariantAttributeBuilder(
      ContextVariant.size('max_width_$width', (size) => size.width <= width),
    );
  }

  /// Creates a variant attribute for a width range breakpoint
  VariantAttributeBuilder widthRange(double minWidth, double maxWidth) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'width_range_${minWidth}_$maxWidth',
        (size) => size.width >= minWidth && size.width <= maxWidth,
      ),
    );
  }

  /// Creates a variant attribute for a minimum height breakpoint
  VariantAttributeBuilder minHeight(double height) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'min_height_$height',
        (size) => size.height >= height,
      ),
    );
  }

  /// Creates a variant attribute for a maximum height breakpoint
  VariantAttributeBuilder maxHeight(double height) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'max_height_$height',
        (size) => size.height <= height,
      ),
    );
  }

  /// Creates a variant attribute for a height range breakpoint
  VariantAttributeBuilder heightRange(double minHeight, double maxHeight) {
    return VariantAttributeBuilder(
      ContextVariant.size(
        'height_range_${minHeight}_$maxHeight',
        (size) => size.height >= minHeight && size.height <= maxHeight,
      ),
    );
  }
}

class VariantAttributeBuilder {
  final Variant _variant;
  const VariantAttributeBuilder(this._variant);
  VariantAttribute<MultiSpec> call([
    Attribute? p1,
    Attribute? p2,
    Attribute? p3,
    Attribute? p4,
    Attribute? p5,
    Attribute? p6,
    Attribute? p7,
    Attribute? p8,
  ]) {
    final attributes = [
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
    ].whereType<Attribute>().toList();

    return VariantAttribute<MultiSpec>(_variant, Style.create(attributes));
  }
}
