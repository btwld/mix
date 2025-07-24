// ignore_for_file: mix_avoid_empty_variants
import 'package:mix/mix.dart';

final variantA = NamedVariant('A');

final case_1 = Style(
  $on.hover(
    // expect_lint: mix_avoid_variant_inside_context_variant
    variantA(),
  ),
);

final case_2 = Style(variantA(), $on.hover());

final case_3 = Style($on.hover(), variantA());

final case_4 = Style(
  $on.hover(
    $on.hover(
      // expect_lint: mix_avoid_variant_inside_context_variant
      variantA(),
      $on.hover(
        // expect_lint: mix_avoid_variant_inside_context_variant
        variantA(),
      ),
    ),
    // expect_lint: mix_avoid_variant_inside_context_variant
    variantA(),
  ),
);
