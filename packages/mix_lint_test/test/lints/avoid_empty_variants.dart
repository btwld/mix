import 'package:mix/mix.dart';

final a = Variant('a');
final b = Variant('b');

// Wrong case

final wrong_case = Style(
  // expect_lint: mix_avoid_empty_variants
  a(),
  // expect_lint: mix_avoid_empty_variants
  b(),
  a(
    // ignore: mix_avoid_empty_variants
    b(),
  ),
);

// Correct case

final correct_case = Style(
  a(
    $box.color.amber(),
  ),
  a(
    b(
      $box.color.amber(),
    ),
  ),
);
