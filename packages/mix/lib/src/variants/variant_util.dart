import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/spec.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'variant.dart';

/// Utility class for creating variant attributes with context-based variants
@Deprecated(
  'Use direct methods like \$box.onHovered() instead of \$box.on.hover()',
)
@immutable
class OnContextVariantUtility<S extends Spec<S>, T extends Style<S>>
    extends MixUtility<T, VariantStyle<S>> {
  const OnContextVariantUtility(super.utilityBuilder);

  /// Creates a variant attribute for the hover state
  VariantAttributeBuilder<S> get hover {
    return VariantAttributeBuilder(
      ContextTrigger.widgetState(WidgetState.hovered),
    );
  }

  /// Creates a variant attribute for the press state
  VariantAttributeBuilder<S> get press {
    return VariantAttributeBuilder(
      ContextTrigger.widgetState(WidgetState.pressed),
    );
  }

  /// Creates a variant attribute for the focus state
  VariantAttributeBuilder<S> get focus {
    return VariantAttributeBuilder(
      ContextTrigger.widgetState(WidgetState.focused),
    );
  }

  /// Creates a variant attribute for the disabled state
  VariantAttributeBuilder<S> get disabled {
    return VariantAttributeBuilder(
      ContextTrigger.widgetState(WidgetState.disabled),
    );
  }

  /// Creates a variant attribute for the selected state
  VariantAttributeBuilder<S> get selected {
    return VariantAttributeBuilder(
      ContextTrigger.widgetState(WidgetState.selected),
    );
  }

  /// Creates a variant attribute for the dragged state
  VariantAttributeBuilder<S> get dragged {
    return VariantAttributeBuilder(
      ContextTrigger.widgetState(WidgetState.dragged),
    );
  }

  /// Creates a variant attribute for the error state
  VariantAttributeBuilder<S> get error {
    return VariantAttributeBuilder(
      ContextTrigger.widgetState(WidgetState.error),
    );
  }

  /// Creates a variant attribute for the scrolled under state
  VariantAttributeBuilder<S> get scrolledUnder {
    return VariantAttributeBuilder(
      ContextTrigger.widgetState(WidgetState.scrolledUnder),
    );
  }

  /// Creates a variant attribute for dark mode
  VariantAttributeBuilder<S> get dark {
    return VariantAttributeBuilder(ContextTrigger.brightness(Brightness.dark));
  }

  /// Creates a variant attribute for light mode
  VariantAttributeBuilder<S> get light {
    return VariantAttributeBuilder(ContextTrigger.brightness(Brightness.light));
  }

  /// Creates a variant attribute for portrait orientation
  VariantAttributeBuilder<S> get portrait {
    return VariantAttributeBuilder(
      ContextTrigger.orientation(Orientation.portrait),
    );
  }

  /// Creates a variant attribute for landscape orientation
  VariantAttributeBuilder<S> get landscape {
    return VariantAttributeBuilder(
      ContextTrigger.orientation(Orientation.landscape),
    );
  }

  /// Creates a variant attribute for mobile size
  VariantAttributeBuilder<S> get mobile {
    return VariantAttributeBuilder(ContextTrigger.mobile());
  }

  /// Creates a variant attribute for tablet size
  VariantAttributeBuilder<S> get tablet {
    return VariantAttributeBuilder(ContextTrigger.tablet());
  }

  /// Creates a variant attribute for desktop size
  VariantAttributeBuilder<S> get desktop {
    return VariantAttributeBuilder(ContextTrigger.desktop());
  }

  /// Creates a variant attribute for left-to-right direction
  VariantAttributeBuilder<S> get ltr {
    return VariantAttributeBuilder(
      ContextTrigger.directionality(TextDirection.ltr),
    );
  }

  /// Creates a variant attribute for right-to-left direction
  VariantAttributeBuilder<S> get rtl {
    return VariantAttributeBuilder(
      ContextTrigger.directionality(TextDirection.rtl),
    );
  }

  /// Creates a variant attribute for iOS platform
  VariantAttributeBuilder<S> get ios {
    return VariantAttributeBuilder(ContextTrigger.platform(TargetPlatform.iOS));
  }

  /// Creates a variant attribute for Android platform
  VariantAttributeBuilder<S> get android {
    return VariantAttributeBuilder(
      ContextTrigger.platform(TargetPlatform.android),
    );
  }

  /// Creates a variant attribute for macOS platform
  VariantAttributeBuilder<S> get macos {
    return VariantAttributeBuilder(
      ContextTrigger.platform(TargetPlatform.macOS),
    );
  }

  /// Creates a variant attribute for Windows platform
  VariantAttributeBuilder<S> get windows {
    return VariantAttributeBuilder(
      ContextTrigger.platform(TargetPlatform.windows),
    );
  }

  /// Creates a variant attribute for Linux platform
  VariantAttributeBuilder<S> get linux {
    return VariantAttributeBuilder(
      ContextTrigger.platform(TargetPlatform.linux),
    );
  }

  /// Creates a variant attribute for Fuchsia platform
  VariantAttributeBuilder<S> get fuchsia {
    return VariantAttributeBuilder(
      ContextTrigger.platform(TargetPlatform.fuchsia),
    );
  }

  /// Creates a variant attribute for web platform
  VariantAttributeBuilder<S> get web {
    return VariantAttributeBuilder(ContextTrigger.web());
  }

  /// Creates a variant attribute for the enabled state (opposite of disabled)
  VariantAttributeBuilder<S> get enabled {
    return VariantAttributeBuilder(
      ContextTrigger.not(ContextTrigger.widgetState(WidgetState.disabled)),
    );
  }

  /// Creates a variant attribute for a breakpoint based on screen size
  VariantAttributeBuilder<S> breakpoint(Breakpoint breakpoint) {
    return VariantAttributeBuilder(
      ContextTrigger.size(
        'breakpoint_${breakpoint.minWidth ?? 'null'}_${breakpoint.maxWidth ?? 'null'}',
        (size) => breakpoint.matches(size),
      ),
    );
  }

  /// Creates a variant attribute for a minimum width breakpoint
  VariantAttributeBuilder<S> minWidth(double width) {
    return VariantAttributeBuilder(
      ContextTrigger.size('min_width_$width', (size) => size.width >= width),
    );
  }

  /// Creates a variant attribute for a maximum width breakpoint
  VariantAttributeBuilder<S> maxWidth(double width) {
    return VariantAttributeBuilder(
      ContextTrigger.size('max_width_$width', (size) => size.width <= width),
    );
  }

  /// Creates a variant attribute for a width range breakpoint
  VariantAttributeBuilder<S> widthRange(double minWidth, double maxWidth) {
    return VariantAttributeBuilder(
      ContextTrigger.size(
        'width_range_${minWidth}_$maxWidth',
        (size) => size.width >= minWidth && size.width <= maxWidth,
      ),
    );
  }

  /// Creates a variant attribute for a minimum height breakpoint
  VariantAttributeBuilder<S> minHeight(double height) {
    return VariantAttributeBuilder(
      ContextTrigger.size(
        'min_height_$height',
        (size) => size.height >= height,
      ),
    );
  }

  /// Creates a variant attribute for a maximum height breakpoint
  VariantAttributeBuilder<S> maxHeight(double height) {
    return VariantAttributeBuilder(
      ContextTrigger.size(
        'max_height_$height',
        (size) => size.height <= height,
      ),
    );
  }

  /// Creates a variant attribute for a height range breakpoint
  VariantAttributeBuilder<S> heightRange(double minHeight, double maxHeight) {
    return VariantAttributeBuilder(
      ContextTrigger.size(
        'height_range_${minHeight}_$maxHeight',
        (size) => size.height >= minHeight && size.height <= maxHeight,
      ),
    );
  }
}

