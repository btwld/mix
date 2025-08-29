import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../widget_spec.dart';

/// Provides a resolved WidgetSpec<S> to descendant widgets.
class WidgetSpecProvider<T extends Spec<T>> extends InheritedWidget {
  const WidgetSpecProvider({
    super.key,
    required this.spec,
    required super.child,
  });

  static WidgetSpec<T>? of<T extends Spec<T>>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<WidgetSpecProvider<T>>();

    return provider?.spec;
  }

  final WidgetSpec<T> spec;

  @override
  bool updateShouldNotify(covariant WidgetSpecProvider<T> oldWidget) =>
      spec != oldWidget.spec;
}
