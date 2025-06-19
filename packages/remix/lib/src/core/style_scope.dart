import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

class StyleScope<U extends SpecUtility> extends InheritedWidget {
  const StyleScope({super.key, required super.child, required this.style});

  static U? of<U extends SpecUtility>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StyleScope<U>>()?.style;
  }

  final U? style;

  @override
  bool updateShouldNotify(StyleScope<U> oldWidget) {
    return style != oldWidget.style;
  }
}
