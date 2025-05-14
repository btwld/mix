import 'package:mix/mix.dart';

final ordered = Style(
  $box.color.red(),
  $box.borderRadius(3),
  $flex.gap(3),
  $flex.row(),
  $icon.size(3),
  $icon.fill(3),
  $text.style.color.red(),
  $text.style.fontSize(3),
);

// expect_lint: mix_attributes_ordering
final outOrder = Style(
  $box.color.red(),
  $flex.gap(3),
  $box.borderRadius(3),
);

// expect_lint: mix_attributes_ordering
final outOrder_2 = Style(
  $box.color.red(),
  $flex.gap(3),
  $box.borderRadius(3),
);

final a = Variant('a');
final b = Variant('b');
final c = Variant('c');

final outOrder_3 = Style(
// expect_lint: mix_attributes_ordering
  a(
    $box.color.red(),
    $flex.gap(3),
    $box.borderRadius(3),
  ),
);

final outOrder_4 = Style(
  a(
// expect_lint: mix_attributes_ordering
    b(
      $box.color.red(),
      $flex.gap(3),
      $box.borderRadius(3),
    ),
  ),
);

final outOrder_5 = Style(
// expect_lint: mix_attributes_ordering
  a(
    $box.color.red(),
// expect_lint: mix_attributes_ordering
    c(
      $box.color.red(),
      $flex.gap(3),
      $box.borderRadius(3),
    ),
    $box.borderRadius(3),
// expect_lint: mix_attributes_ordering
    b(
      $box.color.red(),
      $flex.gap(3),
      $box.borderRadius(3),
    ),
  ),
).applyVariant(a, b);

final inOrder_1 = Style(
  $box.height(20),
  $flex.column(),
  $image.alignment.bottomCenter(),
  $icon.color.amber(),
  $text.capitalize(),
  $stack.fit.expand(),
  $on.dark(
    $box.height(20),
  ),
  $with.clipOval(),
  _style(),
  test(),
);

final inOrder_2 = Style(
  $flex.column(),
  $on.dark(
    $box.height(20),
  ),
  $text.capitalize(),
  $with.clipOval(),
  _style(),
  $box.height(20),
  $stack.fit.expand(),
  test(),
  $icon.color.amber(),
  $image.alignment.bottomCenter(),
);

Style _style = Style(
  $box.border.width(2),
);

Attribute test() => Style.asAttribute(
      $with.scale(1),
    );
