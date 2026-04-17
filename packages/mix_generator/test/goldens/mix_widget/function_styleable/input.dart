library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget(styleable: true)
BoxStyler chipStyle({required Color color}) => BoxStyler.color(color);
