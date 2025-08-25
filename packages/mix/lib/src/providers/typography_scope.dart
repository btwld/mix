import 'package:flutter/material.dart';

import '../properties/typography/typography_mix.dart';

class TypographyScope extends StatelessWidget {
  const TypographyScope({
    required this.typography,
    required this.child,
    super.key,
  });

  static TypographyMix? maybeOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_TypographyInheritedWidget>();

    return inheritedWidget?.typography;
  }

  static TypographyMix of(BuildContext context) {
    final TypographyMix? result = maybeOf(context);
    assert(result != null, 'No TypographyScope found in context');

    return result!;
  }

  final TypographyMix typography;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spec = typography.resolve(context);

    return _TypographyInheritedWidget(
      typography: typography,
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

class _TypographyInheritedWidget extends InheritedWidget {
  const _TypographyInheritedWidget({
    required this.typography,
    required super.child,
  });

  final TypographyMix typography;

  @override
  bool updateShouldNotify(_TypographyInheritedWidget oldWidget) {
    return typography != oldWidget.typography;
  }
}
