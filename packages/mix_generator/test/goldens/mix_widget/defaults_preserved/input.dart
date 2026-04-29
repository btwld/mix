library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class DefaultCardStyler extends Style<BoxSpec> {
  const DefaultCardStyler();

  DefaultCardStyler merge(DefaultCardStyler? other) => this;
}

@MixWidget()
DefaultCardStyler defaultCardStyle({bool compact = false, int padding = 16}) {
  return const DefaultCardStyler();
}
