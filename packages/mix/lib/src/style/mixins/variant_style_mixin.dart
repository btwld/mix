import 'package:flutter/material.dart';

import '../../core/breakpoint.dart';
import '../../core/spec.dart';
import '../../core/style.dart';
import '../../variants/variant.dart';

/// Mixin that provides convenient variant styling methods for spec attributes.
///
/// This mixin follows the same pattern as ModifierMixin, providing
/// a fluent API for applying context variants to spec attributes.
mixin VariantStyleMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
  T variant(Variant variant, T style) {
    return variants([VariantStyle<S>(variant, style)]);
  }

  /// Must be implemented by the class using this mixin
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
  /// BoxStyle().onBuilder((context) {
  ///   final theme = Theme.of(context);
  ///   return BoxStyle().decoration.color(theme.primaryColor);
  /// })
  /// ```
  T onBuilder(T Function(BuildContext context) fn) {
    // Create a VariantStyle with ContextVariantBuilder that will be resolved at runtime
    // Use this style as a placeholder; the actual style comes from the builder function
    return variants([VariantStyle<S>(ContextVariantBuilder<T>(fn), this)]);
  }

  @Deprecated('Use onBuilder instead. This method will be removed in a future version.')
  T builder(T Function(BuildContext context) fn) {
    return onBuilder(fn);
  }

  /// Creates a variant for pressed state
  T onPressed(T style) {
    return variant(ContextVariant.widgetState(WidgetState.pressed), style);
  }

  /// Creates a variant for focused state
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

  /// Creates a variant based on breakpoint
  T onBreakpoint(Breakpoint breakpoint, T style) {
    return variant(ContextVariant.breakpoint(breakpoint), style);
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
}
