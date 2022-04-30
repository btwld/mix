import 'package:mix/mix.dart';

// Dynamic utilities
final xsmall = VariantUtils.xsmall();
final small = VariantUtils.small();
final medium = VariantUtils.medium();
final large = VariantUtils.large();

final portrait = VariantUtils.portrait();
final landscape = VariantUtils.landscape();

final dark = VariantUtils.dark();
final light = VariantUtils.light();

final enabled = not(disabled);
final disabled = VariantUtils.disabled();
final focus = VariantUtils.focused();
final hover = VariantUtils.hover();
final press = VariantUtils.pressing();

const not = VariantUtils.not;
