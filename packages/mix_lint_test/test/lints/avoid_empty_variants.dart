import 'package:mix/mix.dart';

final a = NamedVariant('a');
final b = NamedVariant('b');

// Wrong case

final wrong_case = CompoundStyle(
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

final correct_case = CompoundStyle(
  a($box.color.amber()),
  a(b($box.color.amber())),
);
