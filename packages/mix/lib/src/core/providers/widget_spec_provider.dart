import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../widget_spec.dart';

/// Provides a resolved WidgetSpec<S> to descendant widgets.
class WidgetSpecProvider<S extends WidgetSpec<T>, T extends Spec<T>> extends InheritedWidget {
  const WidgetSpecProvider({
    super.key,
    required this.spec,
    required super.child,
  });

  static S? of<S extends WidgetSpec<T>, T extends Spec<T>>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<WidgetSpecProvider<S, T>>();

    return provider?.spec;
  }

  final S spec;

  @override
  bool updateShouldNotify(covariant WidgetSpecProvider<S, T> oldWidget) =>
      spec != oldWidget.spec;
}
