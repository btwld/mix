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

  /// Creates a variant attribute for the scrolled under state
  VariantAttributeBuilder<S> get scrolledUnder {
    return VariantAttributeBuilder(
      ContextVariant.widgetState(WidgetState.scrolledUnder),
    );
  }

  /// Creates a variant attribute for dark mode
  VariantAttributeBuilder<S> get dark {
    return VariantAttributeBuilder(ContextVariant.brightness(Brightness.dark));
  }

  /// Creates a variant attribute for light mode
  VariantAttributeBuilder<S> get light {
    return VariantAttributeBuilder(ContextVariant.brightness(Brightness.light));
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
    return VariantAttributeBuilder(
      ContextVariant.directionality(TextDirection.ltr),
    );
  }

  /// Creates a variant attribute for right-to-left direction
  VariantAttributeBuilder<S> get rtl {
    return VariantAttributeBuilder(
      ContextVariant.directionality(TextDirection.rtl),
    );
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
      ContextVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
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

typedef VariantFactoryCallback<T extends Style<S>, S extends Spec<S>> =
    T Function(T style);

/// Mixin that provides convenient variant methods for spec attributes.
///
/// This mixin follows the same pattern as ModifierMixin, providing
/// a fluent API for applying context variants to spec attributes.
mixin StyleVariantMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
  /// Must be implemented by the class using this mixin
  T variant(Variant variant, T style);

  T variants(List<VariantStyle<S>> value);
  

  /// Creates a variant for dark mode
  T onDark(T style) {
    return variant(ContextVariant.brightness(Brightness.dark), style);
  }

  T onNot(ContextVariant contextVariant, T style) {
    return variant(ContextVariant.not(contextVariant), style);
  }

  /// Creates a variant for light mode
  T onLight(T style) {
    return variant(ContextVariant.brightness(Brightness.light), style);
  }

  /// Creates a variant for hover state
  T onHovered(T style) {
    return variant(ContextVariant.widgetState(WidgetState.hovered), style);
  }

  /// Creates a variant that applies styling based on the build context.
  ///
  /// The provided builder function receives a [BuildContext] and should return
  /// a style that will be applied when this variant is active.
  ///
  /// Example:
  /// ```dart
  /// BoxStyle().builder((context) {
  ///   final theme = Theme.of(context);
  ///   return BoxStyle().decoration.color(theme.primaryColor);
  /// })
  /// ```
  T builder(T Function(BuildContext context) fn) {
    // Create a VariantStyle with ContextVariantBuilder that will be resolved at runtime
    // Use this style as a placeholder; the actual style comes from the builder function
    return variants([VariantStyle<S>(ContextVariantBuilder<T>(fn), this)]);
  }

  /// Creates a variant for pressed state
  T onPressed(T style) {
    return variant(ContextVariant.widgetState(WidgetState.pressed), style);
  }

  /// Creates a variant for focus state
  T onFocused(T style) {
    return variant(ContextVariant.widgetState(WidgetState.focused), style);
  }

  /// Creates a variant for disabled state
  T onDisabled(T style) {
    return variant(ContextVariant.widgetState(WidgetState.disabled), style);
  }

  /// Creates a variant for selected state
  T onSelected(T style) {
    return variant(ContextVariant.widgetState(WidgetState.selected), style);
  }

  /// Creates a variant for error state
  T onError(T style) {
    return variant(ContextVariant.widgetState(WidgetState.error), style);
  }

  /// Creates a variant for scrolled under state
  T onScrolledUnder(T style) {
    return variant(
      ContextVariant.widgetState(WidgetState.scrolledUnder),
      style,
    );
  }

  /// Creates a variant for dragged state
  T onDragged(T style) {
    return variant(ContextVariant.widgetState(WidgetState.dragged), style);
  }

  /// Creates a variant for enabled state (opposite of disabled)
  T onEnabled(T style) {
    return variant(
      ContextVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
      style,
    );
  }

  /// Creates a variant for portrait orientation
  T onPortrait(T style) {
    return variant(ContextVariant.orientation(Orientation.portrait), style);
  }

  /// Creates a variant for landscape orientation
  T onLandscape(T style) {
    return variant(ContextVariant.orientation(Orientation.landscape), style);
  }

  /// Creates a variant for mobile breakpoint
  T onMobile(T style) {
    return variant(ContextVariant.mobile(), style);
  }

  /// Creates a variant for tablet breakpoint
  T onTablet(T style) {
    return variant(ContextVariant.tablet(), style);
  }

  /// Creates a variant for desktop breakpoint
  T onDesktop(T style) {
    return variant(ContextVariant.desktop(), style);
  }

  /// Creates a variant for left-to-right text direction
  T onLtr(T style) {
    return variant(ContextVariant.directionality(TextDirection.ltr), style);
  }

  /// Creates a variant for right-to-left text direction
  T onRtl(T style) {
    return variant(ContextVariant.directionality(TextDirection.rtl), style);
  }

  /// Creates a variant for iOS platform
  T onIos(T style) {
    return variant(ContextVariant.platform(TargetPlatform.iOS), style);
  }

  /// Creates a variant for Android platform
  T onAndroid(T style) {
    return variant(ContextVariant.platform(TargetPlatform.android), style);
  }

  /// Creates a variant for macOS platform
  T onMacos(T style) {
    return variant(ContextVariant.platform(TargetPlatform.macOS), style);
  }

  /// Creates a variant for Windows platform
  T onWindows(T style) {
    return variant(ContextVariant.platform(TargetPlatform.windows), style);
  }

  /// Creates a variant for Linux platform
  T onLinux(T style) {
    return variant(ContextVariant.platform(TargetPlatform.linux), style);
  }

  /// Creates a variant for Fuchsia platform
  T onFuchsia(T style) {
    return variant(ContextVariant.platform(TargetPlatform.fuchsia), style);
  }

  /// Creates a variant for web platform
  T onWeb(T style) {
    return variant(ContextVariant.web(), style);
  }

  T onBreakpoint(Breakpoint breakpoint, T style) {
    return variant(ContextVariant.breakpoint(breakpoint), style);
  }
}
