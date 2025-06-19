import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/animated/animated_data_dto.dart';
import '../../attributes/animated/animated_util.dart';
import '../../attributes/modifiers/widget_modifiers_config.dart';
import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/factory/mix_data.dart';
import '../../core/factory/style_mix.dart';
import '../../core/spec.dart';
import '../box/box_spec.dart';
import '../flex/flex_spec.dart';
import 'flexbox_widget.dart';

part 'flexbox_spec.g.dart';

const _boxUtility = MixableFieldUtility(
  properties: [
    (path: 'alignment', alias: 'alignment'),
    (path: 'padding', alias: 'padding'),
    (path: 'margin', alias: 'margin'),
    (path: 'constraints', alias: 'constraints'),
    (path: 'constraints.minWidth', alias: 'minWidth'),
    (path: 'constraints.maxWidth', alias: 'maxWidth'),
    (path: 'constraints.minHeight', alias: 'minHeight'),
    (path: 'constraints.maxHeight', alias: 'maxHeight'),
    (path: 'decoration', alias: 'decoration'),
    (path: 'decoration.color', alias: 'color'),
    (path: 'decoration.border', alias: 'border'),
    (path: 'decoration.border.directional', alias: 'borderDirectional'),
    (path: 'decoration.borderRadius', alias: 'borderRadius'),
    (
      path: 'decoration.borderRadius.directional',
      alias: 'borderRadiusDirectional',
    ),
    (path: 'decoration.gradient', alias: 'gradient'),
    (path: 'decoration.gradient.sweep', alias: 'sweepGradient'),
    (path: 'decoration.gradient.radial', alias: 'radialGradient'),
    (path: 'decoration.gradient.linear', alias: 'linearGradient'),
    (path: 'decoration.boxShadows', alias: 'shadows'),
    (path: 'decoration.boxShadow', alias: 'shadow'),
    (path: 'decoration.elevation', alias: 'elevation'),
    (path: 'shapeDecoration', alias: 'shapeDecoration'),
    (path: 'shape', alias: 'shape'),
    (path: 'foregroundDecoration', alias: 'foregroundDecoration'),
    (path: 'transform', alias: 'transform'),
    (path: 'transformAlignment', alias: 'transformAlignment'),
    (path: 'clipBehavior', alias: 'clipBehavior'),
    (path: 'width', alias: 'width'),
    (path: 'height', alias: 'height'),
  ],
);

//TODO: Find a way to reuse as much code as possible from the FlexSpec and BoxSpec
@MixableSpec()
final class FlexBoxSpec extends Spec<FlexBoxSpec>
    with _$FlexBoxSpec, Diagnosticable {
  @MixableField(utilities: [_boxUtility])
  final BoxSpec box;

  final FlexSpec flex;

  static const of = _$FlexBoxSpec.of;
  static const from = _$FlexBoxSpec.from;

  const FlexBoxSpec({
    super.animated,
    super.modifiers,
    BoxSpec? box,
    FlexSpec? flex,
  })  : box = box ?? const BoxSpec(),
        flex = flex ?? const FlexSpec();

  Widget call({List<Widget> children = const [], required Axis direction}) {
    return (isAnimated)
        ? AnimatedFlexBoxSpecWidget(
            spec: this,
            direction: direction,
            curve: animated!.curve,
            duration: animated!.duration,
            onEnd: animated!.onEnd,
            children: children,
          )
        : FlexBoxSpecWidget(
            spec: this,
            direction: direction,
            children: children,
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

class FlexBoxStyle extends FlexBoxSpecUtility<FlexBoxSpecAttribute> {
  FlexBoxStyle() : super((v) => v);
}
