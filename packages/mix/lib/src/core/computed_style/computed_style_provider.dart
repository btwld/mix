import 'package:flutter/widgets.dart';

import '../spec.dart';
import 'computed_style.dart';

/// Provides [ComputedStyle] with selective dependency tracking for performance.
///
/// Enables widgets to depend only on specific spec types, rebuilding only when
/// those particular specs change rather than when any part of the style changes.
/// This provides surgical rebuilds for optimal performance.
class ComputedStyleProvider extends InheritedModel<Type> {
  const ComputedStyleProvider({
    required this.style,
    required super.child,
    super.key,
  });

  /// Returns the spec of type [T] with selective dependency tracking.
  ///
  /// Widgets using this method only rebuild when the specific spec type [T]
  /// changes, not when other unrelated specs change.
  static T? specOf<T extends Spec<T>>(BuildContext context) {
    final provider = InheritedModel.inheritFrom<ComputedStyleProvider>(
      context,
      aspect: T, // Only rebuild when T changes
    );

    return provider?.style.specOf();
  }

  /// Returns the [ComputedStyle] with full dependency, or null if not found.
  ///
  /// Widgets using this method rebuild when any part of the computed style changes.
  static ComputedStyle? maybeOf(BuildContext context) {
    return InheritedModel.inheritFrom<ComputedStyleProvider>(context)?.style;
  }

  /// Returns the [ComputedStyle] with full dependency, throws if not found.
  ///
  /// Widgets using this method rebuild when any part of the computed style changes.
  static ComputedStyle of(BuildContext context) {
    final computedStyle = maybeOf(context);
    assert(computedStyle != null,
        'ComputedStyleProvider not found in widget tree.');

    return computedStyle!;
  }

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
