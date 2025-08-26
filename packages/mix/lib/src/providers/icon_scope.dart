import 'package:flutter/material.dart';

import '../specs/icon/icon_mix.dart';

class IconScope extends StatelessWidget {
  const IconScope({required this.icon, required this.child, super.key});

  static IconMix? maybeOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_IconInheritedWidget>();

    return inheritedWidget?.icon;
  }

  static IconMix of(BuildContext context) {
    final IconMix? result = maybeOf(context);
    assert(result != null, 'No IconScope found in context');

    return result!;
  }

  final IconMix icon;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spec = icon.resolve(context);

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
  const _IconInheritedWidget({required this.icon, required super.child});

  final IconMix icon;

  @override
  bool updateShouldNotify(_IconInheritedWidget oldWidget) {
    return icon != oldWidget.icon;
  }
}
