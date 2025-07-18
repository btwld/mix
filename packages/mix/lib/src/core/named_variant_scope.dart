import 'package:flutter/widgets.dart';

import 'variant.dart';

/// Provides named variants to descendant widgets.
///
/// Named variants are applied explicitly and allow widgets to conditionally
/// apply different styling based on provided variant names.
class NamedVariantScope extends InheritedWidget {
  const NamedVariantScope({
    super.key,
    required this.variants,
    required super.child,
  });

  /// Get the active named variants from the nearest NamedVariantScope ancestor
  static Set<NamedVariant> of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<NamedVariantScope>();

    return scope?.variants ?? const {};
  }

  /// Get the active named variants without establishing a dependency
  static Set<NamedVariant> maybeOf(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<NamedVariantScope>();

    return scope?.variants ?? const {};
  }

  /// Check if a specific named variant is active
  static bool hasVariant(BuildContext context, NamedVariant variant) {
    return of(context).contains(variant);
  }

  /// Apply additional variants to the current scope
  static Widget merge({
    required Set<NamedVariant> variants,
    required Widget child,
  }) {
    return Builder(
      builder: (context) {
        final existingVariants = maybeOf(context);

        return NamedVariantScope(
          variants: {...existingVariants, ...variants},
          child: child,
        );
      },
    );
  }

  /// The set of active named variants
  final Set<NamedVariant> variants;

  @override
  bool updateShouldNotify(NamedVariantScope oldWidget) {
    return variants != oldWidget.variants;
  }
}
