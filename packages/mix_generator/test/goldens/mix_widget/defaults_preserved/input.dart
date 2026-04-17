library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

class DefaultCardStyler extends Style<BoxSpec> {
  const DefaultCardStyler();

  DefaultCardStyler merge(DefaultCardStyler? other) => this;

  Box call({Widget? child = const Widget()}) {
    return Box(style: this, child: child);
  }
}

@MixWidget(widgetBuilder: BoxBuilder())
final defaultCardStyle = DefaultCardStyler();
