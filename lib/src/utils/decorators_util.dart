import 'package:flutter/material.dart';

import '../attributes/scalars/scalar_util.dart';
import '../decorators/clip_decorator.dart';
import '../decorators/default_decorators.dart';

const aspectRatio = AspectRatioDecorator.new;

const opacity = OpacityDecorator.new;
const flexible = FlexibleDecoratorUtility();

const rotate = RotateUtility();

const scale = ScaleDecorator.new;

const clipPath = ClipPathDecorator.new;
const clipOval = ClipOvalDecorator.new;
const clipRect = ClipRectDecorator.new;
const clipRRect = ClipRRectDecorator.new;
const visibility = VisibilityUtility();
final hidden = visibility.off;
final visible = visibility.on;

ClipPathDecorator clipTriangle({Clip? clipBehavior}) {
  return ClipPathDecorator(
    clipBehavior: clipBehavior,
    clipper: const TriangleClipper(),
  );
}

class FlexibleDecoratorUtility {
  const FlexibleDecoratorUtility();

  // FlexibleDecorator flexFit(FlexFit fit) => call(fit: fit);
  // FlexibleDecorator flex(int flex) => call(flex: flex);

  FlexibleDecorator tight([int? flex]) => call(flex: flex, fit: FlexFit.tight);
  FlexibleDecorator loose([int? flex]) => call(flex: flex, fit: FlexFit.loose);
  FlexibleDecorator expanded([int? flex]) => tight(flex);

  FlexibleDecorator call({int? flex, FlexFit? fit, Key? key}) {
    return FlexibleDecorator(flex: flex, fit: fit, key: key);
  }
}

class RotateUtility extends MixUtility<RotateDecorator, int> {
  const RotateUtility() : super(RotateDecorator.new);
  RotateDecorator get d90 => builder(1);
  RotateDecorator get d180 => builder(2);
  RotateDecorator get d270 => builder(3);

  RotateDecorator call(int value) => builder(value);
}

class VisibilityUtility extends BoolUtility<VisibilityDecorator> {
  const VisibilityUtility() : super(VisibilityDecorator.new);
}
