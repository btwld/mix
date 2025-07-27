import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'scalar_util.dart';
import 'strut_style_mix.dart';

final class StrutStyleUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, StrutStyle> {
  late final fontWeight = FontWeightUtility<T>(
    (prop) => call(StrutStyleMix(fontWeight: prop)),
  );

  late final fontStyle = PropUtility<T, FontStyle>(
    (prop) => call(StrutStyleMix(fontStyle: prop)),
  );

  late final fontSize = PropUtility<T, double>(
    (prop) => call(StrutStyleMix(fontSize: prop)),
  );

  late final fontFamily = FontFamilyUtility<T>(
    (v) => call(StrutStyleMix(fontFamily: v)),
  );

  StrutStyleUtility(super.builder) : super(convertToMix: StrutStyleMix.value);

  @override
  T call(StrutStyleMix value) => builder(MixProp(value));
}
