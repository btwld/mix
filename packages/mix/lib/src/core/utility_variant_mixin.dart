import 'package:flutter/material.dart';

import '../variants/variant.dart';
import 'breakpoint.dart';
import 'spec.dart';
import 'style.dart';

/// Mixin providing variant methods for utility classes.
///
/// This mixin provides variant methods for styling utilities with a simple
/// delegation approach. All methods return Style types for consistency
/// with other utility methods like animate().
mixin UtilityVariantMixin<T extends Style<S>, S extends Spec<S>> {
  /// Must be implemented by utilities to apply a variant to a style.
  T withVariant(Variant variant, T style);

  /// Must be implemented by utilities to apply multiple variants to a style.
  T withVariants(List<VariantStyle<S>> variants);

  /// Gets the current utility value as a style.
  T get currentValue;

  /// Creates a variant for dark mode.
  ///
  /// Example:
  /// ```dart
  /// $box.onDark($box.color.white())
  /// ```
  T onDark(T style) {
    return withVariant(ContextVariant.brightness(Brightness.dark), style);
  }

  /// Creates a variant for light mode.
  ///
  /// Example:
  /// ```dart
  /// $box.onLight($box.color.black())
  /// ```
  T onLight(T style) {
    return withVariant(ContextVariant.brightness(Brightness.light), style);
  }

  /// Creates a variant that applies styling based on the build context.
  ///
  /// The provided builder function receives a [BuildContext] and should return
  /// a style that will be applied when this variant is active.
  ///
  /// Example:
  /// ```dart
  /// $box.onBuilder((context) {
  ///   final theme = Theme.of(context);
  ///   return $box.color(theme.primaryColor);
  /// })
  /// ```
  T onBuilder(T Function(BuildContext context) fn) {
    return withVariants([
      VariantStyle<S>(ContextVariantBuilder<T>(fn), currentValue),
    ]);
  }

  /// Creates a variant for when the context does NOT match the provided variant.
  ///
  /// Example:
  /// ```dart
  /// $box.onNot(ContextVariant.brightness(Brightness.dark), $box.color.black())
  /// ```
  T onNot(ContextVariant contextVariant, T style) {
    return withVariant(ContextVariant.not(contextVariant), style);
  }

  /// Creates a variant based on the specified breakpoint.
  ///
  /// Example:
  /// ```dart
  /// $box.onBreakpoint(Breakpoint(minWidth: 600), $box.width(400))
  /// ```
  T onBreakpoint(Breakpoint breakpoint, T style) {
    return withVariant(ContextVariant.breakpoint(breakpoint), style);
  }

  /// Creates a variant for portrait device orientation.
  ///
  /// Example:
  /// ```dart
  /// $box.onPortrait($box.width(300))
  /// ```
  T onPortrait(T style) {
    return withVariant(ContextVariant.orientation(Orientation.portrait), style);
  }

  /// Creates a variant for landscape device orientation.
  ///
  /// Example:
  /// ```dart
  /// $box.onLandscape($box.width(600))
  /// ```
  T onLandscape(T style) {
    return withVariant(
      ContextVariant.orientation(Orientation.landscape),
      style,
    );
  }

  /// Creates a variant for mobile breakpoint.
  ///
  /// Example:
  /// ```dart
  /// $box.onMobile($box.padding(8))
  /// ```
  T onMobile(T style) {
    return withVariant(ContextVariant.mobile(), style);
  }

  /// Creates a variant for tablet breakpoint.
  ///
  /// Example:
  /// ```dart
  /// $box.onTablet($box.padding(16))
  /// ```
  T onTablet(T style) {
    return withVariant(ContextVariant.tablet(), style);
  }

  /// Creates a variant for desktop breakpoint.
  ///
  /// Example:
  /// ```dart
  /// $box.onDesktop($box.padding(24))
  /// ```
  T onDesktop(T style) {
    return withVariant(ContextVariant.desktop(), style);
  }

  /// Creates a variant for left-to-right text direction.
  ///
  /// Example:
  /// ```dart
  /// $box.onLtr($box.padding.left(16))
  /// ```
  T onLtr(T style) {
    return withVariant(ContextVariant.directionality(TextDirection.ltr), style);
  }

  /// Creates a variant for right-to-left text direction.
  ///
  /// Example:
  /// ```dart
  /// $box.onRtl($box.padding.right(16))
  /// ```
  T onRtl(T style) {
    return withVariant(ContextVariant.directionality(TextDirection.rtl), style);
  }

  /// Creates a variant for iOS platform.
  ///
  /// Example:
  /// ```dart
  /// $box.onIos($box.decoration.borderRadius(20))
  /// ```
  T onIos(T style) {
    return withVariant(ContextVariant.platform(TargetPlatform.iOS), style);
  }

  /// Creates a variant for Android platform.
  ///
  /// Example:
  /// ```dart
  /// $box.onAndroid($box.decoration.borderRadius(4))
  /// ```
  T onAndroid(T style) {
    return withVariant(ContextVariant.platform(TargetPlatform.android), style);
  }

  /// Creates a variant for macOS platform.
  ///
  /// Example:
  /// ```dart
  /// $box.onMacos($box.decoration.borderRadius(8))
  /// ```
  T onMacos(T style) {
    return withVariant(ContextVariant.platform(TargetPlatform.macOS), style);
  }

  /// Creates a variant for Windows platform.
  ///
  /// Example:
  /// ```dart
  /// $box.onWindows($box.decoration.borderRadius(0))
  /// ```
  T onWindows(T style) {
    return withVariant(ContextVariant.platform(TargetPlatform.windows), style);
  }

  /// Creates a variant for Linux platform.
  ///
  /// Example:
  /// ```dart
  /// $box.onLinux($box.decoration.borderRadius(4))
  /// ```
  T onLinux(T style) {
    return withVariant(ContextVariant.platform(TargetPlatform.linux), style);
  }

  /// Creates a variant for Fuchsia platform.
  ///
  /// Example:
  /// ```dart
  /// $box.onFuchsia($box.decoration.borderRadius(8))
  /// ```
  T onFuchsia(T style) {
    return withVariant(ContextVariant.platform(TargetPlatform.fuchsia), style);
  }

  /// Creates a variant for web platform.
  ///
  /// Example:
  /// ```dart
  /// $box.onWeb($box.decoration.borderRadius(4))
  /// ```
  T onWeb(T style) {
    return withVariant(ContextVariant.web(), style);
  }

  @Deprecated(
    'Use onBuilder instead. This method will be removed in a future version.',
  )
  T builder(T Function(BuildContext context) fn) {
    return onBuilder(fn);
  }
}
