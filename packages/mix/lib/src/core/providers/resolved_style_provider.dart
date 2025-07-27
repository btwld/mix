import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../style.dart';

/// Provides resolved style to descendant widgets.
///
/// This InheritedWidget makes a [ResolvedStyle] available to its descendants,
/// allowing them to access the resolved styling information without needing
/// to resolve it themselves.
class ResolvedStyleProvider<S extends Spec<S>> extends InheritedWidget {
  const ResolvedStyleProvider({
    super.key,
    required this.resolvedStyle,
    required super.child,
  });

  /// Retrieves the [ResolvedStyle] from the nearest [ResolvedStyleProvider]
  /// ancestor in the widget tree.
  ///
  /// Returns null if no [ResolvedStyleProvider] of the specified type is found.
  static ResolvedStyle<S>? of<S extends Spec<S>>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<ResolvedStyleProvider<S>>();

    return provider?.resolvedStyle;
  }

  /// The resolved style to provide to descendants.
  final ResolvedStyle<S> resolvedStyle;

  @override
  bool updateShouldNotify(ResolvedStyleProvider<S> oldWidget) {
    return resolvedStyle != oldWidget.resolvedStyle;
  }
}
