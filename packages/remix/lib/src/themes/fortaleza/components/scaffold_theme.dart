import 'package:mix/mix.dart';

import '../../../components/layout/scaffold/scaffold.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaScaffoldStyle extends ScaffoldStyle {
  const FortalezaScaffoldStyle();

  @override
  Style makeStyle(SpecConfiguration<ScaffoldSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([$.container.color.$neutral(1)]);
  }
}
