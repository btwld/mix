import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../attributes/animated/animated_data.dart';
import '../../attributes/animated/animated_data_dto.dart';
import '../../attributes/animated/animated_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_data.dart';
import '../../attributes/modifiers/widget_modifiers_data_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/element.dart';
import '../../core/factory/mix_data.dart';
import '../../core/spec.dart';
import 'stack_widget.dart';

part 'stack_spec.g.dart';

@MixableSpec()
final class StackSpec extends Spec<StackSpec> with _$StackSpec, Diagnosticable {
  final AlignmentGeometry? alignment;
  final StackFit? fit;
  final TextDirection? textDirection;
  final Clip? clipBehavior;

  static const of = _$StackSpec.of;

  static const from = _$StackSpec.from;

  const StackSpec({
    this.alignment,
    this.fit,
    this.textDirection,
    this.clipBehavior,
    super.animated,
    super.modifiers,
  });

  Widget call({List<Widget> children = const []}) {
    return isAnimated
        ? AnimatedStackSpecWidget(
            spec: this,
            curve: animated!.curve,
            duration: animated!.duration,
            children: children,
          )
        : StackSpecWidget(spec: this, children: children);
  }

  @override
  StackSpecAttribute toAttribute() {
    return StackSpecAttribute(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
