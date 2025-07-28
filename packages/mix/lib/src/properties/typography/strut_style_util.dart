import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'strut_style_mix.dart';

final class StrutStyleUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, StrutStyle> {
  late final fontWeight = PropUtility<T, FontWeight>(
    (prop) => call(StrutStyleMix.raw(fontWeight: prop)),
  );

  late final fontStyle = PropUtility<T, FontStyle>(
    (prop) => call(StrutStyleMix.raw(fontStyle: prop)),
  );

  late final fontSize = PropUtility<T, double>(
    (prop) => call(StrutStyleMix.raw(fontSize: prop)),
  );

  late final fontFamily = PropUtility<T, String>(
    (v) => call(StrutStyleMix.raw(fontFamily: v)),
  );

  StrutStyleUtility(super.builder) : super(convertToMix: StrutStyleMix.value);

  @override
  T call(StrutStyleMix value) => builder(MixProp(value));
}
