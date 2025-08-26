import 'package:flutter/widgets.dart';

import '../widget_spec.dart';

/// Provides a resolved WidgetSpec<S> to descendant widgets.
class WidgetSpecProvider<S extends WidgetSpec<S>> extends InheritedWidget {
  const WidgetSpecProvider({
    super.key,
    required this.spec,
    required super.child,
  });

  static S? of<S extends WidgetSpec<S>>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<WidgetSpecProvider<S>>();

    return provider?.spec;
  }

  final S spec;

  @override
  bool updateShouldNotify(covariant WidgetSpecProvider<S> oldWidget) =>
      spec != oldWidget.spec;
}
