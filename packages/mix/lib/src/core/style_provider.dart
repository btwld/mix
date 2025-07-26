import 'package:flutter/widgets.dart';

import 'spec.dart';
import 'style.dart';

/// Provides unresolved styles to descendant widgets for inheritance.
class StyleProvider<S extends Spec<S>> extends InheritedWidget {
  const StyleProvider({super.key, required this.style, required super.child});

  static StyleAttribute<S>? of<S extends Spec<S>>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<StyleProvider<S>>();

    return provider?.style;
  }

  static StyleAttribute<S>? maybeOf<S extends Spec<S>>(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<StyleProvider<S>>();

    return provider?.style;
  }

  final StyleAttribute<S> style;

  @override
  bool updateShouldNotify(StyleProvider<S> oldWidget) {
    return style != oldWidget.style;
  }
}

/// Provides multiple style types for widgets that use MultiSpec
class MultiStyleProvider extends InheritedWidget {
  const MultiStyleProvider({
    super.key,
    required this.style,
    required super.child,
  });

  static StyleAttribute? of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<MultiStyleProvider>();

    return provider?.style;
  }

  static StyleAttribute? maybeOf(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<MultiStyleProvider>();

    return provider?.style;
  }

  final StyleAttribute style;

  @override
  bool updateShouldNotify(MultiStyleProvider oldWidget) {
    return style != oldWidget.style;
  }
}
