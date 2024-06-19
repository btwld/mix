import 'package:mix/mix.dart';

final a = Variant('a');
final attribute = $box.alignment.center;

// Wrong case
// expect_lint: mix_max_number_of_attributes_per_style
final wrong_case = Style(
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  // expect_lint: mix_max_number_of_attributes_per_style
  a(
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
  ),
);

// Correct case

final correct_case = Style(
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  attribute(),
  a(
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
    attribute(),
  ),
);
