import 'package:flutter/widgets.dart';

import '../spec.dart';
import '../style.dart';

/// Provides unresolved styles to descendant widgets for inheritance.
class StyleProvider<S extends Spec<S>> extends InheritedWidget {
  const StyleProvider({super.key, required this.style, required super.child});

  static Style<S>? maybeOf<S extends Spec<S>>(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<StyleProvider<S>>();

    return provider?.style;
  }

  final Style<S> style;

  @override
  bool updateShouldNotify(StyleProvider<S> oldWidget) {
    return style != oldWidget.style;
  }
}

