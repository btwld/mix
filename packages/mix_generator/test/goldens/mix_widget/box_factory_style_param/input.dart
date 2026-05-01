library input;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'input.g.dart';

@MixWidget()
BoxStyler cardStyle({BoxStyler? style}) => BoxStyler().merge(style);
