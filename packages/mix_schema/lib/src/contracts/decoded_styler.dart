import 'package:mix/mix.dart';

import 'styler_type.dart';

final class DecodedStyler {
  final StylerType stylerType;
  final Object styler;

  const DecodedStyler({required this.stylerType, required this.styler});

  BoxStyler? get boxStyler {
    final value = styler;
    if (value is BoxStyler) return value;

    return null;
  }

  TextStyler? get textStyler {
    final value = styler;
    if (value is TextStyler) return value;

    return null;
  }

  FlexStyler? get flexStyler {
    final value = styler;
    if (value is FlexStyler) return value;

    return null;
  }

  IconStyler? get iconStyler {
    final value = styler;
    if (value is IconStyler) return value;

    return null;
  }

  ImageStyler? get imageStyler {
    final value = styler;
    if (value is ImageStyler) return value;

    return null;
  }

  StackStyler? get stackStyler {
    final value = styler;
    if (value is StackStyler) return value;

    return null;
  }

  FlexBoxStyler? get flexBoxStyler {
    final value = styler;
    if (value is FlexBoxStyler) return value;

    return null;
  }

  StackBoxStyler? get stackBoxStyler {
    final value = styler;
    if (value is StackBoxStyler) return value;

    return null;
  }
}
