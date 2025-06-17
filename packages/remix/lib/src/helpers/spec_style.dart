import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

class SpecConfiguration<U extends SpecUtility> {
  final BuildContext context;

  final U _utility;

  const SpecConfiguration(this.context, this._utility);

  OnContextVariantUtility get on => OnContextVariantUtility.self;

  U get utilities => _utility;
}

abstract class SpecStyle<U extends SpecUtility> {
  const SpecStyle();

  Style makeStyle(SpecConfiguration<U> spec);
}
