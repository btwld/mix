import 'package:flutter/widgets.dart';

import '../../core/factory/mix_context.dart';
import '../../core/mix_element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'strut_style_dto.dart';

final class StrutStyleUtility<T extends StyleElement>
    extends DtoUtility<T, StrutStyleDto, StrutStyle> {
  late final fontWeight = FontWeightUtility(
    (v) => only(fontWeight: FontWeightMix(v)),
  );

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: EnumMix(v)));

  late final fontSize = FontSizeUtility((v) => only(fontSize: DoubleMix(v)));

  late final fontFamily = FontFamilyUtility(
    (v) => only(fontFamily: StringMix(v)),
  );

  StrutStyleUtility(super.builder)
    : super(
        valueToDto: (v) => StrutStyleDto(
          fontFamily: v.fontFamily != null ? StringMix(v.fontFamily!) : null,
          fontFamilyFallback: v.fontFamilyFallback != null
              ? _ListStringMix(v.fontFamilyFallback!)
              : null,
          fontSize: v.fontSize != null ? DoubleMix(v.fontSize!) : null,
          fontWeight: v.fontWeight != null
              ? FontWeightMix(v.fontWeight!)
              : null,
          fontStyle: v.fontStyle != null ? EnumMix(v.fontStyle!) : null,
          height: v.height != null ? DoubleMix(v.height!) : null,
          leading: v.leading != null ? DoubleMix(v.leading!) : null,
          forceStrutHeight: v.forceStrutHeight != null
              ? BoolMix(v.forceStrutHeight!)
              : null,
        ),
      );

  T token(MixableToken<StrutStyle> token) => throw UnimplementedError(
    'Token support for StrutStyle needs to be redesigned for the simplified DTO pattern',
  );

  T height(double v) => only(height: DoubleMix(v));

  T leading(double v) => only(leading: DoubleMix(v));

  T forceStrutHeight(bool v) => only(forceStrutHeight: BoolMix(v));

  T fontFamilyFallback(List<String> v) =>
      only(fontFamilyFallback: _ListStringMix(v));

  T call({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    return only(
      fontFamily: fontFamily != null ? StringMix(fontFamily) : null,
      fontFamilyFallback: fontFamilyFallback != null
          ? _ListStringMix(fontFamilyFallback)
          : null,
      fontSize: fontSize != null ? DoubleMix(fontSize) : null,
      fontWeight: fontWeight != null ? FontWeightMix(fontWeight) : null,
      fontStyle: fontStyle != null ? EnumMix(fontStyle) : null,
      height: height != null ? DoubleMix(height) : null,
      leading: leading != null ? DoubleMix(leading) : null,
      forceStrutHeight: forceStrutHeight != null
          ? BoolMix(forceStrutHeight)
          : null,
    );
  }

  @override
  T only({
    Mix<String>? fontFamily,
    Mix<List<String>>? fontFamilyFallback,
    Mix<double>? fontSize,
    Mix<FontWeight>? fontWeight,
    Mix<FontStyle>? fontStyle,
    Mix<double>? height,
    Mix<double>? leading,
    Mix<bool>? forceStrutHeight,
  }) {
    return builder(
      StrutStyleDto(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: height,
        leading: leading,
        forceStrutHeight: forceStrutHeight,
      ),
    );
  }
}

// Helper class for list types
class _ListStringMix extends Mix<List<String>> {
  final List<String> _values;
  const _ListStringMix(this._values);

  @override
  List<String> resolve(MixContext mix) {
    return _values;
  }

  @override
  Mix<List<String>> merge(Mix<List<String>>? other) {
    return other ?? this;
  }

  @override
  get props => [_values];
}
