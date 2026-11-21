import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_lint/src/rules/missing_create_constructor.dart';
import 'package:test/test.dart';

void main() {
  // missing_create_constructor reads the `methods` bitmask of an annotation.
  // These guards fail if mix_annotations renumbers its merge flags.
  test('merge flags match package:mix_annotations', () {
    expect(
      MissingCreateConstructor.mixableMergeFlag,
      GeneratedMixMethods.merge,
    );
    expect(
      MissingCreateConstructor.mixableStylerMergeFlag,
      GeneratedStylerMethods.merge,
    );
  });
}
