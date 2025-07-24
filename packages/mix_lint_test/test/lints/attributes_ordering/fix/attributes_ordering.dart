import 'package:mix/mix.dart';

// expect_lint: mix_attributes_ordering
final test1 = Style(
  $flex.gap(3),
  $box.color.red(),
  $flex.row(),
  $box.borderRadius(3),
  $text.style.color.red(),
  $text.style.fontSize(3),
  $icon.size(3),
  $icon.fill(3),
);

// expect_lint: mix_attributes_ordering
final test2 = Style($box.color.red(), $flex.gap(3), $box.borderRadius(3));

final a = NamedVariant('a');
final b = NamedVariant('b');
final c = NamedVariant('c');

final test3 = Style(
  // expect_lint: mix_attributes_ordering
  a($box.color.red(), $flex.gap(3), $box.borderRadius(3)),
);

final test4 = Style(
  a(
    // expect_lint: mix_attributes_ordering
    b($box.color.red(), $flex.gap(3), $box.borderRadius(3)),
  ),
);

final test5 = Style(
  // expect_lint: mix_attributes_ordering
  a(
    $box.color.red(),
    // expect_lint: mix_attributes_ordering
    c($box.color.red(), $flex.gap(3), $box.borderRadius(3)),
    $box.borderRadius(3),
    // expect_lint: mix_attributes_ordering
    b($box.color.red(), $flex.gap(3), $box.borderRadius(3)),
  ),
).applyVariant(a, b);
