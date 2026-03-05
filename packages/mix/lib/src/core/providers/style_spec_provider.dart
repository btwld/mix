import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../style_spec.dart';

/// Provides a resolved StyleSpec<S> to descendant widgets.
class StyleSpecProvider<T extends Spec<T>> extends InheritedWidget {
  /// The resolved style spec provided to descendant widgets.
  final StyleSpec<T> spec;

  const StyleSpecProvider({
    super.key,
    required this.spec,
    required super.child,
  });

  /// Gets the closest [StyleSpec] from the widget tree.
  ///
  /// Creates a dependency on the provider, causing rebuilds when the spec changes.
  static StyleSpec<T>? of<T extends Spec<T>>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<StyleSpecProvider<T>>();

    return provider?.spec;
  }

  @override
  bool updateShouldNotify(covariant StyleSpecProvider<T> oldWidget) =>
      spec != oldWidget.spec;
}
