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
}
