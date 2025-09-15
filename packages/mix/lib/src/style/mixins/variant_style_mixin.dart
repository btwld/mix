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
  T variant(VariantStyle<S> variantStyle) {
    return withVariants([variantStyle]);
  }

  @Deprecated('Use withVariants instead.')
  T variants(List<VariantStyle<S>> variantStyles) {
    return withVariants(variantStyles);
  }

  /// Must be implemented by the class using this mixin
  @override
  T withVariants(List<VariantStyle<S>> value);

  /// Creates a variant for dark mode
  T onDark(T style) {
    return withVariants([
      ContextVariantStyle<S>(ContextVariant.brightness(Brightness.dark), style),
    ]);
  }

  T onNot(ContextVariant variantTrigger, T style) {
    return withVariants([
      ContextVariantStyle<S>(ContextVariant.not(variantTrigger), style),
    ]);
  }

  /// Creates a variant for light mode
  T onLight(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.brightness(Brightness.light),
        style,
      ),
    ]);
  }

  /// Creates a variant for hover state
  T onHovered(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.widgetState(WidgetState.hovered),
        style,
      ),
    ]);
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
    // Create a VariantStyle with VariantStyleBuilder that will be resolved at runtime
    // Use this style as a placeholder; the actual style comes from the builder function
    return withVariants([VariantStyleBuilder<S>((context) => fn(context))]);
  }

  @Deprecated(
    'Use onBuilder instead. This method will be removed in a future version.',
  )
  T builder(T Function(BuildContext context) fn) {
    return onBuilder(fn);
  }

  /// Creates a variant for pressed state
  T onPressed(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.widgetState(WidgetState.pressed),
        style,
      ),
    ]);
  }

  /// Creates a variant for focused state
  T onFocused(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.widgetState(WidgetState.focused),
        style,
      ),
    ]);
  }

  /// Creates a variant for disabled state
  T onDisabled(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.widgetState(WidgetState.disabled),
        style,
      ),
    ]);
  }

  /// Creates a variant for selected state
  T onSelected(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.widgetState(WidgetState.selected),
        style,
      ),
    ]);
  }

  /// Creates a variant for error state
  T onError(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.widgetState(WidgetState.error),
        style,
      ),
    ]);
  }

  /// Creates a variant for scrolled under state
  T onScrolledUnder(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.widgetState(WidgetState.scrolledUnder),
        style,
      ),
    ]);
  }

  /// Creates a variant for dragged state
  T onDragged(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.widgetState(WidgetState.dragged),
        style,
      ),
    ]);
  }

  /// Creates a variant for enabled state (opposite of disabled)
  T onEnabled(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.not(ContextVariant.widgetState(WidgetState.disabled)),
        style,
      ),
    ]);
  }

  /// Creates a variant based on breakpoint
  T onBreakpoint(Breakpoint breakpoint, T style) {
    return withVariants([
      ContextVariantStyle<S>(ContextVariant.breakpoint(breakpoint), style),
    ]);
  }

  /// Creates a variant for portrait orientation
  T onPortrait(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.orientation(Orientation.portrait),
        style,
      ),
    ]);
  }

  /// Creates a variant for landscape orientation
  T onLandscape(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.orientation(Orientation.landscape),
        style,
      ),
    ]);
  }

  /// Creates a variant for mobile breakpoint
  T onMobile(T style) {
    return withVariants([
      ContextVariantStyle<S>(ContextVariant.mobile(), style),
    ]);
  }

  /// Creates a variant for tablet breakpoint
  T onTablet(T style) {
    return withVariants([
      ContextVariantStyle<S>(ContextVariant.tablet(), style),
    ]);
  }

  /// Creates a variant for desktop breakpoint
  T onDesktop(T style) {
    return withVariants([
      ContextVariantStyle<S>(ContextVariant.desktop(), style),
    ]);
  }

  /// Creates a variant for left-to-right text direction
  T onLtr(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.directionality(TextDirection.ltr),
        style,
      ),
    ]);
  }

  /// Creates a variant for right-to-left text direction
  T onRtl(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.directionality(TextDirection.rtl),
        style,
      ),
    ]);
  }

  /// Creates a variant for iOS platform
  T onIos(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.platform(TargetPlatform.iOS),
        style,
      ),
    ]);
  }

  /// Creates a variant for Android platform
  T onAndroid(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.platform(TargetPlatform.android),
        style,
      ),
    ]);
  }

  /// Creates a variant for macOS platform
  T onMacos(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.platform(TargetPlatform.macOS),
        style,
      ),
    ]);
  }

  /// Creates a variant for Windows platform
  T onWindows(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.platform(TargetPlatform.windows),
        style,
      ),
    ]);
  }

  /// Creates a variant for Linux platform
  T onLinux(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.platform(TargetPlatform.linux),
        style,
      ),
    ]);
  }

  /// Creates a variant for Fuchsia platform
  T onFuchsia(T style) {
    return withVariants([
      ContextVariantStyle<S>(
        ContextVariant.platform(TargetPlatform.fuchsia),
        style,
      ),
    ]);
  }

  /// Creates a variant for web platform
  T onWeb(T style) {
    return withVariants([ContextVariantStyle<S>(ContextVariant.web(), style)]);
  }
}
