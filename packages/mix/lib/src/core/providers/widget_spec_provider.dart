import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../widget_spec.dart';

/// Provides a resolved StyleSpec<S> to descendant widgets.
class StyleSpecProvider<T extends Spec<T>> extends InheritedWidget {
  const StyleSpecProvider({
    super.key,
    required this.spec,
    required super.child,
  });

  static StyleSpec<T>? of<T extends Spec<T>>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<StyleSpecProvider<T>>();

    return provider?.spec;
  }

  final StyleSpec<T> spec;

  @override
  bool updateShouldNotify(covariant StyleSpecProvider<T> oldWidget) =>
      spec != oldWidget.spec;
}
