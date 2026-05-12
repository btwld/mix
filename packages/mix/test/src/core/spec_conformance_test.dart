import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  test('generated specs satisfy core Spec contracts', () {
    expectGeneratedSpecConforms(const BoxSpec());
    expectGeneratedSpecConforms(const IconSpec());
    expectGeneratedSpecConforms(const ImageSpec());
    expectGeneratedSpecConforms(const StackSpec());
    expectGeneratedSpecConforms(const TextSpec());
  });
}

/// Asserts that [value] satisfies the three core Spec contracts:
/// `type` reports its runtime type, `StyleSpec<T>` accepts it as a spec,
/// and `SpecTween<T>.lerp` produces a value of the same type.
void expectGeneratedSpecConforms<T extends Spec<T>>(T value) {
  final Spec<T> spec = value;
  final wrapped = StyleSpec<T>(spec: value);
  final tween = SpecTween<T>(begin: value, end: value);

  expect(spec.type, value.runtimeType);
  expect(wrapped.spec, same(value));
  expect(tween.lerp(0.5), isA<T>());
}