/// Builder class for creating variant-based styling attributes.
///
/// This class wraps a [VariantStyle] and provides methods to create
/// [VariantStyle] instances with styling rules that apply
/// when the variant condition is met.
@Deprecated(
  'Use direct methods like \$box.onHovered() instead of \$box.on.hover()',
)
@immutable
class VariantAttributeBuilder<T extends Spec<T>> {
  /// The trigger condition that determines when styling should apply
  final ContextTrigger trigger;

  /// Creates a new [VariantAttributeBuilder] with the given [trigger]
  const VariantAttributeBuilder(this.trigger);

  /// Temporary call method to make the builder functional during deprecation period.
  ///
  /// This allows the existing `.on` pattern to work while users migrate to direct methods.
  /// Usage: `$box.on.hover($box.color.red())` becomes `$box.on.hover()($box.color.red())`
  @Deprecated('Use direct methods like \$box.onHovered() instead')
  EventVariantStyle<T> call<S extends Style<T>>(S style) {
    return EventVariantStyle<T>(trigger, style);
  }

  /// Creates a [VariantStyle] that applies the given styling elements
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
  // This method has been removed as part of the MultiSpec/CompoundStyle cleanup.
  // Variants should now be applied directly to specific spec types.

  @override
  String toString() => 'VariantAttributeBuilder($trigger)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantAttributeBuilder &&
          runtimeType == other.runtimeType &&
          trigger == other.trigger;

  @override
  int get hashCode => trigger.hashCode;
}
