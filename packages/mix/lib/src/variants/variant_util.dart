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
    return VariantAttributeBuilder(ContextVariant.widgetState(.hovered));
  }

  /// Creates a variant attribute for the press state
  VariantAttributeBuilder<S> get press {
    return VariantAttributeBuilder(ContextVariant.widgetState(.pressed));
  }

  /// Creates a variant attribute for the focus state
  VariantAttributeBuilder<S> get focus {
    return VariantAttributeBuilder(ContextVariant.widgetState(.focused));
  }

  /// Creates a variant attribute for the disabled state
  VariantAttributeBuilder<S> get disabled {
    return VariantAttributeBuilder(ContextVariant.widgetState(.disabled));
  }

  /// Creates a variant attribute for the selected state
  VariantAttributeBuilder<S> get selected {
    return VariantAttributeBuilder(ContextVariant.widgetState(.selected));
  }

  /// Creates a variant attribute for the dragged state
  VariantAttributeBuilder<S> get dragged {
    return VariantAttributeBuilder(ContextVariant.widgetState(.dragged));
  }

  /// Creates a variant attribute for the error state
  VariantAttributeBuilder<S> get error {
    return VariantAttributeBuilder(ContextVariant.widgetState(.error));
  }

  /// Creates a variant attribute for the scrolled under state
  VariantAttributeBuilder<S> get scrolledUnder {
    return VariantAttributeBuilder(ContextVariant.widgetState(.scrolledUnder));
  }

  /// Creates a variant attribute for dark mode
  VariantAttributeBuilder<S> get dark {
    return VariantAttributeBuilder(ContextVariant.brightness(.dark));
  }

  /// Creates a variant attribute for light mode
  VariantAttributeBuilder<S> get light {
    return VariantAttributeBuilder(ContextVariant.brightness(.light));
  }

  /// Creates a variant attribute for portrait orientation
  VariantAttributeBuilder<S> get portrait {
    return VariantAttributeBuilder(ContextVariant.orientation(.portrait));
  }

  /// Creates a variant attribute for landscape orientation
  VariantAttributeBuilder<S> get landscape {
    return VariantAttributeBuilder(ContextVariant.orientation(.landscape));
  }

  /// Creates a variant attribute for mobile size
  VariantAttributeBuilder<S> get mobile {
    return VariantAttributeBuilder(ContextVariant.mobile());
  }

  /// Creates a variant attribute for tablet size
  VariantAttributeBuilder<S> get tablet {
    return VariantAttributeBuilder(ContextVariant.tablet());
  }

  /// Creates a variant attribute for desktop size
  VariantAttributeBuilder<S> get desktop {
    return VariantAttributeBuilder(ContextVariant.desktop());
  }

  /// Creates a variant attribute for left-to-right direction
  VariantAttributeBuilder<S> get ltr {
    return VariantAttributeBuilder(ContextVariant.directionality(.ltr));
  }

  /// Creates a variant attribute for right-to-left direction
  VariantAttributeBuilder<S> get rtl {
    return VariantAttributeBuilder(ContextVariant.directionality(.rtl));
  }

  /// Creates a variant attribute for iOS platform
  VariantAttributeBuilder<S> get ios {
    return VariantAttributeBuilder(ContextVariant.platform(.iOS));
  }

  /// Creates a variant attribute for Android platform
  VariantAttributeBuilder<S> get android {
    return VariantAttributeBuilder(ContextVariant.platform(.android));
  }

  /// Creates a variant attribute for macOS platform
  VariantAttributeBuilder<S> get macos {
    return VariantAttributeBuilder(ContextVariant.platform(.macOS));
  }

  /// Creates a variant attribute for Windows platform
  VariantAttributeBuilder<S> get windows {
    return VariantAttributeBuilder(ContextVariant.platform(.windows));
  }

  /// Creates a variant attribute for Linux platform
  VariantAttributeBuilder<S> get linux {
    return VariantAttributeBuilder(ContextVariant.platform(.linux));
  }

  /// Creates a variant attribute for Fuchsia platform
  VariantAttributeBuilder<S> get fuchsia {
    return VariantAttributeBuilder(ContextVariant.platform(.fuchsia));
  }

  /// Creates a variant attribute for web platform
  VariantAttributeBuilder<S> get web {
    return VariantAttributeBuilder(ContextVariant.web());
  }

  /// Creates a variant attribute for the enabled state (opposite of disabled)
  VariantAttributeBuilder<S> get enabled {
    return VariantAttributeBuilder(
      ContextVariant.not(ContextVariant.widgetState(.disabled)),
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
/// [VariantStyle] instances with styling rules that apply
/// when the variant condition is met.
@Deprecated(
  'Use direct methods like \$box.onHovered() instead of \$box.on.hover()',
)
@immutable
class VariantAttributeBuilder<T extends Spec<T>> {
  /// The variant condition that determines when styling should apply
  final Variant variant;

  /// Creates a new [VariantAttributeBuilder] with the given [variant]
  const VariantAttributeBuilder(this.variant);

  /// Temporary call method to make the builder functional during deprecation period.
  ///
  /// This allows the existing `.on` pattern to work while users migrate to direct methods.
  /// Usage: `$box.on.hover($box.color.red())` becomes `$box.on.hover()($box.color.red())`
  @Deprecated('Use direct methods like \$box.onHovered() instead')
  VariantStyle<T> call<S extends Style<T>>(S style) {
    return VariantStyle<T>(variant, style);
  }

  // Former attribute builder method removed as part of the
  // MultiSpec/CompoundStyle cleanup. Apply variants directly to spec types.

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
