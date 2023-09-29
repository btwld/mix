import 'package:flutter/material.dart';

import '../../attributes/shared/shared.descriptor.dart';
import '../../factory/mix_provider_data.dart';
import '../decorator.dart';

class OpacityDecorator extends WidgetDecorator<OpacityDecorator> {
  final double opacity;
  const OpacityDecorator({
    required this.opacity,
    super.key,
  });

  @override
  OpacityDecorator merge(OpacityDecorator other) {
    return OpacityDecorator(opacity: other.opacity);
  }

  @override
  Widget build(MixData mix, Widget child) {
    final common = CommonDescriptor.fromContext(mix);

    return common.animated
        ? AnimatedOpacity(
            key: key,
            duration: common.animationDuration,
            curve: common.animationCurve,
            opacity: opacity,
            child: child,
          )
        : Opacity(
            key: key,
            opacity: opacity,
            child: child,
          );
  }

  @override
  get props => [opacity];
}
