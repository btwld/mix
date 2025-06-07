// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../attributes/enum/enum_util.dart';
import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'flexible_widget_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
final class FlexibleModifierSpec
    extends WidgetModifierSpec<FlexibleModifierSpec>
    with _$FlexibleModifierSpec, Diagnosticable {
  final int? flex;
  final FlexFit? fit;
  const FlexibleModifierSpec({this.flex, this.fit});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  FlexibleModifierSpecAttribute toAttribute() {
    return FlexibleModifierSpecAttribute(flex: flex, fit: fit);
  }

  @override
  Widget build(Widget child) {
    return Flexible(
      flex: flex ?? 1,
      fit: fit ?? FlexFit.loose,
      child: child,
    );
  }
}

final class FlexibleModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, FlexibleModifierSpecAttribute> {
  const FlexibleModifierSpecUtility(super.builder);
  FlexFitUtility<T> get fit => FlexFitUtility((fit) => call(fit: fit));
  IntUtility<T> get flex => IntUtility((flex) => call(flex: flex));
  T tight({int? flex}) =>
      builder(FlexibleModifierSpecAttribute(flex: flex, fit: FlexFit.tight));
  T loose({int? flex}) =>
      builder(FlexibleModifierSpecAttribute(flex: flex, fit: FlexFit.loose));
  T expanded({int? flex}) => tight(flex: flex);

  T call({int? flex, FlexFit? fit}) {
    return builder(FlexibleModifierSpecAttribute(flex: flex, fit: fit));
  }
}
