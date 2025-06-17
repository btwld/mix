import 'package:mix/mix.dart';

StyleElement scaleEffect([double value = 0.92]) => Style.asAttribute(
      $with.scale(1),
      $on.press(
        $with.scale(value),
      ),
    );
