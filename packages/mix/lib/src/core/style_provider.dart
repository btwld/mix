import 'package:flutter/widgets.dart';

import 'factory/style_mix.dart';
import 'spec.dart';

/// Provides unresolved styles to descendant widgets for inheritance.
class StyleProvider<S extends Spec<S>> extends InheritedWidget {
  const StyleProvider({super.key, required this.style, required super.child});

  static StyleElement<S>? of<S extends Spec<S>>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<StyleProvider<S>>();

    return provider?.style;
  }

  static StyleElement<S>? maybeOf<S extends Spec<S>>(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<StyleProvider<S>>();

    return provider?.style;
  }

  final StyleElement<S> style;

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

  static Style? of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<MultiStyleProvider>();

    return provider?.style;
  }

  static Style? maybeOf(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<MultiStyleProvider>();

    return provider?.style;
  }

  final Style style;

  @override
  bool updateShouldNotify(MultiStyleProvider oldWidget) {
    return style != oldWidget.style;
  }
}
