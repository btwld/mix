import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';

void main() {
  group('ModifierSpec', () {
    test('lerpValue should return null when both begin and end are null', () {
      expect(ModifierSpec.lerpValue(null, null, 0.5), isNull);
    });

    test(
      'lerpValue should return the result of lerp when begin and end are not null',
      () {
        const begin = _TestModifierSpec(1);
        const end = _TestModifierSpec(2);
        expect(
          ModifierSpec.lerpValue(begin, end, 0.5),
          isA<_TestModifierSpec>(),
        );
        expect(
          (ModifierSpec.lerpValue(begin, end, 0.5) as _TestModifierSpec?)
              ?.value,
          1.5,
        );
      },
    );
  });

  group('ModifierAttribute', () {
    test('resolve should return a ModifierSpec', () {
      const attribute = _TestModifierAttribute(2);

      expect(attribute, resolvesTo(const _TestModifierSpec(2)));
    });
  });
}

final class _TestModifierSpec extends ModifierSpec<_TestModifierSpec> {
  final double value;
  const _TestModifierSpec(this.value);

  @override
  Widget build(Widget child) {
    return Container();
  }

  @override
  _TestModifierSpec copyWith({double? value}) {
    return _TestModifierSpec(value ?? this.value);
  }

  @override
  get props => [];

  @override
  _TestModifierSpec lerp(_TestModifierSpec? other, double t) {
    if (other == null) return this;

    return _TestModifierSpec(MixHelpers.lerpDouble(value, other.value, t)!);
  }
}

final class _TestModifierAttribute
    extends WidgetModifierSpecAttribute<_TestModifierSpec> {
  final double value;
  const _TestModifierAttribute(this.value);

  @override
  _TestModifierSpec resolve(BuildContext mix) {
    return _TestModifierSpec(value);
  }

  @override
  get props => [];

  @override
  _TestModifierAttribute merge(_TestModifierAttribute? other) {
    return _TestModifierAttribute(other?.value ?? value);
  }
}
