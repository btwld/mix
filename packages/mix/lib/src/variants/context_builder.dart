import 'package:flutter/widgets.dart';

import 'context_variant.dart';

class ContextBuilder extends ContextVariant {
  const ContextBuilder();

  @override
  bool when(BuildContext context) {
    return true;
  }
}
