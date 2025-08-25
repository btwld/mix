import 'package:flutter/material.dart';

import '../properties/iconography/iconography_mix.dart';

class IconographyScope extends StatelessWidget {
  const IconographyScope({
    required this.iconography,
    required this.child,
    super.key,
  });

  static IconographyMix? maybeOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_IconographyInheritedWidget>();

    return inheritedWidget?.iconography;
  }

  static IconographyMix of(BuildContext context) {
    final IconographyMix? result = maybeOf(context);
    assert(result != null, 'No IconographyScope found in context');

    return result!;
  }

  final IconographyMix iconography;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spec = iconography.resolve(context);

    return _IconographyInheritedWidget(
      iconography: iconography,
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

class _IconographyInheritedWidget extends InheritedWidget {
  const _IconographyInheritedWidget({
    required this.iconography,
    required super.child,
  });

  final IconographyMix iconography;

  @override
  bool updateShouldNotify(_IconographyInheritedWidget oldWidget) {
    return iconography != oldWidget.iconography;
  }
}
