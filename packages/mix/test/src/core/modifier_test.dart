import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/modifier.dart';
import 'package:mix/src/core/models/mix_data.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('ModifierSpec', () {
    test('lerpValue should return null when both begin and end are null', () {
      expect(WidgetModifierSpec.lerpValue(null, null, 0.5), isNull);
    });

    test(
        'lerpValue should return the result of lerp when begin and end are not null',
        () {
      const begin = _TestModifierSpec(1, animated: null);
      const end = _TestModifierSpec(2);
      expect(
        WidgetModifierSpec.lerpValue(begin, end, 0.5),
        isA<_TestModifierSpec>(),
      );
      expect(
        (WidgetModifierSpec.lerpValue(begin, end, 0.5) as _TestModifierSpec?)
            ?.value,
        1.5,
      );
    });
  });

  group('ModifierAttribute', () {
    test('resolve should return a ModifierSpec', () {
      const attribute = _TestModifierAttribute(2);

      expect(attribute.resolve(EmptyMixData), isA<_TestModifierSpec>());
      expect(attribute.resolve(EmptyMixData).value, 2);
    });
  });
}

class _TestModifierSpec extends WidgetModifierSpec<_TestModifierSpec> {
  final double value;
  const _TestModifierSpec(
    this.value, {
    super.animated,
  });

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

    return _TestModifierSpec(lerpDouble(value, other.value, t)!);
  }
}

class _TestModifierAttribute
    extends WidgetModifierAttribute<_TestModifierAttribute, _TestModifierSpec> {
  final double value;
  const _TestModifierAttribute(this.value);

  @override
  _TestModifierSpec resolve(MixData mix) {
    return _TestModifierSpec(value);
  }

  @override
  get props => [];

  @override
  _TestModifierAttribute merge(_TestModifierAttribute? other) {
    return _TestModifierAttribute(other?.value ?? value);
  }
}
