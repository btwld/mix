import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/animated/animated_data_dto.dart';
import '../../attributes/animated/animated_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/gap/gap_util.dart';
import '../../attributes/gap/spacing_side_dto.dart';
import '../../attributes/modifiers/widget_modifiers_data.dart';
import '../../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../core/attribute.dart';
import '../../core/factory/mix_data.dart';
import '../../core/factory/mix_provider.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import 'flex_widget.dart';

part 'flex_spec.g.dart';

@MixableSpec()
final class FlexSpec extends Spec<FlexSpec> with _$FlexSpec, Diagnosticable {
  @MixableProperty(
    utilities: [
      MixableUtility(
        properties: [
          (path: 'horizontal', alias: 'row'),
          (path: 'vertical', alias: 'column'),
        ],
      ),
    ],
  )
  final Axis? direction;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final VerticalDirection? verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final Clip? clipBehavior;
  @MixableProperty(
    dto: MixableFieldDto(type: SpacingSideDto),
    utilities: [MixableUtility(type: GapUtility)],
  )
  final double? gap;

  static const of = _$FlexSpec.of;

  static const from = _$FlexSpec.from;

  const FlexSpec({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.verticalDirection,
    this.direction,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior,
    this.gap,
    super.animated,
    super.modifiers,
  });
  Widget call({List<Widget> children = const [], required Axis direction}) {
    return isAnimated
        ? AnimatedFlexSpecWidget(
            spec: this,
            direction: direction,
            curve: animated!.curve,
            duration: animated!.duration,
            children: children,
          )
        : FlexSpecWidget(
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
