import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:mix/mix.dart';

@internal
class StyleScope<U extends SpecUtility> extends InheritedWidget {
  const StyleScope({
    super.key,
    required super.child,
    required this.style,
    this.variants = const [],
  });

  static StyleScope<U>? of<U extends SpecUtility>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StyleScope<U>>();
  }

  final U style;
  final List<Variant> variants;

  @override
  bool updateShouldNotify(StyleScope<U> oldWidget) {
    return style != oldWidget.style;
  }
}
