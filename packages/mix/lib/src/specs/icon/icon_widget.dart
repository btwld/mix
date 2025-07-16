import 'package:flutter/material.dart';

import '../../core/animated_spec_widget.dart';
import '../../core/spec_widget.dart';
import '../../core/styled_widget.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import 'icon_spec.dart';

class StyledIcon extends StyledWidget {
  const StyledIcon(
    this.icon, {
    this.semanticLabel,
    super.style,
    super.key,
    super.inherit = true,
    this.textDirection,
    @Deprecated('Use orderOfModifiers parameter instead')
    List<Type> modifierOrder = const <Type>[],
    super.orderOfModifiers = const <Type>[],
  });

  final IconData? icon;
  final String? semanticLabel;
  // TODO: Should textDirection be a contructor argument or a style attribute?
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      inherit: inherit,
      style: style,
      orderOfModifiers: orderOfModifiers,
      builder: (context) {
        final spec = IconSpec.of(context);

        return IconSpecWidget(
          icon,
          spec: spec,
          semanticLabel: semanticLabel,
          textDirection: textDirection,
          orderOfModifiers: orderOfModifiers,
        );
      },
    );
  }
}

class IconSpecWidget extends SpecWidget<IconSpec> {
  const IconSpecWidget(
    this.icon, {
    super.spec,
    this.semanticLabel,
    super.key,
    this.textDirection,
    @Deprecated('Use orderOfModifiers parameter instead')
    List<Type> modifierOrder = const <Type>[],
    this.orderOfModifiers = const <Type>[],
  });

  final IconData? icon;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context) {
    return RenderSpecModifiers(
      spec: spec ?? const IconSpec(),
      orderOfModifiers: orderOfModifiers,
      child: Icon(
        icon,
        size: spec?.size,
        fill: spec?.fill,
        weight: spec?.weight,
        grade: spec?.grade,
        opticalSize: spec?.opticalSize,
        color: spec?.color,
        shadows: spec?.shadows,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
      ),
    );
  }
}

class AnimatedStyledIcon extends StyledWidget {
  const AnimatedStyledIcon(
    this.icon, {
    this.semanticLabel,
    super.style,
    super.key,
    required this.progress,
    super.inherit,
    this.textDirection,
    @Deprecated('Use orderOfModifiers parameter instead')
    List<Type> modifierOrder = const <Type>[],
    super.orderOfModifiers = const <Type>[],
  });

  final AnimatedIconData icon;
  final String? semanticLabel;
  final Animation<double> progress;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      inherit: inherit,
      style: style,
      orderOfModifiers: orderOfModifiers,
      builder: (context) {
        final spec = IconSpec.of(context);

        return AnimatedIcon(
          icon: icon,
          progress: progress,
          color: spec.color,
          size: spec.size,
          semanticLabel: semanticLabel,
          textDirection: textDirection,
        );
      },
    );
  }
}

class AnimatedIconSpecWidget extends ImplicitlyAnimatedSpecWidget<IconSpec> {
  const AnimatedIconSpecWidget(
    this.icon, {
    required super.spec,
    super.key,
    this.semanticLabel,
    this.textDirection,
    super.curve,
    required super.duration,
    super.onEnd,
    @Deprecated('Use orderOfModifiers parameter instead')
    List<Type> modifierOrder = const <Type>[],
    this.orderOfModifiers = const <Type>[],
  });

  final IconData? icon;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context, IconSpec animatedSpec) {
    return IconSpecWidget(
      icon,
      spec: animatedSpec,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      orderOfModifiers: orderOfModifiers,
    );
  }
}
