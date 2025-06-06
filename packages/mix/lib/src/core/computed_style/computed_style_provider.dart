import 'package:flutter/widgets.dart';

import 'computed_style.dart';

/// Provides [ComputedStyle] with selective dependency tracking for performance.
///
/// Enables widgets to depend only on specific spec types, rebuilding only when
/// those particular specs change rather than when any part of the style changes.
/// This provides surgical rebuilds for optimal performance.
///
/// Access ComputedStyle through [ComputedStyle.of], [ComputedStyle.maybeOf],
/// or [ComputedStyle.specOf] static methods.
class ComputedStyleProvider extends InheritedModel<Type> {
  const ComputedStyleProvider({
    required this.style,
    required super.child,
    super.key,
  });

  /// Computed style data provided to descendant widgets.
  final ComputedStyle style;

  @override
  bool updateShouldNotify(ComputedStyleProvider oldWidget) {
    return style != oldWidget.style;
  }

  @override
  bool updateShouldNotifyDependent(
    ComputedStyleProvider oldWidget,
    Set<Type> dependencies,
  ) {
    // Only notify if the specific spec types have changed
    for (final specType in dependencies) {
      final oldSpec = oldWidget.style.specOfType(specType);
      final newSpec = style.specOfType(specType);
      if (oldSpec != newSpec) {
        return true;
      }
    }

    return false;
  }
}
