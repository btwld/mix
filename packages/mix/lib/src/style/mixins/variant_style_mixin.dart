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
  /// Adds a single variant to this style.
  T variant(Variant variant, T style) {
    return variants([VariantStyle<S>(variant, style)]);
  }

  /// Sets the list of variant styles. Must be implemented by the class using this mixin.
  T variants(List<VariantStyle<S>> value);

  /// Applies the specified named variants by merging their styles into this style.
  ///
  /// This method finds all [VariantStyle]s matching the given [NamedVariant]s
  /// and merges their styles into the base style. The applied variants remain
  /// in `$variants` but this is harmless - they only re-apply when explicitly
  /// passed to `namedVariants` in `build()`, which widgets don't do by default.
  ///
  /// Returns the concrete type [T], enabling method chaining:
  /// ```dart
  /// final style = BoxStyler()
  ///   .variant(small, BoxStyler().width(100))
  ///   .variant(primary, BoxStyler().color(Colors.blue));
  ///
  /// // Apply and chain:
  /// style.applyVariants([small]).onHovered(BoxStyler().opacity(0.8))
  /// ```
  T applyVariants(Iterable<NamedVariant> variantsToApply) {
    final variantsSet = variantsToApply.toSet();

    var result = this as T;
    for (final vs in $variants ?? <VariantStyle<S>>[]) {
      if (vs.variant is NamedVariant && variantsSet.contains(vs.variant)) {
        // ignore: avoid-unnecessary-type-casts
        result = result.merge(vs.value as T) as T;
      }
    }

    return result;
  }

  /// Creates a variant for dark mode.
  T onDark(T style) {
    return variant(ContextVariant.brightness(.dark), style);
  }

  /// Creates a variant for when the context does NOT match the provided variant.
  T onNot(ContextVariant contextVariant, T style) {
    return variant(ContextVariant.not(contextVariant), style);
  }

  /// Creates a variant for light mode.
  T onLight(T style) {
    return variant(ContextVariant.brightness(.light), style);
  }

  /// Creates a variant using a builder function that receives the build context.
  T onBuilder(T Function(BuildContext context) fn) {
    // Create a VariantStyle with ContextVariantBuilder that will be resolved at runtime
    // Use this style as a placeholder; the actual style comes from the builder function
    return variants([VariantStyle<S>(ContextVariantBuilder<T>(fn), this)]);
  }

  /// Deprecated: Use [onBuilder] instead.
  @Deprecated(
    'Use onBuilder instead. This method will be removed in a future version.',
  )
  T builder(T Function(BuildContext context) fn) {
    return onBuilder(fn);
  }

  /// Creates a variant based on the specified breakpoint.
  T onBreakpoint(Breakpoint breakpoint, T style) {
    return variant(ContextVariant.breakpoint(breakpoint), style);
  }

  /// Creates a variant for portrait device orientation.
  T onPortrait(T style) {
    return variant(ContextVariant.orientation(.portrait), style);
  }

  /// Creates a variant for landscape device orientation.
  T onLandscape(T style) {
    return variant(ContextVariant.orientation(.landscape), style);
  }

  /// Creates a variant for mobile breakpoint.
  T onMobile(T style) {
    return variant(ContextVariant.mobile(), style);
  }

  /// Creates a variant for tablet breakpoint.
  T onTablet(T style) {
    return variant(ContextVariant.tablet(), style);
  }

  /// Creates a variant for desktop breakpoint.
  T onDesktop(T style) {
    return variant(ContextVariant.desktop(), style);
  }

  /// Creates a variant for left-to-right text direction.
  T onLtr(T style) {
    return variant(ContextVariant.directionality(.ltr), style);
  }

  /// Creates a variant for right-to-left text direction.
  T onRtl(T style) {
    return variant(ContextVariant.directionality(.rtl), style);
  }

  /// Creates a variant for iOS platform.
  T onIos(T style) {
    return variant(ContextVariant.platform(.iOS), style);
  }

  /// Creates a variant for Android platform.
  T onAndroid(T style) {
    return variant(ContextVariant.platform(.android), style);
  }

  /// Creates a variant for macOS platform.
  T onMacos(T style) {
    return variant(ContextVariant.platform(.macOS), style);
  }

  /// Creates a variant for Windows platform.
  T onWindows(T style) {
    return variant(ContextVariant.platform(.windows), style);
  }

  /// Creates a variant for Linux platform.
  T onLinux(T style) {
    return variant(ContextVariant.platform(.linux), style);
  }

  /// Creates a variant for Fuchsia platform.
  T onFuchsia(T style) {
    return variant(ContextVariant.platform(.fuchsia), style);
  }

  /// Creates a variant for web platform.
  T onWeb(T style) {
    return variant(ContextVariant.web(), style);
  }
}
