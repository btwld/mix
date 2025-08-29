import 'package:flutter/material.dart';

import '../specs/text/text_style.dart';

class TextScope extends StatelessWidget {
  const TextScope({required this.text, required this.child, super.key});

  static TextStyler? maybeOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_TextInheritedWidget>();

    return inheritedWidget?.text;
  }

  static TextStyler of(BuildContext context) {
    final TextStyler? result = maybeOf(context);
    assert(result != null, 'No TextScope found in context');

    return result!;
  }

  final TextStyler text;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final widgetSpec = text.resolve(context);
    final spec = widgetSpec.spec;

    return _TextInheritedWidget(
      text: text,
      child: DefaultTextStyle(
        style: spec.style ?? const TextStyle(),
        textAlign: spec.textAlign,
        softWrap: spec.softWrap ?? true,
        overflow: spec.overflow ?? TextOverflow.clip,
        maxLines: spec.maxLines,
        textWidthBasis: spec.textWidthBasis ?? TextWidthBasis.parent,
        textHeightBehavior: spec.textHeightBehavior,
        child: child,
      ),
    );
  }
}

class _TextInheritedWidget extends InheritedWidget {
  const _TextInheritedWidget({required this.text, required super.child});

  final TextStyler text;

  @override
  bool updateShouldNotify(_TextInheritedWidget oldWidget) {
    return text != oldWidget.text;
  }
}
