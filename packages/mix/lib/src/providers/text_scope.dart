import 'package:flutter/material.dart';

import '../specs/text/text_style.dart';

/// Provides text styling context to descendant widgets.
///
/// Wraps its child in a [DefaultTextStyle] with the resolved text styling
/// and makes the text style available through inheritance.
class TextScope extends StatelessWidget {
  const TextScope({required this.text, required this.child, super.key});

  /// Gets the closest [TextStyler] from the widget tree, or null if not found.
  static TextStyler? maybeOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_TextInheritedWidget>();

    return inheritedWidget?.text;
  }

  /// Gets the closest [TextStyler] from the widget tree.
  ///
  /// Throws an assertion error if no TextScope is found.
  static TextStyler of(BuildContext context) {
    final TextStyler? result = maybeOf(context);
    assert(result != null, 'No TextScope found in context');

    return result!;
  }

  /// The text style to provide to descendant widgets.
  final TextStyler text;

  /// The widget below this widget in the tree.
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
        overflow: spec.overflow ?? .clip,
        maxLines: spec.maxLines,
        textWidthBasis: spec.textWidthBasis ?? .parent,
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
