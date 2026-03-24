import 'package:flutter/material.dart';

import '../specs/icon/icon_style.dart';

/// Provides icon styling context to descendant widgets.
///
/// Wraps its child in an [IconTheme] with the resolved icon styling
/// and makes the icon style available through inheritance.
class IconScope extends StatelessWidget {
  /// The icon style to provide to descendant widgets.
  final IconStyler icon;

  /// The widget below this widget in the tree.
  final Widget child;

  const IconScope({required this.icon, required this.child, super.key});

  /// Gets the closest [IconStyler] from the widget tree, or null if not found.
  static IconStyler? maybeOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_IconInheritedWidget>();

    return inheritedWidget?.icon;
  }

  /// Gets the closest [IconStyler] from the widget tree.
  ///
  /// Throws an assertion error if no IconScope is found.
  static IconStyler of(BuildContext context) {
    final IconStyler? result = maybeOf(context);
    assert(result != null, 'No IconScope found in context');

    return result!;
  }

  @override
  Widget build(BuildContext context) {
    final widgetSpec = icon.resolve(context);
    final spec = widgetSpec.spec;

    return _IconInheritedWidget(
      icon: icon,
      child: IconTheme(
        data: IconThemeData(
          size: spec.size,
          fill: spec.fill,
          weight: spec.weight,
          grade: spec.grade,
          opticalSize: spec.opticalSize,
          color: spec.color,
          opacity: spec.opacity,
          shadows: spec.shadows,
          applyTextScaling: spec.applyTextScaling,
        ),
        child: child,
      ),
    );
  }
}

class _IconInheritedWidget extends InheritedWidget {
  final IconStyler icon;

  const _IconInheritedWidget({required this.icon, required super.child});

  @override
  bool updateShouldNotify(_IconInheritedWidget oldWidget) {
    return icon != oldWidget.icon;
  }
}
